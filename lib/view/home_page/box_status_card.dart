import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../utils/responsive_text.dart';

class BoxStatusCard extends StatelessWidget {
  String status='online';
  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromRGBO(101, 193, 223, 1), // Custom border color
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
                    color: Color.fromRGBO(101, 193, 223, 1)),
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
                Text("Connection : ${status}", style:GoogleFonts.getFont('Poppins',
                  fontSize: 12,
                ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: w*0.009,
                )
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text("Temperature : 25°C",style:GoogleFonts.getFont('Poppins',
                  // fontSize: w*0.033,
                  fontSize: 12,

                ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: Colors.green,
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
                    color: Color.fromRGBO(83, 215, 105, 1),
                    label: "Humidity",
                    labelColor: Color.fromRGBO(83, 215, 105, 1),
                  ),
                ),
                SizedBox(width: 5),
                Flexible(
                  child: AnimatedCircularPercent(
                    color: Color.fromRGBO(101, 193, 223, 1),
                    label: "Battery",
                    labelColor: Color.fromRGBO(101, 193, 223, 1),
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

class AnimatedCircularPercent extends StatefulWidget {

  final Color color;
  final String label;
  final Color labelColor;

  const AnimatedCircularPercent({
    required this.color,
    required this.label,
    required this.labelColor,
  });

  @override
  _AnimatedCircularPercentState createState() =>
      _AnimatedCircularPercentState();
}

class _AnimatedCircularPercentState extends State<AnimatedCircularPercent> {
  double percent = 0.5;

  @override
  void initState() {
    super.initState();
    updatePercent();
  }

  void updatePercent() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        percent = 0.3 + Random().nextDouble() * 0.6; // Randomize for demo
      });
      updatePercent(); // Repeat
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    final clampedPercent = percent.clamp(0.0, 1.0);

    return CircularPercentIndicator(
      radius: w*0.09,
      lineWidth: 6.0,
      animation: true,
      animationDuration: 1000,
      percent: clampedPercent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(clampedPercent * 100).toInt()}%",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 10,
              color: widget.labelColor,
            ),
          ),
        ],
      ),
      progressColor: widget.color,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
