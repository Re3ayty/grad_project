import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/responsive_text.dart';
import '../add_medication/add_medication_screen.dart';
import 'Medication_Reminder_History.dart';

class MedicationReminder extends StatefulWidget {
  @override
  State<MedicationReminder> createState() => _MedicationReminderState();
}

class _MedicationReminderState extends State<MedicationReminder> {
  Query QueryMedicationReminder = FirebaseDatabase.instance.ref().child('missedmed');
  DatabaseReference dbRefMedicationReminder = FirebaseDatabase.instance.ref().child('missedmed');
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationHistoryScreen(),));
                  },
                    icon: Icon(CupertinoIcons.arrow_up_left_arrow_down_right, color: Colors.grey,))

              ],
            ),

            SizedBox(height: 12),
            Expanded(
              child: StreamBuilder(
                stream: dbRefMedicationReminder.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text("No medication today"));
                  }

                  final data = (snapshot.data! as DatabaseEvent).snapshot.value as Map?;
                  if (data == null || data.isEmpty) {
                    return Center(child: Text("No medication today"));
                  }

                  // Check if there's any valid medication
                  bool hasValidMed = false;
                  data.forEach((medName, medTimes) {
                    if (medTimes is Map) {
                      for (var status in medTimes.values) {
                        final s = status.toString().toLowerCase();
                        if (s == 'acknowledged' || s == 'missed' || s == 'pending'||s == 'window') {
                          hasValidMed = true;
                          break;
                        }
                      }
                    }
                  });

                  if (!hasValidMed) {
                    return Center(child: Text("No medication today"));
                  }

                  // Render the FirebaseAnimatedList when valid meds exist
                  return FirebaseAnimatedList(
                    query: QueryMedicationReminder,
                    defaultChild: Center(child: Text('Loading...')),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      Map? medData = snapshot.value as Map?;
                      if (medData == null || medData.isEmpty) {
                        return SizedBox(); // Skip empty
                      }

                      String medName = snapshot.key ?? "Unknown";
                      List<Widget> pillCards = [];

                      medData.forEach((time, status) {
                        final statusStr = status.toString().toLowerCase();
                        if (statusStr != 'acknowledged' && statusStr != 'missed' && statusStr != 'pending'&& statusStr != 'window') return;

                        IconData icon;
                        Color iconColor;
                        Color timeColor;
                        String displayTime = time;

                        switch (statusStr) {
                          case 'window':
                            icon = Icons.alarm;
                            iconColor = Color(0xffffd83b);
                            timeColor = Color(0xffffd83b);
                            displayTime = "Now";
                            break;
                          case 'pending':
                            icon = Icons.hourglass_bottom;
                            iconColor = Colors.blue;
                            timeColor = Colors.blue;
                            break;
                          case 'missed':
                            icon = CupertinoIcons.bell_slash;
                            iconColor = Colors.red;
                            timeColor = Colors.red;
                            displayTime = "Missed $time";
                            break;
                          case 'acknowledged':
                            icon = Icons.check;
                            iconColor = Colors.green;
                            timeColor = Colors.green;
                            break;
                          default:
                            return;
                        }

                        pillCards.add(PillCard(
                          icon: icon,
                          iconColor: iconColor,
                          name: medName,
                          time: displayTime,
                          timeColor: timeColor,
                        ));
                      });

                      if (pillCards.isEmpty) {
                        return SizedBox(); // All statuses filtered out
                      }

                      return Column(children: pillCards);
                    },
                  );
                },
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
