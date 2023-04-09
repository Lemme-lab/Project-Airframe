#include <Arduino.h>
#include <iostream>
#include <cmath>
#include <tuple>
#include "stepcounter.h"

int StepCounter::calculateSteps(std::tuple<double, double> gps, std::tuple<double, double, double> acceleration, int heartRate) {
    double latitude, longitude;
    std::tie(latitude, longitude) = gps;

    double accX, accY, accZ;
    std::tie(accX, accY, accZ) = acceleration;

    if (isStep(latitude, longitude, std::sqrt(accX * accX + accY * accY + accZ * accZ), heartRate)) {
        totalSteps++;
    }

    return totalSteps;
}

bool StepCounter::isStep(double latitude, double longitude, double accelerationMagnitude, int heartRate) {
    const double gpsThreshold = 0.0001; // Adjust the threshold value based on your requirements
    const double accelerationThreshold = 1.5; // Adjust the threshold value based on your requirements
    const int heartRateThreshold = 60; // Adjust the threshold value based on your requirements

    bool gpsValid = std::abs(latitude - prevLatitude) > gpsThreshold || std::abs(longitude - prevLongitude) > gpsThreshold;
    bool accelerationValid = accelerationMagnitude > accelerationThreshold;
    bool heartRateValid = heartRate >= heartRateThreshold;

    prevLatitude = latitude;
    prevLongitude = longitude;

    return gpsValid && accelerationValid && heartRateValid;
}

int StepCounter1::update(float acceleration[3], int heart_beat, long current_time, bool& flag) {
    flag = false;
    double max_val = acceleration[0];

    if (acceleration[1] > max_val) {
        max_val = acceleration[1];
    }

    if (acceleration[2] > max_val) {
        max_val = acceleration[2];
    }

    if (max_val > threshold && (current_time - last_step_time) >= min_interval) {
        counter++;
        last_step_time = current_time;
        flag = true;
    }
    return counter;
}