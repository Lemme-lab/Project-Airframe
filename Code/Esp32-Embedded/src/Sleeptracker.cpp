#include "Sleeptracker.h"

SleepQualityCalculator::SleepQualityCalculator() {
  sleepQualitySum = 0;
  sleepQualityCount = 0;
}

int SleepQualityCalculator::calculateSleepQuality(float accValues[3], int hrValue, int gyrValues[3]) {
  memcpy(accelerometerValues, accValues, sizeof(accelerometerValues));
  heartRateValue = hrValue;
  memcpy(gyroValues, gyrValues, sizeof(gyroValues));

  float accelerometerMagnitude = sqrt(pow(accelerometerValues[0], 2) + pow(accelerometerValues[1], 2) + pow(accelerometerValues[2], 2));
  float gyroMagnitude = sqrt(pow(gyroValues[0], 2) + pow(gyroValues[1], 2) + pow(gyroValues[2], 2));
  float sleepQuality = 100 - (accelerometerMagnitude * 0.2 + abs(heartRateValue - 60) * 0.5 + gyroMagnitude * 0.3);

  sleepQuality = max(min(sleepQuality, 100.0f), 0.0f);

  sleepQualitySum += sleepQuality;
  sleepQualityCount++;

  return static_cast<int>(sleepQualitySum / sleepQualityCount);
}

bool SleepQualityCalculator::isWithinTimeRange() {
  
  /*
  if ((now.hour() >= 20 && now.hour() <= 23) || (now.hour() >= 0 && now.hour() < 7)) {
    return true;
  }
  */

  return true;

  return false;
}