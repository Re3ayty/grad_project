import 'dart:math';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../utils/responsive_text.dart';

class BoxStatusCard extends StatefulWidget {
  Map<String, dynamic> boxStatusData;
  BoxStatusCard({required this.boxStatusData,});
  @override
  State<BoxStatusCard> createState() => _BoxStatusCardState();
}

class _BoxStatusCardState extends State<BoxStatusCard> {


  @override
  Widget build(BuildContext context) {
    double temp = widget.boxStatusData['temperature'];
    double hum = widget.boxStatusData['humidity'];
    int batteryLevel=widget.boxStatusData['percentage'];
    String boxStatus=widget.boxStatusData['status'];
    bool isBoxCharging=widget.boxStatusData['charging'];
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    bool highTemp= temp>=30;
    Color boxTempColor= highTemp? Colors.red: Colors.green;
    bool boxStatusOnline= boxStatus=='online';
    Color boxStatusColor= boxStatusOnline? Colors.green: Colors.red;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green, // Custom border color
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services_outlined,
                    color: Colors.green),
                SizedBox(width: w*0.02),
                Text(
                  "Box Status",
                  style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                    // fontSize: w*0.04,
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Connection : ${boxStatus}", style:GoogleFonts.getFont('Poppins',
                  fontSize: 11,
                ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: boxStatusColor,
                  radius: w*0.009,
                )
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text("Temperature : ${temp.toStringAsFixed(1)}°C",style:GoogleFonts.getFont('Poppins',
                  // fontSize: w*0.033,
                  fontSize: 11,

                ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: boxTempColor,
                  radius: w*0.009,
                )
              ],
            ),
            SizedBox(height: w*0.06),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: AnimatedCircularPercent(
                    percent: (hum ?? 0) / 100,
                    color: Color.fromRGBO(83, 215, 105, 1),
                    label: "Humidity",
                    labelColor: Color.fromRGBO(83, 215, 105, 1),
                    isBoxCharging: false,
                  ),
                ),
                SizedBox(width: 5),
                Flexible(
                  child: AnimatedCircularPercent(
                    percent: (batteryLevel ?? 0) / 100,
                    color: Color.fromRGBO(101, 193, 223, 1),
                    label: "Battery",
                    labelColor: Color.fromRGBO(101, 193, 223, 1),
                    isBoxCharging: isBoxCharging,
                  ),
                ),
              ],
            ),
            SizedBox(height: w*0.04),
          ],
        ),
      ),
    );
  }
}

// class AnimatedCircularPercent extends StatefulWidget {
//
//   final Color color;
//   final String label;
//   final Color labelColor;
//
//   const AnimatedCircularPercent({
//     required this.color,
//     required this.label,
//     required this.labelColor,
//   });
//
//   @override
//   _AnimatedCircularPercentState createState() =>
//       _AnimatedCircularPercentState();
// }
//
// class _AnimatedCircularPercentState extends State<AnimatedCircularPercent> {
//   double percent = 0.5;
//
//   @override
//   void initState() {
//     super.initState();
//     updatePercent();
//   }
//
//   void updatePercent() {
//     Future.delayed(Duration(seconds: 3), () {
//       setState(() {
//         percent = 0.3 + Random().nextDouble() * 0.6; // Randomize for demo
//       });
//       updatePercent(); // Repeat
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     dynamic h = MediaQuery.of(context).size.height;
//     dynamic w = MediaQuery.of(context).size.width;
//     final clampedPercent = percent.clamp(0.0, 1.0);
//
//     return CircularPercentIndicator(
//       radius: w*0.09,
//       lineWidth: 6.0,
//       animation: true,
//       animationDuration: 1000,
//       percent: clampedPercent,
//       center: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "${(clampedPercent * 100).toInt()}%",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: widget.color,
//             ),
//           ),
//           Text(
//             widget.label,
//             style: TextStyle(
//               fontSize: 10,
//               color: widget.labelColor,
//             ),
//           ),
//         ],
//       ),
//       progressColor: widget.color,
//       backgroundColor: Colors.grey[300]!,
//       circularStrokeCap: CircularStrokeCap.round,
//     );
//   }
// }


class AnimatedCircularPercent extends StatelessWidget {
  final Color color;
  final String label;
  final Color labelColor;
  final double percent;
  final bool isBoxCharging;

  const AnimatedCircularPercent({
    required this.percent,
    required this.color,
    required this.label,
    required this.labelColor,
    required this.isBoxCharging,
  });

  @override
  Widget build(BuildContext context) {
    dynamic w = MediaQuery.of(context).size.width;
    final clampedPercent = percent.clamp(0.0, 1.0);

    return CircularPercentIndicator(
      radius: w * 0.09,
      lineWidth: 6.0,
      animation: true,
      animationDuration: 1000,
      percent: clampedPercent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(clampedPercent * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (isBoxCharging) ...[
                SizedBox(width: 4),
                Icon(CupertinoIcons.battery_charging, size: 14, color: Colors.green),
              ],
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '${isBoxCharging ? 'Charging':'${label}'}',
              style: TextStyle(
                fontSize: 10,
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
      progressColor: color,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
