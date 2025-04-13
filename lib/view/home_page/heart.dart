import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../utils/responsive_text.dart';
import 'history_screen.dart';

class HealthMetricsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    String bpmState='normal';
    final double oxygenPercent = 98;
    final clampedPercent = oxygenPercent.clamp(0.0, 100.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE36E6E), // 👉 Border color
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.heart,color: Color(0xffE94358),),
                SizedBox(width: 5),
                Text("Health Metrics", style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),

            SizedBox(height: 5),
            Center(


              child: Text(
                "110 Bpm",
                style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                ),
                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
              ),
            ),

            Center(
              child: Text(
                "You have ${bpmState} Bpm",
                style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500, color: CupertinoColors.inactiveGray,
                  fontSize: 10
                ),
                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Center(
                child: Image.asset(
                  "assets/Images/heartRatePng.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),

            // Oxygen Section
            Row(
              children: [
                Icon(Icons.water_drop_outlined, color: Colors.blue),
                SizedBox(width: 5),
                Text(
                  "Oxygen Levels",
                  style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),

            Padding(
              padding:  EdgeInsets.only(top: w*0.05,bottom: w*0.05),
              child: Center(
                  child: AnimatedCircularPercent(
                    color: Colors.blueAccent,
                    label: "Oxygen",
                    labelColor: Colors.blueAccent,
                    percent: clampedPercent,
                  ),
                  ),
            ),

            // Bottom Button
            Center(
              child: Container(
                width: w*0.4,
                height: w*0.05,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffE5E4E3))),
                  onPressed: () {},
                  child: Text("Measure" ,style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                ),
              ),
            ),
            Center(
              child: TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));

              }, child: Text('Measure Log', style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xff98A2B3)
              ),
                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
              )),
            )
          ],
        ),
      ),
    );
  }
}
class AnimatedCircularPercent extends StatelessWidget {
  final Color color;
  final String label;
  final Color labelColor;
  final double percent;

  const AnimatedCircularPercent({
    required this.color,
    required this.label,
    required this.labelColor,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    final clamped = percent.clamp(0.0, 1.0);

    return CircularPercentIndicator(
        radius: w*0.09,
        lineWidth: 6.0,
        animation: true,
        animationDuration: 1000,
        percent: clamped,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${(clamped * 100).toInt()}%",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: labelColor),
            ),
          ],
        ),
        progressColor: color,
        backgroundColor: Colors.grey[300]!,
        circularStrokeCap: CircularStrokeCap.round,
      );
  }
}

