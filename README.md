# Project Airframe - Open Source Smartwatch

![244198878-646c22c4-e374-44d6-ac0f-87877a9a3229 (1)](https://github.com/user-attachments/assets/7a5e7fc0-9f43-4ed2-866d-ce484d9eea08)

**Project Airframe** is an open-source smartwatch designed to give developers and hobbyists full access to both hardware and software. With state-of-the-art sensors, wireless charging, GPS, and more, it’s a versatile tool for exploring wearable technology. Below, you’ll find everything you need to get started, from hardware specifications to software instructions.

## Table of Contents
1. [Features](#features)
2. [Hardware](#hardware)
3. [Software](#software)
4. [PCB & Electronics](#pcb--electronics)
5. [Installation](#installation)
6. [Usage](#usage)
7. [Contributing](#contributing)
8. [License](#license)

## Features

- **Dual Processor Options**: ESP32-S3 (240MHz dual-core) and NXP i.MX 8 Quad.
- **Sensors**: ECG, Pulse Oximeter, Temperature, IMU (Inertial Measurement Unit), Compass, and more.
- **Wireless Charging**: 5W fast wireless charging.
- **GPS and GNSS**: Built-in GPS for location tracking.
- **Full NFC**: NFC pay, NFC tags, and peer-to-peer communication.
- **Health Monitoring**: Real-time heart rate, oxygen levels (SpO2), ECG data, and more.
- **Fitness Tracking**: Tracks steps, calories, sleep, and daily activity.
- **Custom Watch Faces**: Multiple customizable watch faces.
- **Water Resistant**: Built to handle daily wear and weather conditions.

![241293606-e9c87f54-92d8-475b-8504-8d2cf418f53a](https://github.com/user-attachments/assets/693da952-6e1c-453d-a6ec-a126f1c2ab03)
![207326701-55a5ec6b-7f79-4fc3-8bfd-e77caa1cd0b9](https://github.com/user-attachments/assets/4d40084b-7ca1-4a87-8b07-80a2468a00cc)


---

## Hardware

The **Airframe Smartwatch** integrates sophisticated hardware to support a variety of health, fitness, and location tracking features.

### Specifications

- **Microcontroller**: ESP32-S3 Dual Core (or NXP i.MX 8 Quad)
- **Memory**: 
  - 4MB RAM, 8MB Flash (for ESP32)
  - 8GB DDR4 RAM (for i.MX 8)
- **Display**: 240x240 px touch display.
- **Power Management**: 5W wireless charging, battery fuel gauge, and power management IC.
- **Sensors**:
  - **Pulse Oximeter** 
  - **ECG 3 Lead Sensor** 
  - **Temperature Sensor**
  - **Pressure Sensor**
  - **Inertial Measurement Unit (IMU)**
  - **Compass**
  
- **Connectivity**: 
  - BLE 5.0
  - NFC Reader/Writer
  - GPS/GNSS (GPS, GLONASS, Galileo)
  - Wi-Fi 4.2, NFC Tag

---

### Hardware Gallery

1. **Airframe Smartwatch Prototype**
   ![248464943-83f1d933-ee97-4bca-aef9-81b796344c9b](https://github.com/user-attachments/assets/3a7f311c-2e9c-446f-94e9-5d0d884ee9e1)

2. **Smartwatch Components & PCB Designs**  
   ![248467414-c0ff1934-5fe4-4696-9213-ace8d471f633 (1)](https://github.com/user-attachments/assets/4cb15749-a03a-4ba1-91e2-6235cf5d4ce2)

3. **Smartwatch in Assembled Form - Front & Back**
   ![248465391-174d9c86-a782-402c-9f40-d455ebd8f1ef](https://github.com/user-attachments/assets/88d6a27c-0659-45d0-a401-6666e3d667b4)
   
3. **Smartwatch Puck**
   ![Screenshot 2024-09-30 174631](https://github.com/user-attachments/assets/f66506e5-2965-4dd6-ac76-fcacb692d002)
   ![211921454-efc67dd0-3a86-407a-a53b-dbce7d059ead](https://github.com/user-attachments/assets/1e383d4d-ad63-4f46-b15b-b5678c955e0d)


---

## Software

The Airframe smartwatch is powered by a custom software stack, supporting both real-time data processing on the watch and communication with a companion app.

### Key Software Components

- **BLE Communication**: Enables the watch to communicate via Bluetooth Low Energy (BLE) with smartphones or computers.
- **Flutter App**: Provides a seamless interface for Android and iOS users.
- **Real-Time Health Monitoring**: Continuously tracks and records heart rate, SpO2, ECG data, and more.
- **Fitness and Activity Monitoring**: Step tracking, calorie burn, sleep data, and activity summaries.
- **Custom Watch Faces**: Supports multiple watch faces, showing time, health stats, and weather data.

### Software Images

1. **Airframe Mobile App - Dashboard View**  
![227036885-2fcf2675-f2de-432f-a74a-1f8b804b1e94](https://github.com/user-attachments/assets/7a61117e-b7ba-4130-8972-cf81db6b3340)

2. **Frame-OS**  
---![Screenshot 2024-09-30 175040](https://github.com/user-attachments/assets/5502f927-6beb-450d-83aa-34725e6c004d)


## PCB & Electronics

The electronic components of Airframe are carefully designed to maximize the device’s functionality while maintaining low power consumption and high performance.

### PCB Design Overview

The PCB includes:
- **ESP32-S3 Processor** or **NXP i.MX 8 Quad** variant.
- **Sensor integration** for health tracking, including ECG, SpO2, IMU, and more.
- **Power Management** ICs for efficient battery handling and 5W fast wireless charging.
  
#### PCB Design Diagrams:

1. **PCB**
   ![241123783-0ecd49ee-87ff-4cde-9060-24d48c5cfade](https://github.com/user-attachments/assets/2314dfe0-84d8-4635-9061-3e2ef1ed1341)

---

## Installation

### Setting Up the Watch Firmware

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/your-repository/airframe-smartwatch.git
   cd airframe-smartwatch
   ```

2. **Install Prerequisites**  
   Follow the instructions to install dependencies for ESP32 or NXP i.MX 8.

3. **Flash the Firmware**  
   Flash the microcontroller using the ESP32 toolchain or NXP i.MX tools.

4. **Mobile App Setup**  
   The companion app is developed using Flutter:
   ```bash
   cd mobile_app
   flutter run
   ```

---

## Usage

Once the firmware is flashed and the app is running, you can:

- **Pair with BLE**: Connect the watch with your smartphone using Bluetooth.
- **Monitor Health Data**: Track real-time health data like ECG, SpO2, steps, and more.
- **Customize Watch Faces**: Change and customize watch faces using the app.

---



Project Airframe is open-source, and contributions are welcome! To get started:

1. Fork the repository.
2. Create a new branch for your feature/bugfix.
3. Make your changes and test thoroughly.
4. Submit a pull request.

## Images
![241123783-0ecd49ee-87ff-4cde-9060-24d48c5cfade](https://github.com/user-attachments/assets/723f9d1d-d55b-43e2-903b-58e9a6d527c5)
![241123687-09d4c374-2d0c-455f-a919-4a59138ad10e (1)](https://github.com/user-attachments/assets/98daed2b-03cf-461d-a02b-3312617687c1)
![227036885-2fcf2675-f2de-432f-a74a-1f8b804b1e94](https://github.com/user-attachments/assets/dc71fa96-021d-498c-95cd-1b7353347f7b)
![211921454-efc67dd0-3a86-407a-a53b-dbce7d059ead](https://github.com/user-attachments/assets/d7088ce9-c997-458a-9e91-dc985a632ba4)
![248467414-c0ff1934-5fe4-4696-9213-ace8d471f633 (1)](https://github.com/user-attachments/assets/61887194-b57b-45d6-9b67-0e76043d813e)
![248465391-174d9c86-a782-402c-9f40-d455ebd8f1ef](https://github.com/user-attachments/assets/6e123352-491e-40b5-af0f-9c0008e83fb9)
![248465139-50e438e8-4756-424c-868c-67f0bfdfedbb](https://github.com/user-attachments/assets/a68f6fce-e5cd-4bab-bd28-738f808581b7)
![248464943-83f1d933-ee97-4bca-aef9-81b796344c9b](https://github.com/user-attachments/assets/a76052a9-a93f-41f6-9087-b57bb3987414)
![244199015-1c1b4e0c-4dde-461f-a7b2-ccfb9a86e202](https://github.com/user-attachments/assets/92ec8bbe-2105-4832-90a0-8a6831f65365)
![244198923-7aafcdc3-8758-4472-8234-4ef7c5881dfe](https://github.com/user-attachments/assets/8199f988-7c31-4913-b2d4-b22e3f266962)
![241293606-e9c87f54-92d8-475b-8504-8d2cf418f53a](https://github.com/user-attachments/assets/979d5030-795e-4fb5-97d5-64fe775a2b9d)
![248467414-c0ff1934-5fe4-4696-9213-ace8d471f633](https://github.com/user-attachments/assets/172599c9-fc08-4d54-b06c-b6f6def764fe)


---

## License

Project Airframe is licensed under the MIT License. See `LICENSE` for more details.
