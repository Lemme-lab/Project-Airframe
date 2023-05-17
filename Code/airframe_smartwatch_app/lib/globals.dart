library globals;

int battery = 0;
int O2stand = 0;
int steps = 0;
int heartrate = 0;
List<int> heartrate_list = [
  130, 160, 180, 190, 150, 100, 170, 140, 110, 130, 180, 110, 150, 150, 140, 110,
  100, 170, 110, 150, 130, 160, 150, 160, 130, 140, 110, 130, 150, 100
];
List<int> ECG_Values = [
  130, 140, 130, 150, 110, 180, 170, 110, 140, 160, 150, 150, 130, 140, 100, 180,
  150, 130, 150, 160, 110, 100, 180, 110, 150, 140, 110, 150, 170, 190
];
List<int> oxy_level = [
  130, 180, 100, 190, 150, 130, 110, 140, 150, 170, 110, 160, 150, 180, 110, 140,
  150, 170, 130, 190, 110, 130, 140, 150, 100, 160, 180, 110, 130, 150
];
double display = 0;
int kcal = 0;
int temperature = 0;
int altitude = 0;

int Oxy_AVG = 0;
int Oxy_Max = 0;
int Oxy_Min = 0;

int heart_AVG = 0;
int heart_Max = 0;
int heart_Min = 0;

int bpm = 0;
int hours = 0;
int minutes = 0;
List<double> past_sleep = [0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
List<double> past_distance = [0, 0, 0, 0, 0, 0];
List<String> past_distance_month = ["Mar", "Mar", "Mar", "Mar", "Mar", "Mar"];
List<String> past_distance_day = ["14", "16", "18", "20", "22", "24"];
String training_status = "Running";
String daily_progress = (steps/100).round().toString();

String ble_string = "";
String nfc_string = "";


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