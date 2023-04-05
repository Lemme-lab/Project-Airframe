#include <Arduino.h>
#include <sstream>
#include <string>
using namespace std;

class BleData {
public:
  long last_update;
  int software_version;
  int steps;
  int sensors;
  bool wireless;
  int hardware_version;
  int watch_type;
  int daily_progress;
  int training_status;
  float past_distance_day;
  float past_distance_month;
  int past_sleep;
  int heart_Min;
  int heart_Max;
  int heart_AVG;
  int Oxy_Min;
  int Oxy_Max;
  int Oxy_AVG;
  int altitude;
  int temperature;
  int heartrate;
  int O2stand;
  int kcal;
  int battery;
  int bpm;
  int flash;
  int hours;
  int minutes;
  int ram;
  int soc;

  BleData(long long last_update = 0, int software_version = 0, int steps = 0,
              int sensors = 0, int wireless = 0, int hardware_version = 0,
              int watch_type = 0, int daily_progress = 0, int training_status = 0,
              float past_distance_day = 0.0, float past_distance_month = 0.0,
              int past_sleep = 0, int heart_Min = 0, int heart_Max = 0,
              int heart_AVG = 0, int Oxy_Min = 0, int Oxy_Max = 0, int Oxy_AVG = 0,
              int altitude = 0, int temperature = 0, int heartrate = 0, int O2stand = 0,
              int kcal = 0, int battery = 0, int bpm = 0, int flash = 0,
              int hours = 0, int minutes = 0, int ram = 0, int soc = 0) :
      last_update(last_update), software_version(software_version), steps(steps),
      sensors(sensors), wireless(wireless), hardware_version(hardware_version),
      watch_type(watch_type), daily_progress(daily_progress), training_status(training_status),
      past_distance_day(past_distance_day), past_distance_month(past_distance_month),
      past_sleep(past_sleep), heart_Min(heart_Min), heart_Max(heart_Max),
      heart_AVG(heart_AVG), Oxy_Min(Oxy_Min), Oxy_Max(Oxy_Max), Oxy_AVG(Oxy_AVG),
      altitude(altitude), temperature(temperature), heartrate(heartrate), O2stand(O2stand),
      kcal(kcal), battery(battery), bpm(bpm), flash(flash), hours(hours),
      minutes(minutes), ram(ram), soc(soc)
  {
  }


  void setLastUpdate(long value) { last_update = value; }
  long getLastUpdate() const { return last_update; }

  void setSoftwareVersion(int value) { software_version = value; }
  int getSoftwareVersion() const { return software_version; }

  void setSteps(int value) { steps = value; }
  int getSteps() const { return steps; }

  void setSensors(int value) { sensors = value; }
  int getSensors() const { return sensors; }

  void setWireless(bool value) { wireless = value; }
  bool getWireless() const { return wireless; }

  void setHardwareVersion(int value) { hardware_version = value; }
  int getHardwareVersion() const { return hardware_version; }

  void setWatchType(int value) { watch_type = value; }
  int getWatchType() const { return watch_type; }

  void setDailyProgress(int value) { daily_progress = value; }
  int getDailyProgress() const { return daily_progress; }

  void setTrainingStatus(int value) { training_status = value; }
  int getTrainingStatus() const { return training_status; }

  void setPastDistanceDay(float value) { past_distance_day = value; }
  float getPastDistanceDay() const { return past_distance_day; }

  void setPastDistanceMonth(float value) { past_distance_month = value; }
  float getPastDistanceMonth() const { return past_distance_month; }

  void setPastSleep(int value) { past_sleep = value; }
  int getPastSleep() const { return past_sleep; }

  void setHeartMin(int value) { heart_Min = value; }
  int getHeartMin() const { return heart_Min; }

  void setHeartMax(int value) { heart_Max = value; }
  int getHeartMax() const { return heart_Max; }

  void setHeartAvg(int value) { heart_AVG = value; }
  int getHeartAvg() const { return heart_AVG; }

  void setOxyMin(int value) { Oxy_Min = value; }
  int getOxyMin() const { return Oxy_Min; }

  void setOxyMax(int value) { Oxy_Max = value; }
  int getOxyMax() const { return Oxy_Max; }

  void setOxyAvg(int value) { Oxy_AVG = value; }
  int getOxyAvg() const { return Oxy_AVG; }

  void setAltitude(int value) { altitude = value; }
  int getAltitude() const { return altitude; }

  void setTemperature(int value) { temperature = value; }
  int getTemperature() const { return temperature; }

  void setHeartRate(int value) { heartrate = value; }
  int getHeartRate() const { return heartrate; }

  void setO2Stand(int value) { O2stand = value; }
  int getO2Stand() const { return O2stand; }

  void setKcal(int value) { kcal = value; }
  int getKcal() const { return kcal; }

  void setBattery(int value) { battery = value; }
  int getBattery() const { return battery; }

  void setBPM(int value) { bpm = value; }
  int getBPM() const { return bpm; }

  void setFlash(int value) { flash = value; }
  int getFlash() const { return flash; }

  void setHours(int value) { hours = value; }
  int getHours() const { return hours; }

  void setMinutes(int value) { minutes = value; }
  int getMinutes() const { return minutes; }

  void setRAM(int value) { ram = value; }
  int getRAM() const { return ram; }

  void setSOC(int value) { soc = value; }
  int getSOC() const { return soc; }

  void printValues() {
    Serial.print("last_update: "); Serial.println(last_update);
    Serial.print("software_version: "); Serial.println(software_version);
    Serial.print("steps: "); Serial.println(steps);
    Serial.print("sensors: "); Serial.println(sensors);
    Serial.print("wireless: "); Serial.println(wireless);
    Serial.print("hardware_version: "); Serial.println(hardware_version);
    Serial.print("watch_type: "); Serial.println(watch_type);
    Serial.print("daily_progress: "); Serial.println(daily_progress);
    Serial.print("training_status: "); Serial.println(training_status);
    Serial.print("past_distance_day: "); Serial.println(past_distance_day);
    Serial.print("past_distance_month: "); Serial.println(past_distance_month);
    Serial.print("past_sleep: "); Serial.println(past_sleep);
    Serial.print("heart_Min: "); Serial.println(heart_Min);
    Serial.print("heart_Max: "); Serial.println(heart_Max);
    Serial.print("heart_AVG: "); Serial.println(heart_AVG);
    Serial.print("Oxy_Min: "); Serial.println(Oxy_Min);
    Serial.print("Oxy_Max: "); Serial.println(Oxy_Max);
    Serial.print("Oxy_AVG: "); Serial.println(Oxy_AVG);
    Serial.print("altitude: "); Serial.println(altitude);
    Serial.print("temperature: "); Serial.println(temperature);
    Serial.print("heartrate: "); Serial.println(heartrate);
    Serial.print("O2stand: "); Serial.println(O2stand);
    Serial.print("kcal: "); Serial.println(kcal);
    Serial.print("battery: "); Serial.println(battery);
    Serial.print("bpm: "); Serial.println(bpm);
    Serial.print("flash: "); Serial.println(flash);
    Serial.print("hours: "); Serial.println(hours);
    Serial.print("minutes: "); Serial.println(minutes);
    Serial.print("ram: "); Serial.println(ram);
    Serial.print("soc: "); Serial.println(soc);
  }

  String to_string() const {
    String str = "last_update: " + String(last_update) + ", " +
                 "software_version: " + String(software_version) + ", " +
                 "steps: " + String(steps) + ", " +
                 "sensors: " + String(sensors) + ", " +
                 "wireless: " + String(wireless) + ", " +
                 "hardware_version: " + String(hardware_version) + ", " +
                 "watch_type: " + String(watch_type) + ", " +
                 "daily_progress: " + String(daily_progress) + ", " +
                 "training_status: " + String(training_status) + ", " +
                 "past_distance_day: " + String(past_distance_day) + ", " +
                 "past_distance_month: " + String(past_distance_month) + ", " +
                 "past_sleep: " + String(past_sleep) + ", " +
                 "heart_Min: " + String(heart_Min) + ", " +
                 "heart_Max: " + String(heart_Max) + ", " +
                 "heart_AVG: " + String(heart_AVG) + ", " +
                 "Oxy_Min: " + String(Oxy_Min) + ", " +
                 "Oxy_Max: " + String(Oxy_Max) + ", " +
                 "Oxy_AVG: " + String(Oxy_AVG) + ", " +
                 "altitude: " + String(altitude) + ", " +
                 "temperature: " + String(temperature) + ", " +
                 "heartrate: " + String(heartrate) + ", " +
                 "O2stand: " + String(O2stand) + ", " +
                 "kcal: " + String(kcal) + ", " +
                 "battery: " + String(battery) + ", " +
                 "bpm: " + String(bpm) + ", " +
                 "flash: " + String(flash) + ", " +
                 "hours: " + String(hours) + ", " +
                 "minutes: " + String(minutes) + ", " +
                 "ram: " + String(ram) + ", " +
                 "soc: " + String(soc);
                 
    return str;
}

BleData convertStringToBleData(string input_string) {
    BleData data;
    stringstream ss(input_string);
    string line;
    while (getline(ss, line)) {
        stringstream line_ss(line);
        string key, value;
        if (getline(line_ss, key, ':') && getline(line_ss, value)) {
            if (key == "last_update") {
                data.last_update = stol(value);
            } else if (key == "software_version") {
                data.software_version = stoi(value);
            } else if (key == "steps") {
                data.steps = stoi(value);
            } else if (key == "sensors") {
                data.sensors = stoi(value);
            } else if (key == "wireless") {
                data.wireless = stoi(value);
            } else if (key == "hardware_version") {
                data.hardware_version = stoi(value);
            } else if (key == "watch_type") {
                data.watch_type = stoi(value);
            } else if (key == "daily_progress") {
                data.daily_progress = stoi(value);
            } else if (key == "training_status") {
                data.training_status = stoi(value);
            } else if (key == "past_distance_day") {
                data.past_distance_day = stof(value);
            } else if (key == "past_distance_month") {
                data.past_distance_month = stof(value);
            } else if (key == "past_sleep") {
                data.past_sleep = stoi(value);
            } else if (key == "heart_Min") {
                data.heart_Min = stoi(value);
            } else if (key == "heart_Max") {
                data.heart_Max = stoi(value);
            } else if (key == "heart_AVG") {
                data.heart_AVG = stoi(value);
            } else if (key == "Oxy_Min") {
                data.Oxy_Min = stoi(value);
            } else if (key == "Oxy_Max") {
                data.Oxy_Max = stoi(value);
            } else if (key == "Oxy_AVG") {
                data.Oxy_AVG = stoi(value);
            } else if (key == "altitude") {
                data.altitude = stoi(value);
            } else if (key == "temperature") {
                data.temperature = stoi(value);
            } else if (key == "heartrate") {
                data.heartrate = stoi(value);
            } else if (key == "O2stand") {
                data.O2stand = stoi(value);
            } else if (key == "kcal") {
                data.kcal = stoi(value);
            } else if (key == "battery") {
                data.battery = stoi(value);
            } else if (key == "bpm") {
                data.bpm = stoi(value);
            } else if (key == "flash") {
                data.flash = stoi(value);
            } else if (key == "hours") {
                data.hours = stoi(value);
            } else if (key == "minutes") {
                data.minutes = stoi(value);
            } else if (key == "ram") {
                data.ram = stoi(value);
            } else if (key == "soc") {
                data.soc = stoi(value);
            }
        }
    }
    return data;
}

};