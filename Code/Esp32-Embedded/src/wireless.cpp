#include <Arduino.h>

#include "PN5180.h"

#include "Debug.h"

#include "SparkFun_u-blox_GNSS_v3.h"

#include <Wire.h>



SFE_UBLOX_GNSS myGNSS;

void GPSSetup() {
    if (myGNSS.begin() == false) {
        Serial.println(F("u-blox GNSS module not detected at default I2C address. Please check wiring. Freezing."));
        while (1);
    }
    myGNSS.setNMEAOutputPort(Serial);
}

void GPS(int & latitude, int & longitude, int & ) {
    latitude = myGNSS.getLatitude();
    longitude = myGNSS.getLongitude();
    delay(100);
}