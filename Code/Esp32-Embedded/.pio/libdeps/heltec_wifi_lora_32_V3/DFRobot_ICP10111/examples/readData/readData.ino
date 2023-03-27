/*!
 * @file readData.ino
 * @brief This demo is for SEN0516. Run it to get sensor temperature, air pressure and altitude.
 * @copyright  Copyright (c) 2021 DFRobot Co.Ltd (http://www.dfrobot.com)
 * @license The MIT License (MIT)
 * @author [TangJie](jie.tang@dfrobot.com)
 * @version V1.0
 * @date 2021-11-05
 * @url https://github.com/DFRobot/DFRobot_ICP10111
 */

#include <DFRobot_ICP10111.h>

DFRobot_ICP10111 icp;

void setup(void)
{
    Serial.begin(115200);
    while(icp.begin() != 0){
      Serial.println("Failed to initialize the sensor");
      }
     Serial.println("Success to initialize the sensor");
     /**
      * @brief Set work mode
      * |------------------|-----------|-------------------|----------------------|
      * |       api        |   mode    |Conversion Time(ms)|Pressure RMS Noise(Pa)|
      * |icp.eLowPower     |  Low Power   |      1.8          |        3.2           |
      * |icp.eNormal       |  Normal      |      6.3          |        1.6           |
      * |icp.eLowNoise     |  Low Noise   |      23.8         |        0.8           |
      * |icp.eUltraLowNoise|  Ultra-low Noise |      94.5         |        0.4           |
      */
     icp.setWorkPattern(icp.eNormal);
}

void loop(void)
{
  Serial.println("------------------------------");
  Serial.print("Read air pressure:");
  Serial.print(icp.getAirPressure());
  Serial.println("Pa");
  Serial.print("Read temperature:");
  Serial.print(icp.getTemperature());
  Serial.println("℃");
  Serial.print("Read altitude:");
  Serial.print(icp.getElevation());
  Serial.println("m");
  delay(1000);
}
