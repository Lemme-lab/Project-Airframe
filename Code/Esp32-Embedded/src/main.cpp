#include <Arduino.h>
#include "SPI.h"
#include <TFT_eSPI.h>
#include "scanner.h"
#include "sensors.h"
#include "health.h"
#include "SPIFFS.h"
#include "ble.h"
#include "stepcounter.h"
#include "Sleeptracker.h"
#include "esp_timer.h"
#include "wireless.h"
#include <fallDetection.h>
#include <EEPROM.h>
#include "display.h"
#include <CST816S.h>

#define BD71850_I2C_ADDRESS 0x4B

// Define Bd71850 register addresses
#define BUCK1_VOLTAGE_REG 0x0D
#define BUCK2_VOLTAGE_REG 0x10

#define TFT_WIDTH 240
#define TFT_HEIGHT 240

long irValue;
float beatsPerMinute;
double beatAvg;

int x;
int y;
int z;

float x_acceleration;
float y_acceleration;
float z_acceleration;
float avg_acc;

int32_t heartRate = 0;
int32_t spo2 = 0;

int latitude = 0;
int longitude = 0;

float airPressure;
float temperature = 0;
int altitude = 550;

unsigned long previousMillis = 0;
unsigned long previousMillis3 = 0;
const unsigned long interval = 2000;
const unsigned long interval2 = 4000;
const unsigned long interval3 = 30000;
const unsigned long interval4 = 100;
const unsigned long interval5 = 1000;
const unsigned long interval6 = 500;

int battery = 80;
int O2stand = 75;
int steps = 4000;
double display = 80;
int kcal = 657;
int kcalGoal = 800;
int Oxy_AVG = 80;
int Oxy_Max = 89;
int Oxy_Min = 65;

int heart_AVG = 70;
int heart_Max = 90;
int heart_Min = 60;

double Stresscore = 0;
bool fallDetectionbool = false;

int bpm = 78;
int hours = 0;
int minutes = 0;
int seconds = 0;
String training_status = "Normal";
String daily_progress = "";

int date = 27;

float bpSystolic = 0, bpDiastolic = 0;

int watchface = 2;
bool always_on_display = true;
bool Battery_Saving_Mode = false;
bool reset_to_default = false;
bool software_update = false;
bool flush_cache = false;
bool reset_to_defaults = false;

bool bluetooth = true;
bool nfc = true;
bool gps = true;
bool messages = true;
bool disable_updates = false;

bool Oxymeter_pulse = true;
bool pressure_altitude = true;
bool ECG = true;
bool Axis_IMU = true;
bool compass = true;
bool keep_all_on_device = true;

String watch_type = "Airframe";
double hardware_version = 0.1;
String sensors = "Oxymeter, Pulse, ECG, Alttitude, Pressure, Temperature, IMU, Compass";
String soc = "ESP32-S3";
String ram = "4MB";
String flash = "8MB";
String wireless = "GPS, Wifi Bluetooth4.2, NFC Tag";
String software_version = "0.0.01";
String last_update = "07.04.2023";

double sleep1[12] = {10.6, 3, 7, 9, 8, 8, 7, 1, 9, 10, 8, 9.5};
double sleepqualtiy[12] = {90, 89, 79, 67, 98, 98, 89, 95, 92, 78, 88, 97};
int ECG_Values[50] = {0, -1, 2, 0, 1, 4, 1, 0, -2, -1, 0, -1, 0, 1, 3, 0, 1, 0, -2, -1, 0, -1, 0, 1, 2, 0, -1, -3, -2, -1, 0, 1, 0, -1, 0, 2, 0, -1, -2, -1, 0, -1, 0, 1, 2, 0, -1, -2, -1, 0};
int oxy_level[50] = {98, 99, 97, 96, 95, 97, 94, 92, 90, 89, 91, 90, 92, 94, 96, 97, 98, 99, 97, 96, 94, 93, 91, 92, 94, 95, 97, 98, 96, 95, 94, 93, 91, 90, 89, 88, 90, 92, 93, 94, 96, 97, 98, 99, 97, 95, 94, 93, 91, 90};
int heart_rate[50] = {70, 71, 72, 71, 70, 68, 69, 72, 74, 77, 80, 83, 85, 87, 88, 89, 88, 87, 85, 84, 82, 80, 79, 77, 75, 74, 72, 71, 70, 69, 68, 68, 67, 67, 66, 66, 65, 65, 64, 64, 63, 63, 62, 62, 61, 61, 60, 60, 59, 59};
int acc[3] = {50, 0, 30};
int axsi[3] = {20, 30, 10};
double past_distance[6] = {11591, 11599, 11924, 3693, 17728, 13303};
String past_distance_month[6] = {"Mar", "Mar", "Mar", "Mar", "Mar", "Mar"};
String past_distance_day[6] = {"14", "16", "18", "20", "22", "24"};

void setBuckVoltage(uint8_t reg, uint16_t voltage)
{
  // Write voltage to register

  Wire.beginTransmission(BD71850_I2C_ADDRESS);
  Serial.print("Writing to Device: ");
  Serial.println(String(BD71850_I2C_ADDRESS));
  Wire.write(reg);
  Serial.print("Writing to Register: ");
  Serial.println(String(reg));
  Wire.write(voltage);
  Serial.print("Writing: ");
  Serial.println(String(voltage));
  Wire.endTransmission();
  Serial.println("Finished");
  Serial.println("");
}

void outputData()
{
  printf("\r");
  printf("\033[K");
  Serial.print("IR=");
  Serial.print(irValue);
  Serial.print(", BPM=");
  Serial.print(beatsPerMinute);
  Serial.print(", Avg BPM=");
  Serial.print(beatAvg);
  Serial.println();

  Serial.print("Magnetic field (uT): ");
  Serial.print(x);
  Serial.print(", ");
  Serial.print(y);
  Serial.print(", ");
  Serial.println(z);

  Serial.print(F("HR="));
  Serial.print(heartRate, DEC);

  Serial.print(F(", SPO2="));
  Serial.print(spo2, DEC);
  Serial.println();

  Serial.print("Pressure: ");
  Serial.print(airPressure);
  Serial.print(" hPa, Temperature: ");
  Serial.print(temperature);
  Serial.print(" C°, ");
  Serial.print(altitude);
  Serial.println(" m");

  Serial.print("Acceleration X float = ");
  Serial.println(x_acceleration);

  Serial.print("Acceleration Y float = ");
  Serial.println(y_acceleration);

  Serial.print("Acceleration Z float = ");
  Serial.println(z_acceleration);

  Serial.print("Estimated Blood Pressure: ");
  Serial.print(bpSystolic, 2);
  Serial.print("/");
  Serial.print(bpDiastolic, 2);
  Serial.println(" mmHg");

  Serial.println(" ");
  Serial.println(" ");
}

BleData data(battery, spo2, steps, beatsPerMinute, display, kcal, temperature, altitude,
             Oxy_AVG, Oxy_Max, Oxy_Min, heart_AVG, heart_Max, heart_Min, beatsPerMinute, hours, minutes,
             sleep1, past_distance, past_distance_month, past_distance_day, oxy_level, ECG_Values, heart_rate,
             acc, axsi, training_status, daily_progress, watchface, always_on_display,
             Battery_Saving_Mode, reset_to_default, software_update, flush_cache, reset_to_defaults,
             bluetooth, nfc, gps, messages, disable_updates, Oxymeter_pulse, pressure_altitude,
             ECG, Axis_IMU, compass, keep_all_on_device, watch_type, hardware_version, soc,
             ram, flash, wireless, sensors, software_version, last_update);

MAX30105 particleSensor;
SemaphoreHandle_t max30105_semaphore;

int blecounter = 0;

CST816S touch(21, 22, 5, 4);

void setup()
{

  Serial.begin(115200);
  Serial.println("");
  Serial.println("");
  Serial.println("");

  EEPROM.begin(512);

  blesetup();
  data.printValues();

  // Wire.begin(46,45);
  // Max30105Setup();
  // LIS2MDLTRSetup();
  // Max30105_O2_Setup();
  // ICP_Setup();
  // KXTJ3_Setup();
  // LSM6DSLTR_Setup();

  touch.begin();
  Serial.print(touch.data.version);

  // Serial.begin(115200);
  // Wire.begin(45,46);
  // Wire.setClock(300000);

  // Wire.beginTransmission(BD71850_I2C_ADDRESS);
  // Wire.write(0x05);
  // Wire.write(01000010);
  // Wire.endTransmission();

  // Wire.beginTransmission(BD71850_I2C_ADDRESS);
  // Wire.write(0x0D);
  // Wire.write(00111100);
  // Wire.endTransmission();

  // scanner_setup();

  /*
  max30105_semaphore = xSemaphoreCreateBinary();

    xTaskCreatePinnedToCore(
        Max30105_O2_task,
        "Max30105_O2_task",
        4096,
        NULL,
        1,
        NULL,
        APP_CPU_NUM
    );
  */

  // initDisplay();
}

int age = 18;
int height = 185;
int weight = 78;
char gender = 'm';

StepCounter stepCounter;

StepCounter1 stepCounter1;

String activity = "Normal";
bool flag = false;
bool timeflag = false;

bool o2_flag = false;
bool pbm_flag = true;
bool temp_flag = true;

int counter_sensor_health = 0;

SleepQualityCalculator sleepQualityCalc;

int counter_sensor = 0;

bool watchfaces = 1;
int plot = 1;
int page = 1;

int app = 0;

int startX = 0;
int startY = 0;

int endX = 0;
int endY = 0;


void loop()
{

  if (Serial.available() > 0)
  {
    app = Serial.parseInt();

    if (app == 1)
    {
      watchface++;
      if (watchface == 4)
      {
        watchface = 1;
      }
      page = 1;
    }
    if (app == 2)
    {
      plot++;
      if (plot == 4)
      {
        plot = 1;
      }
      watchfaces = 0;
      page = 2;
    }
    if (app == 3)
    {
      page = 3;
    }
    if (app == 4)
    {
      page = 4;
    }
  }

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval4)
  {
    endX = startX;
    endY = startY;

    startX = touch.data.x;
    startY = touch.data.y;

    previousMillis = currentMillis;
  }

  SwipeDirection direction = checkSwipeDirection(startX, startY, endX, endY);

  switch (direction)
  {
  case SWIPE_LEFT:
    app--;
    break;
  case SWIPE_RIGHT:
    app++;
    break;
  case NO_SWIPE:
    bool isPressed = isDisplayPressed(touch.data.x, touch.data.y);

    if (isPressed)
    {

      if (app == 1)
      {
        watchface++;
        if (watchface == 4)
        {
          watchface = 1;
        }
        page = 1;
      }

      if (app == 2)
      {
        plot++;
        if (plot == 4)
        {
          plot = 1;
        }
        watchfaces = 0;
        page = 2;
      }
    }

    break;
  }

  daily_progress = steps / 100;

  unsigned long currentMillis3 = millis();

  int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;

  totalSeconds %= 86400 / 2;

  int degrees = map(totalSeconds, 0, 86400 / 2, 0, 360) - 90;

  if (currentMillis - previousMillis >= interval5)
  {

    blecounter++;
    Serial.println(blecounter);

    if (blecounter == 1)
    {
      sendJson(data);
    }
    if (blecounter == 2)
    {
      sendJsonData1(data);
    }
    if (blecounter == 3)
    {
      sendJsonData2(data);
    }
    if (blecounter == 4)
    {
      sendJsonInfos(data);
    }
    if (blecounter == 5)
    {
      sendJson(data);
      blecounter = 1;
    }

    minutes++;
    seconds++;
    seconds++;
    seconds++;
    previousMillis = currentMillis;
  }

  steps++;

  /*
    if (page == 1)
    {
      drawWatchFaces(watchface, degrees, altitude, steps, kcal, kcalGoal, seconds, minutes, hours, sleep1, date);
    }
    else if (page == 2)
    {
      drawStats(heart_rate, heart_AVG, heart_Max, heart_Min, oxy_level, Oxy_AVG, Oxy_Max, Oxy_Min, ECG_Values, plot);
    }
    else if (page == 3)
    {
      displaySleepingData(sleep1, sleepqualtiy);
    }
    else if (page == 4)
    {
      drawInfos(watch_type, hardware_version, sensors, soc, ram, flash, wireless, software_version, last_update);
    }
  */

  /*
   float acceleration[3] = {x_acceleration, y_acceleration, z_acceleration};

   if (sleepQualityCalc.isWithinTimeRange()) {

    if(timeflag == true){
       for (size_t i = 12 - 1; i > 0; --i) {
         sleep1[i] = sleep1[i - 1];
       }

       sleep1[0] = 0;
    }
    timeflag = false;

    int sleepQuality = sleepQualityCalc.calculateSleepQuality(acceleration, heartRate, axsi);
    sleep1[0] = sleepQuality;
    Serial.print("Sleep Quality: ");
    Serial.println(sleepQuality);

  } else {
    Serial.println("Outside of sleep monitoring time range");
    timeflag = true;
  }


   String activity_new = getActivityStatus(heartRate, O2stand, acceleration, temperature);;
   Serial.println(training_status);

   //steps= stepCounter.calculateSteps(std::make_tuple(latitude, longitude), std::make_tuple(x, y, z), heartRate);
   //Serial.println(steps);
   steps = stepCounter1.update(acceleration, heartRate, currentMillis, flag);
   Serial.println(steps);

   if(flag != false){
    estimateCaloriesBurned(age, weight, height, gender, heartRate, avg_acc, O2stand, 35.0);
   }
    kcal = getCaloriesBurned();
    Serial.println(kcal);


   if(activity_new != "Unknown"){
      training_status = activity_new;
   }

   daily_progress = (steps/100) + "";

   delay(500);
   */

  /*
  unsigned long currentMillis = millis();

  int ecgValue = analogRead(1);
  float voltage = (float)ecgValue * (3.3 / 4095.0); // Convert ADC reading to voltage
  Serial.println(voltage, 4); // Print voltage with 4 decimal places
  delay(10); // Wait for 10ms before next reading
  */

  // Max30105HeartRate(irValue, beatsPerMinute, beatAvg);
  // Max30105_O2(heartRate, spo2);
  // Max30105Temp(temperature);
  // LIS2MDLTRData(x, y, z);
  // ICP_Data(airPressure,temperature,altitude);
  // KXTJ3_Data(x_acceleration, y_acceleration, z_acceleration); // not working now
  // LSM6DSLTR_Data(x_acceleration, y_acceleration, z_acceleration, avg_acc);

  /*
  axsi[0] = x;
  axsi[1] = y;
  axsi[2] = z;

  acc[0] = x_acceleration;
  acc[1] = y_acceleration;
  acc[2] = z_acceleration;

  if(counter_sensor_health == 0){
     if(pbm_flag == true){
       Serial.println("Setting up PBM");
       Max30105Setup();
     }

     if(o2_flag == true){
       Serial.println("Setting up O2");
       Max30105_O2_Setup();
       start_Max30105_O2_task();
     }

     if(temp_flag == true){
       Serial.println("Setting up Body Temp");
       Max30105Temp_Setup();
     }
  }

  if(pbm_flag == true){
    //Serial.println("Checking Heart Beat");
    Max30105HeartRate(irValue, beatsPerMinute, beatAvg);
    counter_sensor_health++;
  }

  if(o2_flag == true){
    //Serial.println("Checking O2 Levels");
    xSemaphoreGive(max30105_semaphore);
    //Max30105_O2(heartRate, spo2);
    counter_sensor_health++;
  }

     if(temp_flag == true){
    //Serial.println("Checking Heart Beat");
    Max30105Temp(temperature);
    Stresscore = calculateStress(beatAvg, temperature, activity);

    if (Stresscore < 0.1) {
      Serial.println("Low stress");
   } else if (Stresscore < 0.3) {
      Serial.println("Moderate stress");
   } else {
      Serial.println("High stress");
   }
    counter_sensor_health++;
  }


  if (currentMillis - previousMillis >= interval) {
      if(counter_sensor == 3){
       pbm_flag = false;
       temp_flag = true;
       o2_flag = false;
      }

     outputData();
     previousMillis = currentMillis;
   }

   if (currentMillis - previousMillis >= interval4) {
     fallDetectionbool = fallDetection(x_acceleration, y_acceleration, z_acceleration, axsi[0], axsi[1], axsi[2]);
     previousMillis = currentMillis;
   }

   if (currentMillis3 - previousMillis3 >= interval3) {


     if(counter_sensor == 1){
     if(pbm_flag == true){
       pbm_flag = false;
     }else{
       pbm_flag = true;
     }
     }

     if(counter_sensor == 2){
     if(o2_flag == true){
       o2_flag = false;
     }else{
       o2_flag = true;
     }
     counter_sensor = 0;
     }
     counter_sensor++;
     counter_sensor_health = 0;
     previousMillis3 = currentMillis3;
    }


   calculate_blood_pressure(bpSystolic, bpDiastolic, irValue);
*/

  // updateSleepCounter(heartRate, x_acceleration, y_acceleration,z_acceleration,axsi[0],axsi[1],axsi[2], hours, minutes, seconds, sleep1);

  /*
    if (currentMillis - previousMillis >= interval2) {
       Max30105_O2(heartRate, spo2);
       previousMillis = currentMillis;
       }
  */

  // scanner();
}