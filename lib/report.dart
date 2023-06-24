//import 'dart:math';

//import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/models/Athlete.dart';
//import 'package:web_dashboard/models/set.dart';

class ReportScreen extends StatefulWidget {
  static const String id = "report_screen";
  final Athlete athlete;

  const ReportScreen({Key? key, required this.athlete}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? _date;
  String? _reps;
  String? _RPE;
  String? _load;
  String? _intensity;

  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  // String _coachEmail = "";
  // List<setExersice> _sets = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('day').get().then((snapshot) {
      print('Documents found: ${snapshot.docs.length}');
      if (snapshot.docs.isNotEmpty) {
        print('Document data: ${snapshot.docs.first.data()}');
        setState(() {
          _date = snapshot.docs.first.data()['date'];
        });
      }
    });
    FirebaseFirestore.instance.collection('sets').get().then((snapshot) {
      setState(() {
        _data = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
    // void _fetchData() async {
    //   final daySnapshot =
    //       await FirebaseFirestore.instance.collection('day').get();

    //   final dayData = daySnapshot.docs.map((doc) => doc.data()).toList();

    // final setSnapshot =
    //     await FirebaseFirestore.instance.collection('sets').get();

    // final setData = setSnapshot.docs.map((doc) => doc.data()).toList();

    // final data = dayData.asMap().entries.map((entry) {
    //   // final day = entry.value['date'];
    //   final set = setData[entry.key];

    //   return {
    //     'date': ['date'],
    //     'reps': set['reps'],
    //     'RPE': set['RPE'],
    //     'load': set['load'],
    //     'intensity': set['intensity'],
    //     //'e1RM': set['e1RM'],
    //   };
    // }).toList();

    setState(() {
      _isLoading = false;
    });
  }

  // void _fetchData() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   dynamic user;
  //   user = await _auth.currentUser;
  //   _coachEmail = user.email;

  //   await _getSets();
  //   print(_sets.length);
  //   setState(() {
  //     _isLoading = !_isLoading;
  //   });
  // }

  // Future _getSets() async {
  //   final setSnapshot =
  //       await FirebaseFirestore.instance.collection('sets').get();

  //   setSnapshot.docs.forEach((element) {
  //     setExersice temp =
  //         setExersice.fromJson(setId: element.id, setData: element.data());
  //     print(_coachEmail);

  //     if (_coachEmail == temp.athleteId) _sets.add(temp);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Report'),
        //actions: [IconButton(onPressed: () {}, icon: Icon(Icons.download))]
      ),
      body: _isLoading
          ? SpinKitWanderingCubes(
              color: Colors.cyan,
            )
          : Row(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.blue,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildTableArea(),
                        ),
                        Expanded(
                          flex: 4,
                          child: _buildGraphArea(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTableArea() {
    return Container(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          border: TableBorder(
              top: const BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.grey[300]!),
              left: BorderSide(color: Colors.grey[300]!),
              right: BorderSide(color: Colors.grey[300]!),
              // verticalInside: BorderSide(color: Colors.grey[300]!),
              horizontalInside: const BorderSide(color: Colors.grey, width: 1)),
          minWidth: 600,
          columns: [
            DataColumn(
              label: Text('Day'),
            ),
            DataColumn(
              label: Text('Reps'),
              numeric: true,
            ),
            DataColumn(
              label: Text('RPE'),
              numeric: true,
            ),
            DataColumn(
              label: Text('Load'),
              numeric: true,
            ),
            DataColumn(
              label: Text('intensity'),
              numeric: true,
            ),
            // DataColumn(
            //   label: Text('e1RM'),
            //   numeric: true,
            // ),
          ],
          rows: _data
              .map(
                (data) => DataRow(
                  cells: [
                    DataCell(Text('$_date')),
                    DataCell(Text(data['reps'])),
                    DataCell(Text(data['RPE'])),
                    DataCell(Text(data['load'])),
                    DataCell(Text(data['intensity'])),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGraphArea() {
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.deepPurple,
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.lightGreen,
                      child: Column(children: [
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(" Chart Data"),
                          color: Colors.grey[900],
                        )),
                        Expanded(
                            child: Container(
                          color: Colors.grey[900],
                        )),
                      ]),
                    )),
                Expanded(
                    child: Container(
                  // alignment: Alignment.centerLeft,
                  color: Colors.grey[900],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              //SizedBox(height: 0,),
                              Text(
                                '62kg',
                                style: TextStyle(height: 3, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Min',
                        style: TextStyle(
                            color: Colors.green, height: 0, fontSize: 15),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  color: Colors.grey[900],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              //SizedBox(height: 0,),
                              Text(
                                '75kg',
                                style: TextStyle(height: 3, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Max',
                        style: TextStyle(
                            color: Colors.green, height: 0, fontSize: 15),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  color: Colors.grey[900],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              //SizedBox(height: 0,),
                              Text(
                                '+13kg',
                                style: TextStyle(height: 3, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Change',
                        style: TextStyle(
                            color: Colors.green, height: 0, fontSize: 15),
                      )
                    ],
                  ),
                )),
              ]),
            ),
          ),
          Expanded(
              flex: 5,
              child: Container(
                color: Colors.grey[900],
                child: LineChart(mainData()),
              )),
        ],
      ),
    );
  }

  List<Color> gradientColors = [Colors.green, Colors.green];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('June 17', style: style);
        break;
      case 1:
        text = const Text('June 22', style: style);
        break;
      case 2:
        text = const Text('June 27', style: style);
        break;
      case 3:
        text = const Text('June 30', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '60Kg';
        break;
      case 20:
        text = '62Kg';
        break;
      case 30:
        text = '64Kg';
        break;
      case 40:
        text = '66Kg';
        break;
      case 50:
        text = '68Kg';
        break;
      case 60:
        text = '70kg';
        break;
      case 70:
        text = '72Kg';
        break;
      case 80:
        text = '74kg';
        break;
      case 90:
        text = '76Kg';
        break;
      case 100:
        text = '78kg';
        break;
      case 110:
        text = '80Kg';
        break;
      // case 120:
      //   text = '120k';
      //   break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 3,
      minY: 0,
      maxY: 120,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 20),
            FlSpot(0.2, 50),
            FlSpot(0.4, 75),
            FlSpot(0.6, 80),
            FlSpot(1, 63),
            FlSpot(2, 40),
            FlSpot(3, 20),
            FlSpot(4, 80),
            FlSpot(3, 30.3),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
