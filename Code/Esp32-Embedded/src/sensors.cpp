#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"
#include <Adafruit_LIS2MDL.h>
#include "spo2_algorithm.h"
#include <DFRobot_ICP10111.h>
#include "kxtj3-1057.h"
#include <Adafruit_LSM6DS33.h>

#define LOW_POWER
#define KXTJ3_DEBUG Serial
#define MAX_BRIGHTNESS 255

float   sampleRate = 6.25;  
uint8_t accelRange = 2;     

KXTJ3 myIMU(0x0E); 

const byte RATE_SIZE = 4; 
byte rates[RATE_SIZE]; 
byte rateSpot = 0;
long lastBeat = 0; 

MAX30105 particleSensor;
Adafruit_LIS2MDL mag = Adafruit_LIS2MDL(12345);
DFRobot_ICP10111 icp;
Adafruit_LSM6DS33 lsm6ds;

uint32_t irBuffer[100]; 
uint32_t redBuffer[100];  

int32_t bufferLength; 
int8_t validSPO2; 
int8_t validHeartRate; 

#define KXTJ3_ADDRESS 0x0F
#define LSM6DSL_ADDR 0x6A

float acc_x_init = 0;
float acc_y_init = 0;
float acc_z_init = 0;

void Max30105Setup(){

  Serial.println("Initializing Max30105");

  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) 
  {
    Serial.println("MAX30105 was not found. Please check wiring/power. ");
    while (1);
  }

  particleSensor.setup(); 
  particleSensor.setPulseAmplitudeRed(0x0A); 
  particleSensor.setPulseAmplitudeGreen(0); 
  particleSensor.enableDIETEMPRDY();

}

void Max30105HeartRate(long& irValue, float& beatsPerMinute, double& beatAvg){
  irValue = particleSensor.getIR();

  if (checkForBeat(irValue) == true)
  {
    long delta = millis() - lastBeat;
    lastBeat = millis();

    beatsPerMinute = 60 / (delta / 1000.0);

    if (beatsPerMinute < 255 && beatsPerMinute > 20)
    {
      rates[rateSpot++] = (byte)beatsPerMinute; 
      rateSpot %= RATE_SIZE; 
      beatAvg = 0;
      for (byte x = 0 ; x < RATE_SIZE ; x++)
        beatAvg += rates[x];
        beatAvg /= RATE_SIZE;
    }
  }
}

void Max30105Temp(float& temperature){
  temperature = particleSensor.readTemperature();
}

void Max30105_O2_Setup(){
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) 
  {
    Serial.println(F("MAX30105 was not found. Please check wiring/power."));
    while (1);
  }

  byte ledBrightness = 60; 
  byte sampleAverage = 4; 
  byte ledMode = 2; 
  byte sampleRate = 100; 
  int pulseWidth = 411; 
  int adcRange = 4096; 

  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);
}

void Max30105_O2(int32_t& heartRate, int32_t& spo2){
  bufferLength = 100; 

  for (byte i = 0 ; i < bufferLength ; i++)
  {
    while (particleSensor.available() == false) 
      particleSensor.check(); 

    redBuffer[i] = particleSensor.getRed();
    irBuffer[i] = particleSensor.getIR();
    particleSensor.nextSample(); 
  }


  maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);

   for (byte i = 25; i < 100; i++)
    {
      redBuffer[i - 25] = redBuffer[i];
      irBuffer[i - 25] = irBuffer[i];
    }

    for (byte i = 75; i < 100; i++)
    {
      while (particleSensor.available() == false) 
        particleSensor.check(); 

      redBuffer[i] = particleSensor.getRed();
      irBuffer[i] = particleSensor.getIR();
      particleSensor.nextSample(); 
    }

    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
}

void LIS2MDLTRSetup() {
  if(!mag.begin())
  {
    Serial.println("Ooops, no LIS2MDL detected ... Check your wiring!");
    while(1);
  }
}

void LIS2MDLTRData(int& x, int&y, int& z) {
  sensors_event_t event;
  mag.getEvent(&event);
  x = event.magnetic.x;
  y = event.magnetic.y;
  z = event.magnetic.z;
}

void LIS2MDLTRCompass(float& heading){
  sensors_event_t event;
  mag.getEvent(&event);

  float Pi = 3.14159;

  heading = (atan2(event.magnetic.y,event.magnetic.x) * 180) / Pi;

  if (heading < 0)
  {
    heading = 360 + heading;
  }
}

void ICP_Setup(){
   while(icp.begin() != 0){
      Serial.println("Failed to initialize the sensor");
      }
   icp.setWorkPattern(icp.eNormal);
};

void ICP_Data(float& airPressure, int& temperature, int& altitude){
  airPressure = icp.getAirPressure();
  temperature = static_cast<int>(icp.getTemperature());
  altitude = static_cast<int>(icp.getElevation());
};

void KXTJ3_Setup(){
  
  // Configure KXTJ3-1057 accelerometer
  Wire.beginTransmission(KXTJ3_ADDRESS);
  Wire.write(0x18); // Control register 2
  Wire.write(0x80); // Reset sensor
  Wire.endTransmission();
  delay(100);

  Wire.beginTransmission(KXTJ3_ADDRESS);
  Wire.write(0x18); // Control register 2
  Wire.write(0x02); // Set operating mode to standby
  Wire.endTransmission();
  delay(100);

  Wire.beginTransmission(KXTJ3_ADDRESS);
  Wire.write(0x18); // Control register 2
  Wire.write(0x01); // Set operating mode to measurement
  Wire.endTransmission();
  delay(100);

  Wire.beginTransmission(KXTJ3_ADDRESS);
  Wire.write(0x0B); // Output data register X
  Wire.endTransmission();

}

void KXTJ3_Data(float& x, float& y, float& z){

  byte data[6];

  // Read 6 bytes of acceleration data from the KXTJ3-1057 accelerometer
  Wire.requestFrom(KXTJ3_ADDRESS, 6);
  for (int i = 0; i < 6; i++) {
    data[i] = Wire.read();
  }

  // Convert acceleration data to g
  int16_t x_raw = (data[1] << 8) | data[0];
  int16_t y_raw = (data[3] << 8) | data[2];
  int16_t z_raw = (data[5] << 8) | data[4];
  x = (float)x_raw / 1024.0;
  y = (float)y_raw / 1024.0;
  z = (float)z_raw / 1024.0;

}

void LSM6DSLTR_Setup(){
    Wire.beginTransmission(LSM6DSL_ADDR);
  Wire.write(0x10); 
  Wire.write(0x60); 
  Wire.endTransmission();

  Wire.beginTransmission(LSM6DSL_ADDR);
  Wire.write(0x11); 
  Wire.write(0x60); 
  Wire.endTransmission();

  Wire.beginTransmission(LSM6DSL_ADDR);
  Wire.write(0x22); 
  Wire.endTransmission(false);
  Wire.requestFrom(LSM6DSL_ADDR, 12, true);

  int16_t gyro_x = (Wire.read() | Wire.read() << 8);
  int16_t gyro_y = (Wire.read() | Wire.read() << 8);
  int16_t gyro_z = (Wire.read() | Wire.read() << 8);
  int16_t accel_x = (Wire.read() | Wire.read() << 8);
  int16_t accel_y = (Wire.read() | Wire.read() << 8);
  int16_t accel_z = (Wire.read() | Wire.read() << 8);

  float accel_scale = 0.061f; 
  float gyro_scale = 70.0f; 
  
  acc_x_init = accel_x * accel_scale;
  acc_y_init = accel_y * accel_scale;
  acc_z_init = accel_z * accel_scale;

}

float avg_acc_saved = 0;

void LSM6DSLTR_Data(float& x_acceleration, float& y_acceleration, float& z_acceleration, float& avg_acc){
  
  Wire.beginTransmission(LSM6DSL_ADDR);
  Wire.write(0x22); 
  Wire.endTransmission(false);
  Wire.requestFrom(LSM6DSL_ADDR, 12, true);


  int16_t gyro_x = (Wire.read() | Wire.read() << 8);
  int16_t gyro_y = (Wire.read() | Wire.read() << 8);
  int16_t gyro_z = (Wire.read() | Wire.read() << 8);
  int16_t accel_x = (Wire.read() | Wire.read() << 8);
  int16_t accel_y = (Wire.read() | Wire.read() << 8);
  int16_t accel_z = (Wire.read() | Wire.read() << 8);

  float accel_scale = 0.061f; 
  float gyro_scale = 70.0f; 
  
  x_acceleration = ((accel_x * accel_scale) - acc_x_init) / 100;
  y_acceleration = ((accel_y * accel_scale) - acc_y_init) / 100;
  z_acceleration = ((accel_z * accel_scale) - acc_z_init) / 100;

  float avg_acc_new = (x_acceleration + y_acceleration + z_acceleration)/3;
  avg_acc_saved = (avg_acc + avg_acc_new)/2;
  avg_acc = avg_acc_saved;
}







