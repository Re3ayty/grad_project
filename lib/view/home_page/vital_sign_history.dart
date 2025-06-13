import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcs_grad_project/model/body_temp_readings.dart';
import 'package:hcs_grad_project/model/heart_rate_readings.dart';
import 'package:hcs_grad_project/viewModel/firbase_realtime_dao.dart';
import 'package:hcs_grad_project/viewModel/provider/app_auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HeartRateHistoryPage extends StatefulWidget {
  @override
  HeartRateHistoryPageState createState() => HeartRateHistoryPageState();
}

class HeartRateHistoryPageState extends State<HeartRateHistoryPage>
    with SingleTickerProviderStateMixin {
  String selectedRange = 'Week';
  late TabController _tabController;
  final Map<String, List<double>> heartRateRanges = {
    'Week': [70, 80, 100, 85, 75, 95, 97],
    'Month': [60, 65, 70, 78, 80, 82, 89, 90, 95, 100, 103, 109],
    'Year': [75, 80, 85, 90, 95],
  };

  final Map<String, List<double>> temperatureRanges = {
    'Week': [36.5, 36.7, 36.8, 37.0, 36.9, 36.6, 36.8],
    'Month': [
      36.4,
      36.6,
      36.8,
      37.1,
      36.9,
      37.0,
      36.7,
      36.5,
      36.8,
      37.2,
      36.6,
      36.9
    ],
    'Year': [36.6, 36.7, 36.8, 36.9, 37.0],
  };

  final Map<String, List<double>> oxygenRanges = {
    'Week': [95, 96, 97, 98, 99, 98, 97],
    'Month': [96, 96, 97, 98, 99, 99, 98, 97, 97, 96, 95, 96],
    'Year': [97, 98, 98, 99, 99],
  };

  final Map<String, List<String>> xLabels = {
    'Week': ['Sun', 'Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat'],
    'Month': [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ],
    'Year': ['2025', '2026', '2027', '2028', '2029'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AppAuthProvider>(context, listen: false)
            .firebaseAuthUser
            ?.uid ??
        '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('History', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Custom Toggle TabBar
            Row(
              children: [
                buildTab('Heart Rate', CupertinoIcons.heart, Colors.red, 0),
                SizedBox(width: 6),
                buildTab(
                    'Temperature', CupertinoIcons.thermometer, Colors.green, 1),
                SizedBox(width: 6),
                buildTab('Oxygen Level', CupertinoIcons.drop, Colors.blue, 2),
              ],
            ),
            SizedBox(height: 20),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FutureBuilder<List<HeartRateData>>(
                      future: MedicationBoxDao.getHeartRateHistory(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading data'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No data'));
                        }
                        final data = snapshot.data!;
                        data.sort(
                            (a, b) => a.lastUpdated!.compareTo(b.lastUpdated!));

                        // week start and end dates
                        final latest = data.last.lastUpdated!;
                        int daysFromSunday = latest.weekday % 7;
                        final weekStart =
                            latest.subtract(Duration(days: daysFromSunday));
                        final weekEnd = weekStart.add(Duration(days: 6));
                        final weekData = data.where((d) {
                          final date = d.lastUpdated!;
                          return !date.isBefore(weekStart) &&
                              !date.isAfter(weekEnd);
                        }).toList();
                        // Map to hold readings for each day of the week
                        Map<int, HeartRateData?> dayToReading = {
                          for (var i = 0; i < 7; i++) i: null
                        };
                        for (var reading in weekData) {
                          int dayIndex = reading.lastUpdated!.weekday % 7;
                          if (dayToReading[dayIndex] == null ||
                              reading.lastUpdated!.isAfter(
                                  dayToReading[dayIndex]!.lastUpdated!)) {
                            dayToReading[dayIndex] = reading;
                          }
                        }

                        // Filter data for the selected range
                        final spots = List.generate(7, (i) {
                          final reading = dayToReading[i];
                          final value = reading?.avgBPM ?? 0.0;
                          return value != null && value >= 60
                              ? FlSpot(i.toDouble(), value.toDouble())
                              : FlSpot(i.toDouble(), double.nan);
                        });

                        final labels = [
                          'Sun',
                          'Mon',
                          'Tues',
                          'Wed',
                          'Thur',
                          'Fri',
                          'Sat'
                        ];

                        return buildChartSection(
                          title: "Heart Rate",
                          icon: CupertinoIcons.heart,
                          iconColor: Colors.red,
                          chartSpots: spots,
                          xLabels: labels,
                          minY: 60,
                          maxY: 160,
                          yLabelSuffix: ' bpm',
                          latestValue: '${data.last.avgBPM} BPM',
                        );
                      }),
                  FutureBuilder<List<BodyTempReadings>>(
                      future: BodyTempDao.getBodyTempData(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading data'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No data'));
                        }
                        final data = snapshot.data!;
                        data.sort(
                            (a, b) => a.lastUpdated!.compareTo(b.lastUpdated!));
                        // week start and end dates
                        final latest = data.last.lastUpdated!;
                        int daysFromSunday = latest.weekday % 7;
                        final weekStart =
                            latest.subtract(Duration(days: daysFromSunday));
                        final weekEnd = weekStart.add(Duration(days: 6));
                        final weekData = data.where((d) {
                          final date = d.lastUpdated!;
                          return !date.isBefore(weekStart) &&
                              !date.isAfter(weekEnd);
                        }).toList();
                        // Map to hold readings for each day of the week
                        Map<int, BodyTempReadings?> dayToReading = {
                          for (var i = 0; i < 7; i++) i: null
                        };
                        for (var reading in weekData) {
                          int dayIndex = reading.lastUpdated!.weekday % 7;
                          if (dayToReading[dayIndex] == null ||
                              reading.lastUpdated!.isAfter(
                                  dayToReading[dayIndex]!.lastUpdated!)) {
                            dayToReading[dayIndex] = reading;
                          }
                        }

                        // Filter data for the selected range
                        // Filter data for the selected range
                        final spots = List.generate(7, (i) {
                          final reading = dayToReading[i];
                          final value = reading?.bodyTempC ?? 0.0;
                          return value != null && value >= 36.0
                              ? FlSpot(i.toDouble(), value.toDouble())
                              : FlSpot(i.toDouble(), double.nan);
                        });
                        final labels = [
                          'Sun',
                          'Mon',
                          'Tues',
                          'Wed',
                          'Thur',
                          'Fri',
                          'Sat'
                        ];
                        return buildChartSection(
                          title: "Body Temperature",
                          icon: CupertinoIcons.thermometer,
                          iconColor: Colors.green,
                          chartSpots: spots,
                          xLabels: labels,
                          minY: 36.0,
                          maxY: 45.0,
                          yLabelSuffix: '°C',
                          latestValue: '${data.last.bodyTempC}°C',
                        );
                      }),
                  FutureBuilder<List<HeartRateData>>(
                      future: MedicationBoxDao.getSpO2List(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading data'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No data'));
                        }
                        final data = snapshot.data!;
                        data.sort(
                            (a, b) => a.lastUpdated!.compareTo(b.lastUpdated!));
                        // week start and end dates
                        final latest = data.last.lastUpdated!;
                        int daysFromSunday = latest.weekday % 7;
                        final weekStart =
                            latest.subtract(Duration(days: daysFromSunday));
                        final weekEnd = weekStart.add(Duration(days: 6));
                        final weekData = data.where((d) {
                          final date = d.lastUpdated!;
                          return !date.isBefore(weekStart) &&
                              !date.isAfter(weekEnd);
                        }).toList();
                        // Map to hold readings for each day of the week
                        Map<int, HeartRateData?> dayToReading = {
                          for (var i = 0; i < 7; i++) i: null
                        };
                        for (var reading in weekData) {
                          int dayIndex = reading.lastUpdated!.weekday % 7;
                          if (dayToReading[dayIndex] == null ||
                              reading.lastUpdated!.isAfter(
                                  dayToReading[dayIndex]!.lastUpdated!)) {
                            dayToReading[dayIndex] = reading;
                          }
                        }

                        // Filter data for the selected range
                        // Filter data for the selected range
                        final spots = List.generate(7, (i) {
                          final reading = dayToReading[i];
                          final value = reading?.avgSpO2 ?? 0.0;
                          return value != null && value >= 90
                              ? FlSpot(i.toDouble(), value.toDouble())
                              : FlSpot(i.toDouble(), double.nan);
                        });
                        final labels = [
                          'Sun',
                          'Mon',
                          'Tues',
                          'Wed',
                          'Thur',
                          'Fri',
                          'Sat'
                        ];

                        return buildChartSection(
                          title: "Oxygen Level",
                          icon: CupertinoIcons.drop,
                          iconColor: Colors.blue,
                          chartSpots: spots,
                          xLabels: labels,
                          minY: 90.0,
                          maxY: 100.0,
                          yLabelSuffix: '%',
                          latestValue: '${data.last.avgSpO2}%',
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTab(String text, IconData icon, Color iconColor, int index) {
    final bool selected = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Color(0xFFC0D0FB) : Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            SizedBox(width: 5),
            Text(text,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget buildChartSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<FlSpot> chartSpots,
    required List<String> xLabels,
    required double minY,
    required double maxY,
    required String yLabelSuffix,
    required String latestValue,
  }) {
    //connect shown points
    List<List<FlSpot>> segments = [];
    List<FlSpot> current = [];
    for (var spot in chartSpots) {
      if (!spot.y.isNaN) {
        current.add(spot);
      } else if (current.isNotEmpty) {
        segments.add(List.from(current));
        current.clear();
      }
    }
    if (current.isNotEmpty) segments.add(current);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(icon, color: iconColor),
                    SizedBox(width: 8),
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        selectedRange = value;
                      });
                    },
                    itemBuilder: (_) => ['Week', 'Month', 'Year']
                        .map((range) =>
                            PopupMenuItem(value: range, child: Text(range)))
                        .toList(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF4978F9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Text(selectedRange,
                              style: TextStyle(color: Colors.white)),
                          Icon(Icons.keyboard_arrow_down_sharp,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.5,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 6,
                    minY: minY,
                    maxY: maxY,
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: true, reservedSize: 40)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < xLabels.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(xLabels[index],
                                    style: const TextStyle(fontSize: 10)),
                              );
                            }
                            return SizedBox.shrink();
                          },
                          interval: 1,
                        ),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: segments
                        .map(
                          (segment) => LineChartBarData(
                            spots: segment,
                            isCurved: false,
                            barWidth: 2,
                            color: iconColor,
                            dotData: FlDotData(
                              show: true,
                              checkToShowDot: (spot, barData) {
                                // Only show dot if value is >= minY
                                return spot.y >= minY;
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: 10),
              Text(title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Spacer(),
              Text("Latest : $latestValue",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
