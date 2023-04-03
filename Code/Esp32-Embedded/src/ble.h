#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <bleObj.h>

string strToString(std::string str);

int strToInt(std::string str);

double intToDouble(int value, double max);

bool intToBool(int value);

void bleSetup();

void sendJson(BleData bleData);

BleData getData();