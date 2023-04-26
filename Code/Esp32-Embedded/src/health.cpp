#include <Arduino.h>
#include <iostream>
#include <cmath>
#include <tuple>
#include <Filters.h>

double caloriesBurned = 0.0;

double estimateCaloriesBurned(int age, double weight, double height, char gender, double heartRate, float avgAcceleration, double oxygen, double bodyTemperature) {
    double met = 0.0;

    double bmr = 0.0;
    if (gender == 'M' || gender == 'm') {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else if (gender == 'F' || gender == 'f') {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    if (heartRate < 100) {
        met = 1.5;
    } else if (heartRate >= 100 && heartRate < 130) {
        met = 3.0;
    } else if (heartRate >= 130 && heartRate < 160) {
        met = 6.0;
    } else {
        met = 8.0;
    }

    met += 2 * avgAcceleration + 0.02 * oxygen + 0.03 * (bodyTemperature);

    caloriesBurned += (met * (weight / 200) * 1) / 50;

    return caloriesBurned;
}

double getCaloriesBurned(){
    return caloriesBurned;
}


static String lastStatus = "";   // variable to remember the last output
static int count = 0;            // variable to count consecutive same outputs
    

String getActivityStatus(double heartRate, double oxygen, float acceleration[3], double bodyTemperature) {

    const double RUNNING_HR = 130;
    const double RUNNING_ACC = 1.5;
    const double RUNNING_ACC_n = -1.5;
    const double RUNNING_OXY = 95;
    const double RUNNING_TEMP = 37.5;

    const double EXERCISING_HR = 80;
    const double EXERCISING_ACC = 1;
    const double EXERCISING_ACC_n = -1;
    const double EXERCISING_OXY = 93;
    const double EXERCISING_TEMP = 37;

    const double HYSTERESIS = 1.0;

    if(acceleration[0] < 0 ){
        acceleration[0] = acceleration[0]*(-1);
    }

    if(acceleration[1] < 0 ){
        acceleration[1] = acceleration[1]*(-1);
    }

    if(acceleration[2] < 0 ){
        acceleration[2] = acceleration[2]*(-1);
    }

    double max_val = acceleration[0];

    if (acceleration[1] > max_val) {
        max_val = acceleration[1];
    }

    if (acceleration[2] > max_val) {
        max_val = acceleration[2];
    }

    String newStatus = "";

    if (max_val > RUNNING_ACC && heartRate > RUNNING_HR && oxygen > RUNNING_OXY && bodyTemperature > RUNNING_TEMP) {
        newStatus = "Running";
    } 
    else if (max_val > EXERCISING_ACC + HYSTERESIS  || heartRate > EXERCISING_HR + HYSTERESIS || oxygen > EXERCISING_OXY || bodyTemperature > EXERCISING_TEMP) {
        newStatus = "Exercising";
    }
    else if (max_val < EXERCISING_ACC && heartRate < EXERCISING_HR && oxygen < EXERCISING_OXY && bodyTemperature < EXERCISING_TEMP ) {
        newStatus = "Normal";
    }
    else {
        newStatus = "Unknown";
    }

    Serial.println(count);
    Serial.println(lastStatus);

    if (newStatus == lastStatus) {   // check if the new status is the same as the last one
        count++;                     // increment the count
        if (count >= 2) {           // if the count exceeds the threshold
            count = 0;               // reset the count
            return lastStatus;       // return the last status
        }
    }
    else {                           // if the new status is different from the last one
        lastStatus = newStatus;      // update the last status
        count = 0;                   // reset the count
    }
    
    return "Unknown";               // return "Unknown" if the same status has not been repeated for 20 times
}

const int windowSize = 5; 
int signalBuffer[windowSize];
int bufferIndex = 0;

int movingAverage(int input) {
  signalBuffer[bufferIndex] = input;
  bufferIndex = (bufferIndex + 1) % windowSize;

  int sum = 0;
  for (int i = 0; i < windowSize; i++) {
    sum += signalBuffer[i];
  }
  return sum / windowSize;
}

int ppgThreshold = 10000; 
extern unsigned long lastRPeakTimestamp = 0;
extern unsigned long lastPPGPeakTimestamp = 0;
int lastPPGValue = 0;
extern bool ppgPeakDetected = false;

void detectPPGPeak(int ppgValue, unsigned long timestamp) {
  if (ppgValue > ppgThreshold && lastPPGValue <= ppgThreshold) {
    ppgPeakDetected = true;
    lastPPGPeakTimestamp = timestamp;
  }
  lastPPGValue = ppgValue;
}

float stressLevel = 0;

double calculateStress(double heartRate, double bodyTemperature, String activity) {
    double baselineHeartRate = 60.0;
    double baselineBodyTemperature = 36;

    double heartRateDeviation = (heartRate - baselineHeartRate) / baselineHeartRate;
    double bodyTemperatureDeviation = (bodyTemperature - baselineBodyTemperature) / baselineBodyTemperature;

    double heartRateWeight = 0.5;
    double bodyTemperatureWeight = 0.5;
    double stressScore = 0;

    if(activity == "Normal"){
      double stressScore = sqrt((heartRateDeviation * heartRateDeviation) * heartRateWeight +
                              (bodyTemperatureDeviation * bodyTemperatureDeviation) * bodyTemperatureWeight);  
    }

    String myStr = String(stressScore);
    Serial.println("StresssScore: " + myStr);
    

    return stressScore;
}

const int numSamples = 100;
const float lowcut = 0.5;
const float highcut = 10.0;
const int order = 1;

FilterOnePole lowpassFilter(LOWPASS, highcut);
FilterOnePole highpassFilter(HIGHPASS, lowcut);

float preprocessData(float rawData) {
  float lowpassed = lowpassFilter.input(rawData);
  float filteredData = highpassFilter.input(lowpassed);
  return filteredData;
}

int findPeaks(float *filteredData, int numSamples, int *peaks) {
  int numPeaks = 0;
  for (int i = 1; i < numSamples - 1; i++) {
    if (filteredData[i] > filteredData[i - 1] && filteredData[i] > filteredData[i + 1]) {
      peaks[numPeaks++] = i;
    }
  }
  return numPeaks;
}

float calculatePtt(int *peaks, int numPeaks) {
  float peakIntervals = 0;
  for (int i = 1; i < numPeaks; i++) {
    peakIntervals += peaks[i] - peaks[i - 1];
  }
  float ptt = peakIntervals / (numPeaks - 1);
  return ptt;
}

void calculate_blood_pressure(float &bpSystolic, float &bpDiastolic, float infraredData) {
  static float rawData[numSamples] = {0};
  static float filteredData[numSamples] = {0};
  int peaks[numSamples] = {0};
  int numPeaks = 0;

  memmove(rawData, rawData + 1, sizeof(float) * (numSamples - 1));
  memmove(filteredData, filteredData + 1, sizeof(float) * (numSamples - 1));

  rawData[numSamples - 1] = infraredData;
  filteredData[numSamples - 1] = preprocessData(infraredData);

  numPeaks = findPeaks(filteredData, numSamples, peaks);

  if (numPeaks >= 2) {
    float ptt = calculatePtt(peaks, numPeaks);

    bpSystolic = 0.45 * ptt + 80;
    bpDiastolic = 0.15 * ptt + 60;
  } else {
    bpSystolic = -1;
    bpDiastolic = -1;
  }
}