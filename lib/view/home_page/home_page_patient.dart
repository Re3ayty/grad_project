import 'dart:convert';
import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/view/settings/settings.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/firbase_realtime_dao.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import 'bodyTemperature.dart';
import 'box_status_card.dart';
import 'medication_reminder.dart';
import 'emngercy.dart';
import 'heart.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  DatabaseReference dbRefHumAndTemp = FirebaseDatabase.instance.ref().child("(BOX)Hum&Temp");
  DatabaseReference dbRefBattery = FirebaseDatabase.instance.ref().child("battery");
  DatabaseReference dbRefBoxStatus = FirebaseDatabase.instance.ref().child("devices");
  DatabaseReference dbRefHealthMetrics = FirebaseDatabase.instance.ref().child("healthMonitor");
  DatabaseReference dbRefBodyTemperature = FirebaseDatabase.instance.ref().child("patientTemp");
  // Query dbRef = FirebaseDatabase.instance.ref().child('(BOX)Hum&Temp');
  // DatabaseReference reference = FirebaseDatabase.instance.ref().child('Students');
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    var authProvider = Provider.of<AppAuthProvider>(context);

    Uint8List? imageBytes;
    final profileBase64 = authProvider.databaseUser?.profileImageBase64;
    if (profileBase64 != null && profileBase64.isNotEmpty) {
      imageBytes = base64Decode(profileBase64);
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageBytes != null
                          ? MemoryImage(imageBytes)
                          : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getGreeting()},",
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaler:
                          TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                    Text(
                      '${authProvider.databaseUser!.userName!.characters.first.toUpperCase()}${authProvider.databaseUser!.userName!.substring(1)}',
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w500, color: Colors.grey[700]),
                      textScaler:
                          TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreenPage(),
                      )),
                  icon: Icon(Icons.settings, size: 30),
                ),
              ],
            ),

            SizedBox(height: 20),
            MedicationReminder(),
            SizedBox(height: 20),

              // Side-by-side layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [

////////////////////////////////////////// right////////////////////////////
//                     StreamBuilder<DatabaseEvent>(
//                     stream: dbRefHumAndTemp.onValue,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//                         final data = snapshot.data!.snapshot.value as Map;
//
//                         double temperature = data['temperature'] ?? 0.0;
//                         double humidity = data['humidity'] ?? 0.0;
//
//                         return StreamBuilder(
//                           stream: dbRefBattery.onValue,
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//                               final data = snapshot.data!.snapshot.value as Map;
//                               bool charging= data['charging'] ?? 0.0;
//                               int percentage= data['percentage'] ?? 0.0;
//                               double voltage= data['voltage'] ?? 0.0;
//                               return StreamBuilder(
//                                 stream: dbRefBoxStatus.onValue,
//                               builder: (context, snapshot) {
//                                   if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//                                     final data = snapshot.data!.snapshot.value as Map;
//                                     String status = data['status'];
//                                     return BoxStatusCard(HumAndTempAndBattery: {
//                                       'status': status,
//                                       'temperature':temperature,
//                                       'humidity': humidity,
//                                       'percentage':percentage,
//                                 });
//                                 } else if (snapshot.hasError) {
//                                 return Text("Error: ${snapshot.error}");
//                                 } else {
//                                 return CircularProgressIndicator();
//                                 }
//                               },
//                               );
//                             } else if (snapshot.hasError) {
//                               return Text("Error: ${snapshot.error}");
//                             } else {
//                               return CircularProgressIndicator();
//                             }
//                             },
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text("Error: ${snapshot.error}");
//                       } else {
//                         return CircularProgressIndicator();
//                       }
//                     },
//                   ),
////////////////////////////////////////////////////////////////////////////////////
                        StreamBuilder<DashboardData>(
                          stream: getCombinedDashboardStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              return BoxStatusCard(
                                boxStatusData: {
                                  'temperature': data.temperature,
                                  'humidity': data.humidity,
                                  'percentage': data.batteryPercentage,
                                  'status': data.status,
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),


                        //////////////////////////////////
                        StreamBuilder<DatabaseEvent>(
                          stream: dbRefBodyTemperature.onValue,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              final data = snapshot.data!.snapshot.value as Map;
                              String status = data['status'] ?? 'Stopped';
                              dynamic temperatureC = data['temperatureC'] ?? 0.0;
                              dynamic temperatureF = data['temperatureF'] ?? 0.0;
                              return BodyTemperature(
                                patientTempData:{
                                'status':status,
                                  'temperatureC':temperatureC,
                                  'temperatureF':temperatureF
                              },);
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),


                        EmergencyContactCard(),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child:
                      StreamBuilder<DatabaseEvent>(
                    stream: dbRefHealthMetrics.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                        final data = snapshot.data!.snapshot.value as Map;
                        int avgBPM = data['avgBPM'] ?? 0;
                        // int avgSpO2 = data['avgSpO2'] ?? 0.0;
                        bool fingerPlaced = data['fingerPlaced'] ?? false;
                        int liveBPM = data['liveBPM'] ?? 0;
                        int liveSpO2= data['liveSpO2'] ?? 0;
                        int processing= data['processing'] ?? 0;
                        String status = data['status'] ?? 'Stopped';

                        return HealthMetricsCard(
                          healthMatrixData:{
                            'avgBPM': avgBPM,
                            // 'avgSpO2': avgSpO2,
                            'fingerPlaced': fingerPlaced,
                            'liveBPM': liveBPM,
                            'liveSpO2': liveSpO2,
                            'processing': processing,
                            'status': status,
                        },
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  ),
                ],
              ),

            SizedBox(height: 20),
          ],
        ),
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.blueAccent,
      //   unselectedItemColor: Colors.grey,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home" ),
      //     BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medication"),
      //     BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Assistant"),
      //   ],
      // ),
    );
  }
}
