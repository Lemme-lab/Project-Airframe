//
// Created by lucas on 08.03.2023.
//

#ifndef EMBEDDED_CODE_WIRELESS_H
#define EMBEDDED_CODE_WIRELESS_H

#include <linux/i2c-dev.h>
#include <fcntl.h>
#include <unistd.h>

bool readMAXM10SData(int i2c_bus, int i2c_addr, float& temperature, float& humidity) {
    // Open the I2C bus
    std::string i2c_bus_str = "/dev/i2c-" + std::to_string(i2c_bus);
    int fd = open(i2c_bus_str.c_str(), O_RDWR);
    if (fd < 0) {
        std::cerr << "Failed to open I2C bus: " << strerror(errno) << std::endl;
        return false;
    }

    // Set the slave address
    if (ioctl(fd, I2C_SLAVE, i2c_addr) < 0) {
        std::cerr << "Failed to set I2C slave address: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Send measurement command
    uint8_t command[] = {0x24, 0x00};
    if (write(fd, command, sizeof(command)) != sizeof(command)) {
        std::cerr << "Failed to send measurement command: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Wait for measurement to complete
    usleep(50000); // wait for 50 ms

    // Read data from the sensor
    uint8_t data_buf[6];
    if (read(fd, data_buf, sizeof(data_buf)) != sizeof(data_buf)) {
        std::cerr << "Failed to read MAX-M10S-00B data: " << strerror(errno) << std::endl;
        close(fd);
        return false;
    }

    // Convert raw data to temperature and humidity values
    uint16_t temp_raw = (data_buf[0] << 8) | data_buf[1];
    uint16_t hum_raw = (data_buf[3] << 8) | data_buf[4];
    temperature = -45.0f + 175.0f * static_cast<float>(temp_raw) / 65536.0f;
    humidity = 100.0f * static_cast<float>(hum_raw) / 65536.0f;

    // Close the I2C bus and return success
    close(fd);
    return true;
}


#endif //EMBEDDED_CODE_WIRELESS_H
