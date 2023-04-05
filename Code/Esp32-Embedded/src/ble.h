#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <bleObj.h>

String strToString(std::string str);

int strToInt(std::string str);

double intToDouble(int value, double max);

bool intToBool(int value);

void blesetup();

void sendJson(BleData bleData);

