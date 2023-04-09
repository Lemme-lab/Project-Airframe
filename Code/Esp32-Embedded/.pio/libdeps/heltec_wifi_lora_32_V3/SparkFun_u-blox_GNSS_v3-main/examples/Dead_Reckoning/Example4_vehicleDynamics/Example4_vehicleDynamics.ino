/*
  By: Elias Santistevan
  SparkFun Electronics
  Date: May, 2020
  License: MIT. See license file for more information.

  Feel like supporting open source hardware?
  Buy a board from SparkFun!
  ZED-F9R: https://www.sparkfun.com/products/16344  

  Hardware Connections:
  Plug a Qwiic cable into the GNSS and a Redboard Qwiic
  If you don't have a platform with a Qwiic connection use the 
	SparkFun Qwiic Breadboard Jumper (https://www.sparkfun.com/products/14425)
  Open the serial monitor at 115200 baud to see the output

	After calibrating the module and securing it to your vehicle such that it's
  stable within 2 degrees, and the board is oriented correctly with regards to
  the vehicle's frame, you can now read the vehicle's "attitude". The attitude
  includes the vehicle's heading, pitch, and roll. You can also check the
  accuracy of those readings. 

*/

#include <Wire.h> //Needed for I2C to GNSS

#include <SparkFun_u-blox_GNSS_v3.h> //http://librarymanager/All#SparkFun_u-blox_GNSS_v3
SFE_UBLOX_GNSS myGNSS;

void setup()
{
  delay(1000);
  
  Serial.begin(115200);
  Serial.println(F("SparkFun u-blox Example"));

  Wire.begin();

  if (myGNSS.begin() == false) //Connect to the u-blox module using Wire port
  {
    Serial.println(F("u-blox GNSS not detected at default I2C address. Please check wiring. Freezing."));
    while (1);
  }

  myGNSS.setI2COutput(COM_TYPE_UBX); //Set the I2C port to output UBX only (turn off NMEA noise)

  if (myGNSS.getEsfInfo()){

    Serial.print(F("Fusion Mode: "));  
    Serial.println(myGNSS.packetUBXESFSTATUS->data.fusionMode);  

    if (myGNSS.packetUBXESFSTATUS->data.fusionMode == 1){
      Serial.println(F("Fusion Mode is Initialized!"));  
		}
		else {
      Serial.println(F("Fusion Mode is either disabled or not initialized!"));  
			Serial.println(F("Please see the previous example for more information."));
		}
  }
}

void loop()
{
  // ESF data is produced at the navigation rate, so by default we'll get fresh data once per second
	if (myGNSS.getEsfAlignment()) // Poll new ESF ALG data
  {
  	Serial.print(F("Status: ")); 
  	Serial.print(myGNSS.packetUBXESFALG->data.flags.bits.status);
    Serial.print(F(" Roll: ")); 
    Serial.print(myGNSS.getESFroll(), 2); // Use the helper function to get the roll in degrees
  	Serial.print(F(" Pitch: ")); 
  	Serial.print(myGNSS.getESFpitch(), 2); // Use the helper function to get the pitch in degrees
  	Serial.print(F(" Heading: ")); 
  	Serial.print(myGNSS.getESFyaw(), 2); // Use the helper function to get the yaw in degrees
  	Serial.print(F(" Errors: ")); 
  	Serial.print(myGNSS.packetUBXESFALG->data.error.bits.tiltAlgError);
  	Serial.print(myGNSS.packetUBXESFALG->data.error.bits.yawAlgError);
  	Serial.println(myGNSS.packetUBXESFALG->data.error.bits.angleError);
  }

  delay(250);
}
