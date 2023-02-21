import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




const primaryColor = Color(0xFF151026);


void main() => runApp(MaterialApp(
  home: App(),
));

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);


  @override
  State<App> createState() => _AppState();
}



class watchfaces extends StatefulWidget {
  const watchfaces({Key? key}) : super(key: key);

  @override
  State<watchfaces> createState() => _watchfacesState();
}

class _AppState extends State<App> {

  int battery = 80;
  int O2stand = 40;
  int steps = 6560;
  int heartrate = 70;
  double display = 90;
  int kcal = 845;
  int temperature = 24;
  int altitude = 550;

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

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.home),

        ),
        title:
        Text('Airframe'),
        centerTitle: true,
        backgroundColor: Color(0xff023535),
      ),

      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Screenshot 2023-01-23 at 22.05.13.png"),
              fit: BoxFit.cover,
            ),
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
                                  width: 190,
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
                                                          '$O2stand%',
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
                                        //Steps
                                        Container(
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                                width: 130,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                    gradient: SweepGradient(
                                                      endAngle: 10-(steps/1000) + 0.0,
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
                                                      '$steps',
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
                                                              isCurved: true,
                                                              barWidth: 2,
                                                              belowBarData: BarAreaData(
                                                                show: true,
                                                                gradient: LinearGradient(
                                                                  colors: gradientColors3,
                                                                ),
                                                              ),
                                                              dotData: FlDotData(
                                                                show: false,
                                                              ),
                                                              gradient: LinearGradient(
                                                                colors: gradientColors2,
                                                              ),
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
                                              margin: EdgeInsets.only(left: 12.0, top: 20.0, right: 5.0),
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
                                                                end: Alignment(battery/20, 5),
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
                                                            '$battery%',
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
                                    InkWell(
                                      onTap: () {_navigateToNextScreen(context);},
                                    child: Container(
                                      width: 180,
                                      height: 180,
                                      margin: EdgeInsets.only(left: 15.0, top: 20.0, right: 5.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xff1A1A1A),
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35))
                                      ),
                                      child: Image.asset('assets/Untitled-1_2.png'),
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
                                              margin: EdgeInsets.only(left: 300.0, top: 75,),
                                              child: Text(
                                                  '$heartrate''pbm',
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
                                  end: Alignment(battery/20, 5),
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
                              value: display,
                              max: 100,
                              label: display.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  display = value;
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
                              width: 195,
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
                                       '$kcal' 'kcal',
                                       style: TextStyle(
                                           color: Colors.white,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 25)
                                   ),
                                 )
                               ],
                             ),
                            ),
                            Container(
                              width: 195,
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
                                        'Temperature',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23)
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 90.0),
                                    child: Text(
                                        '$temperature''°C',
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
                                        'Altitude',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23)
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 55.0),
                                    child: Text(
                                        '$altitude''/absl',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21)
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],


                        )

                    ),
                    // Last Tabs
                    Container(
                        child: Row(
                          children: [
                            Container(
                              width: 195,
                              height: 90,
                              margin: EdgeInsets.only(left: 5.0, top: 15.0, bottom:50.0),
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
                                    margin: EdgeInsets.only(left: 5.0),
                                    width: 90,
                                    height: 90,
                                    child: Image.asset('assets/nfc.png'),

                              ),
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: Image.asset('assets/gps.png'),

                                  ),
                                ]
                              ),
                            ),
                            Container(
                              width: 195,
                              height: 90,
                              margin: EdgeInsets.only(left: 5.0, top: 15.0, right: 5.0, bottom:50.0),
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
                                    margin: EdgeInsets.only(right: 32.0),
                                    width: 50,
                                    height: 50,
                                    child: Image.asset('assets/settings.png'),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                  ]
              )
          )
      ),
    );
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
          image: DecorationImage(
            image: AssetImage("assets/Screenshot 2023-01-19 at 10.06.28.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
         child: Column(

          children:[
            InkWell(
            onTap: () {},
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
                onTap: () {},
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
                onTap: () {},
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
  const stats({Key? key}) : super(key: key);

  @override
  State<stats> createState() => _statsState();
}

class _statsState extends State<stats> {
  int Oxy_AVG = 80;
  int Oxy_Max = 80;
  int Oxy_Min = 80;

  int heart_AVG = 80;
  int heart_Max = 80;
  int heart_Min = 80;

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
        image: DecorationImage(
          image: AssetImage("assets/Screenshot 2023-01-19 at 10.06.28.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
      children: [
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
                  '$Oxy_AVG%',
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
                  '$Oxy_Min%',
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
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 15.0),
                child:Text(
                  '$Oxy_Max%',
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
                  '$heart_AVG%',
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
                  '$heart_Min%',
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
                margin: EdgeInsets.only(left: 10.0, top: 0.0, right: 15.0),
                child:Text(
                  '$heart_Max%',
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
    );
  }

  void _navigateToNextScreenhome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
  }
}

class maps extends StatefulWidget {
  const maps({Key? key}) : super(key: key);

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {

  final LatLng _center = const LatLng(45.521563, -122.677433);

  late GoogleMapController mapController;

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










