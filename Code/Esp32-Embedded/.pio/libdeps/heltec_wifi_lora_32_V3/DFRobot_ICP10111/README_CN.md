# DFRobot_ICP10111
- [English Version](./README.md)

SEN0516压力传感器系列基于MEMS电容技术，在最低功率下提供超低噪音，实现行业领先的相对精度、传感器吞吐量和温度稳定性.压力传感器可以测量压力差，精度为±1 Pa.使高度测量差异小到8.5厘米，低于一个台阶的高度.使用Gravity接口方便使用.


![产品效果图片](./resources/images/SEN0516.png)


## 产品链接（https://www.dfrobot.com.cn/）

    SKU：SEN0516

## 目录

  * [概述](#概述)
  * [库安装](#库安装)
  * [方法](#方法)
  * [兼容性](#兼容性)
  * [历史](#历史)
  * [创作者](#创作者)

## 概述

* SEN0516具有高精度、低功耗、温度稳定等优点
* 能够稳定获取温度、大气压强和海拔高度
* 温度温度工作范围：-40℃ 到 85℃
* 压力工作范围：30到110kPa

## 库安装

使用此库前，请首先下载库文件，将其粘贴到\Arduino\libraries目录中，然后打开examples文件夹并在该文件夹中运行演示。

## 方法

```C++
  /**
   * @fn begin
   * @brief 初始化函数
   * @details 初始化传感器
   * @return uint8_t 类型，表示返回初始化状态
   * @retval 0 初始化成功
   * @return -1 初始化失败
   */
  int8_t begin(void);

  /**
   * @fn setWorkPattern
   * @brief 设置工作模式
   * @param mode 工作模式选择
   * @return None
   */
  void setWorkPattern(eWorkPattern_t mode);

  /**
   * @fn getTemperature
   * @brief 获取传感器获取温度
   * @return 传感器获取的温度
   */
  float getTemperature(void);

  /**
   * @fn getAirPressure
   * @brief 获取传感器获取的大气压强
   * @return 返回传感器获取的大气压强
   */
  float getAirPressure(void);

  /**
   * @fn getElevation
   * @brief 通过传感器获取的大气压强计算的海拔
   * @return 返回计算后的海拔高度
   */
  float getElevation(void);
```

## 兼容性

MCU                | Work Well    | Work Wrong   | Untested    | Remarks
------------------ | :----------: | :----------: | :---------: | :----:
Arduino Uno        |      √       |              |             |
Arduino MEGA2560   |      √       |              |             |
Arduino Leonardo   |      √       |              |             |
FireBeetle-ESP8266 |      √       |              |             |
FireBeetle-ESP32   |      √       |              |             |
FireBeetle-M0      |      √       |              |             |
Micro:bit          |      √       |              |             |


## 历史

- 2019/06/25 - 1.0.0 版本

## 创作者

Written by TangJie(jie.tang@dfrobot.com), 2021. (Welcome to our [website](https://www.dfrobot.com/))





