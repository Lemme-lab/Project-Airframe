/*
 * Main.cpp
 *
 *  Created on: 18.03.2023
 *      Author: lucas
 */

#include "em_device.h"
#include "em_chip.h"
#include "em_i2c.h"
#include "em_cmu.h"
#include "em_gpio.h"

#define BATTERY_ADDR 0x10
#define O2STAND_ADDR 0x20

// Define global variables to hold the values
int batteryValue = 0;
int o2standValue = 0;

// Initialize I2C peripheral as a slave
// Initialize I2C peripheral as a slave
void initI2CSlave() {
  // Enable clock for I2C and GPIO peripherals
  CMU_ClockEnable(cmuClock_I2C0, true);
  CMU_ClockEnable(cmuClock_GPIO, true);

  // Set up I2C GPIO pins
  GPIO_PinModeSet(gpioPortC, 4, gpioModeWiredAndPullUpFilter, 1);
  GPIO_PinModeSet(gpioPortC, 5, gpioModeWiredAndPullUpFilter, 1);

  // Initialize I2C peripheral
  I2C_Init_TypeDef i2cInit = I2C_INIT_DEFAULT;
  i2cInit.enable = true;
  i2cInit.master = false;
  i2cInit.refFreq = 0;
  i2cInit.freq = I2C_FREQ_STANDARD_MAX;

  I2C_Init(I2C0, &i2cInit);

  // Set up the I2C slave addresses
  I2C_SlaveAddressSet(I2C0, BATTERY_ADDR, I2C_ADDRMASK_NONE);
  I2C_SlaveAddressSet(I2C0, O2STAND_ADDR, I2C_ADDRMASK_NONE);

  // Enable I2C interrupts
  I2C_IntClear(I2C0, I2C_IFC_ACK | I2C_IFC_NACK | I2C_IFC_MSTOP | I2C_IFC_BUSERR | I2C_IFC_SSTOP | I2C_IFC_RXDATAV);
  I2C_IntEnable(I2C0, I2C_IEN_ACK | I2C_IEN_NACK | I2C_IEN_MSTOP | I2C_IEN_BUSERR | I2C_IEN_SSTOP | I2C_IEN_RXDATAV);
  NVIC_EnableIRQ(I2C0_IRQn);
}
// I2C interrupt handler
extern "C" void I2C0_IRQHandler(void) {
  uint32_t iflags = I2C_IntGet(I2C0);

  if (iflags & I2C_IF_RXDATAV) {
    // Handle RXDATAV interrupt
    uint8_t data = I2C_Rx(I2C0);

    if (I2C0->RXDATA == BATTERY_ADDR) {
      // Set batteryValue to the received data
      batteryValue = (int)data
    }

    if (I2C0->RXDATA == O2STAND_ADDR) {
      // Set o2standValue to the received data
      o2standValue = (int)data;
    }
  }

  I2C_IntClear(I2C0, iflags);
  }

int main(void) {

  // Initialize I2C peripheral as a slave
  initI2CSlave();

  // Main loop
  while (1) {

  }
  }

Main::~Main ()
{
  // TODO Auto-generated destructor stub
}

