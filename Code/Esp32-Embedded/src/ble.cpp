#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <ble.h>

// https://www.uuidgenerator.net/

#define DEVICENAME "ESP32"

#define SEND "f2f9a4de-ef95-4fe1-9c2e-ab5ef6f0d6e9"
#define SEND_INT "e376bd46-0d9a-44ab-bb71-c262d06f60c7"
#define SEND_BOOL "5c409aab-50d4-42c2-bf57-430916e5eaf4"
#define SEND_STRING "9e8fafe1-8966-4276-a3a3-d0b00269541e"

#define RECIVE "1450dbb0-e48c-4495-ae90-5ff53327ede4"
#define RECIVE_INT "ec693074-43fe-489d-b63b-94456f83beb5"
#define RECIVE_BOOL "45db5a06-5481-49ee-a8e9-10b411d73de7"
#define RECIVE_STRING "9393c756-78ea-4629-a53e-52fb10f9a63f"

bool deviceConnected = false;

String strToString(std::string str) {
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
      String str = strToString(pCharacteristic->getValue());
      Serial.print("Recived String:");
      Serial.println(str);
    }
};

class WriteInt: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      int rint = strToInt(pCharacteristic->getValue());
      Serial.print("Recived Int:");
      Serial.println(rint);
    }
};

class WriteBool: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      bool rbool = intToBool(strToInt(pCharacteristic->getValue()));
      Serial.print("Recived Bool:");
      Serial.println(rbool ? "ON" : "OFF");
    }
};

BLECharacteristic *sSendInt;
BLECharacteristic *sSendBool;
BLECharacteristic *sSendString;

void blesetup() {
  Serial.print("Device Name:");
  Serial.println(DEVICENAME);

  BLEDevice::init(DEVICENAME);
  BLEServer *btServer = BLEDevice::createServer();
  btServer->setCallbacks(new ConnectionServerCallbacks());
  
  BLEService *sRecive = btServer->createService(RECIVE);
  uint32_t cwrite = BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE;

  BLECharacteristic *sReciveInt = sRecive->createCharacteristic(RECIVE_INT, cwrite);
  sReciveInt->setCallbacks(new WriteInt());

  BLECharacteristic *sReciveBool = sRecive->createCharacteristic(RECIVE_BOOL, cwrite);
  sReciveBool->setCallbacks(new WriteBool());

  BLECharacteristic *sReciveString = sRecive->createCharacteristic(RECIVE_STRING, cwrite);
  sReciveString->setCallbacks(new WriteString());


  BLEService *sSend = btServer->createService(SEND);
  uint32_t cnotify = BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE  |
                     BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_INDICATE;

  sSendInt = sSend->createCharacteristic(SEND_INT, cnotify);
  sSendInt->addDescriptor(new BLE2902());
  sSendInt->setValue("9000");

  sSendBool = sSend->createCharacteristic(SEND_BOOL, cnotify);
  sSendBool->addDescriptor(new BLE2902());
  sSendBool->setValue("0");

  sSendString = sSend->createCharacteristic(SEND_STRING, cnotify);
  sSendString->addDescriptor(new BLE2902());
  sSendString->setValue("Hi");


  sRecive->start();
  sSend->start();

  BLEAdvertising *pAdvertising = btServer->getAdvertising();
  pAdvertising->start();
}

uint32_t value = 0;

void sendJson(BleData bleData){
  if (deviceConnected) {
    Serial.println("Sending Object");
    String data = bleData.to_string();
    std::string send = data.c_str();
    sSendString->setValue(send);
    Serial.println(data);
    Serial.println("");
    sSendString->notify();
    }else{
      Serial.println("Not Connected");
    }
}

void sendJsonData1(BleData bleData){
  if (deviceConnected) {
    Serial.println("Sending Object Data");
    String data = bleData.to_string_data1();
    std::string send = data.c_str();
    sSendString->setValue(send);
    Serial.println(data);
    Serial.println("");
    sSendString->notify();
    }else{
      Serial.println("Not Connected");
    }
}

void sendJsonData2(BleData bleData){
  if (deviceConnected) {
    Serial.println("Sending Object Data");
    String data = bleData.to_string_data2();
    std::string send = data.c_str();
    sSendString->setValue(send);
    Serial.println(data);
    Serial.println("");
    sSendString->notify();
    }else{
      Serial.println("Not Connected");
    }
}

void sendJsonInfos(BleData bleData){
  if (deviceConnected) {
    Serial.println("Sending Object Data");
    String data = bleData.to_string_infos();
    std::string send = data.c_str();
    sSendString->setValue(send);
    Serial.println(data);
    sSendString->notify();
    }else{
      Serial.println("Not Connected");
    }
}



