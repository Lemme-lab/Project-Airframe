#include <Arduino.h>

#include <sstream>

#include <string> using namespace std;

class BleData {
    public:

    int battery;
    int O2stand;
    int steps;
    int heartrate;
    double display;
    int kcal;
    int temperature;
    int altitude;

    int Oxy_AVG;
    int Oxy_Max;
    int Oxy_Min;


    int heart_AVG;
    int heart_Max;
    int heart_Min;


    int ECG_Values[50];
    int oxy_level[50];
    int heart_rate[50];
    int acc[3];
    int axsi[3];

    int bpm;
    int hours;
    int minutes;
    double past_sleep[12];
    double past_distance[6];
    String past_distance_month[6];
    String past_distance_day[6];
    String training_status;
    String daily_progress;

    int watchface;
    bool always_on_display;
    bool Battery_Saving_Mode;
    bool reset_to_default;
    bool software_update;
    bool flush_cache;
    bool reset_to_defaults;

    bool bluetooth;
    bool nfc;
    bool gps;
    bool messages;
    bool disable_updates;

    bool Oxymeter_pulse;
    bool pressure_altitude;
    bool ECG;
    bool Axis_IMU;
    bool compass;
    bool keep_all_on_device;

    String watch_type;
    double hardware_version;
    String soc;
    String ram;
    String flash;
    String wireless;
    String sensors;
    String software_version;
    String last_update;

    BleData(int b, int o2, int s, int hr, double d, int k, int t, int alt,
        int o_avg, int o_max, int o_min, int h_avg, int h_max, int h_min, int bpm_val,
        int hr_val, int min_val, double sleep[], double dist[], String dist_month[], String dist_day[], int ecgv[],
        int ox[], int heart[], int ac[], int axi[], String status, String progress, int face, bool always_on, bool batt_saving, bool reset_default,
        bool software, bool flush, bool reset_defaults, bool bt, bool nfc_enabled, bool gps_enabled,
        bool message_notifications, bool updates_disabled, bool oxymeter, bool pressure, bool ecg, bool imu,
        bool compass_enabled, bool keep_all, String type, double hw_version, String soc_version,
        String ram_size, String flash_size, String wireless_type, String sensor_type,
        String software_ver, String last) {

        battery = b;
        O2stand = o2;
        steps = s;
        heartrate = hr;
        display = d;
        kcal = k;
        temperature = t;
        altitude = alt;

        Oxy_AVG = o_avg;
        Oxy_Max = o_max;
        Oxy_Min = o_min;

        heart_AVG = h_avg;
        heart_Max = h_max;
        heart_Min = h_min;

        bpm = bpm_val;
        hours = hr_val;
        minutes = min_val;

        for (int i = 0; i < 12; i++) {
            past_sleep[i] = sleep[i];
        }

        for (int i = 0; i < 6; i++) {
            past_distance[i] = dist[i];
            past_distance_month[i] = dist_month[i];
            past_distance_day[i] = dist_day[i];
        }

        for (int i = 0; i < 50; i++) {
            ECG_Values[i] = ecgv[i];
            oxy_level[i] = ox[i];
            heart_rate[i] = heart[i];
        }

        for (int i = 0; i < 50; i++) {
            ECG_Values[i] = ox[i];
            oxy_level[i] = ecgv[i];
            heart_rate[i] = heart[i];
        }

        for (int i = 0; i < 3; i++) {
            acc[i] = ac[i];
            axsi[i] = axi[i];
        }

        training_status = status;
        daily_progress = progress;

        watchface = face;
        always_on_display = always_on;
        Battery_Saving_Mode = batt_saving;
        reset_to_default = reset_default;
        software_update = software;
        flush_cache = flush;
        reset_to_defaults = reset_defaults;

        bluetooth = bt;
        nfc = nfc_enabled;
        gps = gps_enabled;
        messages = message_notifications;
        disable_updates = updates_disabled;

        Oxymeter_pulse = oxymeter;
        pressure_altitude = pressure;
        ECG = ecg;
        Axis_IMU = imu;
        compass = compass_enabled;
        keep_all_on_device = keep_all;

        watch_type = type;
        hardware_version = hw_version;
        soc = soc_version;
        ram = ram_size;
        flash = flash_size;
        wireless = wireless_type;
        sensors = sensor_type;
        software_version = software_ver;
        last_update = last;
    }



    int getBattery() {
        return battery;
    }

    void setBattery(int value) {
        battery = value;
    }

    // O2stand
    int getO2stand() {
        return O2stand;
    }

    void setO2stand(int value) {
        O2stand = value;
    }

    // Steps
    int getSteps() {
        return steps;
    }

    void setSteps(int value) {
        steps = value;
    }

    // Heartrate
    int getHeartrate() {
        return heartrate;
    }

    void setHeartrate(int value) {
        heartrate = value;
    }

    // Display
    double getDisplay() {
        return display;
    }

    void setDisplay(double value) {
        display = value;
    }

    // kcal
    int getKcal() {
        return kcal;
    }

    void setKcal(int value) {
        kcal = value;
    }

    // Temperature
    int getTemperature() {
        return temperature;
    }

    void setTemperature(int value) {
        temperature = value;
    }

    // Altitude
    int getAltitude() {
        return altitude;
    }

    void setAltitude(int value) {
        altitude = value;
    }

    // Oxy_AVG
    int getOxy_AVG() {
        return Oxy_AVG;
    }

    void setOxy_AVG(int value) {
        Oxy_AVG = value;
    }

    // Oxy_Max
    int getOxy_Max() {
        return Oxy_Max;
    }

    void setOxy_Max(int value) {
        Oxy_Max = value;
    }

    // Oxy_Min
    int getOxy_Min() {
        return Oxy_Min;
    }

    void setOxy_Min(int value) {
        Oxy_Min = value;
    }

    // heart_AVG
    int getHeart_AVG() {
        return heart_AVG;
    }

    void setHeart_AVG(int value) {
        heart_AVG = value;
    }

    // heart_Max
    int getHeart_Max() {
        return heart_Max;
    }

    void setHeart_Max(int value) {
        heart_Max = value;
    }

    // heart_Min
    int getHeart_Min() {
        return heart_Min;
    }

    void setHeart_Min(int value) {
        heart_Min = value;
    }

    // bpm
    int getBpm() {
        return bpm;
    }

    void setBpm(int value) {
        bpm = value;
    }

    // hours
    int getHours() {
        return hours;
    }

    void setHours(int value) {
        hours = value;
    }

    // minutes
    int getMinutes() {
        return minutes;
    }

    void setMinutes(int value) {
        minutes = value;
    }

    // past_sleep
    double getPastSleep(int index) {
        return past_sleep[index];
    }

    void setPastSleep(int index, double value) {
        past_sleep[index] = value;
    }

    // past_distance
    double getPastDistance(int index) {
        return past_distance[index];
    }

    void setPastDistance(int index, double value) {
        past_distance[index] = value;
    }

    // past_distance_month
    String getPastDistanceMonth(int index) {
        return past_distance_month[index];
    }

    void setPastDistanceMonth(int index, String value) {
        past_distance_month[index] = value;
    }

    // past_distance_day
    String getPastDistanceDay(int index) {
        return past_distance_day[index];
    }

    void setPastDistanceDay(int index, String value) {
        past_distance_day[index] = value;
    }

    // training_status
    String getTrainingStatus() {
        return training_status;
    }

    void setTrainingStatus(String value) {
        training_status = value;
    }

    // daily_progress
    String getDailyProgress() {
        return daily_progress;
    }

    void setDailyProgress(String value) {
        daily_progress = value;
    }

    // watchface
    int getWatchface() {
        return watchface;
    }

    void setWatchface(int value) {
        watchface = value;
    }

    // always_on_display
    bool getAlwaysOnDisplay() {
        return always_on_display;
    }

    void setAlwaysOnDisplay(bool value) {
        always_on_display = value;
    }

    // Battery_Saving_Mode
    bool getBatterySavingMode() {
        return Battery_Saving_Mode;
    }

    void setBatterySavingMode(bool value) {
        Battery_Saving_Mode = value;
    }

    // reset_to_default
    bool getResetToDefault() {
        return reset_to_default;
    }

    void setResetToDefault(bool value) {
        reset_to_default = value;
    }

    // software_update
    bool getSoftwareUpdate() {
        return software_update;
    }

    void setSoftwareUpdate(bool value) {
        software_update = value;
    }

    // flush_cache
    bool getFlushCache() {
        return flush_cache;
    }

    void setFlushCache(bool value) {
        flush_cache = value;
    }

    // reset_to_defaults
    bool getResetToDefaults() {
        return reset_to_defaults;
    }

    void setResetToDefaults(bool value) {
        reset_to_defaults = value;
    }

    // bluetooth
    bool getBluetooth() {
        return bluetooth;
    }

    void setBluetooth(bool value) {
        bluetooth = value;
    }

    // nfc
    bool getNFC() {
        return nfc;
    }

    void setNFC(bool value) {
        nfc = value;
    }

    // gps
    bool getGPS() {
        return gps;
    }

    void setGPS(bool value) {
        gps = value;
    }

    // messages
    bool getMessages() {
        return messages;
    }

    void setMessages(bool value) {
        messages = value;
    }

    // disable_updates
    bool getDisableUpdates() {
        return disable_updates;
    }

    void setDisableUpdates(bool value) {
        disable_updates = value;
    }

    // Oxymeter_pulse
    bool getOxymeterPulse() {
        return Oxymeter_pulse;
    }

    void setOxymeterPulse(bool value) {
        Oxymeter_pulse = value;
    }

    // pressure_altitude
    bool getPressureAltitude() {
        return pressure_altitude;
    }

    void setPressureAltitude(bool value) {
        pressure_altitude = value;
    }

    // ECG
    bool getECG() {
        return ECG;
    }

    void setECG(bool value) {
        ECG = value;
    }

    // Axis_IMU
    bool getAxisIMU() {
        return Axis_IMU;
    }

    void setAxisIMU(bool value) {
        Axis_IMU = value;
    }

    // compass
    bool getCompass() {
        return compass;
    }

    void setCompass(bool value) {
        compass = value;
    }

    // keep_all_on_device
    bool getKeepAllOnDevice() {
        return keep_all_on_device;
    }

    void setKeepAllOnDevice(bool value) {
        keep_all_on_device = value;
    }

    // watch_type
    String getWatchType() {
        return watch_type;
    }

    void setWatchType(String value) {
        watch_type = value;
    }

    // hardware_version
    double getHardwareVersion() {
        return hardware_version;
    }

    void setHardwareVersion(double value) {
        hardware_version = value;
    }

    // soc
    String getSoc() {
        return soc;
    }

    void setSoc(String value) {
        soc = value;
    }

    // ram
    String getRam() {
        return ram;
    }

    void setRam(String value) {
        ram = value;
    }

    // flash
    String getFlash() {
        return flash;
    }

    void setFlash(String value) {
        flash = value;
    }

    // wireless
    String getWireless() {
        return wireless;
    }

    void setWireless(String value) {
        wireless = value;
    }

    // sensors
    String getSensors() {
        return sensors;
    }

    void setSensors(String value) {
        sensors = value;
    }

    // software_version
    String getSoftwareVersion() {
        return software_version;
    }

    void setSoftwareVersion(String value) {
        software_version = value;
    }

    // last_update
    String getLastUpdate() {
        return last_update;
    }

    void setLastUpdate(String value) {
        last_update = value;
    }

    void printValues() {
        Serial.print("last_update: ");
        Serial.println(last_update);
        Serial.print("software_version: ");
        Serial.println(software_version);
        Serial.print("steps: ");
        Serial.println(steps);
        Serial.print("sensors: ");
        Serial.println(sensors);
        Serial.print("wireless: ");
        Serial.println(wireless);
        Serial.print("hardware_version: ");
        Serial.println(hardware_version);
        Serial.print("watch_type: ");
        Serial.println(watch_type);
        Serial.print("daily_progress: ");
        Serial.println(daily_progress);
        Serial.print("training_status: ");
        Serial.println(training_status);

        Serial.print("past_distance_day: ");

        for (int i = 0; i < 6; i++) {
            Serial.print(past_distance_day[i]);
            Serial.print(", ");
        }

        Serial.println();

        Serial.print("past_distance_month: ");

        for (int i = 0; i < 6; i++) {
            Serial.print(past_distance_month[i]);
            Serial.print(", ");
        }

        Serial.println();

        Serial.print("past_sleep: ");

        for (int i = 0; i < 12; i++) {
            Serial.print(past_sleep[i]);
            Serial.print(", ");
        }

        Serial.println();

        Serial.print("heart_Min: ");
        Serial.println(heart_Min);
        Serial.print("heart_Max: ");
        Serial.println(heart_Max);
        Serial.print("heart_AVG: ");
        Serial.println(heart_AVG);
        Serial.print("Oxy_Min: ");
        Serial.println(Oxy_Min);
        Serial.print("Oxy_Max: ");
        Serial.println(Oxy_Max);
        Serial.print("Oxy_AVG: ");
        Serial.println(Oxy_AVG);
        Serial.print("altitude: ");
        Serial.println(altitude);
        Serial.print("temperature: ");
        Serial.println(temperature);
        Serial.print("heartrate: ");
        Serial.println(heartrate);
        Serial.print("O2stand: ");
        Serial.println(O2stand);
        Serial.print("kcal: ");
        Serial.println(kcal);
        Serial.print("battery: ");
        Serial.println(battery);
        Serial.print("bpm: ");
        Serial.println(bpm);
        Serial.print("flash: ");
        Serial.println(flash);
        Serial.print("hours: ");
        Serial.println(hours);
        Serial.print("minutes: ");
        Serial.println(minutes);
        Serial.print("ram: ");
        Serial.println(ram);
        Serial.print("soc: ");
        Serial.println(soc);

        Serial.print("watchface: ");
        Serial.println(watchface);
        Serial.print("always_on_display: ");
        Serial.println(always_on_display);
        Serial.print("Battery_Saving_Mode: ");
        Serial.println(Battery_Saving_Mode);
        Serial.print("reset_to_default: ");
        Serial.println(reset_to_default);
        Serial.print("software_update: ");
        Serial.println(software_update);
        Serial.print("flush_cache: ");
        Serial.println(flush_cache);
        Serial.print("reset_to_defaults: ");
        Serial.println(reset_to_defaults);

        Serial.print("bluetooth: ");
        Serial.println(bluetooth);
        Serial.print("nfc: ");
        Serial.println(nfc);
        Serial.print("gps: ");
        Serial.println(gps);
        Serial.print("messages: ");
        Serial.println(messages);
        Serial.print("disable_updates: ");
        Serial.println(disable_updates);

        Serial.print("Oxymeter_pulse: ");
        Serial.println(Oxymeter_pulse);
        Serial.print("pressure_altitude: ");
        Serial.println(pressure_altitude);
        Serial.print("ECG: ");
        Serial.println(ECG);


    }

    String to_string() const {
        String str = 
            "Data: Generell, "
            "battery: " + String(battery) + ", " +
            "O2stand: " + String(O2stand) + ", " +
            "steps: " + String(steps) + ", " +
            "heartrate: " + String(heartrate) + ", " +
            "display: " + String(display) + ", " +
            "kcal: " + String(kcal) + ", " +
            "temperature: " + String(temperature) + ", " +
            "altitude: " + String(altitude) + ", " +
            "Oxy_AVG: " + String(Oxy_AVG) + ", " +
            "Oxy_Max: " + String(Oxy_Max) + ", " +
            "Oxy_Min: " + String(Oxy_Min) + ", " +
            "heart_AVG: " + String(heart_AVG) + ", " +
            "heart_Max: " + String(heart_Max) + ", " +
            "heart_Min: " + String(heart_Min) + ", " +
            "training_status: " + training_status + ", " +
            "daily_progress: " + daily_progress + ", " +
            "hours: " + hours + ", " + 
            "minutes: " + minutes;
    
        return str;
    }

    String to_string_infos() const {
        String str = "Data: Info, ";       
            str += 
            "always_on_display: " + String(always_on_display) + ", " +
            "Battery_Saving_Mode: " + String(Battery_Saving_Mode) + ", " +
            "reset_to_default: " + String(reset_to_default) + ", " +
            "bluetooth: " + String(bluetooth) + ", " +
            "nfc: " + String(nfc) + ", " +
            "gps: " + String(gps) + ", " +
            "messages: " + String(messages) + ", " +
            "disable_updates: " + String(disable_updates) + ", " +
            "Oxymeter_pulse: " + String(Oxymeter_pulse) + ", " +
            "pressure_altitude: " + String(pressure_altitude) + ", " +
            "ECG: " + String(ECG) + ", " +
            "Axis_IMU: " + String(Axis_IMU) + ", " +
            "compass: " + String(compass) + ", " +
            "keep_all_on_device: " + String(keep_all_on_device) + ", " +
            "hardware_version: " + String(hardware_version) + ", " +
            "soc: " + soc + ", " +
            "ram: " + ram + ", " +
            "flash: " + flash + ", " +
            "wireless: " + wireless + ", " +
            "sensors: " + sensors + ", " +
            "software_version: " + software_version + ", " +
            "last_update: " + last_update;

        return str;
    }

    String to_string_data1() const {
        String str = "Data: Data1, ECG_Values: [";
        for (int i = 0; i < 50; i++) {
            str += String(ECG_Values[i]);
            if (i < 49) {
                str += ", ";
            }
        }
        str += "], oxy_level: [";
        for (int i = 0; i < 50; i++) {
            str += String(oxy_level[i]);
            if (i < 49) {
                str += ", ";
            }
        }
        return str;
    }

    String to_string_data2() const {
        String str = "";
        str += "Data: Data2, Heart_rate: [";
        for (int i = 0; i < 50; i++) {
            str += String(heart_rate[i]);
            if (i < 49) {
                str += ", ";
            }
        }
        str += "], acc: [";
        for (int i = 0; i < 3; i++) {
            str += String(acc[i]);
            if (i < 2) {
                str += ", ";
            }
        }
        str += "], axsi: [";
        for (int i = 0; i < 3; i++) {
            str += String(axsi[i]);
            if (i < 2) {
                str += ", ";
            }
        }
        str += "], bpm: " + String(bpm) + ", " +
            "hours: " + String(hours) + ", " +
            "minutes: " + String(minutes) + ", " +
            "past_sleep: [";
        for (int i = 0; i < 12; i++) {
            str += String(past_sleep[i]);
            if (i < 11) {
                str += ", ";
            }
        }
        str += "], past_distance: [";
        for (int i = 0; i < 6; i++) {
            str += String(past_distance[i]);
            if (i < 5) {
                str += ", ";
            }
        }
        str += "], past_distance_month: [";
        for (int i = 0; i < 6; i++) {
            str += past_distance_month[i];
            if (i < 5) {
                str += ", ";
            }
        }
        str += "], past_distance_day: [";
        for (int i = 0; i < 6; i++) {
            str += past_distance_day[i];
            if (i < 5) {
                str += ", ";
            }
        }
        return str;
    }

/*
    BleData convertStringToBleData(string input_string) {
        BleData data;
        stringstream ss(input_string);
        string line;

        while (getline(ss, line)) {
            stringstream line_ss(line);
            string key,
            value;

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
    }*/
}

;