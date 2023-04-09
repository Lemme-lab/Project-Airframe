/*
  Get the NMEA sentence using getLatestNMEAGPxxx (GGA, VTG, RMC, ZDA)
  By: Paul Clark
  SparkFun Electronics
  Date: March 2nd, 2022
  License: MIT. See license file for more information.

  ** Please note: this example will not run on Arduino Uno. See https://github.com/sparkfun/SparkFun_u-blox_GNSS_Arduino_Library/blob/main/README.md#memory-usage

  This example shows how to turn on/off the NMEA sentences being output over I2C.
  It then demonstrates how to use the new getLatestNMEAGPxxx function to retrieve the latest GPGGA message.
  getLatestNMEAGPxxx returns immediately - it is not blocking.
  It returns:
    0 if no data is available
    1 if the data is valid but is stale (you have read it before)
    2 if the data is valid and fresh

  If the module is using multiple GNSS constellations, the GGA message will be prefixed with Talker ID "GN" instead of "GP".
  The library includes getLatestNMEAGNxxx functions too.
  This example shows how to use both functions - and how to change the Talker ID so the GNGGA messages become GPGGA etc..

  Feel like supporting open source hardware?
  Buy a board from SparkFun!
  SparkFun GPS-RTK2 - ZED-F9P (GPS-15136)    https://www.sparkfun.com/products/15136
  SparkFun GPS-RTK-SMA - ZED-F9P (GPS-16481) https://www.sparkfun.com/products/16481
  SparkFun MAX-M10S Breakout (GPS-18037)     https://www.sparkfun.com/products/18037
  SparkFun ZED-F9K Breakout (GPS-18719)      https://www.sparkfun.com/products/18719
  SparkFun ZED-F9R Breakout (GPS-16344)      https://www.sparkfun.com/products/16344

  Hardware Connections:
  Plug a Qwiic cable into the GNSS and a RedBoard
  If you don't have a platform with a Qwiic connection use the SparkFun Qwiic Breadboard Jumper (https://www.sparkfun.com/products/14425)
  Open the serial monitor at 115200 baud to see the output
*/

#include <Wire.h> //Needed for I2C to GNSS

#include <SparkFun_u-blox_GNSS_v3.h> //Click here to get the library: http://librarymanager/All#SparkFun_u-blox_GNSS_v3
SFE_UBLOX_GNSS myGNSS;

void setup()
{

  Serial.begin(115200);
  Serial.println(F("SparkFun u-blox GNSS Example"));

  Wire.begin();

  //myGNSS.enableDebugging(); // Uncomment this line to enable debug messages on Serial

  if (myGNSS.begin() == false)
  {
    Serial.println(F("u-blox GNSS not detected at default I2C address. Please check wiring. Freezing."));
    while (1)
      ;
  }

  //Disable or enable various NMEA sentences over the I2C interface
  myGNSS.setI2COutput(COM_TYPE_NMEA | COM_TYPE_UBX); // Turn on both UBX and NMEA sentences on I2C. (Turn off RTCM and SPARTN)
  myGNSS.newCfgValset(VAL_LAYER_RAM_BBR); // Use cfgValset to disable / enable individual NMEA messages
  myGNSS.addCfgValset8(UBLOX_CFG_MSGOUT_NMEA_ID_GLL_I2C, 0);
  myGNSS.addCfgValset8(UBLOX_CFG_MSGOUT_NMEA_ID_GSA_I2C, 0);
  myGNSS.addCfgValset8(UBLOX_CFG_MSGOUT_NMEA_ID_GSV_I2C, 0);
  myGNSS.addCfgValset8(UBLOX_CFG_MSGOUT_NMEA_ID_RMC_I2C, 1);
  myGNSS.addCfgValset8(UBLOX_CFG_MSGOUT_NMEA_ID_VTG_I2C, 1);
  myGNSS.addCfgValset8(UBLOX_CFG_MSGOUT_NMEA_ID_GGA_I2C, 1);
  myGNSS.addCfgValset8(UBLOX_CFG_MSGOUT_NMEA_ID_ZDA_I2C, 1);
  if (myGNSS.sendCfgValset()) // Send the configuration VALSET
    Serial.println(F("NMEA messages were configured successfully"));
  else
    Serial.println(F("NMEA message configuration failed!"));

  // Set the Main Talker ID to "GP". The NMEA GGA messages will be GPGGA instead of GNGGA
  myGNSS.setMainTalkerID(SFE_UBLOX_MAIN_TALKER_ID_GP);
  //myGNSS.setMainTalkerID(SFE_UBLOX_MAIN_TALKER_ID_DEFAULT); // Uncomment this line to restore the default main talker ID

  myGNSS.setHighPrecisionMode(true); // Enable High Precision Mode - include extra decimal places in the GGA messages

  //myGNSS.saveConfiguration(VAL_CFG_SUBSEC_IOPORT | VAL_CFG_SUBSEC_MSGCONF); //Optional: Save only the ioPort and message settings to NVM

  Serial.println(F("Messages configured"));

  //myGNSS.setNMEAOutputPort(Serial); // Uncomment this line to echo all NMEA data to Serial for debugging
}

void loop()
{
  // getLatestNMEAGPGGA calls checkUblox for us. We don't need to do it here

  NMEA_GGA_data_t dataGGA; // Storage for the GPGGA data
  uint8_t result = myGNSS.getLatestNMEAGPGGA(&dataGGA); // Get the latest GPGGA data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GPGGA: Length: "));
    Serial.print(dataGGA.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataGGA.nmea); // .nmea is printable (NULL-terminated)
  }

  result = myGNSS.getLatestNMEAGNGGA(&dataGGA); // Get the latest GNGGA data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GNGGA: Length: "));
    Serial.print(dataGGA.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataGGA.nmea); // .nmea is printable (NULL-terminated)
  }

  // getLatestNMEAGPVTG calls checkUblox for us. We don't need to do it here

  NMEA_VTG_data_t dataVTG; // Storage for the GPVTG data
  result = myGNSS.getLatestNMEAGPVTG(&dataVTG); // Get the latest GPVTG data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GPVTG: Length: "));
    Serial.print(dataVTG.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataVTG.nmea); // .nmea is printable (NULL-terminated)
  }

  result = myGNSS.getLatestNMEAGNVTG(&dataVTG); // Get the latest GNVTG data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GNVTG: Length: "));
    Serial.print(dataVTG.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataVTG.nmea); // .nmea is printable (NULL-terminated)
  }

  // getLatestNMEAGPRMC calls checkUblox for us. We don't need to do it here

  NMEA_RMC_data_t dataRMC; // Storage for the GPRMC data
  result = myGNSS.getLatestNMEAGPRMC(&dataRMC); // Get the latest GPRMC data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GPRMC: Length: "));
    Serial.print(dataRMC.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataRMC.nmea); // .nmea is printable (NULL-terminated)
  }

  result = myGNSS.getLatestNMEAGNRMC(&dataRMC); // Get the latest GNRMC data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GNRMC: Length: "));
    Serial.print(dataRMC.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataRMC.nmea); // .nmea is printable (NULL-terminated)
  }

  // getLatestNMEAGPZDA calls checkUblox for us. We don't need to do it here

  NMEA_ZDA_data_t dataZDA; // Storage for the GPZDA data
  result = myGNSS.getLatestNMEAGPZDA(&dataZDA); // Get the latest GPZDA data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GPZDA: Length: "));
    Serial.print(dataZDA.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataZDA.nmea); // .nmea is printable (NULL-terminated)
  }

  result = myGNSS.getLatestNMEAGNZDA(&dataZDA); // Get the latest GNZDA data (if any)
  
  if (result == 2)
  {
    // Data contains .length and .nmea
    Serial.print(F("Latest GNZDA: Length: "));
    Serial.print(dataZDA.length);
    Serial.print(F("\tData: "));
    Serial.print((const char *)dataZDA.nmea); // .nmea is printable (NULL-terminated)
  }

  delay(250);
}
