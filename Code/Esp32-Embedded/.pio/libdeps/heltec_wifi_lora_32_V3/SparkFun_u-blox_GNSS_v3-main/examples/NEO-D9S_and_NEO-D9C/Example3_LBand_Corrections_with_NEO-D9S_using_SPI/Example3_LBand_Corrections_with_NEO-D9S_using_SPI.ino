/*
  Use the NEO-D9S L-Band receiver to provide corrections to a ZED-F9x via UBX-RXM-PMP messages using SPI
  By: SparkFun Electronics / Paul Clark
  Based on original code by: u-blox AG / Michael Ammann
  v3 updates: December 22nd, 2022
  License: MIT. See license file for more information.

  This example shows how to obtain SPARTN correction data from a NEO-D9S L-Band receiver and push it over SPI to a ZED-F9x.

  This is a proof of concept to show how the UBX-RXM-PMP corrections control the accuracy.

  Please note: this example won't work on the SparkFun Combo Board (SPX-20167) as that cannot be configured for SPI.
  You will need to use the stand-alone NEO-D9S breakout plus (e.g.) a ZED-F9P and configure both for SPI using the DSEL jumper.

  You will need a Thingstream PointPerfect account to be able to access the SPARTN Credentials (L-Band or L-Band + IP Dynamic Keys).
  Copy and paste the Current Key and Next Key into secrets.h.

  Feel like supporting open source hardware?
  Buy a board from SparkFun!
  ZED-F9P RTK2: https://www.sparkfun.com/products/16481
  NEO-D9S:      https://www.sparkfun.com/products/19390

  Hardware Connections:
  Use jumper cables to connect the NEO-D9S and ZED-F9x GNSS to your board
  You need to connect GND, PICO, POCI, SCK, two Chip Selects, plus 3V3 or 5V depending on your needs and boards.
  Open the serial monitor at 115200 baud to see the output
*/

#include "secrets.h" // <- Copy and paste the Current Key and Next Key into secrets.h

#include <SparkFun_u-blox_GNSS_v3.h> //http://librarymanager/All#SparkFun_u-blox_GNSS_v3
SFE_UBLOX_GNSS_SPI myGNSS; // ZED-F9x
SFE_UBLOX_GNSS_SPI myLBand; // NEO-D9S

#define mySPI SPI       // Use SPI. Change this if required
#define mySpeed 2000000 // Run the SPI bus at 2MHz
#define gnssCS 4        // Define the GPIO pin for the GNSS (ZED-F9P) Chip Select. Change this as required
#define lbandCS 17      // Define the GPIO pin for the L-Band (NEO-D9S) Chip Select. Change this as required

const uint32_t myLBandFreq = 1556290000; // Uncomment this line to use the US SPARTN 1.8 service
//const uint32_t myLBandFreq = 1545260000; // Uncomment this line to use the EU SPARTN 1.8 service

#define OK(ok) (ok ? F("  ->  OK") : F("  ->  ERROR!")) // Convert bool into OK/ERROR

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

  Serial.println(F(" Bytes. Pushing it to the GNSS..."));
  
  //Push the PMP data to the GNSS
  //The payload length could be variable, so we need to push the header and payload, then checksum
  myGNSS.pushRawData(&pmpData->sync1, (size_t)payloadLen + 6); // Push the sync chars, class, ID, length and payload
  myGNSS.pushRawData(&pmpData->checksumA, (size_t)2); // Push the checksum bytes
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
  // Ensure both CS pins are high
  pinMode(gnssCS, OUTPUT);
  digitalWrite(gnssCS, HIGH);
  pinMode(lbandCS, OUTPUT);
  digitalWrite(lbandCS, HIGH);

  Serial.begin(115200);
  delay(1000);
  Serial.println(F("NEO-D9S SPARTN Corrections"));

  mySPI.begin(); //Start SPI

  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  // Begin and configure the ZED-F9x

  //myGNSS.enableDebugging(); // Uncomment this line to enable helpful debug messages on Serial

  while (myGNSS.begin(mySPI, gnssCS, mySpeed) == false) //Connect to the u-blox module using the details defined above
  {
    Serial.println(F("u-blox GNSS module not detected. Please check wiring."));
    delay(2000);
  }
  Serial.println(F("u-blox GNSS module connected"));

  bool    ok = myGNSS.setSPIOutput(COM_TYPE_UBX); //Turn off NMEA noise
  if (ok) ok = myGNSS.setSPIInput(COM_TYPE_UBX | COM_TYPE_NMEA | COM_TYPE_SPARTN); //Be sure SPARTN input is enabled
  if (ok) ok = myGNSS.setDGNSSConfiguration(SFE_UBLOX_DGNSS_MODE_FIXED); // Set the differential mode - ambiguities are fixed whenever possible
  if (ok) ok = myGNSS.setNavigationFrequency(1); //Set output in Hz.
  if (ok) ok = myGNSS.setVal8(UBLOX_CFG_SPARTN_USE_SOURCE, 1); // use LBAND PMP message
  if (ok) ok = myGNSS.setVal8(UBLOX_CFG_MSGOUT_UBX_RXM_COR_SPI, 1); // Enable UBX-RXM-COR messages on I2C
  
  //Configure the SPARTN IP Dynamic Keys
  //"When the receiver boots, the host should send 'current' and 'next' keys in one message." - Use setDynamicSPARTNKeys for this.
  //"Every time the 'current' key is expired, 'next' takes its place."
  //"Therefore the host should then retrieve the new 'next' key and send only that." - Use setDynamicSPARTNKey for this.
  // The key can be provided in binary (uint8_t) format or in ASCII Hex (char) format, but in both cases keyLengthBytes _must_ represent the binary key length in bytes.
  if (ok) ok = myGNSS.setDynamicSPARTNKeys(currentKeyLengthBytes, currentKeyGPSWeek, currentKeyGPSToW, currentDynamicKey,
                                           nextKeyLengthBytes, nextKeyGPSWeek, nextKeyGPSToW, nextDynamicKey);

  //if (ok) ok = myGNSS.saveConfiguration(VAL_CFG_SUBSEC_IOPORT | VAL_CFG_SUBSEC_MSGCONF); //Optional: Save the ioPort and message settings to NVM and BBR
  
  Serial.print(F("GNSS: configuration "));
  Serial.println(OK(ok));

  myGNSS.setAutoPVTcallbackPtr(&printPVTdata); // Enable automatic NAV PVT messages with callback to printPVTdata so we can watch the carrier solution go to fixed

  myGNSS.setRXMCORcallbackPtr(&printRXMCOR); // Print the contents of UBX-RXM-COR messages so we can check if the PMP data is being decrypted successfully

  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  // Begin and configure the NEO-D9S L-Band receiver

  //myLBand.enableDebugging(); // Uncomment this line to enable helpful debug messages on Serial

  // Make sure the spiBuffer is larger than a 528 byte PMP message
  // Otherwise we could lose incoming data during pushRXMPMP
  myLBand.setSpiBufferSize(640);

  while (myLBand.begin(mySPI, lbandCS, mySpeed) == false) //Connect to the u-blox NEO-D9S using the details defined above
  {
    Serial.println(F("u-blox NEO-D9S not detected. Please check wiring."));
    delay(2000);
  }
  Serial.println(F("u-blox NEO-D9S connected"));

  do // Repeat until successful. Occasionally the configuration fails if the module is already receiving PMP data
  {
    myLBand.checkUblox(); // Discard any old PMP data in the buffer
  
    myLBand.newCfgValset();
    myLBand.addCfgValset32(UBLOX_CFG_PMP_CENTER_FREQUENCY,   myLBandFreq); // Default 1539812500 Hz
    myLBand.addCfgValset16(UBLOX_CFG_PMP_SEARCH_WINDOW,      2200);        // Default 2200 Hz
    myLBand.addCfgValset8(UBLOX_CFG_PMP_USE_SERVICE_ID,      0);           // Default 1 
    myLBand.addCfgValset16(UBLOX_CFG_PMP_SERVICE_ID,         21845);       // Default 50821
    myLBand.addCfgValset16(UBLOX_CFG_PMP_DATA_RATE,          2400);        // Default 2400 bps
    myLBand.addCfgValset8(UBLOX_CFG_PMP_USE_DESCRAMBLER,     1);           // Default 1
    myLBand.addCfgValset16(UBLOX_CFG_PMP_DESCRAMBLER_INIT,   26969);       // Default 23560
    myLBand.addCfgValset8(UBLOX_CFG_PMP_USE_PRESCRAMBLING,   0);           // Default 0
    myLBand.addCfgValset64(UBLOX_CFG_PMP_UNIQUE_WORD,        16238547128276412563ull);
    myLBand.addCfgValset8(UBLOX_CFG_MSGOUT_UBX_RXM_PMP_SPI, 1); // Ensure UBX-RXM-PMP is enabled on the SPI port
    ok = myLBand.sendCfgValset(2100);
    
    Serial.print(F("L-Band: configuration "));
    Serial.println(OK(ok));
  }
  while (!ok);

  myLBand.softwareResetGNSSOnly(); // Do a restart

  myLBand.setRXMPMPmessageCallbackPtr(&pushRXMPMP); // Call pushRXMPMP when new PMP data arrives. Push it to the GNSS
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

void loop()
{
  myGNSS.checkUblox(); // Check for the arrival of new GNSS data and process it.
  myGNSS.checkCallbacks(); // Check if any GNSS callbacks are waiting to be processed.

  myLBand.checkUblox(); // Check for the arrival of new PMP data and process it.
  myLBand.checkCallbacks(); // Check if any LBand callbacks are waiting to be processed.
}
