/*!
 * @file DFRobot_ICP10111.cpp
 * @brief Define basic structure of DFRobot_ICP class, the implementation of basic method
 * @copyright	Copyright (c) 2021 DFRobot Co.Ltd (http://www.dfrobot.com)
 * @license The MIT License (MIT)
 * @author [TangJie](jie.tang@dfrobot.com)
 * @version V1.0
 * @date 2021-11-05
 * @url https://github.com/DFRobot/DFRobot_ICP10111
 */
#include "DFRobot_ICP10111.h"

DFRobot_ICP10111::DFRobot_ICP10111(TwoWire *pWire, uint8_t address)
{
    _pWire = pWire;
    _address = address;
}

int8_t DFRobot_ICP10111::begin(void)
{
    _pWire->begin();
    
    uint8_t buf[3];
    short otp[4];
    uint16_t reg = 0xEFC8;
    if(readReg(reg, buf, 3) != 0)
      return -1;
    uint16_t data = buf[0]<<8|buf[1];
    DBG((data));
    if((data & 0x08) == 0x08){
      readOtpFromI2c(otp);
      initBase(_d,otp);
      DBG("a");
      return 0;
    }
    return -1;
}

void DFRobot_ICP10111::setWorkPattern(eWorkPattern_t mode)
{
    _mode = mode;
}

float DFRobot_ICP10111::getAirPressure(void)
{
  getTempAndAirPressure();
  return _t->airPressure;
}

float DFRobot_ICP10111::getTemperature(void)
{
 getTempAndAirPressure();
  return _t->temp;
}

float DFRobot_ICP10111::getElevation(void)
{
  getTempAndAirPressure();
  float elevation = 44330 * (1.0 - pow((_t->airPressure/100.0) / 1015.0, 0.1903));
  return elevation;
}

void DFRobot_ICP10111::readOtpFromI2c(short *out)
{
  uint8_t dataWrite[3];
  uint8_t dataRead[8];

  dataWrite[0] = 0X00;
  dataWrite[1] = 0x66;
  dataWrite[2] = 0x9C;
  writeReg(0xC595,dataWrite,3);
  for(uint8_t i = 0; i < 4; i ++){
    readReg(0xC7F7, dataRead, 3);
    out[i] = dataRead[0] << 8 | dataRead[1];
  }
}

void DFRobot_ICP10111::initBase(sInvInvpres_t *s, short *otp)
{
  for(uint8_t i = 0; i < 4; i++){
    s->sensorConstants[i] = otp[i];
  }
  s->pPaCalib[0] = 45000.0;
  s->pPaCalib[1] = 80000.0;
  s->pPaCalib[2] = 105000.0;
  s->LUTLower = 3.5 * ((uint32_t)1<<20);
  s->LUTUpper = 11.5 * ((uint32_t)1<<20);
  s->quadrFactor = 1/16777216.0;
  s->offstFactor = 2048.0;
}

void DFRobot_ICP10111::getTempAndAirPressure(void)
{
  uint8_t buf[9];
  uint32_t airPressure;
  uint16_t temp;
  float t;
  readReg(_mode, buf, 9);
  airPressure = (uint32_t)buf[0] << 16 | (uint32_t)buf[1] << 8 | (uint32_t)buf[3];
  temp = (uint16_t)buf[6]<<8 | buf[7];
  t = (float)(temp - 32768);
  _i->s1 = _d->LUTLower + (float)(_d->sensorConstants[0] * t * t) *_d->quadrFactor;
  _i->s2= _d->offstFactor * _d->sensorConstants[3] + (float)(_d->sensorConstants[1] * t * t) * _d->quadrFactor;
  _i->s3= _d->LUTUpper + (float)(_d->sensorConstants[2] * t * t) * _d->quadrFactor;
  calculateConversionConstants(_d->pPaCalib, _i);
  
  _t->airPressure = _o->A + (_o->B / (_o->C + airPressure));
  _t->temp = -45.f + 175.f /65536.f * temp;
}

void DFRobot_ICP10111::calculateConversionConstants(float *pPa, sInitialData_t *i)
{
  _o->C = (i->s1 * i->s2 *(pPa[0] - pPa[1]) +  \
           i->s2 * i->s3 *(pPa[1] - pPa[2]) + \
           i->s3 * i->s1 * (pPa[2] - pPa[0])) / \
          (i->s3 * (pPa[0] - pPa[1]) + i->s1 * (pPa[1] - pPa[2]) + \
           i->s2 * (pPa[2] - pPa[0]));   
  _o->A = (pPa[0] * i->s1 - pPa[1] * i->s2 - (pPa[1] - pPa[0]) * _o->C) / (i->s1 - i->s2);   
  _o->B = (pPa[0] - _o->A) * (i->s1 + _o->C); 
}

void DFRobot_ICP10111::writeReg(uint16_t reg, void* pBuf, size_t size)
{
  if(pBuf == NULL){
	  DBG("pBuf ERROR!! : null pointer");
  }
  uint8_t regBuf[2];
  regBuf[0] = reg >> 8;
  regBuf[1] = reg & 0xff;
  uint8_t * _pBuf = (uint8_t *)pBuf;
  _pWire->beginTransmission(_address);
  _pWire->write(&regBuf[0], 1);
  _pWire->write(&regBuf[1], 1);

  for(uint16_t i = 0; i < size; i++){
    _pWire->write(_pBuf[i]);
  }
  _pWire->endTransmission();
}

uint8_t DFRobot_ICP10111::readReg(uint16_t reg, void* pBuf, size_t size)
{
  if(pBuf == NULL){
    DBG("pBuf ERROR!! : null pointer");
  }
  uint8_t regBuf[2];
  regBuf[0] = reg >> 8;
  regBuf[1] = reg & 0xff;
  uint8_t * _pBuf = (uint8_t *)pBuf;
  _pWire->beginTransmission(_address);
  _pWire->write(regBuf[0]);
  _pWire->write(regBuf[1]);
  if(_pWire->endTransmission() != 0)
    return 1;
  delay(100);
  _pWire->requestFrom(_address, (uint8_t) size);
  for(uint16_t i = 0; i < size; i++){
    _pBuf[i] = _pWire->read();
  }
  return 0;
}

