#include <Arduino.h>

void NFCSetup();

void showIRQStatus(uint32_t irqStatus);

void readDataNFC();

void writeDataNFC();

void GPSSetup();

void GPS(int & latitude, int & longitude);

double toRadians(double degree);

void Speedometer(double & speed);