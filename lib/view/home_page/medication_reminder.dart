import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/responsive_text.dart';
import '../add_medication/add_medication_screen.dart';

class MedicationReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Container(
      height: h*0.4, // Set height as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),

          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(8), // space between image and circle border
                  decoration: BoxDecoration(
                    color: Color(0xFFD2E4F5), // background color for the circle
                    shape: BoxShape.circle,

                  ),
                  child: Icon(CupertinoIcons.bell,color: Color(0xff0658FD),)
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Medication Reminder",
                    style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                    ),
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ///todo medication history
                  },
                    icon: Icon(CupertinoIcons.arrow_up_left_arrow_down_right, color: Colors.grey,))
                
              ],
            ),

            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PillCard(icon: Icons.check, iconColor: Colors.green, name: "Roaccutane", time: "11:20 PM", timeColor: Colors.green),
                    PillCard(icon: Icons.alarm, iconColor: Colors.red, name: "Ibuprofen", time: "Missed", timeColor: Colors.red),
                    PillCard(icon: Icons.hourglass_bottom, iconColor: Colors.blue, name: "Roaccutane", time: "10:15 PM", timeColor: Colors.blue),
                    PillCard(icon: Icons.hourglass_bottom, iconColor: Colors.blue, name: "Ibuprofen", time: "03:00 AM", timeColor: Colors.blue),
                    PillCard(icon: Icons.hourglass_bottom, iconColor: Colors.blue, name: "Roaccutane", time: "09:20 AM", timeColor: Colors.blue),
                    // Add more if needed
                  ],


                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicationScreen(),)),
                  child: Text(
                  "Set a reminders",
                    style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                      color:Color.fromRGBO(165, 168, 180, 1),
                    ),
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                ),
                Icon(Icons.settings,color: Color.fromRGBO(165, 168, 180, 1) ,)
              ],
            ),

          ],
        ),

      ),
    );
  }
}

class PillCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String time;
  final Color timeColor;

  const PillCard({required this.icon, required this.iconColor, required this.name, required this.time, required this.timeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white, // background color for the circle
                shape: BoxShape.circle,),
              child: Icon(icon, color: iconColor, size: 24)),
          SizedBox(width: 12),
          Expanded(child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: timeColor)),
        ],
      ),
    );
  }
}
