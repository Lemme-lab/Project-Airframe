#include "DigitalFilter.h"

DigitalFilter::DigitalFilter(FilterType filter_type,float fs){
    fs_ = fs;
    ts_ = 1.0/fs_;
    filter_type_ = filter_type;
}

int DigitalFilter::init(){
    float a0_tmp;
    gain_ = 1.0;
    switch(filter_type_){
        
        //1st order lowpass filter. Need to set fcl before calling init().
        //transfer function in S space H(s) = 1/(1+tau*s)
        //transfer function in Z space H(z) = {b0+b1*z^(-1)}/{1+a1*z^(-1)} 
        case LPF1:          
            delay_step_ = 1;
            a_.resize(2);
            b_.resize(2);
            u_.resize(2);
            y_.resize(2);
            tau_ = 1.0/(2.0*pi_*fc_);
            a0_tmp = ts_+2.0*tau_;
            b_[0] = ts_/a0_tmp;
            b_[1] = b_[0];
            a_[0] = 1.0;
            a_[1] = (ts_-2.0*tau_)/a0_tmp;
            this->reset();       
            break;
            
        //2nd order lowpass filter. Need to set fcl and zeta before calling init().
        //transfer function in S space H(s) = 1/(1+2*zeta*tau*s+tau^2*s^2)
        case LPF2:
            delay_step_ = 2;
            a_.resize(3);
            b_.resize(3);
            u_.resize(3);
            y_.resize(3);
            
            tau_ = 1.0/(2.0*pi_*fc_);
            a0_tmp = ts_*ts_+4.0*zeta_*tau_*ts_+4.0*tau_*tau_;
            b_[0] = (ts_*ts_)/a0_tmp;
            b_[1] = (2.0*ts_*ts_)/a0_tmp;
            b_[2] = (ts_*ts_)/a0_tmp;
            a_[0] = 1.0;
            a_[1] = (2.0*ts_*ts_-8.0*tau_*tau_)/a0_tmp;
            a_[2] = (ts_*ts_-4*zeta_*tau_*ts_+4*tau_*tau_)/a0_tmp;
            this->reset();
        break;
        //2nd order highpass filter. Need to set fch and zeta before calling init().
        //transfer function in S space H(s) = S^2/(1+2*zeta*tau*s+tau^2*s^2)
        case HPF2:
            delay_step_ = 2;
            a_.resize(3);
            b_.resize(3);
            u_.resize(3);
            y_.resize(3);
            
            tau_ = 1.0/(2.0*pi_*fc_);
            a0_tmp = ts_*ts_+4.0*zeta_*tau_*ts_+4.0*tau_*tau_;
            b_[0] = (4.0*tau_*tau_)/a0_tmp;
            b_[1] = (-8.0*tau_*tau_)/a0_tmp;
            b_[2] = (4.0*tau_*tau_)/a0_tmp;
            a_[0] = 1.0;
            a_[1] = (2.0*ts_*ts_-8*tau_*tau_)/a0_tmp;
            a_[2] = (ts_*ts_-4*zeta_*tau_*ts_+4*tau_*tau_)/a0_tmp;
            this->reset();
            /*
            omega = 2.0*pi_*fch_;
            delay_step_ = 2;
            a_.resize(3);
            b_.resize(3);
            u_.resize(3);
            y_.resize(3);
            a0_tmp_ = 4.0+4.0*zeta_*omega*ts_+ts_*ts_*omega*omega;
            b_[0] = 4.0/a0_tmp_;
            b_[1] = -8.0/a0_tmp_;
            b_[2] = b_[0];
            a_[0] = 1.0;
            a_[1] = (-8.0+2.0*ts_*ts_*omega*omega)/a0_tmp_;
            a_[2] = (4.0-4.0*zeta_*omega*ts_+ts_*ts_*omega*omega)/a0_tmp_;
            this->reset();
            */
        break;
            
        //Resonance filter.Need to set fc and zeta before calling init().
        case RESONANCE:
            delay_step_ = 2;
            a_.resize(3);
            b_.resize(3);
            u_.resize(3);
            y_.resize(3);
            
            tau_=1.0/(2*pi_*fc_);
            a0_tmp = ts_*ts_+4.0*zeta_*tau_*ts_+4.0*tau_*tau_;
            b_[0] = (4.0*zeta_*tau_*ts_)/a0_tmp;
            b_[1] = 0;
            b_[2] = (-4.0*zeta_*tau_*ts_)/a0_tmp;
            a_[0] = 1.0;
            a_[1] = (2.0*ts_*ts_-8*tau_*tau_)/a0_tmp;
            a_[2] = (ts_*ts_-4*zeta_*tau_*ts_+4*tau_*tau_)/a0_tmp;
            //gain_ = 1.0/a_[0];
            this->reset();
        break;
        case HILBERT:
            float sum_tmp = 0;
            delay_step_ = tap_;
            a_.resize(tap_);
            b_.resize(tap_);
            u_.resize(tap_);
            y_.resize(tap_);
            vectorSetAllToZero(a_);
            for(int i=1;i<tap_;i++){
                b_[i-1] = (2.0/(i-(tap_+1)/2.0)*pi_)*sin((i-(tap_+1)/2)*pi_/2.0)*sin((i-(tap_+1)/2)*pi_/2.0);
            }
            b_[(int)((tap_-1)/2)] = 0;
            
            //normalize filter coefficients b
            for(int i=0;i<tap_;i++){
                sum_tmp += b_[i]*b_[i];
            }
            sum_tmp = sqrt(sum_tmp);
            for(int i=0;i<tap_;i++){
                b_[i] =b_[i] / sum_tmp;
            }
            this->reset();
        break;
        default:
            delay_step_ = 0;
        break;
    }
    return delay_step_;        
}

//Calcurate new output of digial filter.
//Using direct type 2 IIRfilter.
float DigitalFilter::update(float input){
    float output = 0.0;
    vectorRightShift(u_);
    vectorRightShift(y_);
    u_[0] = gain_*input;
    for(int i = 0;i < (int)u_.size();i++){
        output += b_[i] * u_[i];
    }
    for(int i = 1;i < (int)y_.size();i++){
        output -= a_[i] * y_[i];
    }
    y_[0] = output;
    if(filter_type_ == HILBERT){
        output = (float)sqrt(output*output+u_[(int)((tap_-1)/2)]*u_[(int)((tap_-1)/2)]);
    }
    return output;    
}

void DigitalFilter::reset(){
    this->vectorSetAllToZero(u_);
    this->vectorSetAllToZero(y_);
}


//accesor of fc(center frequency)
void DigitalFilter::set_fc(float fc){
    fc_ = fc;
}
//accesor of zeta(decrement)
void DigitalFilter::set_zeta(float zeta){
    zeta_ = zeta;
}

//accesor of quality factor   
void DigitalFilter::set_Q(float q){
    Q_ = q;
}

//accesor of quality factor   
void DigitalFilter::set_tap(int tap){
    tap_ = tap;
}

//get delay step of designed filter.
int DigitalFilter::get_delay_step(){
    return delay_step_;
}

//right shift elements of vector
void DigitalFilter::vectorRightShift(vector<float> &array){
    for(int i = array.size();i > 1;i--){
           array[i-1] = array[i-2];
    }
    array[0] = 0.0;
}

//set 0 to all elements of vector
void DigitalFilter::vectorSetAllToZero(vector<float> &array){
    for(int i = 0;i < (int)array.size();i++){
        array[i] = 0.0;
    }
}




          
            
            
            
            
        