import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HeartRateHistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HeartRateHistoryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HeartRateHistoryPage extends StatefulWidget {
  @override
  HeartRateHistoryPageState createState() => HeartRateHistoryPageState();
}

class HeartRateHistoryPageState extends State<HeartRateHistoryPage> with SingleTickerProviderStateMixin {
  String selectedRange = 'Week';
  late TabController _tabController;

  final Map<String, List<double>> heartRateRanges = {
    'Week': [70, 80, 100, 85, 75, 95, 97],
    'Month': [60, 65, 70, 78, 80, 82, 89, 90, 95, 100, 103, 109],
    'Year': [75, 80, 85, 90, 95],
  };

  final Map<String, List<double>> temperatureRanges = {
    'Week': [36.5, 36.7, 36.8, 37.0, 36.9, 36.6, 36.8],
    'Month': [36.4, 36.6, 36.8, 37.1, 36.9, 37.0, 36.7, 36.5, 36.8, 37.2, 36.6, 36.9],
    'Year': [36.6, 36.7, 36.8, 36.9, 37.0],
  };

  final Map<String, List<double>> oxygenRanges = {
    'Week': [95, 96, 97, 98, 99, 98, 97],
    'Month': [96, 96, 97, 98, 99, 99, 98, 97, 97, 96, 95, 96],
    'Year': [97, 98, 98, 99, 99],
  };

  final Map<String, List<String>> xLabels = {
    'Week': ['Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
    'Month': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    'Year': ['2019', '2020', '2021', '2022', '2023'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
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
                buildTab('Temperature', CupertinoIcons.thermometer, Colors.green, 1),
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
                  buildChartSection(
                    title: "Heart Rate",
                    icon: CupertinoIcons.heart,
                    iconColor: Colors.red,
                    chartData: heartRateRanges[selectedRange]!,
                    minY: 60,
                    maxY: 110,
                    yLabelSuffix: ' bpm',
                    latestValue: '${heartRateRanges[selectedRange]!.last.toInt()} BPM',
                  ),
                  buildChartSection(
                    title: "Temperature",
                    icon: CupertinoIcons.thermometer,
                    iconColor: Colors.green,
                    chartData: temperatureRanges[selectedRange]!,
                    minY: 36.0,
                    maxY: 38.0,
                    yLabelSuffix: '°C',
                    latestValue: '${temperatureRanges[selectedRange]!.last.toStringAsFixed(1)} °C',
                  ),
                  buildChartSection(
                    title: "Oxygen Level",
                    icon: CupertinoIcons.drop,
                    iconColor: Colors.blue,
                    chartData: oxygenRanges[selectedRange]!,
                    minY: 90,
                    maxY: 100,
                    yLabelSuffix: '%',
                    latestValue: '${oxygenRanges[selectedRange]!.last.toInt()}%',
                  ),
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
            Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget buildChartSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<double> chartData,
    required double minY,
    required double maxY,
    required String yLabelSuffix,
    required String latestValue,
  }) {
    final labels = xLabels[selectedRange]!;

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
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        selectedRange = value;
                      });
                    },
                    itemBuilder: (_) => ['Week', 'Month', 'Year']
                        .map((range) => PopupMenuItem(value: range, child: Text(range)))
                        .toList(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF4978F9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Text(selectedRange, style: TextStyle(color: Colors.white)),
                          Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white),
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
                    minY: minY,
                    maxY: maxY,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: ((maxY - minY) / 5),
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(
                              '${value.toStringAsFixed(1)}$yLabelSuffix',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            return (index >= 0 && index < labels.length)
                                ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(labels[index], style: TextStyle(fontSize: 10)),
                            )
                                : SizedBox.shrink();
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(chartData.length, (i) => FlSpot(i.toDouble(), chartData[i])),
                        isCurved: true,
                        barWidth: 2,
                        color: iconColor,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
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
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Spacer(),
              Text("Latest : $latestValue", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
