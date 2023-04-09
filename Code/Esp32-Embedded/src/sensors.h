#include "MAX30105.h"
#include "Adafruit_Sensor.h"



void Max30105Setup( );

void Max30105HeartRate(long& irValue, float& beatsPerMinute, double& beatAvg);

void LIS2MDLTRSetup();

void LIS2MDLTRData(int& x, int&y, int& z);

void Max30105Temp(float& temperature);

void Max30105_O2_Setup();

void Max30105_O2(int& heartRate, int& spo2);

void LIS2MDLTRCompass(float& heading);

void ICP_Setup();

void ICP_Data(float& airPressure, int& temperature, int& altitude);

void KXTJ3_Setup();

void KXTJ3_Data(float& x, float& y, float& z);

void LSM6DSLTR_Setup();

void LSM6DSLTR_Data();

void LSM6DSLTR_Setup();

void LSM6DSLTR_Data(float& x_acceleration, float& y_acceleration, float& z_acceleration, float& avg_acc);

