#ifndef Sleeptracker_H
#define Sleeptracker_H

#include <Arduino.h>

class SleepQualityCalculator {
  private:
    float accelerometerValues[3];
    int heartRateValue;
    int gyroValues[3];
    float sleepQualitySum;
    int sleepQualityCount;

  public:
    SleepQualityCalculator();
    int calculateSleepQuality(float accValues[3], int hrValue, int gyrValues[3]);
    bool isWithinTimeRange();
};

bool isAsleep(int heartRate, int accelX, int accelY, int accelZ, int gyroX, int gyroY, int gyroZ);

void updateSleepCounter(int heartRate, int accelX, int accelY, int accelZ, int gyroX, int gyroY, int gyroZ, int hours, int minutes, int seconds, double (&sleep)[12]);

int getSleepQuality();

#endif