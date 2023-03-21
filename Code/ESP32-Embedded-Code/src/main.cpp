#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_GFX.h>
#include <Adafruit_GC9A01.h>

#define TFT_CS 10
#define TFT_RST 9
#define TFT_DC 8

Adafruit_GC9A01 tft = Adafruit_GC9A01(TFT_CS, TFT_DC, TFT_RST);

const uint16_t image1[] = {...};
const uint16_t image2[] = {...};
const uint16_t image3[] = {...};

BLECharacteristic *pCharacteristic;
bool deviceConnected = false;

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
  }

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
  }
};

void displayImages() {
  tft.fillScreen(0);
  tft.pushImage(0, 0, 240, 240, image1);
  
  // rotate image2 around its center
  int16_t x = 120;
  int16_t y = 120;
  tft.startWrite();
  tft.setAddrWindow(0, 0, 239, 239);
  for (int16_t i = 0; i < 240; i++) {
    for (int16_t j = 0; j < 240; j++) {
      int16_t x0 = i - x;
      int16_t y0 = j - y;
      int16_t newx = (x0 * cos(0.01)) - (y0 * sin(0.01)) + x;
      int16_t newy = (x0 * sin(0.01)) + (y0 * cos(0.01)) + y;
      tft.writePixel(newx, newy, image2[j * 240 + i]);
    }
  }
  tft.endWrite();
  
  // rotate image3 around its center
  x = 120;
  y = 120;
  tft.startWrite();
  tft.setAddrWindow(0, 0, 239, 239);
  for (int16_t i = 0; i < 240; i++) {
    for (int16_t j = 0; j < 240; j++) {
      int16_t x0 = i - x;
      int16_t y0 = j - y;
      int16_t newx = (x0 * cos(0.02)) - (y0 * sin(0.02)) + x;
      int16_t newy = (x0 * sin(0.02)) + (y0 * cos(0.02)) + y;
      tft.writePixel(newx, newy, image3[j * 240 + i]);
    }
  }
  tft.endWrite();
}

void ble_setup(){
  BLEDevice::init("MyDevice"); // Set the name of the device

  BLEServer *pServer = BLEDevice::createServer(); // Create the BLE server
  pServer->setCallbacks(new MyServerCallbacks());

  // Create a custom service with a custom UUID
  BLEUUID customServiceUUID("0000b000-0000-1000-8000-00805f9b34fb");
  BLEService *pService = pServer->createService(customServiceUUID);

  // Create a custom characteristic with a custom UUID
  BLEUUID customCharUUID("0000c000-0000-1000-8000-00805f9b34fb");
  pCharacteristic = pService->createCharacteristic(
                      customCharUUID,
                      BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_NOTIFY
                    );

  pCharacteristic->addDescriptor(new BLE2902()); // Add the descriptor

  pService->start(); // Start the service
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(customServiceUUID); // Add the custom service UUID
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x06);  // Set the advertising interval
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising(); // Start advertising
  Serial.println("Waiting for a connection...");
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  ble_setup();
  tft.begin();
  tft.setRotation(1);
}

void loop() {
  displayImages();

  /*
  if (deviceConnected) {
    String value = "Hello, world!"; // The data to send
    pCharacteristic->setValue(value.c_str()); // Set the value of the characteristic
    pCharacteristic->notify(); // Send the data to the central device
    delay(1000); // Wait a second before sending the next message
  }
  */
 
}