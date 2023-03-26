library globals;

int battery = 80;
int O2stand = 40;
int steps = 6560;
int heartrate = 70;
double display = 90;
int kcal = 845;
int temperature = 24;
int altitude = 550;

int Oxy_AVG = 80;
int Oxy_Max = 80;
int Oxy_Min = 80;

int heart_AVG = 80;
int heart_Max = 80;
int heart_Min = 80;

int bpm = 117;
int hours = 7;
int minutes = 23;
List<double> past_sleep = [10, 8.12, 5.12, 6.12, 9.20, 5.8, 7.9, 7.7, 7.2, 8.3, 8.8, 5.9];
List<double> past_distance = [15000, 10000, 8000, 12300, 14200, 3400];
List<String> past_distance_month = ["Mar", "Mar", "Mar", "Mar", "Mar", "Mar"];
List<String> past_distance_day = ["14", "16", "18", "20", "22", "24"];
String training_status = "Running";
String daily_progress = (steps/100).round().toString();


int watchface = 1;
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
String soc = "NXP i.MX 8 Quad";
String ram = "DDR4 1.2GHZ 8GB";
String flash = "8GB AND Flash";
String wireless = "GPS, Wifi Bluetooth5.1, NFC Tag/Reager";
String senors = "Oxymeter, Pulse, ECG, Alttitude, Pressure, Temperature, IMU, Compass";
String software_version = "0.0.01";
String last_update = "02.03.2023gr";