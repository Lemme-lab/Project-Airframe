/*!
 * @file DFRobot_ICP10111.h
 * @brief Define basic structure of DFRobot_ICP class
 * @details This library is for SEN0516 sensor, which can get the air pressure and temperature, and also altitude(calculated according to the pressure)
 * @n 
 * @copyright	Copyright (c) 2021 DFRobot Co.Ltd (http://www.dfrobot.com)
 * @license The MIT License (MIT)
 * @author [TangJie](jie.tang@dfrobot.com)
 * @version V1.0
 * @date 2021-11-05
 * @url https://github.com/DFRobot/DFRobot_ICP10111
 */

#ifndef _DFROBOT_ICP10111_H_
#define _DFROBOT_ICP10111_H_

#include <Arduino.h>
#include <Wire.h>

//#define ENABLE_DBG //!< Open this macro and you can see the details of the program
#ifdef ENABLE_DBG
#define DBG(...) {Serial.print("[");Serial.print(__FUNCTION__); Serial.print("(): "); Serial.print(__LINE__); Serial.print(" ] "); Serial.println(__VA_ARGS__);}
#else
#define DBG(...)
#endif

class DFRobot_ICP10111
{
    
public:
  /**
   * @enum eWorkPattern_t
   * @brief Work mode select
   */
  typedef enum{
    eLowPower      = 0x401A, /**<Low Power Mode Conversion Time: 1.8ms  Pressure RMS Noise:3.2Pa*/
    eNormal        = 0x48A3, /**<Normal Mode Conversion Time:6.3ms Pressure RMS Noise:1.6Pa*/
    eLowNoise      = 0x5059, /**<Low Noise Mode Conversion Time:23.8ms  Pressure RMS Noise:0.8Pa*/
    eUltraLowNoise = 0x58E0, /**<Ultra Low Noise Mode Conversion Time:94.5  Pressure RMS Noise:0.4Pa*/
  }eWorkPattern_t;

public:
  /**
   * @fn DFRobot_ICP
   * @brief Constructor
   * @param pWire  I2C object
   * @param address I2C address
   * @return None 
   */
    DFRobot_ICP10111(TwoWire *pWire = &Wire, uint8_t address = 0x63);

  /**
   * @fn begin
   * @brief Init function
   * @details Initialize sensor
   * @return uint8_t type, indicate return init status
   * @retval 0 Init succeed
   * @retval -1 Init failed
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
   * @brief Get the measured barometric pressure 
   * @return Return the air pressure that sensor obtained
   */
  float getAirPressure(void);

  /**
   * @fn getElevation
   * @brief Get the elevation calculated according to the measured air pressure 
   * @return Return the calculated elevation
   */
  float getElevation(void);
    
private:

  /**
   * @struct  sInvInvpres_t
   * @brief   Store the calculated data
   */
  typedef struct{
    float sensorConstants[4]; // OTP values
    float pPaCalib[3];
    float LUTLower;
    float LUTUpper;
    float quadrFactor;
    float offstFactor;
  }sInvInvpres_t;

  /**
   * @struct sGetTempAndAirPressure_t
   * @brief Save the temperature and air pressure data
   */
  typedef struct{
    float temp;
    float airPressure;
  }sGetTempAndAirPressure_t;
  /**
   * @struct sInitialData_t
   * @brief Store initial check data
   */
  typedef struct{
    float s1;
    float s2;
    float s3;
  }sInitialData_t;
  /**
   * @struct sUltimatelyData_t
   * @brief Store ultimate check data
   */
  typedef struct{
    float A;
    float B;
    float C;
  }sUltimatelyData_t;
  

private:

  TwoWire *_pWire;
  uint8_t _address;
  uint16_t _mode;

  sInvInvpres_t _dataStorage;
  sInvInvpres_t *_d = &_dataStorage;

  sGetTempAndAirPressure_t _tempAndAirPressure;
  sGetTempAndAirPressure_t *_t = &_tempAndAirPressure;

  sInitialData_t _inputData;
  sInitialData_t *_i=&_inputData;
  
  sUltimatelyData_t _outData;
  sUltimatelyData_t *_o = &_outData;
 /**
  * @fn readOtpFromI2c
  * @brief Get the sensor check data
  * @param out Store the check data
  * @return None
  */
  void readOtpFromI2c(short *out);

  /**
   * @fn initBase
   * @brief Initialize sensor calculation value 
   * @param s The structure for storing sensor calculated value
   * @param otp The stored check value
   */
  void initBase(sInvInvpres_t *s, short *otp);

  /**
   * @fn getTempAndAirPressure
   * @brief Get the temperature and air pressure
   * @return None
   */
  void getTempAndAirPressure(void);

  /**
   * @fn calculateConversionConstants
   * @brief The conversion formula constants for barometric pressure calculation
   * @param pPa Default calculated value
   * @param i The structure for storing base value
   * @return None
   */
  void calculateConversionConstants(float *pPa, sInitialData_t *i);

  /**
   * @fn writeReg
   * @brief Write register function, design it as a virtual function, implemented by a derived class
   * @param reg  Register address 8bits
   * @param pBuf Storage and buffer for data to be written
   * @param size Length of data to be written
   * @return None
   */
  void writeReg(uint16_t reg, void* pBuf, size_t size);

  /**
   * @fn readReg
   * @brief Read register function, design it as a virtual function, implemented by a derived class
   * @param reg  Register address 8bits
   * @param pBuf Storage and buffer for data to be read
   * @param size Length of data to be read
   * @return uint8_t type, indicate return the read register status
   * @retval 0 Read succeed
   * @retval 1 Read failed
   */
  uint8_t readReg(uint16_t reg, void* pBuf, size_t size);

};


#endif
