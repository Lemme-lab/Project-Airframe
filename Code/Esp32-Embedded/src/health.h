#include <Arduino.h>

double estimateCaloriesBurned(int age, double weight, double height, char gender, double heartRate, float avgAcceleration, double oxygen, double bodyTemperature);

String getActivityStatus(double heartRate, double oxygen, float acceleration[3], double bodyTemperature);

double getCaloriesBurned();

int movingAverage(int input);

void detectPPGPeak(int ppgValue, unsigned long timestamp);

int estimateBloodPressure(float ptt);

double calculateStress(double heartRate, double bodyTemperature, String activity);