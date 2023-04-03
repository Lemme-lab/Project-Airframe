#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <bleObj.h>

#define DEVICENAME "Airframe-Watch"

#define SEND "f2f9a4de-ef95-4fe1-9c2e-ab5ef6f0d6e9"
#define SEND_STRING "9e8fafe1-8966-4276-a3a3-d0b00269541e"

#define RECIVE "1450dbb0-e48c-4495-ae90-5ff53327ede4"
#define RECIVE_STRING "9393c756-78ea-4629-a53e-52fb10f9a63f"

bool deviceConnected = false;
BleData data;


string strToString(std::string str) {
  return str.c_str();
}

int strToInt(std::string str) {
  const char* encoded = str.c_str();
  return 256 * int(encoded[1]) + int(encoded[0]);
}

double intToDouble(int value, double max) {
  return (1.0 * value) / max;
}

bool intToBool(int value) {
  if (value == 0) {
    return false;
  }
  return true;
}

class ConnectionServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("Connected");
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("Disconnected");
    }
};

class WriteString: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      string str = strToString(pCharacteristic->getValue());
      data = data.convertStringToBleData(str);
      Serial.print("Recived Object:");
      Serial.println(data.to_string().c_str());
    }
};


BLECharacteristic *sSendString;

void bleSetup() {
  Serial.print("Device Name:");
  Serial.println(DEVICENAME);

  BLEDevice::init(DEVICENAME);
  BLEServer *btServer = BLEDevice::createServer();
  btServer->setCallbacks(new ConnectionServerCallbacks());

  BLEService *sRecive = btServer->createService(RECIVE);
  uint32_t cwrite = BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE;

  BLECharacteristic *sReciveString = sRecive->createCharacteristic(RECIVE_STRING, cwrite);
  sReciveString->setCallbacks(new WriteString());

  BLEService *sSend = btServer->createService(SEND);
  uint32_t cnotify = BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE  |
                     BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_INDICATE;

  sSendString = sSend->createCharacteristic(SEND_STRING, cnotify);
  sSendString->addDescriptor(new BLE2902());

  sRecive->start();
  sSend->start();

  BLEAdvertising *pAdvertising = btServer->getAdvertising();
  pAdvertising->start();
}

void sendJson(BleData bleData){
  if (deviceConnected) {
    Serial.println("Sending Object");
    sSendString->setValue(bleData.to_string());
    sSendString->notify();
    }else{
      Serial.println("Not Connected");
    }
}

BleData getData(){
  return data;
}


