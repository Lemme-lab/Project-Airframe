#include "Sleeptracker.h"
#include <EEPROM.h>

SleepQualityCalculator::SleepQualityCalculator()
{
  sleepQualitySum = 0;
  sleepQualityCount = 0;
}

int SleepQualityCalculator::calculateSleepQuality(float accValues[3], int hrValue, int gyrValues[3])
{
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

bool SleepQualityCalculator::isWithinTimeRange()
{

  /*
  if ((now.hour() >= 20 && now.hour() <= 23) || (now.hour() >= 0 && now.hour() < 7)) {
    return true;
  }
  */

  return true;

  return false;
}

// Sleep detection variables
const int MIN_SLEEP_HEART_RATE = 50;
const int MAX_SLEEP_HEART_RATE = 80;
const int MOTION_THRESHOLD = 5;
unsigned long lastSleepCheck = 0;
int sleepCounter = 0;

int counter1;


void updateSleepCounter(int heartRate, int accelX, int accelY, int accelZ, int gyroX, int gyroY, int gyroZ, int hours, int minutes, int seconds, double (&sleep)[12]) {

  EEPROM.get(0, counter1);

  if(hours == 0 && minutes == 0 && seconds == 0){
        counter1++;
        EEPROM.put(0, counter1);  
        EEPROM.commit();
  }

  // Check if the user is asleep every second
  if (millis() - lastSleepCheck >= 1000) {
    lastSleepCheck = millis();
    if (isAsleep(heartRate, accelX, accelY, accelZ, gyroX, gyroY, gyroZ)) {
      sleepCounter++;
    }
  }

  // Increment sleep counter every 5 minutes of sleep
  if (sleepCounter >= 300) {
    sleepCounter = 0;
    sleep[counter1]+=5;
  }
}

bool isAsleep(int heartRate, int accelX, int accelY, int accelZ, int gyroX, int gyroY, int gyroZ) {
  // Check if the user's heart rate is within the sleep range
  if (heartRate < MIN_SLEEP_HEART_RATE || heartRate > MAX_SLEEP_HEART_RATE) {
    return false;
  }

  // Check if the user is not moving
  if (abs(accelX) > MOTION_THRESHOLD || abs(accelY) > MOTION_THRESHOLD || abs(accelZ) > MOTION_THRESHOLD) {
    return false;
  }

  // Check if the user's gyroscope values are low
  if (abs(gyroX) > MOTION_THRESHOLD || abs(gyroY) > MOTION_THRESHOLD || abs(gyroZ) > MOTION_THRESHOLD) {
    return false;
  }

  return true;
}

