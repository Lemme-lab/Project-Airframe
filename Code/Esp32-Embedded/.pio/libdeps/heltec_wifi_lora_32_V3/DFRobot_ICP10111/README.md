# DFRobot_ICP10111
- [中文版](./README_CN.md)

The ICP-10111 pressure sensor family is based on MEMS capacitive technology which provides ultra-low noise at the lowest power, enabling industry-leading relative accuracy, sensor throughput, and temperature stability. The pressure sensor can measure pressure differences with an accuracy of ±1 Pa, enabling altitude measurement differentials as small as 8.5 cm, less than the height of a single stair step.

![产品效果图片](./resources/images/SEN0516.png)


## Product Link (https://www.dfrobot.com)

    SKU：SEN0516

## Table of Content 

  * [Summary](#Summary)
  * [Installation](#Installation)
  * [Method](#Method)
  * [Compatibility](#Compatibility)
  * [History](#History)
  * [Editor](#Editor)

## Summary

* High accuracy, low power consumption, temperature stability
* Stable data measurement of temperature, barometric pressure and altitude
* Temperature operating range: -40℃ to 85℃
* Pressure operating range: 30 to 110kPa

## Installation

Download the library file before use, paste it into the \Arduino\libraries directory, then open the examples folder and run the demo in the folder.

## Method

```C++
  /**
   * @fn begin
   * @brief Init function
   * @details Initialize sensor
   * @return uint8_t type, indicate return init status
   * @retval 0 Init succeed
   * @return -1 Init failed
   */
  int8_t begin(void);

  /**
   * @fn setWorkPattern
   * @brief Set work mode
   * @param mode Work mode select
   * @return None
   */
  void setWorkPattern(eWorkPattern_t mode);

  /**
   * @fn getTemperature
   * @brief Get the measured temperature 
   * @return The temperature that sensor obtained
   */
  float getTemperature(void);

  /**
   * @fn getAirPressure
   * @brief Get the air pressure that sensor obtained
   * @return Return the air pressure that sensor obtained
   */
  float getAirPressure(void);

  /**
   * @fn getElevation
   * @brief Get the elevation calculated according to the measured barometric pressure
   * @return Return the calculated elevation
   */
  float getElevation(void);
```

## Compatibility
MCU                | Work Well    | Work Wrong   | Untested    | Remarks
------------------ | :----------: | :----------: | :---------: | :----:
Arduino Uno        |      √       |              |             |
Arduino MEGA2560   |      √       |              |             |
Arduino Leonardo   |      √       |              |             |
FireBeetle-ESP8266 |      √       |              |             |
FireBeetle-ESP32   |      √       |              |             |
FireBeetle-M0      |      √       |              |             |
Micro:bit          |      √       |              |             |


## History

- 2021/11/05 - Version 1.0.0 released.

## Editor

Written by TangJie(jie.tang@dfrobot.com), 2021. (Welcome to our [website](https://www.dfrobot.com/))





