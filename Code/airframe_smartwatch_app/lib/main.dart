import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartphone_app/settings.dart';
import 'bluetoothconnect.dart';
import 'globals.dart' as globals;
import 'ble.dart';

GetIt getIt = GetIt.instance;

const primaryColor = Color(0xFF151026);

StreamController<String> _stringController = StreamController<String>.broadcast();

String _stringOutput = "";
StreamSubscription<String> _stringSubscription;

void _checkVariable(String newValue) {
  // Check if the variable has changed
  if (newValue != _stringOutput) {
    // Add the new value to the stream
    _stringController.add(newValue);
  }
}

void main() {
  getIt.registerSingleton<ConfigNameController>(ConfigNameController("ESP32"));
  getIt.registerSingleton<SnackbarController>(SnackbarController());
  getIt.registerSingleton<BluetoothController>(BluetoothController());

  final bluetooth = getIt.get<BluetoothController>();

  int idk = 0;

  String _stringOutput = "";
  StreamSubscription<String> _stringSubscription;
  StreamSubscription<bool> _boolSubscription;
  StreamSubscription<int> _intSubscription;

  bluetooth.getStringStream().listen((data) {
    _stringOutput = data;
    print(data);

    List<String> inputList = data.split(", ");

    for (String item in inputList) {
      List<String> pair = item.split(": ");
      String key = pair[0];
      String value = pair[1];

      switch (key) {
        case "last_update":
          globals.last_update = value;
          break;
        case "software_version":
          globals.software_version = value;
          break;
        case "steps":
          globals.steps = int.parse(value);
          _checkVariable(value);
          break;
        case "sensors":
          globals.senors = value;
          break;
        case "wireless":
          globals.wireless = value;
          break;
        case "hardware_version":
          globals.hardware_version = double.parse(value);
          break;
        case "watch_type":
          globals.watch_type = value;
          break;
        case "daily_progress":
          globals.daily_progress = value;
          break;
        case "training_status":
          globals.training_status = value;
          break;
        case "past_distance_day":
        //globals.past_distance_day = double.parse(value);
          break;
        case "past_distance_month":
        //globals.past_distance_month = double.parse(value);
          break;
        case "past_sleep":
        //globals.past_sleep = value;
          break;
        case "heart_Min":
          globals.heart_Min = int.parse(value);
          break;
        case "heart_Max":
          globals.heart_Max = int.parse(value);
          break;
        case "heart_AVG":
          globals.heart_AVG = int.parse(value);
          break;
        case "Oxy_Min":
          globals.Oxy_Min = int.parse(value);
          break;
        case "Oxy_Max":
          globals.Oxy_Max = int.parse(value);
          break;
        case "Oxy_AVG":
          globals.Oxy_AVG = int.parse(value);
          break;
        case "altitude":
          globals.altitude = int.parse(value);
          break;
        case "temperature":
          globals.temperature = int.parse(value);
          break;
        case "heartrate":
          globals.heartrate = int.parse(value);
          break;
        case "O2stand":
          globals.O2stand = int.parse(value);
          break;
        case "kcal":
          globals.kcal = int.parse(value);
          break;
        case "battery":
          globals.battery = int.parse(value);
          break;
        case "bpm":
          globals.bpm = int.parse(value);
          break;
        case "flash":
          globals.flash = value;
          break;
        case "hours":
          globals.hours = int.parse(value);
          break;
        case "minutes":
          globals.minutes = int.parse(value);
          break;
        case "ram":
          globals.ram = value;
          break;
        case "soc":
          globals.soc = value;
          break;
      }
    }

  });

  runApp(MaterialApp(
    home: App(),
  ));
}


class App extends StatefulWidget {
  const App({Key key}) : super(key: key);


  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {


  @override
  void initState() {
    super.initState();
    _stringSubscription = _stringController.stream.listen((data) {
      setState(() {
        _stringOutput = data;
      });
    });
  }

  @override
  void dispose() {
    _stringController.close();
    _stringSubscription.cancel();
    super.dispose();
  }


  void setup(){
    globals.battery = 80;
    globals.O2stand = 40;
    globals.steps = 6560;
    globals.heartrate = 70;
    globals.display = 90;
    globals.kcal = 845;
    globals.temperature = 24;
    globals.altitude = 550;
  }


  final LatLng _center = const LatLng(45.521563, -122.677433);


  List<FlSpot> points = [
    FlSpot(0, 110.0),
    FlSpot(1, 110.0),
    FlSpot(2, 130.0),
    FlSpot(3, 100.0),
    FlSpot(4, 130.0),
    FlSpot(5, 160.0),
    FlSpot(6, 190.0),
    FlSpot(7, 150.0),
    FlSpot(8, 170.0),
    FlSpot(9, 180.0),
    FlSpot(10, 140.0),
    FlSpot(11, 150.0),
    FlSpot(12, 160.0),
    FlSpot(13, 190.0),
    FlSpot(14, 150.0),
    FlSpot(15, 170.0),
    FlSpot(16, 180.0),
    FlSpot(17, 140.0),
    FlSpot(18, 150.0),
    FlSpot(19, 110.0),
    FlSpot(20, 110.0),
    FlSpot(21, 130.0),
    FlSpot(22, 100.0),
    FlSpot(23, 130.0),
    FlSpot(24, 160.0),
    FlSpot(25, 190.0),
    FlSpot(26, 150.0),
    FlSpot(27, 170.0),
    FlSpot(28, 180.0),
    FlSpot(29, 140.0),
    FlSpot(30, 150.0),
    FlSpot(31, 160.0),
    FlSpot(32, 190.0),
    FlSpot(33, 150.0),
    FlSpot(34, 170.0),
    FlSpot(35, 180.0),
    FlSpot(36, 140.0),
  ];
  List<FlSpot> points1 = [
    FlSpot(0, 110.0),
    FlSpot(0.5, 110.0),
    FlSpot(1, 130.0),
    FlSpot(2.5, 100.0),
    FlSpot(3, 130.0),
    FlSpot(3.5, 160.0),
    FlSpot(4, 190.0),
    FlSpot(4.5, 150.0),
    FlSpot(5, 170.0),
    FlSpot(5.5, 180.0),
    FlSpot(6, 140.0),
    FlSpot(6.5, 150.0),
    FlSpot(7, 160.0),
    FlSpot(7.5, 190.0),
    FlSpot(8, 150.0),
    FlSpot(8.5, 170.0),
    FlSpot(9, 180.0),
    FlSpot(9.5, 140.0),
    FlSpot(10, 150.0),
    FlSpot(10.5, 110.0),
    FlSpot(11, 110.0),
    FlSpot(11.5, 130.0),
    FlSpot(12, 100.0),
    FlSpot(13, 130.0),
    FlSpot(14, 160.0),
    FlSpot(15, 190.0),
    FlSpot(16, 150.0),
    FlSpot(17, 170.0),
    FlSpot(18, 180.0),
    FlSpot(19, 140.0),
    FlSpot(20, 150.0),
    FlSpot(21, 160.0),
    FlSpot(22, 190.0),
    FlSpot(23, 150.0),
    FlSpot(24, 170.0),
  ];
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<Color> gradientColors1 = [
    const Color(0xff23b6e6).withOpacity(0.5),
    const Color(0xff02d39a).withOpacity(0.5),
  ];
  List<Color> gradientColors2 = [
    const Color(0xffF27405),
    const Color(0xffF27405),
    const Color(0xffF25C05),
  ];
  List<Color> gradientColors3 = [
    const Color(0xffF27405).withOpacity(0.3),
    const Color(0xffF25C05).withOpacity(0.3),
    const Color(0xffF25C05).withOpacity(0.3),
  ];
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        backgroundColor: Color(0xff023535),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 10),
              child: Icon(Icons.home,
                color: Colors.white,
                size: 32.0,
              ),
            ),
            SizedBox(width: 4.0),
            Text("Airframe",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4.0),
            BluetoothConnect(
              deviceName: "ESP32",
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.settings),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SettingsButton(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),


      body:  Container (
          decoration: BoxDecoration(
              //Black
              color: Color(0xff1A1A1A),
              //Green Background
              /*
              image: DecorationImage(
                image: AssetImage("assets/Screenshot 2023-01-23 at 22.05.13.png"),
                fit: BoxFit.cover,
              ),
             */
          ),
          child: SingleChildScrollView(
              child: Column(
                  children:[
                    // First Component
                    Container (
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Status BaR
                              Container (
                                  width: 185,
                                  height: 380,
                                  margin: EdgeInsets.only(left: 5.0, top: 20.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xff1A1A1A),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35))
                                  ),
                                  child: Column(
                                      children: [
                                        //SpO2
                                        Container(
                                            child: Column(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.only(right: 68.0, top: 15.0),
                                                      child: Text(
                                                          'SpO2',
                                                          style: TextStyle(color: Colors.white, fontSize: 23))
                                                  ),
                                                  Container(
                                                    height: 15,
                                                    width: 15,

                                                    margin: EdgeInsets.only(right: 0, left: 0),
                                                    child: Image.asset('assets/arrow.png'),
                                                  ),
                                                  Container(
                                                      child: Row(
                                                          children: [
                                                            Container(
                                                              width: 23,
                                                              height: 6,
                                                              margin: EdgeInsets.only(right: 2.0, top: 5.0, left: 30),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xffE84053),
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 73,
                                                              height: 6,
                                                              margin: EdgeInsets.only(right: 3.0, top: 5.0),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xffF06C00),
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 33,
                                                              height: 6,
                                                              margin: EdgeInsets.only(right: 2.0, top: 5.0),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xff00ff9b),
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ]
                                                      )
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(right: 78.0, top: 5.0),
                                                      child: Text(
                                                          globals.O2stand.toString() + '%',
                                                          style: TextStyle(color: Colors.white, fontSize: 20))
                                                  ),                               ]
                                            )
                                        ),
                                        //Split line
                                        Container(
                                          width: 150,
                                          height: 5,
                                          color: Colors.white,
                                        ),
                                        //globals.steps
                                        InkWell(
                                        onTap: () {_navigateToNextScreenHealth(context);},
                                        child:(
                                        Container(
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                                width: 130,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                    gradient: SweepGradient(
                                                      endAngle: 10-(globals.steps/1000) + 0.0,
                                                      colors: <Color>[
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff000000),
                                                        Color(0xff00ff9b),
                                                        Color(0xff2effad),
                                                        Color(0xff2effad),
                                                        Color(0xff2effad),
                                                        Color(0xff2effad),
                                                      ],
                                                    ),
                                                    shape: BoxShape.circle
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 45, top: 25, bottom: 10),
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff1A1A1A),
                                                    shape: BoxShape.circle
                                                ),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(top: 50, bottom: 10),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      globals.steps.toString(),
                                                      style: TextStyle(color: Colors.white, fontSize: 26))
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 80, left: 65),
                                                width: 60,
                                                height: 2,
                                                color: Colors.white,
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(top: 85, bottom: 10),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Steps',
                                                      style: TextStyle(color: Colors.white, fontSize: 15))
                                              ),
                                            ],
                                          ),
                                        )
                                        )
                                        ),
                                        //Split line
                                        Container(
                                          width: 150,
                                          height: 5,
                                          color: Colors.white,
                                        ),
                                        //ECG
                                        InkWell(
                                          onTap: () {_navigateToNextScreenStats(context);},
                                          child:(
                                          Stack(
                                              children: [
                                                Container(
                                                      width: 160,
                                                      height: 100,
                                                      margin: EdgeInsets.only(top: 7.0),
                                                      decoration: BoxDecoration(
                                                          color:Colors.white,
                                                          border: Border.all(
                                                            color:Colors.white,
                                                            width: 2,
                                                          ),
                                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                                      ),
                                                      child: LineChart(
                                                        LineChartData(
                                                          minY: 60,
                                                          lineBarsData: [
                                                            LineChartBarData(
                                                              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                                                              barWidth: 2,
                                                              belowBarData: BarAreaData(
                                                                show: true,
                                                                color:Colors.red.withOpacity(0.5),
                                                              ),
                                                              dotData: FlDotData(
                                                                show: false,
                                                              ),
                                                              color:Colors.red,
                                                            ),
                                                          ],
                                                          borderData: FlBorderData(
                                                              border: const Border(bottom: BorderSide( color: Colors.transparent))),
                                                          gridData: FlGridData(show: true),
                                                          titlesData: FlTitlesData(
                                                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                Container(
                                                  width: 160,
                                                  height: 100,
                                                  margin: EdgeInsets.only(top: 7.0),
                                                  decoration: BoxDecoration(
                                                      color:Colors.transparent,
                                                      border: Border.all(
                                                        color:Colors.white,
                                                        width: 2,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                                  ),
                                                ),
                                              ],
                                          )
                                          )
                                        )


                                      ]
                                  )
                              ),
                              //Batterie, Watchface
                              Container (
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration( borderRadius: BorderRadius.circular(20)),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 180.0,
                                              width: 180.0,
                                              margin: EdgeInsets.only(left: 5.0, top: 22.0, right: 5.0),
                                              child: ClipRRect(borderRadius: BorderRadius.circular(20), child: SizedBox.fromSize(
                                                size: Size.fromRadius(48), // Image radius
                                                child: Stack(
                                                    children: [
                                                      Image.asset('assets/211920484-7c349c77-0106-4b2a-833e-7458ce933a75.jpg'),
                                                      Container(
                                                          height: 25.0,
                                                          width: 130.0,
                                                          margin: EdgeInsets.only(left: 25.0, top: 150.0, right: 5.0),
                                                          decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                begin: Alignment.centerLeft,
                                                                end: Alignment(globals.battery/20, 5),
                                                                colors: <Color>[
                                                                  Color(0xff00ff9b),
                                                                  Color(0xff2effad),
                                                                  Color(0xff2effad),
                                                                  Color(0xff2effad),
                                                                  Color(0xff2effad),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                  Color(0xff000000),
                                                                ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                                tileMode: TileMode.mirror,
                                                              ),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Text(
                                                            globals.battery.toString() + '%',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Color(0xff6E6E6E), fontSize: 20),)
                                                      )
                                                    ]
                                                ),
                                              ),),
                                            ),
                                          ]
                                          ,)
                                    ),
                                    Container (
                                      child: globals.watchface == 1?
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(
                                          width: 180,
                                          height: 180,
                                          margin: EdgeInsets.only(left: 8.0, top: 20.0, right: 5.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xff1A1A1A),
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                          ),

                                          child: Image.asset('assets/Untitled-1_2.png'),
                                        ),
                                      ):
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(),
                                      ),
                                    ),
                                    Container (
                                      child: globals.watchface == 2?
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(
                                          width: 180,
                                          height: 180,
                                          margin: EdgeInsets.only(left: 8.0, top: 20.0, right: 5.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xff1A1A1A),
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                          ),

                                          child: Image.asset('assets/Untitled-1_2_2.png'),
                                        ),
                                      ):
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(),
                                      ),
                                    ),
                                    Container (
                                      child: globals.watchface == 3?
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(
                                          width: 180,
                                          height: 180,
                                          margin: EdgeInsets.only(left: 8.0, top: 20.0, right: 5.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xff1A1A1A),
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                          ),

                                          child: Image.asset('assets/Untitled-1_2_1.png'),
                                        ),
                                      ):
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(),
                                      ),
                                    ),
                                    Container (
                                      child: globals.watchface == 4?
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(
                                          width: 180,
                                          height: 180,
                                          margin: EdgeInsets.only(left: 8.0, top: 20.0, right: 5.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xff1A1A1A),
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                          ),

                                          child: Image.asset('assets/watchface-4.png'),
                                        ),
                                      ):
                                      InkWell(
                                        onTap: () {_navigateToNextScreen(context);},
                                        child: Container(),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ]
                        )
                    ),
                    //Heart Rate

                    InkWell(
                        onTap: () {_navigateToNextScreenStats(context);},
                        child:(
                            Stack(
                              children: [
                                Container (
                                  width: 400,
                                  height: 130,
                                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xff1A1A1A),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35))
                                  ),

                                  child: DefaultTextStyle(
                                    style: TextStyle(color: Colors.white),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 28.0, top: 5, right: 5.0),
                                              child: Text(
                                                  'Heart Rate',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25)
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Container(
                                                constraints: const BoxConstraints(
                                                  maxWidth: 396,
                                                  maxHeight: 130,
                                                ),
                                                child: LineChart(
                                                  LineChartData(
                                                    minY: 70,
                                                    lineBarsData: [
                                                      LineChartBarData(
                                                        show: true, // t
                                                        spots: points1.map((point) => FlSpot(point.x, point.y)).toList(),
                                                        isCurved: false,
                                                        barWidth: 1.5,
                                                        belowBarData: BarAreaData(
                                                          show: true,
                                                          color: Color(0xff2A3729).withOpacity(0.5),
                                                        ),
                                                        dotData: FlDotData(
                                                          show: false,
                                                        ),
                                                        color: Color(0xff76D571),
                                                      ),
                                                    ],
                                                    borderData: FlBorderData(
                                                        border: const Border(bottom: BorderSide( color: Colors.white, width: 3), left: BorderSide(color: Colors.white))),
                                                    gridData: FlGridData(show: true),
                                                    titlesData: FlTitlesData(

                                                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      bottomTitles: AxisTitles(sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 15,
                                                        interval: 3,
                                                        getTitlesWidget: (value, meta) {

                                                          String text = '';
                                                          switch (value.toInt()) {
                                                            case 1:
                                                              text = '1:00';
                                                              break;
                                                            case 2:
                                                              text = '2:00';
                                                              break;
                                                            case 3:
                                                              text = '3:00';
                                                              break;
                                                            case 4:
                                                              text = '4:00';
                                                              break;
                                                            case 5:
                                                              text = '5:00';
                                                              break;
                                                            case 6:
                                                              text = '6:00';
                                                              break;
                                                            case 7:
                                                              text = '7:00';
                                                              break;
                                                            case 8:
                                                              text = '8:00';
                                                              break;
                                                            case 9:
                                                              text = '9:00';
                                                              break;
                                                            case 10:
                                                              text = '10:00';
                                                              break;
                                                            case 11:
                                                              text = '11:00';
                                                              break;
                                                            case 12:
                                                              text = '12:00';
                                                              break;
                                                            case 13:
                                                              text = '13:00';
                                                              break;
                                                            case 14:
                                                              text = '14:00';
                                                              break;
                                                            case 15:
                                                              text = '15:00';
                                                              break;
                                                            case 16:
                                                              text = '16:00';
                                                              break;
                                                            case 17:
                                                              text = '17:00';
                                                              break;
                                                            case 18:
                                                              text = '18:00';
                                                              break;
                                                            case 19:
                                                              text = '19:00';
                                                              break;
                                                            case 20:
                                                              text = '20:00';
                                                              break;
                                                            case 21:
                                                              text = '21:00';
                                                              break;
                                                            case 22:
                                                              text = '22:00';
                                                              break;
                                                            case 23:
                                                              text = '23:00';
                                                              break;
                                                            case 24:
                                                              text = '24:00';
                                                              break;
                                                          }
                                                          return Text(text);
                                                        },
                                                      ), drawBehindEverything: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 270.0, top: 75,),
                                              child: Text(
                                                  globals.heartrate.toString() + 'pbm',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25)
                                              ),
                                            ),
                                          ]
                                      ),


                                    ),
                                  ),

                                ),
                                Container(
                                  width: 400,
                                  height: 130,
                                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                                  decoration: BoxDecoration(
                                      color:Colors.transparent,
                                      border: Border.all(
                                        color:Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                ),
                              ],
                            )
                        )
                    ),
                    //Display Brightness
                    Container (
                      width: 400,
                      height: 50,
                      margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                      decoration: BoxDecoration(
                          color: Color(0xff1A1A1A),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 360,

                            height: 20,
                            margin: EdgeInsets.only(left: 19.0, top: 14.0, right: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment(globals.battery/20, 5),
                                  colors: <Color>[
                                    Color(0xff000000),
                                    Color(0xff383838),
                                    Color(0xff646464),
                                    Color(0xff858585),
                                    Color(0xff9a9a9a),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                    Color(0xffffffff),



                                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                  tileMode: TileMode.mirror,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(40))
                            ),
                          ),
                          Container(
                            child: Slider(
                              activeColor: Color(0xff00273d),
                              value: globals.display,
                              max: 100,
                              label: globals.display.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  globals.display = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),

                    ),
                    //Google Maps
                    InkWell(
                    onTap: () {_navigateToNextScreenMaps(context);},
                    child:(
                    Stack(
                    children: [
                      Container (
                      width: 400,
                      height: 200,
                      margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                      decoration: BoxDecoration(
                          color: Color(0xff1A1A1A),
                          border: Border.all(
                            color: Colors.black,
                            width: 3,
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(35))
                      ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 11.0,
                          ),
                        ),
                     ),
                    ),
                      Container(
                        width: 350,
                        height: 200,
                        margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                        decoration: BoxDecoration(
                            color:Colors.transparent,
                            border: Border.all(
                              color:Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                      ),
                       ],
                      )
                     )
                    ),

                    //Statistic Tabs
                    Container(
                        child: Row(
                          children: [
                            Container(
                              width: 179,
                              height: 150,
                              margin: EdgeInsets.only(left: 10.0, top: 20.0, right: 5.0),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                             child: Column(
                               children: [
                                 InkWell(
                                 onTap: () {_navigateToNextScreenHealth(context);},
                                 child: Column(
                                     children: [
                                 Container(
                                   height: 100,
                                   width: 100,
                                   child: Image.asset('assets/6981804.png'),
                                 ),
                                 Container(
                                   width: 80,
                                   height: 6,
                                   decoration: BoxDecoration(
                                       color: Color(0xff00ff9b),
                                       border: Border.all(
                                         color: Colors.white,
                                       ),
                                       borderRadius: BorderRadius.all(Radius.circular(35))
                                   ),

                                 ),
                                 Container(
                                   margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                                   child: Text(
                                       globals.kcal.toString() + 'kcal',
                                       style: TextStyle(
                                           color: Colors.white,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 25)
                                   ),
                                 )
                                 ]
                                ))
                               ],
                             ),
                            ),
                            InkWell(
                                onTap: () {_navigateToNextScreenStatsTab(context);},
                                child: Column(
                                  children: [
                            Container(
                              width: 180,
                              height: 150,
                              margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5.0, top: 10),
                                    child: Text(
                                        'Temperature:',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23)
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 90.0),
                                    child: Text(
                                        globals.temperature.toString() + '°C',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21)
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(35))
                                    ),

                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 55.0, top: 10),
                                    child: Text(
                                        'Altitude:',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23)
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 55.0),
                                    child: Text(
                                        globals.altitude.toString() + '/absl',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21)
                                    ),
                                  ),
                                ],
                              ),
                            )
                                    ]))
                          ],


                        )

                    ),
                    // Last Tabs
                    Container(
                        child: Row(
                          children: [
                            Container(
                              width: 180,
                              height: 90,
                              margin: EdgeInsets.only(left: 10.0, top: 15.0, bottom:50.0),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 15.0),
                                    width: 70,
                                    height: 90,
                                    child: Image.asset('assets/nfc.png'),

                              ),
                                  Container(
                                    margin: EdgeInsets.only(right: 15.0),
                                    width: 70,
                                    height: 90,
                                    child: Image.asset('assets/gps.png'),

                                  ),
                                ]
                              ),
                            ),
                        InkWell(
                            onTap: () {_navigateToNextScreenSettings(context);},
                            child:(
                                Stack(
                                  children: [
                                    Container(
                                    width: 180,
                                    height: 90,
                                    margin: EdgeInsets.only(left: 5.0, top: 15.0, right: 0.0, bottom:50.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xff1A1A1A),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(35))
                                    ),
                                    child: Row(

                                      children: [

                                        Container(
                                          margin: EdgeInsets.only(left: 30.0),
                                          child: Text(
                                              'Options',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 17.0),
                                          width: 50,
                                          height: 50,
                                          child: Image.asset('assets/settings.png'),
                                        )
                                      ],
                                    ),
                                  )])),
                            ),
                          ],
                        )
                    ),
                  ]
              )
          )
      ),
    );
  }

  void _navigateToNextApp(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => watchfaces()));
  }
  void _navigateToNextScreenStats(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => stats()));
  }
  void _navigateToNextScreenMaps(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => maps()));
  }
  void _navigateToNextScreenHealth(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => health()));
  }
  void _navigateToNextScreenSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => settings()));
  }
  void _navigateToNextScreenStatsTab(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => stattab()));
  }


}

class watchfaces extends StatefulWidget {
  const watchfaces({Key key}) : super(key: key);


  @override
  State<watchfaces> createState() => _watchfacesState();
}

class _watchfacesState extends State<watchfaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          //Black
          color: Color(0xff1A1A1A),
          //Green Background
          /*
          image: DecorationImage(
            image: AssetImage("assets/Screenshot 2023-01-19 at 10.06.28.png"),
            fit: BoxFit.cover,
          ),
          */
        ),

        child: SingleChildScrollView(
         child: Column(
          children:[
            InkWell(
            onTap: () {globals.watchface = 1;_navigateToNextScreenhome(context);},
              child: Container(
                width: 280,
                height: 280,
                margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Screenshot 2023-01-19 at 10.10.39.png"),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(35))
                ),
                child: Image.asset('assets/Untitled-1_2.png'),
              )
            ),
            InkWell(
                onTap: () {globals.watchface = 2;_navigateToNextScreenhome(context);},
                child: Container(
                  width: 280,
                  height: 280,
                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(4, 5),
                          colors: <Color>[
                      Color(0xffFFF500),
                      Color(0xffACD500),
                            Color(0xff1c2300),
                      Color(0xffCEFF00),
                   ]
                  ),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Image.asset('assets/Untitled-1_2_2.png'),
                )
            ),
            InkWell(
                onTap: () {globals.watchface = 3;_navigateToNextScreenhome(context);},
                child: Container(
                  width: 280,
                  height: 280,
                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Screenshot 2023-01-19 at 10.09.26.png"),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Image.asset('assets/Untitled-1_2_1.png'),
                )
            ),
            InkWell(
                onTap: () {globals.watchface = 4;_navigateToNextScreenhome(context);},
                child: Container(
                  width: 280,
                  height: 280,
                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/watchface-4.png"),
                        fit: BoxFit.cover,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment(1,3),
                        colors: <Color>[
                          Color(0xff00E0D7),
                          Color(0xff004B8B),
                          Color(0xff001AA8),
                          Color(0xff016069),
                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                        tileMode: TileMode.mirror,
                      ),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Image.asset('assets/watchface-4.png'),
                )
            ),
          ],
        ),
       ),
      ),
    );
  }

  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
}

class stats extends StatefulWidget {
  const stats({Key key}) : super(key: key);

  @override
  State<stats> createState() => _statsState();
}

class _statsState extends State<stats> {

  void setup(){
    globals.Oxy_AVG = 80;
    globals.Oxy_Max = 80;
    globals.Oxy_Min = 80;

    globals.heart_AVG = 80;
    globals.heart_Max = 80;
    globals.heart_Min = 80;
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  List<FlSpot> points1 = [
    FlSpot(0, 110.0),
    FlSpot(0.5, 110.0),
    FlSpot(1, 130.0),
    FlSpot(2.5, 100.0),
    FlSpot(3, 130.0),
    FlSpot(3.5, 160.0),
    FlSpot(4, 190.0),
    FlSpot(4.5, 150.0),
    FlSpot(5, 170.0),
    FlSpot(5.5, 180.0),
    FlSpot(6, 140.0),
    FlSpot(6.5, 150.0),
    FlSpot(7, 160.0),
    FlSpot(7.5, 190.0),
    FlSpot(8, 150.0),
    FlSpot(8.5, 170.0),
    FlSpot(9, 180.0),
    FlSpot(9.5, 140.0),
    FlSpot(10, 150.0),
    FlSpot(10.5, 110.0),
    FlSpot(11, 110.0),
    FlSpot(11.5, 130.0),
    FlSpot(12, 100.0),
    FlSpot(13, 130.0),
    FlSpot(14, 160.0),
    FlSpot(15, 190.0),
    FlSpot(16, 150.0),
    FlSpot(17, 170.0),
    FlSpot(18, 180.0),
    FlSpot(19, 140.0),
    FlSpot(20, 150.0),
    FlSpot(21, 160.0),
    FlSpot(22, 190.0),
    FlSpot(23, 150.0),
    FlSpot(24, 170.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),

    body: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        //Black
        color: Color(0xff1A1A1A),
        //Green Background
        /*
        image: DecorationImage(
          image: AssetImage("assets/Screenshot 2023-01-19 at 10.06.28.png"),
          fit: BoxFit.cover,
        ),
      */
      ),
      child: SingleChildScrollView(
        child: Column(
          children:[

        Container (
          width: 400,
          height: 180,
          margin: EdgeInsets.only(left: 5.0, top: 40.0, right: 5.0),
          decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(35))
          ),

          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 28.0, top: 5, right: 5.0),
                      child: Text(
                          'ECG',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 396,
                          maxHeight: 430,
                        ),
                        child: LineChart(
                          LineChartData(
                            minY: 70,
                            lineBarsData: [
                              LineChartBarData(
                                show: true, // t
                                spots: points1.map((point) => FlSpot(point.x, point.y)).toList(),
                                isCurved: false,
                                barWidth: 1.5,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Color(0xffFF8E8E).withOpacity(0.6),
                                ),
                                dotData: FlDotData(
                                  show: false,
                                ),
                                color: Color(0xffFF8E8E),
                              ),
                            ],
                            borderData: FlBorderData(
                                border: const Border(bottom: BorderSide( color: Colors.white, width: 3), left: BorderSide(color: Colors.white))),
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(

                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 15,
                                interval: 3,
                                getTitlesWidget: (value, meta) {

                                  String text = '';
                                  switch (value.toInt()) {
                                    case 1:
                                      text = '1:00';
                                      break;
                                    case 2:
                                      text = '2:00';
                                      break;
                                    case 3:
                                      text = '3:00';
                                      break;
                                    case 4:
                                      text = '4:00';
                                      break;
                                    case 5:
                                      text = '5:00';
                                      break;
                                    case 6:
                                      text = '6:00';
                                      break;
                                    case 7:
                                      text = '7:00';
                                      break;
                                    case 8:
                                      text = '8:00';
                                      break;
                                    case 9:
                                      text = '9:00';
                                      break;
                                    case 10:
                                      text = '10:00';
                                      break;
                                    case 11:
                                      text = '11:00';
                                      break;
                                    case 12:
                                      text = '12:00';
                                      break;
                                    case 13:
                                      text = '13:00';
                                      break;
                                    case 14:
                                      text = '14:00';
                                      break;
                                    case 15:
                                      text = '15:00';
                                      break;
                                    case 16:
                                      text = '16:00';
                                      break;
                                    case 17:
                                      text = '17:00';
                                      break;
                                    case 18:
                                      text = '18:00';
                                      break;
                                    case 19:
                                      text = '19:00';
                                      break;
                                    case 20:
                                      text = '20:00';
                                      break;
                                    case 21:
                                      text = '21:00';
                                      break;
                                    case 22:
                                      text = '22:00';
                                      break;
                                    case 23:
                                      text = '23:00';
                                      break;
                                    case 24:
                                      text = '24:00';
                                      break;
                                  }
                                  return Text(text);
                                },
                              ), drawBehindEverything: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),


            ),
          ),

        ),
        Container (
          width: 400,
          height: 180,
          margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
          decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(35))
          ),

          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 28.0, top: 5, right: 5.0),
                      child: Text(
                          'Oxymeter',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 396,
                          maxHeight: 430,
                        ),
                        child: LineChart(
                          LineChartData(
                            minY: 70,
                            lineBarsData: [
                              LineChartBarData(
                                show: true, // t
                                spots: points1.map((point) => FlSpot(point.x, point.y)).toList(),
                                isCurved: false,
                                barWidth: 1.5,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Color(0xff2A3729).withOpacity(0.5),
                                ),
                                dotData: FlDotData(
                                  show: false,
                                ),
                                color: Color(0xff76D571),
                              ),
                            ],
                            borderData: FlBorderData(
                                border: const Border(bottom: BorderSide( color: Colors.white, width: 3), left: BorderSide(color: Colors.white))),
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(

                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 15,
                                interval: 3,
                                getTitlesWidget: (value, meta) {

                                  String text = '';
                                  switch (value.toInt()) {
                                    case 1:
                                      text = '1:00';
                                      break;
                                    case 2:
                                      text = '2:00';
                                      break;
                                    case 3:
                                      text = '3:00';
                                      break;
                                    case 4:
                                      text = '4:00';
                                      break;
                                    case 5:
                                      text = '5:00';
                                      break;
                                    case 6:
                                      text = '6:00';
                                      break;
                                    case 7:
                                      text = '7:00';
                                      break;
                                    case 8:
                                      text = '8:00';
                                      break;
                                    case 9:
                                      text = '9:00';
                                      break;
                                    case 10:
                                      text = '10:00';
                                      break;
                                    case 11:
                                      text = '11:00';
                                      break;
                                    case 12:
                                      text = '12:00';
                                      break;
                                    case 13:
                                      text = '13:00';
                                      break;
                                    case 14:
                                      text = '14:00';
                                      break;
                                    case 15:
                                      text = '15:00';
                                      break;
                                    case 16:
                                      text = '16:00';
                                      break;
                                    case 17:
                                      text = '17:00';
                                      break;
                                    case 18:
                                      text = '18:00';
                                      break;
                                    case 19:
                                      text = '19:00';
                                      break;
                                    case 20:
                                      text = '20:00';
                                      break;
                                    case 21:
                                      text = '21:00';
                                      break;
                                    case 22:
                                      text = '22:00';
                                      break;
                                    case 23:
                                      text = '23:00';
                                      break;
                                    case 24:
                                      text = '24:00';
                                      break;
                                  }
                                  return Text(text);
                                },
                              ), drawBehindEverything: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),


            ),
          ),

        ),
        Container (
          width: 400,
          height: 50,
          margin: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0),
          decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(35))
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 25.0, top: 0.0, right: 15.0),
                child:Text(
                  "AVG: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 15.0),
                child:Text(
                  globals.Oxy_AVG.toString() + '%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              Container(
                child:Text(
                  "Min: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 15.0),
                child:Text(
                  globals.Oxy_Min.toString() + '%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              Container(
                child:Text(
                  "Max: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 14.0),
                child:Text(
                  globals.Oxy_Max.toString() + '%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

            ],

          ),

        ),
        Container (
          width: 400,
          height: 180,
          margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
          decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(35))
          ),

          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 28.0, top: 5, right: 5.0),
                      child: Text(
                          'Heart Rate',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 396,
                          maxHeight: 430,
                        ),
                        child: LineChart(
                          LineChartData(
                            minY: 70,
                            lineBarsData: [
                              LineChartBarData(
                                show: true, // t
                                spots: points1.map((point) => FlSpot(point.x, point.y)).toList(),
                                isCurved: false,
                                barWidth: 1.5,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Color(0xff71C0F3).withOpacity(0.5),
                                ),
                                dotData: FlDotData(
                                  show: false,
                                ),
                                color: Color(0xff71C0F3),
                              ),
                            ],
                            borderData: FlBorderData(
                                border: const Border(bottom: BorderSide( color: Colors.white, width: 3), left: BorderSide(color: Colors.white))),
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(

                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 15,
                                interval: 3,
                                getTitlesWidget: (value, meta) {

                                  String text = '';
                                  switch (value.toInt()) {
                                    case 1:
                                      text = '1:00';
                                      break;
                                    case 2:
                                      text = '2:00';
                                      break;
                                    case 3:
                                      text = '3:00';
                                      break;
                                    case 4:
                                      text = '4:00';
                                      break;
                                    case 5:
                                      text = '5:00';
                                      break;
                                    case 6:
                                      text = '6:00';
                                      break;
                                    case 7:
                                      text = '7:00';
                                      break;
                                    case 8:
                                      text = '8:00';
                                      break;
                                    case 9:
                                      text = '9:00';
                                      break;
                                    case 10:
                                      text = '10:00';
                                      break;
                                    case 11:
                                      text = '11:00';
                                      break;
                                    case 12:
                                      text = '12:00';
                                      break;
                                    case 13:
                                      text = '13:00';
                                      break;
                                    case 14:
                                      text = '14:00';
                                      break;
                                    case 15:
                                      text = '15:00';
                                      break;
                                    case 16:
                                      text = '16:00';
                                      break;
                                    case 17:
                                      text = '17:00';
                                      break;
                                    case 18:
                                      text = '18:00';
                                      break;
                                    case 19:
                                      text = '19:00';
                                      break;
                                    case 20:
                                      text = '20:00';
                                      break;
                                    case 21:
                                      text = '21:00';
                                      break;
                                    case 22:
                                      text = '22:00';
                                      break;
                                    case 23:
                                      text = '23:00';
                                      break;
                                    case 24:
                                      text = '24:00';
                                      break;
                                  }
                                  return Text(text);
                                },
                              ), drawBehindEverything: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),


            ),
          ),

        ),
        Container (
          width: 400,
          height: 50,
          margin: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0),
          decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(35))
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 25.0, top: 0.0, right: 15.0),
                child:Text(
                  "AVG: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 15.0),
                child:Text(
                   globals.heart_AVG.toString() + '%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              Container(
                child:Text(
                  "Min: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 15.0),
                child:Text(
                  globals.heart_Min.toString() + '%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                child:Text(
                  "Max: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 14.0),
                child:Text(
                  globals.heart_Max.toString() + '%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

            ],

          ),

        ),
      ],
    ),
    ),
    ),
    );
  }

  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
}

class maps extends StatefulWidget {
  const maps({Key key}) : super(key: key);

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {

  final LatLng _center = const LatLng(45.521563, -122.677433);

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Screenshot 2023-01-19 at 10.06.28.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
          child: Column(

            children:[
              Container (
                width: 800,
                height: 790,
                decoration: BoxDecoration(
                    color: Color(0xff1A1A1A),
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),


                ),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 11.0,
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
}

class health extends StatefulWidget {
  const health({Key key}) : super(key: key);

  @override
  State<health> createState() => _healthState();
}

class _healthState extends State<health> {

  void setup(){
    globals.bpm = 117;
    globals.kcal = 346;
    globals.hours = 7;
    globals.minutes = 23;
    globals.past_sleep = [10, 8.12, 5.12, 6.12, 9.20, 5.8, 7.9, 7.7, 7.2, 8.3, 8.8, 5.9];
    globals.past_distance = [15000, 10000, 8000, 12300, 14200, 3400];
    globals.past_distance_month = ["Mar", "Mar", "Mar", "Mar", "Mar", "Mar"];
    globals.past_distance_day = ["14", "16", "18", "20", "22", "24"];
    globals.training_status = "Running";
    globals.steps = 6799;
  }

  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff1A1A1A),

        child: SingleChildScrollView(
          child: Column(
            children:[
              Container(
              child: Row(
                children:[
                  Container(
                    width: 182,
                    height: 190,
                    margin: EdgeInsets.only(left: 5.0,top:15),
                    decoration: BoxDecoration(
                        color: Color(0xff1A1A1A),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))

                    ),
                    child: Column(
                      children: [
                        Container(
                        child: Row(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            margin: EdgeInsets.only(top: 0.0),
                            child: Image.asset('assets/Untitled-1.png'),
                          ),
                          Container(
                              child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 0.0),
                                      child: Text(
                                          globals.bpm.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30)
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 0.0),
                                      child: Text(
                                          'Pbm',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25)
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ]
                        ),
                        ),
                        Container(
                          width: 240,
                          height: 75,
                          margin: EdgeInsets.only(right: 15.0),
                          child: Image.asset('assets/idkidk.png'),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children:[
                        Container(
                          width: 182,
                          height: 190,
                          margin: EdgeInsets.only(left: 10.0,top:15),
                          decoration: BoxDecoration(
                              color: Color(0xff1A1A1A),
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))

                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 80.0, top:5),
                                child: Text(
                                    'Sleep',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)
                                ),
                              ),
                              Container(
                                child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        child: Image.asset('assets/Untitled-4.png'),
                                      ),
                                      Container(
                                          child: Column(
                                              children: [
                                                Container(
                                                 child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 0.0, top:5),
                                                      child: Text(
                                                        globals.hours.toString(),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 30)
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 5.0, top:5),
                                                      child: Text(
                                                          'h',
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 30)
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 7.0, top:5),
                                                      child: Text(
                                                          globals.minutes.toString(),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 30)
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 5.0, top:5),
                                                      child: Text(
                                                          'm',
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 30)
                                                      ),
                                                    ),
                                                    ]),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: 60.0, top:0),
                                                  child: Text(
                                                      'Time',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20)
                                                  ),
                                                ),
                                                ])
                                      ),

                                      ]),
                              ),
                              Container(
                                  child: Row(
                                      children: [
                                        Container(
                                          child: Stack(
                                          children: [
                                            Container(
                                              height: 70,
                                              width: 10,
                                              margin: EdgeInsets.only(left: 5.0, top: 5),
                                              decoration: BoxDecoration(
                                                color: Color(0xff1A1A1A),
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: globals.past_sleep[0]*7,
                                              width: 10,
                                              margin: EdgeInsets.only(left: 5.0,top: 5),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment(0.1,5),
                                                  colors: <Color>[
                                                    Color(0xff00F0D5),
                                                    Color(0xff008BAC),
                                                    Color(0xff00FFEB),
                                                    Color(0xff008BAC),
                                                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                  tileMode: TileMode.mirror,
                                                ),
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[1]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[1]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[2]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[2]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[3]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[3]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[4]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[4]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[6]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[6]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[7]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[7]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[8]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[8]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[9]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[9]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                        Container(
                                            child: Stack(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0, top: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1A1A1A),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: globals.past_sleep[10]*7,
                                                    width: 10,
                                                    margin: EdgeInsets.only(left: 5.0,top: 5 + (70-globals.past_sleep[10]*7)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment(0.1,5),
                                                        colors: <Color>[
                                                          Color(0xff00F0D5),
                                                          Color(0xff008BAC),
                                                          Color(0xff00FFEB),
                                                          Color(0xff008BAC),
                                                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                                        tileMode: TileMode.mirror,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                      ])),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                height:10,
                width: 380,
                color: Colors.white,
              ),
              Container(
                 width: 390,
                 height: 300,
                 margin: EdgeInsets.only(top: 10.0),
                 decoration: BoxDecoration(
                 color: Color(0xff1A1A1A),
                 border: Border.all(
                 color: Colors.white,
                 ),
                 borderRadius: BorderRadius.all(Radius.circular(10))
            ),
                child: Column(
                  children:[
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Text(
                           globals.training_status.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)
                      ),
                    ),
                    InkWell(
                        child:(
                            Container(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 95, top: 20, bottom: 10),
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        gradient: SweepGradient(
                                          endAngle: 10-(globals.steps/1000) + 0.0,
                                          colors: <Color>[
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xffFFFFFF),
                                            Color(0xff00AA7C),
                                            Color(0xff8BFFED),
                                            Color(0xff00E0C6),
                                            Color(0xff00FF93),
                                            Color(0xff2effad),
                                          ],
                                        ),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 102, top: 27, bottom: 10),
                                    width: 185,
                                    height: 185,
                                    decoration: BoxDecoration(
                                        color: Color(0xff1A1A1A),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left:5, top: 70, bottom: 10),
                                      alignment: Alignment.center,
                                      child: Text(
                                          globals.steps.toString(),
                                          style: TextStyle(color: Colors.white, fontSize: 40))
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 120, left: 150),
                                    width: 90,
                                    height: 4,
                                    color:   Color(0xff00FF93),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 125, bottom: 10),
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Steps',
                                          style: TextStyle(color: Colors.grey, fontSize: 27))
                                  ),
                                ],
                              ),
                            )
                        )
                    ),
                    Container(),
                    ])
              ),
              Container(
                width: 390,
                height: 100,
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    color: Color(0xff1A1A1A),
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                    children:[
                      Container(
                          margin: EdgeInsets.only(left:5, top: 5),
                          alignment: Alignment.center,
                          child: Text(
                              globals.kcal.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 40))
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, left: 10),
                        width: 90,
                        height: 3,
                        color:   Color(0xff57FFB8),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 1, ),
                          alignment: Alignment.center,
                          child: Text(
                              'Calories Burnt',
                              style: TextStyle(color: Colors.grey, fontSize: 27))
                      ),
                    ]
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                height:10,
                width: 380,
                color: Colors.white,
              ),
              Container(
                width: 390,
                height: 300,
                margin: EdgeInsets.only(top: 10.0, bottom: 15),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Row(
                  children: [
                    Container(
                        child: Column(
                            children: [
                              Container(
                                child: Row(
                                    children: [
                                      Container(
                                          child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: 10.0, left:30),
                                                  child: Text(
                                                      'Progress:',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25)
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 2.0, right:10),
                                                  child: Text(
                                                      globals.daily_progress.toString() + '%',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 33)
                                                  ),
                                                ),
                                              ])),
                                      Container(
                                          child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: 10.0, left:75),
                                                  child: Text(
                                                      'Distance:',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25)
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 2.0, left:95),
                                                  child: Text(
                                                      globals.past_distance[5].toInt().toString() + " m",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 33)
                                                  ),
                                                ),
                                              ])),
                                    ])),
                              Container(
                                  child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height:globals.past_distance[0]/80,
                                          width: 45,
                                          margin: EdgeInsets.only(left: 40.0,top: (15000/80 - globals.past_distance[0]/80)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment(2,4),
                                              colors: <Color>[
                                                Color(0xff0EA4B1),
                                                Color(0xff11E2AA),
                                                Color(0xff00E0D7),
                                                Color(0xff0090AA),
                                                Color(0xff00D38A),
                                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                              tileMode: TileMode.mirror,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height:globals.past_distance[1]/80,
                                          width: 45,
                                          margin: EdgeInsets.only(left: 10.0,top: (15000/80 - globals.past_distance[1]/80)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment(2,4),
                                              colors: <Color>[
                                                Color(0xff0EA4B1),
                                                Color(0xff11E2AA),
                                                Color(0xff00E0D7),
                                                Color(0xff0090AA),
                                                Color(0xff00D38A),
                                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                              tileMode: TileMode.mirror,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height:globals.past_distance[2]/80,
                                          width: 45,
                                          margin: EdgeInsets.only(left: 10.0,top: (15000/80 - globals.past_distance[2]/80)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment(2,4),
                                              colors: <Color>[
                                                Color(0xff0EA4B1),
                                                Color(0xff11E2AA),
                                                Color(0xff00E0D7),
                                                Color(0xff0090AA),
                                                Color(0xff00D38A),
                                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                              tileMode: TileMode.mirror,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height:globals.past_distance[3]/80,
                                          width: 45,
                                          margin: EdgeInsets.only(left: 10.0,top: (15000/80 - globals.past_distance[3]/80)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment(2,4),
                                              colors: <Color>[
                                                Color(0xff0EA4B1),
                                                Color(0xff11E2AA),
                                                Color(0xff00E0D7),
                                                Color(0xff0090AA),
                                                Color(0xff00D38A),
                                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                              tileMode: TileMode.mirror,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height:globals.past_distance[4]/80,
                                          width: 45,
                                          margin: EdgeInsets.only(left: 10.0,top: (15000/80 - globals.past_distance[4]/80)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment(2,4),
                                              colors: <Color>[
                                                Color(0xff0EA4B1),
                                                Color(0xff11E2AA),
                                                Color(0xff00E0D7),
                                                Color(0xff0090AA),
                                                Color(0xff00D38A),
                                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                              tileMode: TileMode.mirror,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height:globals.past_distance[5]/80,
                                          width: 45,
                                          margin: EdgeInsets.only(left: 10.0, top: (15000/80 - globals.past_distance[5]/80)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment(2,4),
                                              colors: <Color>[
                                                Color(0xff0EA4B1),
                                                Color(0xff11E2AA),
                                                Color(0xff00E0D7),
                                                Color(0xff0090AA),
                                                Color(0xff00D38A),
                                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                              tileMode: TileMode.mirror,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ])),
                              Container(
                                  child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0, left:35),
                                          child: Text(
                                              globals.past_distance_day[0].toString() + " "+ globals.past_distance_month[0].toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0, left:7),
                                          child: Text(
                                              globals.past_distance_day[1].toString() + " "+ globals.past_distance_month[1].toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0, left:7),
                                          child: Text(
                                              globals.past_distance_day[2].toString() + " "+ globals.past_distance_month[2].toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0, left:7),
                                          child: Text(
                                              globals.past_distance_day[3].toString() + " "+ globals.past_distance_month[3].toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0, left:7),
                                          child: Text(
                                              globals.past_distance_day[4].toString() + " "+ globals.past_distance_month[4].toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0, left:7),
                                          child: Text(
                                              globals.past_distance_day[5].toString() + " "+ globals.past_distance_month[5].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)
                                          ),
                                        ),
                                      ])),

                            ])),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
}

class settings extends StatefulWidget {
  const settings({Key key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {

  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff1A1A1A),

        child: SingleChildScrollView(
          child: Column(
            children:[
              InkWell(
                  onTap: () {_navigateToNextSettingsGenerell(context);},
               child:(
                Stack(
                  children: [
                    Container (
        width: 320,
        height: 50,
        margin: EdgeInsets.only(left: 0.0, top: 30.0),
        padding: EdgeInsets.only(left:100, top: 6),
        decoration: BoxDecoration(
            color: Color(0xff1A1A1A),
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(35))
        ),
        child: Row(
            children:[
              Container(
                  child: Text(
                      'Generell',
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: 36.0, top: 5,),
                width: 35,
                height: 35,
                child: Image.asset('assets/arrow1.png'),
              )
            ]
        ),
      ),
             ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsWireless(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Wireless',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 36.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsSensor(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Sensor',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsInfos(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:60, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Informations',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 22.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
            ],
          ),
        ),
      ),
    );

  }
  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
  void _navigateToNextSettingsGenerell(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Generell()));
  }
  void _navigateToNextSettingsWireless(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsWireless()));
  }
  void _navigateToNextSettingsSensor(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Sensor()));
  }

  void _navigateToNextSettingsInfos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => infos()));
  }
}

class Generell extends StatefulWidget {
  const Generell({Key key}) : super(key: key);

  @override
  State<Generell> createState() => _GenerellState();
}

class _GenerellState extends State<Generell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff1A1A1A),

        child: SingleChildScrollView(
          child: Column(
            children:[
              InkWell(
                  onTap: () {_navigateToNextSettings(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width:380,
                              height: 380,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:0, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Column(
                                  children:[
                                    Container(
                                        child: Row(
                                            children:[
                                              Container(
                                                  margin: EdgeInsets.only(left: 110.0, top: 0.0),
                                                  padding: EdgeInsets.only(left:0, top: 6),
                                                  child: Text(
                                                      'Generell',
                                                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                                  )
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 30.0, top: 9,),
                                                width: 35,
                                                height: 35,
                                                child: Image.asset('assets/arrow1.png'),
                                              ),
                                            ])
                                    ),
                                    Container(
                                      child: Stack(
                                        children: [
                                          Container(
                                              child: Row(
                                                  children:[
                                                    Container (
                                                      width: 280,
                                                      height: 30,
                                                      margin: EdgeInsets.only(left: 50.0, top: 30.0),
                                                      padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xff1A1A1A),
                                                          border: Border.all(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius: BorderRadius.all(Radius.circular(35))
                                                      ),
                                                      child: Row(
                                                          children:[
                                                            Container(
                                                                child: Text(
                                                                    'Always On Display',
                                                                    style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold,)
                                                                )
                                                            ),

                                                          ]
                                                      ),
                                                    ),
                                                  ])),
                                          InkWell(
                                              onTap: () {globals.Battery_Saving_Mode =! globals.Battery_Saving_Mode;setState(() {});},
                                              child:(
                                                  Stack(
                                                      children: [
                                                        Container (
                                                          width: 75,
                                                          height: 25,
                                                          margin: EdgeInsets.only(left: 250.0, top: 32.5),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Sensor',
                                                                        style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                        if (globals.Battery_Saving_Mode == true) ...[
                                                          Container (
                                                            width: 40,
                                                            height: 20,
                                                            margin: EdgeInsets.only(left: 282.0, top: 35.0),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.greenAccent,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ] else ...[
                                                          Container (
                                                            width: 40,
                                                            height: 20,
                                                            margin: EdgeInsets.only(left: 257.0, top: 35.0),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.grey,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                      ))),
                                        ]
                                      )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'globals.battery Saving Mode',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.always_on_display =! globals.always_on_display;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.always_on_display == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Reset to Defaults',
                                                                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.reset_to_default =! globals.reset_to_default;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          Container (
                                                            width: 70,
                                                            height: 20,
                                                            margin: EdgeInsets.only(left: 253.0, top: 25.0),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.blueGrey,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  )),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Software Updates',
                                                                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.software_update =! globals.software_update;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Software Updates',
                                                                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          Container (
                                                            width: 70,
                                                            height: 20,
                                                            margin: EdgeInsets.only(left: 253.0, top: 25.0),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.blueGrey,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Software Updates',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  )),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Flush Cache',
                                                                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.flush_cache =! globals.flush_cache;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          Container (
                                                            width: 70,
                                                            height: 20,
                                                            margin: EdgeInsets.only(left: 253.0, top: 25.0),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.blueGrey,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  )),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Reset to Defaults',
                                                                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.always_on_display =! globals.always_on_display;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          Container (
                                                            width: 70,
                                                            height: 20,
                                                            margin: EdgeInsets.only(left: 253.0, top: 25.0),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.blueGrey,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  )),
                                            ]
                                        )
                                    ),

                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsWireless(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Wireless',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 36.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsSensor(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Sensor',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsInfos(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:60, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Informations',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 22.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),

            ],
          ),
        ),
      ),
    );

  }

  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
  void _navigateToNextSettingsGenerell(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Generell()));
  }
  void _navigateToNextSettingsWireless(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsWireless()));
  }
  void _navigateToNextSettingsSensor(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Sensor()));
  }
  void _navigateToNextSettingsInfos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => infos()));
  }
  void _navigateToNextSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => settings()));
  }
}

class SettingsWireless extends StatefulWidget {
  const SettingsWireless({Key key}) : super(key: key);

  @override
  State<SettingsWireless> createState() => _SettingsWirelessState();
}

class _SettingsWirelessState extends State<SettingsWireless> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff1A1A1A),

        child: SingleChildScrollView(
          child: Column(
            children:[
              InkWell(
                  onTap: () {_navigateToNextSettingsGenerell(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Generell',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettings(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width:380,
                              height: 380,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:0, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Column(
                                  children:[
                                    Container(
                                        child: Row(
                                            children:[
                                              Container(
                                                  margin: EdgeInsets.only(left: 110.0, top: 0.0),
                                                  padding: EdgeInsets.only(left:0, top: 6),
                                                  child: Text(
                                                      'Wireless',
                                                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                                  )
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 30.0, top: 9,),
                                                width: 35,
                                                height: 35,
                                                child: Image.asset('assets/arrow1.png'),
                                              ),
                                            ])
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 30.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Bluetooth 5.2',
                                                                        style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.bluetooth =! globals.bluetooth;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 32.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.bluetooth == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 35.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                              child: Row(
                                                                  children:[
                                                                    Container(
                                                                        child: Text(
                                                                            'Sensor',
                                                                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                        )
                                                                    ),

                                                                  ]
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 35.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                              child: Row(
                                                                  children:[
                                                                    Container(
                                                                        child: Text(
                                                                            'Sensor',
                                                                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                        )
                                                                    ),

                                                                  ]
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'NFC Reader/Tag',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.nfc =! globals.nfc;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.nfc == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'GPS',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.gps =! globals.gps;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.gps == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Receive Messages',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.messages =! globals.messages;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.messages == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Dissable Updates',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.disable_updates =! globals.disable_updates;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.disable_updates == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),


                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsSensor(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Sensor',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsInfos(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:60, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Informations',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 22.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),

            ],
          ),
        ),
      ),
    );

  }

  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
  void _navigateToNextSettingsGenerell(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Generell()));
  }
  void _navigateToNextSettingsWireless(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsWireless()));
  }
  void _navigateToNextSettingsSensor(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Sensor()));
  }
  void _navigateToNextSettingsInfos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => infos()));
  }
  void _navigateToNextSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => settings()));
  }
}

class Sensor extends StatefulWidget {
  const Sensor({Key key}) : super(key: key);

  @override
  State<Sensor> createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff1A1A1A),

        child: SingleChildScrollView(
          child: Column(
            children:[
              InkWell(
                  onTap: () {_navigateToNextSettingsGenerell(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Generell',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsWireless(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Wireless',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettings(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width:380,
                              height: 380,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:0, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Column(
                                  children:[
                                    Container(
                                        child: Row(
                                            children:[
                                              Container(
                                                  margin: EdgeInsets.only(left: 110.0, top: 0.0),
                                                  padding: EdgeInsets.only(left:0, top: 6),
                                                  child: Text(
                                                      'Sensors',
                                                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                                  )
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 30.0, top: 9,),
                                                width: 35,
                                                height: 35,
                                                child: Image.asset('assets/arrow1.png'),
                                              ),
                                            ])
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 30.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Oxymeter/Pulse',
                                                                        style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.Oxymeter_pulse =! globals.Oxymeter_pulse;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 32.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.Oxymeter_pulse == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 35.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                              child: Row(
                                                                  children:[
                                                                    Container(
                                                                        child: Text(
                                                                            'Sensor',
                                                                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                        )
                                                                    ),

                                                                  ]
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 35.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                              child: Row(
                                                                  children:[
                                                                    Container(
                                                                        child: Text(
                                                                            'Sensor',
                                                                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                        )
                                                                    ),

                                                                  ]
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Pressure/altitude',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.pressure_altitude =! globals.pressure_altitude;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.pressure_altitude == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'ECG',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.ECG =! globals.ECG;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.ECG == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Compass',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.compass =! globals.compass;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.compass == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),
                                    Container(
                                        child: Stack(
                                            children: [
                                              Container(
                                                  child: Row(
                                                      children:[
                                                        Container (
                                                          width: 280,
                                                          height: 30,
                                                          margin: EdgeInsets.only(left: 50.0, top: 20.0),
                                                          padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff1A1A1A),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(35))
                                                          ),
                                                          child: Row(
                                                              children:[
                                                                Container(
                                                                    child: Text(
                                                                        'Keep all on Device',
                                                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,)
                                                                    )
                                                                ),

                                                              ]
                                                          ),
                                                        ),
                                                      ])),
                                              InkWell(
                                                  onTap: () {globals.keep_all_on_device =! globals.keep_all_on_device;setState(() {});},
                                                  child:(
                                                      Stack(
                                                        children: [
                                                          Container (
                                                            width: 75,
                                                            height: 25,
                                                            margin: EdgeInsets.only(left: 250.0, top: 22.5),
                                                            padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(35))
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                      child: Text(
                                                                          'Sensor',
                                                                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
                                                                      )
                                                                  ),

                                                                ]
                                                            ),
                                                          ),
                                                          if (globals.keep_all_on_device == true) ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 282.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.greenAccent,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Container (
                                                              width: 40,
                                                              height: 20,
                                                              margin: EdgeInsets.only(left: 257.0, top: 25.0),
                                                              padding: EdgeInsets.only(left:10, top: 0, right: 100),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey,
                                                                  border: Border.all(
                                                                    color: Colors.white,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(35))
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ))),
                                            ]
                                        )
                                    ),


                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsInfos(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:60, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Informations',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 22.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),

            ],
          ),
        ),
      ),
    );

  }

  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
  void _navigateToNextSettingsGenerell(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Generell()));
  }
  void _navigateToNextSettingsWireless(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsWireless()));
  }
  void _navigateToNextSettingsSensor(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Sensor()));
  }
  void _navigateToNextSettingsInfos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => infos()));
  }
  void _navigateToNextSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => settings()));
  }
}

class infos extends StatefulWidget {
  const infos({Key key}) : super(key: key);

  @override
  State<infos> createState() => _infosState();
}

class _infosState extends State<infos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff1A1A1A),

        child: SingleChildScrollView(
          child: Column(
            children:[
              InkWell(
                  onTap: () {_navigateToNextSettingsGenerell(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Generell',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsWireless(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Wireless',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 58.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettingsSensor(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width: 320,
                              height: 50,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0),
                              padding: EdgeInsets.only(left:100, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Row(
                                  children:[
                                    Container(
                                        child: Text(
                                            'Sensors',
                                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 62.0, top: 5,),
                                      width: 35,
                                      height: 35,
                                      child: Image.asset('assets/arrow1.png'),
                                    )
                                  ]
                              ),
                            ),
                          ]))),
              InkWell(
                  onTap: () {_navigateToNextSettings(context);},
                  child:(
                      Stack(
                          children: [
                            Container (
                              width:380,
                              height: 580,
                              margin: EdgeInsets.only(left: 0.0, top: 30.0, bottom: 10),
                              padding: EdgeInsets.only(left:0, top: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xff1A1A1A),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                              child: Column(
                                  children:[
                                    Container(
                                        child: Row(
                                            children:[
                                              Container(
                                                  margin: EdgeInsets.only(left: 100.0, top: 0.0),
                                                  padding: EdgeInsets.only(left:0, top: 6),
                                                  child: Text(
                                                      'Informations',
                                                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)
                                                  )
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 30.0, top: 9,),
                                                width: 35,
                                                height: 35,
                                                child: Image.asset('assets/arrow1.png'),
                                              ),
                                            ])
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 130.0, top: 10.0),
                                        padding: EdgeInsets.only(left:0, top: 12),
                                        child: Text(
                                            'Watch: ' + globals.watch_type,
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 175.0, top: 0.0),
                                        padding: EdgeInsets.only(left:0, top: 2),
                                        child: Text(
                                            'Version: ' + globals.hardware_version.toString(),
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),

                                    Container(
                                        margin: EdgeInsets.only(right: 70.0, top: 10.0),
                                        padding: EdgeInsets.only(left:0, top: 12),
                                        child: Text(
                                            'SOC: ' + globals.soc,
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 55.0, top: 0.0),
                                        padding: EdgeInsets.only(left:0, top: 2),
                                        child: Text(
                                            'Ram: ' + globals.ram.toString(),
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 75.0, top: 0.0),
                                        padding: EdgeInsets.only(left:0, top: 2),
                                        child: Text(
                                            'Flash: ' + globals.flash.toString(),
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),

                                    Container(
                                        margin: EdgeInsets.only(right: 65.0, top: 15.0),
                                        padding: EdgeInsets.only(left:38, top: 2),
                                        child: Text(
                                            'Wireless: ' + globals.wireless.toString(),
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),

                                    Container(
                                        margin: EdgeInsets.only(right: 55.0, top: 15.0),
                                        padding: EdgeInsets.only(left: 40, top: 2),
                                        child: Text(
                                            'Sensors: ' + globals.senors.toString(),
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),

                                    Container(
                                        margin: EdgeInsets.only(right: 125.0, top: 40.0),
                                        padding: EdgeInsets.only(left:0, top: 2),
                                        child: Text(
                                            'Software: ' + globals.software_version.toString(),
                                            style: TextStyle(color: Colors.grey, fontSize: 23, fontWeight: FontWeight.bold,)
                                        )
                                    ),

                                    Container(
                                        margin: EdgeInsets.only(right: 215.0, top: 20.0),
                                        padding: EdgeInsets.only(left:0, top: 2),
                                        child: Text(
                                            globals.last_update.toString(),
                                            style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold,)
                                        )
                                    ),

                                  ]
                              ),
                            ),
                          ]))),

            ],
          ),
        ),
      ),
    );

  }
  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
  void _navigateToNextSettingsGenerell(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Generell()));
  }
  void _navigateToNextSettingsWireless(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsWireless()));
  }
  void _navigateToNextSettingsSensor(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Sensor()));
  }
  void _navigateToNextSettingsInfos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => infos()));
  }
  void _navigateToNextSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => settings()));
  }
}

class stattab extends StatefulWidget {
  const stattab({Key key}) : super(key: key);

  @override
  State<stattab> createState() => _stattabState();
}

class _stattabState extends State<stattab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {_navigateToNextScreenhome(context);},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff1A1A1A),

        child: SingleChildScrollView(
          child: Container(
            width: 450,
            height: 1550,
            margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0, bottom: 15),
            decoration: BoxDecoration(
                color: Color(0xff1A1A1A),
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(35))
            ),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0),
                 child: Row(
                   children: [
                     Container(
                       width: 180,
                       height: 150,
                       margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                       decoration: BoxDecoration(
                           color: Color(0xff1A1A1A),
                           border: Border.all(
                             color: Colors.white,
                           ),
                           borderRadius: BorderRadius.all(Radius.circular(35))
                       ),
                       child: Column(
                         children: [
                           Container(
                             margin: EdgeInsets.only(right: 5.0, top: 10),
                             child: Text(
                                 'Temperature:',
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 23)
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 90.0),
                             child: Text(
                                 globals.temperature.toString() + '°C',
                                 style: TextStyle(
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 21)
                             ),
                           ),
                           Container(
                             width: 150,
                             height: 4,
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 border: Border.all(
                                   color: Colors.white,
                                 ),
                                 borderRadius: BorderRadius.all(Radius.circular(35))
                             ),

                           ),
                           Container(
                             margin: EdgeInsets.only(right: 55.0, top: 10),
                             child: Text(
                                 'Altitude:',
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 23)
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 55.0),
                             child: Text(
                                 globals.altitude.toString() + '/absl',
                                 style: TextStyle(
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 21)
                             ),
                           ),
                         ],
                       ),
                     ),
                     Container(
                       width: 180,
                       height: 150,
                       margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                       decoration: BoxDecoration(
                           color: Color(0xff1A1A1A),
                           border: Border.all(
                             color: Colors.white,
                           ),
                           borderRadius: BorderRadius.all(Radius.circular(35))
                       ),
                       child: Column(
                         children: [
                           Container(
                             margin: EdgeInsets.only(right: 30.0, top: 10),
                             child: Text(
                                 'Heartrate:',
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 23)
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 25.0, top: 5.0, right: 90.0),
                             child: Text(
                                 globals.heartrate.toString() + 'pbm',
                                 style: TextStyle(
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 21)
                             ),
                           ),
                           Container(
                             width: 150,
                             height: 4,
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 border: Border.all(
                                   color: Colors.white,
                                 ),
                                 borderRadius: BorderRadius.all(Radius.circular(35))
                             ),

                           ),
                           Container(
                             margin: EdgeInsets.only(right: 85.0, top: 10),
                             child: Text(
                                 'Kcal:',
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 23)
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 45.0),
                             child: Text(
                                 globals.kcal.toString() + " kcal",
                                 style: TextStyle(
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 21)
                             ),
                           ),
                         ],
                       ),
                     ),
                  ]
                 )
                ),
                Container(
                    margin: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0),
                    child: Row(
                        children: [
                          Container(
                            width: 180,
                            height: 150,
                            margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                            decoration: BoxDecoration(
                                color: Color(0xff1A1A1A),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(35))
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 55.0, top: 10),
                                  child: Text(
                                      'Battery:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23)
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 90.0),
                                  child: Text(
                                      globals.battery.toString() + '%',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21)
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35))
                                  ),

                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 65.0, top: 10),
                                  child: Text(
                                      'Steps:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23)
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 65.0),
                                  child: Text(
                                      globals.steps.toString() + '',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 180,
                            height: 150,
                            margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                            decoration: BoxDecoration(
                                color: Color(0xff1A1A1A),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(35))
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 45.0, top: 10),
                                  child: Text(
                                      'Display:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23)
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 70.0),
                                  child: Text(
                                      globals.display.toString() + '%',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21)
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35))
                                  ),

                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 35.0, top: 10),
                                  child: Text(
                                      'O2Stand:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23)
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 65.0),
                                  child: Text(
                                      globals.O2stand.toString() + '%',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                    )
                ),
                Container(
                  width: 370,
                  height: 150,
                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Color(0xff1A1A1A),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5.0, top: 10, left: 10),
                                  child: Text(
                                      'Past Sleep: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)
                                  ),
                                ),
                                Container(
                                  width: 156,
                                  margin: EdgeInsets.only(left: 35.0, top: 5.0, right: 55.0, bottom: 5),
                                  child: Text(
                                      globals.past_sleep.toString(),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)
                                  ),
                                ),
                              ])
                      ),
                      Container(
                        width: 350,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(35))
                        ),

                      ),
                      Container(
                          child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5.0, top: 10, left: 10),
                                  child: Text(
                                      'Past Distance: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)
                                  ),
                                ),
                                Container(
                                  width: 146,
                                  margin: EdgeInsets.only(left: 5.0, top: 8.0, right: 55.0),
                                  child: Text(
                                      globals.past_distance.toString(),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)
                                  ),
                                ),
                              ])
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 370,
                  height: 150,
                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Color(0xff1A1A1A),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5.0, top: 10, left: 10),
                                  child: Text(
                                      'Oxygen: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)
                                  ),
                                ),
                                Container(
                                  width: 156,
                                  margin: EdgeInsets.only(left: 35.0, top: 5.0, right: 55.0, bottom: 5),
                                  child: Text(
                                      globals.past_sleep.toString(),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)
                                  ),
                                ),
                              ])
                      ),
                      Container(
                        width: 350,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(35))
                        ),

                      ),
                      Container(
                          child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5.0, top: 10, left: 10),
                                  child: Text(
                                      'ECG: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)
                                  ),
                                ),
                                Container(
                                  width: 146,
                                  margin: EdgeInsets.only(left: 65.0, top: 8.0, right: 55.0),
                                  child: Text(
                                      globals.past_distance.toString(),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)
                                  ),
                                ),
                              ])
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 370,
                  height: 450,
                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Color(0xff1A1A1A),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5.0, top: 10),
                        child: Text(
                            'BLE MESSAGE:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23)
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(35))
                        ),

                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 55.0),
                        child: Text(
                            globals.ble_string.toString(),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 21)
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 370,
                  height: 350,
                  margin: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Color(0xff1A1A1A),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5.0, top: 10),
                        child: Text(
                            'NFC Message:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23)
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(35))
                        ),

                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 55.0),
                        child: Text(
                            globals.nfc_string.toString(),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 21)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
}

















