//
// Created by lucas on 08.03.2023.
//

#ifndef EMBEDDED_CODE_SENSORS_H
#define EMBEDDED_CODE_SENSORS_H

#include "Sensors.h"
#include <fcntl.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <iostream>
#include <cstring>
#include <errno.h>
#include <vector>
#include <string>

bool readKXTJ3Data(float& x_acc, float& y_acc, float& z_acc) {
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x0F

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Configure the KXTJ3 IC
    uint8_t config[] = {0x0, 0x0};
    config[0] |= (0 << 3); // Output data rate: 50 Hz
    config[0] |= (1 << 2); // Acceleration range: +/-2g
    config[0] |= (0 << 1); // Standby mode
    config[0] |= (0 << 0); // Operating mode: measurement
    if (write(fd, config, sizeof(config)) != sizeof(config)) {
        std::cerr << "Failed to configure KXTJ3 IC: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Read data from the KXTJ3 IC
    uint8_t data_buf[6];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read KXTJ3 data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Convert the raw data to acceleration values
    int16_t x_raw = (data_buf[1] << 8) | data_buf[0];
    int16_t y_raw = (data_buf[3] << 8) | data_buf[2];
    int16_t z_raw = (data_buf[5] << 8) | data_buf[4];
    x_acc = x_raw * 2.0f / 32768.0f;
    y_acc = y_raw * 2.0f / 32768.0f;
    z_acc = z_raw * 2.0f / 32768.0f;


    close(fd);
    return true;
}

bool readICP10111Data(float& temperature, float& humidity, float& pressure)
{
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x68
    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Start measurement
    uint8_t data[2] = {0x10, 0x00};
    if (write(fd, data, sizeof(data)) != sizeof(data)) {
        std::cerr << "Failed to start measurement: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }
    usleep(1000);

    // Read data from the ICP-10111 IC
    uint8_t data_buf[9];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read ICP-10111 data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Convert the raw data to temperature, humidity, and pressure
    int16_t temp_raw = (data_buf[3] << 8) | data_buf[4];
    int16_t humid_raw = (data_buf[5] << 8) | data_buf[6];
    int32_t press_raw = ((data_buf[1] << 16) | (data_buf[2] << 8) | data_buf[0]) >> 4;
    temperature = (temp_raw / 100.0f) + 25.0f;
    humidity = (humid_raw / 1024.0f) * 100.0f;
    pressure = (press_raw / 16384.0f) * 1000.0f;


    close(fd);
    return true;
}

void configureLIS2MDLTR(){
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x1C

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
    }

    // Configure magnetometer in continuous measurement mode
    uint8_t config[2] = {0x60, 0x00};
    if (write(fd, config, sizeof(config)) != sizeof(config)) {
        std::cerr << "Failed to configure LIS2MDLTR: " << strerror(errno) << std::endl;
        close(fd);
    }
    usleep(100);

}

bool readLIS2MDLTRData(float& x, float& y, float& z)
{
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x1C
    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Read data from the LIS2MDLTR magnetometer
    uint8_t data_buf[6];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read LIS2MDLTR data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Convert the raw data to magnetic field strength
    int16_t x_raw = (data_buf[1] << 8) | data_buf[0];
    int16_t y_raw = (data_buf[3] << 8) | data_buf[2];
    int16_t z_raw = (data_buf[5] << 8) | data_buf[4];
    x = x_raw * 0.015f;
    y = y_raw * 0.015f;
    z = z_raw * 0.015f;

    close(fd);
    return true;
}

bool readM41T62Q6FData(uint8_t& seconds, uint8_t& minutes, uint8_t& hours, uint8_t& day, uint8_t& date, uint8_t& month, uint16_t& year) {
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x68

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Read data from the M41T62Q6F IC
    uint8_t data_buf[7];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read M41T62Q6F data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    seconds = (data_buf[0] & 0x7F);
    minutes = (data_buf[1] & 0x7F);
    hours = (data_buf[2] & 0x3F);
    day = (data_buf[3] & 0x07);
    date = (data_buf[4] & 0x3F);
    month = (data_buf[5] & 0x1F);
    year = ((data_buf[6] << 8) | (data_buf[5] >> 1)) + 1900;


    close(fd);
    return true;
}

bool readAD8232Data(unsigned char& val){

#define ARRAY_SIZE 1800000
    unsigned char data[ARRAY_SIZE];

    int fd, i;

    // Open the analog input pin
    fd = open("/sys/devices/soc0/soc/2100000.aips-bus/21a4000.adc/iio:device0/in_voltage0_raw", O_RDONLY);
    if (fd < 0) {
        printf("Error: cannot open analog input pin.\n");
        return -1;
    }

    // Read the analog voltage and store it in the array
    for (i = 0; i < ARRAY_SIZE; i++) {
        lseek(fd, 0, SEEK_SET);
        read(fd, &val, 4);
        data[i] = val;
        usleep(10000);
    }

    // Print the data to the console
    for (i = 0; i < ARRAY_SIZE; i++) {
        printf("%d\n", data[i]);
    }

    close(fd);

    return true;

}

void configureLSM6DSLTR(){
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x6B

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
    }

    // Configure the LSM6DSLTR IC
    uint8_t config[] = {0x0, 0x0};
    config[0] |= (1 << 4); // Enable accelerometer
    config[0] |= (1 << 3); // Enable gyroscope
    config[0] |= (1 << 2); // Output data rate: 104 Hz
    config[0] |= (1 << 1); // Acceleration range: +/-2g
    config[0] |= (1 << 0); // Gyroscope range: +/-250 dps
    if (write(fd, config, sizeof(config)) != sizeof(config)) {
        std::cerr << "Failed to configure LSM6DSLTR IC: " << strerror(errno) << std::endl;
        close(fd);
    }


}

bool readLSM6DSLTRData(float& x_acc, float& y_acc, float& z_acc) {
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x6B

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Read data from the LSM6DSLTR IC
    uint8_t data_buf[12];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read LSM6DSLTR data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Convert the raw data to acceleration values
    int16_t x_raw = (data_buf[1] << 8) | data_buf[0];
    int16_t y_raw = (data_buf[3] << 8) | data_buf[2];
    int16_t z_raw = (data_buf[5] << 8) | data_buf[4];
    x_acc = x_raw * 2.0f / 32768.0f;
    y_acc = y_raw * 2.0f / 32768.0f;
    z_acc = z_raw * 2.0f / 32768.0f;

    close(fd);
    return true;
}

void configureMAX30101(){

#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x57

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
    }

    // Configure the MAX30101EFD+ IC
    uint8_t config[] = {0x03, 0x02, 0x03, 0x05, 0x00, 0x0C};
    if (write(fd, config, sizeof(config)) != sizeof(config)) {
        std::cerr << "Failed to configure MAX30101EFD+ IC: " << strerror(errno) << std::endl;
        close(fd);
    }
}

bool readMAX30101Data(float& ir, float& red) {
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x57

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Read data from the MAX30101EFD+ IC
    uint8_t data_buf[6];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read MAX30101EFD+ data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Convert the raw data to IR and red light values
    uint32_t ir_raw = (data_buf[3] << 16) | (data_buf[4] << 8) | data_buf[5];
    uint32_t red_raw = (data_buf[0] << 16) | (data_buf[1] << 8) | data_buf[2];
    ir = ir_raw * 0.00244f; // convert to millivolts
    red = red_raw * 0.00244f; // convert to millivolts

    close(fd);
    return true;
}

bool readPAT9125KSData(float& x_pos, float& y_pos, float& motion) {
#define I2C_BUS 1
#define I2C_SLAVE_ADDR 0x34

    // Open the I2C bus
    std::string i2c_bus = "/dev/i2c-" + std::to_string(I2C_BUS);
    int fd = open(i2c_bus.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, I2C_SLAVE_ADDR) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Send command to start data read
    uint8_t cmd[] = {0x00};
    if (write(fd, cmd, sizeof(cmd)) != sizeof(cmd)) {
        std::cerr << "Failed to send read command to PAT9125KS: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Read data from the PAT9125KS IC
    uint8_t data_buf[3];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read PAT9125KS data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Convert the raw data to position and motion values
    int16_t x_raw = (data_buf[1] << 8) | data_buf[0];
    int16_t y_raw = (data_buf[2] << 8);
    x_pos = x_raw;
    y_pos = y_raw;
    motion = (data_buf[2] & 0x80) >> 7;

    close(fd);
    return true;
}

#endif //EMBEDDED_CODE_SENSORS_H
