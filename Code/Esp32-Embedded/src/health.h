#include <Arduino.h>

double estimateCaloriesBurned(int age, double weight, double height, char gender, double heartRate, float avgAcceleration, double oxygen, double bodyTemperature);

String getActivityStatus(double heartRate, double oxygen, float acceleration[3], double bodyTemperature);

double getCaloriesBurned();

int movingAverage(int input);

void detectPPGPeak(int ppgValue, unsigned long timestamp);

double calculateStress(double heartRate, double bodyTemperature, String activity);

float preprocessData(float rawData);

int findPeaks(float *filteredData, int numSamples, int *peaks);

float calculatePtt(int *peaks, int numPeaks);

void calculate_blood_pressure(float &bpSystolic, float &bpDiastolic, float infraredData);

