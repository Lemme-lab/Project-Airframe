class receivedData {
  final int battery ;
  final int O2stand;
  final int steps;
  final int heartrate;
  final int kcal;
  final int temperature;
  final int altitude;

  final int Oxy_AVG;
  final int Oxy_Max;
  final int Oxy_Min;

  final int heart_AVG;
  final int heart_Max;
  final int heart_Min;

  final int bpm;
  final int hours;
  final int minutes;
  final List<double> past_sleep;
  final  List<double> past_distance;
  final List<String> past_distance_month;
  final List<String> past_distance_day;
  final String training_status;
  final String daily_progress;


  final String watch_type;
  final double hardware_version;
  final String soc;
  final String ram;
  final String flash;
  final String wireless;
  final String senors;
  final String software_version;
  final String last_update;


  receivedData(this.battery, this.O2stand, this.steps, this.heartrate, this.kcal, this.temperature, this.altitude, this.Oxy_AVG, this.Oxy_Max,
           this.Oxy_Min, this.heart_AVG, this.heart_Max, this.heart_Min, this.bpm, this.hours, this.minutes, this.past_sleep, this.past_distance,
           this.past_distance_month, this.past_distance_day, this.training_status, this.daily_progress, this.watch_type, this.hardware_version, this.soc, this.ram, this.flash,
           this.wireless, this.senors, this.software_version, this.last_update);

  factory receivedData.fromJson(Map<String, dynamic> json) {
    return receivedData(
      json['battery'],json['O2stand'],json['steps'],json['heartrate'],json['kcal'],json['temperature'],json['altitude'],json['Oxy_AVG'],json['Oxy_Max'],json['Oxy_Min'],
      json['heart_AVG'],json['heart_Max'],json['heart_Min'],json['bpm'],json['hours'],json['minutes'],json['past_sleep'],json['past_distance'],json['past_distance_month'],json['past_distance_day'],
      json['training_status'],json['daily_progress'],json['watch_type'],json['hardware_version'],json['soc'],json['ram'],json['flash'],json['wireless'],json['senors'],json['software_version'],
      json['last_update']
    );
  }
}
class sendData {
  final String name;
  final int age;
  final double height;


  sendData(this.name, this.age, this.height);

  factory sendData.fromJson(Map<String, dynamic> json) {
    return sendData(
      json['name'],
      json['age'],
      json['height'],
    );
  }
}