#ifndef DIGITALFILTER_H
#define DIGITALFILTER_H
#include "mbed.h"
#include "math.h"
#include<vector>

/**enumrator to choose filter type
*
*/
typedef enum FilterType{
         LPF1,
         LPF2,
         HPF1,
         HPF2,
         RESONANCE,
         NOTCH,
         HILBERT,
}FilterType;  
 
 /**
 * DigitalFilter class
 */              
class DigitalFilter
{
    public:
        
        /** Create a DigitalFilter instance
        *@param filter_type desired filter type
        *@param fs sampling frequency
        */
        DigitalFilter(FilterType filter_type,float fs);    //constructor, choose filter type and set sampling frequency
        
        /** initialize DigitalFilter.Need to set several parameters before calling this method.
        */
        int init();                  //calcurate and set filter coefficients.Return value is the delay step of designed filter.
        
        /**Update filter outputs.
        *@param input latest input of filter
        */
        float update(float input);   //update filter outputs. 
        
        /** Reset buffer of filter
        */
        void reset();                //reset filter inputs and past inputs(all past inputs set to 0)
        
        
        /**accesor of fc(center frequency)
        *@param fc center frequency
        */
        void set_fc(float fc);       //accesor of fc(center frequency)
        
        /**accesor of zeta(decrement)
        *@param zeta decrement of filter
        */
        void set_zeta(float zeta);   //accesor of zeta(decrement)
        
        
        /**accesor of q(quality factor)
        *@param q quality factor
        */
        void set_Q(float q);       //accesor of quality factor
        
        /**accesor of tap(hilbert filter's tap number)
        *@param tap hilbert filter's tap number
        */
        void set_tap(int tap);     //accesor of hilbert filter's tap number
        
        /**accesor of filter time constant
        */
        float get_tau();          //accesor of filter time constant
        
        /**accesor of delay_step
        */
        int get_delay_step();        //get delay step of designed filter
        
    private:
        void vectorRightShift(vector<float> &array);   //right shift elements of vector
        void vectorSetAllToZero(vector<float> &array);      //set all elements of vector to 0
        vector<float> a_;         //filter coefficients of denominator a
        vector<float> b_;         //filter coefficients of numerator b
        vector<float> u_;         //intermediate outputs of filter
        vector<float> y_;         //intermediate outputs of filter             
        int delay_step_;        //delay step
        float gain_;              //filter gain
        float fs_;                //sampling frequency
        float ts_;                //sampling time
        float fc_;                //center frequency
        float zeta_;              //decrement 
        float Q_;                 //quality factor
        float tau_;
        int tap_;               //tap number of hilbert filter
        static const float pi_ = 3.141592;          //circular constant
        FilterType filter_type_ ;
};
#endif