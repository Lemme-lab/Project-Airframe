/*
  Use ESP32 WiFi to get the L-Band dynamic keys from PointPerfect, allowing a ZED-F9x to use
  the PMP data from a NEO-D9S correction data receiver.
  By: SparkFun / Paul Clark
  Based on original code by: u-blox AG / Michael Ammann
  Date: March 17th, 2022
  License: MIT. See license file for more information.

  This example shows how to obtain the L-Band dynamic keys from PointPerfect over ESP32 WiFi
  and push them over I2C to a ZED-F9x. The ZED will then be able to decrypt the PMP correction data
  from a NEO-D9S correction data receiver.

  You can copy the keys directly from the Thingstream portal and paste them into your code -
  but calculating the "valid from" week and time is a chore.
  This example requests the keys for you (using your client key and certificates) via MQTT.
  It prints them too, so you can copy and paste them into your code if you wish.

  You will need to have a valid u-blox Thingstream account and have a PointPerfect L-Band or L-Band + IP
  Location Thing and payed plan. Copy and paste your Client ID, Certificates and Key into secrets.h.
  
  If you are using the SparkFun Combo Board (SPX-20167), the correction data is transferred from the NEO to the ZED via UART2.
  You don't need to push it over I2C. Doing so just gives the ZED twice as many correction messages.
  Uncomment the "#define noPush" below to disable the I2C push.

  Thingstream offers SSR corrections to SPARTN capable RTK receivers such as the u-blox ZED-F9 series 
  in continental Europe and US. Their Network is planned to be expanded to other regions over the next years. 
  To sign up, go to: https://portal.thingstream.io/app/location-services/things

  For more information about MQTT, SPARTN and PointPerfect Correction Services 
  please see: https://www.u-blox.com/en/product/pointperfect
  
  Feel like supporting open source hardware?
  Buy a board from SparkFun!
  ZED-F9P RTK2: https://www.sparkfun.com/products/16481
  NEO-D9S Correction Data Receiver: https://www.sparkfun.com/products/19390
  ZED-F9P + NEO-D9S Combo Board: https://www.sparkfun.com/products/20167
  
  Hardware Connections:
  Plug a Qwiic cable into the GNSS and a ESP32 Thing Plus
  If you don't have a platform with a Qwiic connection use the SparkFun Qwiic Breadboard Jumper (https://www.sparkfun.com/products/14425)
  Open the serial monitor at 115200 baud to see the output
*/

//#define noPush // Uncomment this line to disable pushing the correction data over I2C. Useful for the combo board which uses UART2 instead.

#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <ArduinoMqttClient.h> // Click here to get the library: http://librarymanager/All#ArduinoMqttClient

#include "secrets.h" // <- Copy and paste your Client ID, Certificates and Key into secrets.h

#include <SparkFun_u-blox_GNSS_v3.h> // Click here to get the library: http://librarymanager/All#SparkFun_u-blox_GNSS_v3
SFE_UBLOX_GNSS myGNSS; // ZED-F9x
SFE_UBLOX_GNSS myLBand; // NEO-D9S

const uint32_t myLBandFreq = 1556290000; // Uncomment this line to use the US SPARTN 1.8 service
//const uint32_t myLBandFreq = 1545260000; // Uncomment this line to use the EU SPARTN 1.8 service

#define OK(ok) (ok ? F("  ->  OK") : F("  ->  ERROR!")) // Convert uint8_t into OK/ERROR

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    
//Global variables

long lastReceived_ms = 0; //5 RTCM messages take approximately ~300ms to arrive at 115200bps
int maxTimeBeforeHangup_ms = 10000; //If we fail to get a complete RTCM frame after 10s, then disconnect from caster

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Callback: pushRXMPMP will be called when new PMP data arrives
// See u-blox_structs.h for the full definition of UBX_RXM_PMP_message_data_t
//         _____  You can use any name you like for the callback. Use the same name when you call setRXMPMPmessageCallbackPtr
//        /               _____  This _must_ be UBX_RXM_PMP_message_data_t
//        |              /              _____ You can use any name you like for the struct
//        |              |             /
//        |              |             |
void pushRXMPMP(UBX_RXM_PMP_message_data_t *pmpData)
{
  //Extract the raw message payload length
  uint16_t payloadLen = ((uint16_t)pmpData->lengthMSB << 8) | (uint16_t)pmpData->lengthLSB;
  Serial.print(F("New RXM-PMP data received. Message payload length is "));
  Serial.print(payloadLen);

#ifndef noPush

  Serial.println(F(" Bytes. Pushing it to the GNSS..."));
  
  //Push the PMP data to the GNSS
  //The payload length could be variable, so we need to push the header and payload, then checksum
  myGNSS.pushRawData(&pmpData->sync1, (size_t)payloadLen + 6); // Push the sync chars, class, ID, length and payload
  myGNSS.pushRawData(&pmpData->checksumA, (size_t)2); // Push the checksum bytes

#else

  Serial.println(F(" Bytes."));

#endif

}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Callback: printPVTdata will be called when new NAV PVT data arrives
// See u-blox_structs.h for the full definition of UBX_NAV_PVT_data_t
//         _____  You can use any name you like for the callback. Use the same name when you call setAutoPVTcallbackPtr
//        /                  _____  This _must_ be UBX_NAV_PVT_data_t
//        |                 /               _____ You can use any name you like for the struct
//        |                 |              /
//        |                 |              |
void printPVTdata(UBX_NAV_PVT_data_t *ubxDataStruct)
{
  double latitude = ubxDataStruct->lat; // Print the latitude
  Serial.print(F("Lat: "));
  Serial.print(latitude / 10000000.0, 7);

  double longitude = ubxDataStruct->lon; // Print the longitude
  Serial.print(F("  Long: "));
  Serial.print(longitude / 10000000.0, 7);

  double altitude = ubxDataStruct->hMSL; // Print the height above mean sea level
  Serial.print(F("  Height: "));
  Serial.print(altitude / 1000.0, 3);

  uint8_t fixType = ubxDataStruct->fixType; // Print the fix type
  Serial.print(F("  Fix: "));
  Serial.print(fixType);
  if (fixType == 0)
    Serial.print(F(" (None)"));
  else if (fixType == 1)
    Serial.print(F(" (Dead Reckoning)"));
  else if (fixType == 2)
    Serial.print(F(" (2D)"));
  else if (fixType == 3)
    Serial.print(F(" (3D)"));
  else if (fixType == 3)
    Serial.print(F(" (GNSS + Dead Reckoning)"));
  else if (fixType == 5)
    Serial.print(F(" (Time Only)"));
  else
    Serial.print(F(" (UNKNOWN)"));

  uint8_t carrSoln = ubxDataStruct->flags.bits.carrSoln; // Print the carrier solution
  Serial.print(F("  Carrier Solution: "));
  Serial.print(carrSoln);
  if (carrSoln == 0)
    Serial.print(F(" (None)"));
  else if (carrSoln == 1)
    Serial.print(F(" (Floating)"));
  else if (carrSoln == 2)
    Serial.print(F(" (Fixed)"));
  else
    Serial.print(F(" (UNKNOWN)"));

  uint32_t hAcc = ubxDataStruct->hAcc; // Print the horizontal accuracy estimate
  Serial.print(F("  Horizontal Accuracy Estimate: "));
  Serial.print(hAcc);
  Serial.print(F(" (mm)"));

  Serial.println();    
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Callback: printRXMCOR will be called when new RXM COR data arrives
// See u-blox_structs.h for the full definition of UBX_RXM_COR_data_t
//         _____  You can use any name you like for the callback. Use the same name when you call setRXMCORcallbackPtr
//        /                  _____  This _must_ be UBX_RXM_COR_data_t
//        |                 /               _____ You can use any name you like for the struct
//        |                 |              /
//        |                 |              |
void printRXMCOR(UBX_RXM_COR_data_t *ubxDataStruct)
{
  Serial.print(F("UBX-RXM-COR:  ebno: "));
  Serial.print(ubxDataStruct->ebno);

  Serial.print(F("  protocol: "));
  if (ubxDataStruct->statusInfo.bits.protocol == 1)
    Serial.print(F("RTCM3"));
  else if (ubxDataStruct->statusInfo.bits.protocol == 2)
    Serial.print(F("SPARTN"));
  else if (ubxDataStruct->statusInfo.bits.protocol == 29)
    Serial.print(F("PMP (SPARTN)"));
  else if (ubxDataStruct->statusInfo.bits.protocol == 30)
    Serial.print(F("QZSSL6"));
  else
    Serial.print(F("Unknown"));

  Serial.print(F("  errStatus: "));
  if (ubxDataStruct->statusInfo.bits.errStatus == 1)
    Serial.print(F("Error-free"));
  else if (ubxDataStruct->statusInfo.bits.errStatus == 2)
    Serial.print(F("Erroneous"));
  else
    Serial.print(F("Unknown"));

  Serial.print(F("  msgUsed: "));
  if (ubxDataStruct->statusInfo.bits.msgUsed == 1)
    Serial.print(F("Not used"));
  else if (ubxDataStruct->statusInfo.bits.msgUsed == 2)
    Serial.print(F("Used"));
  else
    Serial.print(F("Unknown"));

  Serial.print(F("  msgEncrypted: "));
  if (ubxDataStruct->statusInfo.bits.msgEncrypted == 1)
    Serial.print(F("Not encrypted"));
  else if (ubxDataStruct->statusInfo.bits.msgEncrypted == 2)
    Serial.print(F("Encrypted"));
  else
    Serial.print(F("Unknown"));

  Serial.print(F("  msgDecrypted: "));
  if (ubxDataStruct->statusInfo.bits.msgDecrypted == 1)
    Serial.print(F("Not decrypted"));
  else if (ubxDataStruct->statusInfo.bits.msgDecrypted == 2)
    Serial.print(F("Successfully decrypted"));
  else
    Serial.print(F("Unknown"));

  Serial.println();
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

void setup()
{
  delay(1000);
  
  Serial.begin(115200);
  Serial.println(F("NEO-D9S PMP Corrections"));

  Wire.begin(); //Start I2C

  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  // Begin and configure the ZED-F9x

  //myGNSS.enableDebugging(); // Uncomment this line to enable helpful debug messages on Serial

  while (myGNSS.begin() == false) //Connect to the u-blox module using Wire port
  {
    Serial.println(F("u-blox GNSS module not detected at default I2C address. Please check wiring."));
    delay(2000);
  }
  Serial.println(F("u-blox GNSS module connected"));
  
  uint8_t ok = myGNSS.setI2COutput(COM_TYPE_UBX); //Turn off NMEA noise
  if (ok) ok = myGNSS.setI2CInput(COM_TYPE_UBX | COM_TYPE_NMEA | COM_TYPE_SPARTN); //Be sure SPARTN input is enabled
  if (ok) ok = myGNSS.setDGNSSConfiguration(SFE_UBLOX_DGNSS_MODE_FIXED); // Set the differential mode - ambiguities are fixed whenever possible
  if (ok) ok = myGNSS.setNavigationFrequency(1); //Set output in Hz.
  if (ok) ok = myGNSS.setVal8(UBLOX_CFG_SPARTN_USE_SOURCE, 1); // use LBAND PMP message
  if (ok) ok = myGNSS.setVal8(UBLOX_CFG_MSGOUT_UBX_RXM_COR_I2C, 1); // Enable UBX-RXM-COR messages on I2C
  
  Serial.print(F("GNSS: configuration "));
  Serial.println(OK(ok));

  myGNSS.setAutoPVTcallbackPtr(&printPVTdata); // Enable automatic NAV PVT messages with callback to printPVTdata so we can watch the carrier solution go to fixed

  myGNSS.setRXMCORcallbackPtr(&printRXMCOR); // Print the contents of UBX-RXM-COR messages so we can check if the PMP data is being decrypted successfully

  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  // Begin and configure the NEO-D9S L-Band receiver

  //myLBand.enableDebugging(); // Uncomment this line to enable helpful debug messages on Serial

  while (myLBand.begin(Wire, 0x43) == false) //Connect to the u-blox NEO-D9S using Wire port. The D9S default I2C address is 0x43 (not 0x42)
  {
    Serial.println(F("u-blox NEO-D9S not detected at default I2C address. Please check wiring."));
    delay(2000);
  }
  Serial.println(F("u-blox NEO-D9S connected"));

  myLBand.newCfgValset(); // Create a new Configuration Interface message - this defaults to VAL_LAYER_RAM_BBR (change in RAM and BBR)
  myLBand.addCfgValset32(UBLOX_CFG_PMP_CENTER_FREQUENCY,   myLBandFreq); // Default 1539812500 Hz
  myLBand.addCfgValset16(UBLOX_CFG_PMP_SEARCH_WINDOW,      2200);        // Default 2200 Hz
  myLBand.addCfgValset8(UBLOX_CFG_PMP_USE_SERVICE_ID,      0);           // Default 1 
  myLBand.addCfgValset16(UBLOX_CFG_PMP_SERVICE_ID,         21845);       // Default 50821
  myLBand.addCfgValset16(UBLOX_CFG_PMP_DATA_RATE,          2400);        // Default 2400 bps
  myLBand.addCfgValset8(UBLOX_CFG_PMP_USE_DESCRAMBLER,     1);           // Default 1
  myLBand.addCfgValset16(UBLOX_CFG_PMP_DESCRAMBLER_INIT,   26969);       // Default 23560
  myLBand.addCfgValset8(UBLOX_CFG_PMP_USE_PRESCRAMBLING,   0);           // Default 0
  myLBand.addCfgValset64(UBLOX_CFG_PMP_UNIQUE_WORD,        16238547128276412563ull); 
  myLBand.addCfgValset8(UBLOX_CFG_MSGOUT_UBX_RXM_PMP_I2C,   1); // Ensure UBX-RXM-PMP is enabled on the I2C port 
  myLBand.addCfgValset8(UBLOX_CFG_MSGOUT_UBX_RXM_PMP_UART1, 1); // Output UBX-RXM-PMP on UART1
  myLBand.addCfgValset8(UBLOX_CFG_UART2OUTPROT_UBX, 1);         // Enable UBX output on UART2
  myLBand.addCfgValset8(UBLOX_CFG_MSGOUT_UBX_RXM_PMP_UART2, 1); // Output UBX-RXM-PMP on UART2
  myLBand.addCfgValset32(UBLOX_CFG_UART1_BAUDRATE,         38400); // match baudrate with ZED default
  myLBand.addCfgValset32(UBLOX_CFG_UART2_BAUDRATE,         38400); // match baudrate with ZED default
  ok = myLBand.sendCfgValset(); // Apply the settings
  
  Serial.print(F("L-Band: configuration "));
  Serial.println(OK(ok));

  myLBand.softwareResetGNSSOnly(); // Do a restart

  myLBand.setRXMPMPmessageCallbackPtr(&pushRXMPMP); // Call pushRXMPMP when new PMP data arrives. Push it to the GNSS

  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  // Connect to WiFi so we can request the dynamic keys via MQTT
  
  Serial.print(F("Connecting to local WiFi"));
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(F("."));
  }
  Serial.println();

  Serial.print(F("WiFi connected with IP: "));
  Serial.println(WiFi.localIP());
  
  while (Serial.available()) Serial.read();

  Serial.println(F("Press any key to start MQTT Client."));

}

void loop()
{
  if (Serial.available())
  {
    beginClient();

    while (Serial.available()) Serial.read(); //Empty buffer of any newline chars

    Serial.println(F("Press any key to start MQTT Client."));
  }

  myGNSS.checkUblox(); // Check for the arrival of new GNSS data and process it.
  myGNSS.checkCallbacks(); // Check if any GNSS callbacks are waiting to be processed.

  myLBand.checkUblox(); // Check for the arrival of new PMP data and process it.
  myLBand.checkCallbacks(); // Check if any LBand callbacks are waiting to be processed.
}

WiFiClientSecure wifiClient = WiFiClientSecure();
MqttClient mqttClient(wifiClient);

void mqttMessageHandler(int messageSize)
{
  const uint16_t mqttLimit = 512;
  uint8_t *mqttData = new uint8_t[mqttLimit]; // Allocate memory to hold the MQTT data
  if (mqttData == NULL)
  {
    Serial.println(F("Memory allocation for mqttData failed!"));
    return;
  }

  Serial.print(F("Pushing data from "));
  Serial.print(mqttClient.messageTopic());
  Serial.println(F(" topic to ZED"));

  while (mqttClient.available())
  {
    uint16_t mqttCount = 0;

    while (mqttClient.available())
    {
      char ch = mqttClient.read();
      //Serial.write(ch); //Pipe to serial port is fine but beware, it's a lot of binary data
      mqttData[mqttCount++] = ch;
    
      if (mqttCount == mqttLimit)
        break;
    }

    if (mqttCount > 0)
    {
      //Push KEYS or SPARTN data to GNSS module over I2C
      myGNSS.pushRawData(mqttData, mqttCount, false);
      lastReceived_ms = millis();

      if ((mqttData[0] == 0xB5) // Check if this is UBX-RXM-SPARTNKEY
       && (mqttData[1] == 0x62)
       && (mqttData[2] == 0x02) // Class: RXM
       && (mqttData[3] == 0x36)) // ID: SPARTNKEY
      {
        uint8_t numKeys = mqttData[7]; // Get the number of keys
        uint8_t keyStart = 10 + (numKeys * 8); // Point to the start of the first key
        for (uint8_t key = 0; key < numKeys; key++)
        {
          Serial.print(F("SPARTNKEY: "));
          Serial.println(key);
          Serial.print(F("Valid from GPS week number: "));
          uint16_t validFromWno = ((uint16_t)mqttData[12 + (key * 8)]) | ((uint16_t)mqttData[13 + (key * 8)] << 8); // Little endian
          Serial.println(validFromWno);
          Serial.print(F("Valid from GPS time of week: "));
          uint32_t validFromTow = ((uint32_t)mqttData[14 + (key * 8)]) | ((uint32_t)mqttData[15 + (key * 8)] << 8) | ((uint32_t)mqttData[16 + (key * 8)] << 16) | ((uint32_t)mqttData[17 + (key * 8)] << 24);
          Serial.println(validFromTow);
          uint8_t keyLengthBytes = mqttData[11 + (key * 8)];
          Serial.print(F("Key length (bytes): "));
          Serial.println(keyLengthBytes);
          Serial.print(F("Key: \""));
          for (uint8_t digit = 0; digit < keyLengthBytes; digit++)
          {
            Serial.print(mqttData[keyStart + digit] >> 4, HEX); // Print the key as ASCII Hex
            Serial.print(mqttData[keyStart + digit] & 0x0F, HEX); // Print the key as ASCII Hex
          }
          Serial.println(F("\""));
          keyStart += keyLengthBytes; // Update keyStart for the next key
        }
      }
    }
  }

  delete[] mqttData;
}

//Connect to MQTT broker, receive dynamic keys and push to ZED module over I2C
void beginClient()
{
  Serial.println(F("Subscribing to Broker. Press key to stop"));
  delay(10); //Wait for any serial to arrive
  while (Serial.available()) Serial.read(); //Flush

  while (Serial.available() == 0)
  {
    //Connect if we are not already
    if (wifiClient.connected() == false)
    {
      // Connect to AWS IoT
      wifiClient.setCACert(AWS_CERT_CA);
      wifiClient.setCertificate(AWS_CERT_CRT);
      wifiClient.setPrivateKey(AWS_CERT_PRIVATE);
      mqttClient.setId(MQTT_CLIENT_ID);
      mqttClient.setKeepAliveInterval(60*1000);
      mqttClient.setConnectionTimeout( 5*1000);
      if (!mqttClient.connect(AWS_IOT_ENDPOINT, AWS_IOT_PORT)) {
        Serial.print(F("MQTT connection failed! Error code = "));
        Serial.println(mqttClient.connectError());
        return;
      } else {
        Serial.println(F("You're connected to the PointPerfect MQTT broker: "));
        Serial.println(AWS_IOT_ENDPOINT);
        // Subscribe to MQTT and register a callback
        Serial.println(F("Subscribe to Topics")); 
        mqttClient.onMessage(mqttMessageHandler);
        mqttClient.subscribe(MQTT_TOPIC_KEY);
        lastReceived_ms = millis();
      } //End attempt to connect
    } //End connected == false
    else {
      mqttClient.poll();
    }
    
    //Close socket if we don't have new data for 10s
    if (millis() - lastReceived_ms > maxTimeBeforeHangup_ms)
    {
      Serial.println(F("MQTT timeout. Disconnecting..."));
      if (mqttClient.connected() == true)
        mqttClient.stop();
      return;
    }

    myGNSS.checkUblox(); // Check for the arrival of new GNSS data and process it.
    myGNSS.checkCallbacks(); // Check if any GNSS callbacks are waiting to be processed.
  
    myLBand.checkUblox(); // Check for the arrival of new PMP data and process it.
    myLBand.checkCallbacks(); // Check if any LBand callbacks are waiting to be processed.

    delay(10);
  }

  Serial.println(F("User pressed a key"));
  Serial.println(F("Disconnecting..."));
  wifiClient.stop();
}
