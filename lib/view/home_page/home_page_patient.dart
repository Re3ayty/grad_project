import 'dart:convert';
import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/view/home_page/treatment_progress_caregiver.dart';
import 'package:hcs_grad_project/view/settings/settings.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/firbase_realtime_dao.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import '../alerts/alerts_screen.dart';
import '../filling/filling.dart';
import 'Medication_Reminder_History.dart';
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
  DatabaseReference dbCaregiverMessage = FirebaseDatabase.instance.ref().child("caregiverMessages");
  Query dbRefCaregiverMessage = FirebaseDatabase.instance.ref().child('caregiverMessages');

  // Query dbRef = FirebaseDatabase.instance.ref().child('(BOX)Hum&Temp');
  // DatabaseReference reference = FirebaseDatabase.instance.ref().child('Students');
  bool isMessageUrgent = false;
  TextEditingController caregiverMessageController = TextEditingController();
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
    Widget messageBubble({required Map caregiverMessages}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(right: 30), // leave space for delete icon
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (caregiverMessages['isUrgent'])
                        const Icon(Icons.circle, color: Colors.red, size: 12),
                      if (caregiverMessages['isUrgent']) const SizedBox(width: 6),
                      Expanded(child: Text(caregiverMessages['message'])),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(caregiverMessages['timestamp'],
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              width: 30,
              top: 10,
              child: IconButton(onPressed: () {
                dbCaregiverMessage.child(caregiverMessages['key']).remove();
              },icon:Icon(Icons.delete_outline, color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(

      floatingActionButton: authProvider.databaseUser!.patientOrCaregiver! == "Cargiver"
          ?
      FloatingActionButton(onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom, // adjust for keyboard
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quick Message',
                            style: GoogleFonts.inter(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sample messages//////////////////////////////////////////////////////////
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black),
                            ),
                            child: SizedBox(
                              height: 200, // adjust this height as needed
                              child: FirebaseAnimatedList(
                                query: dbRefCaregiverMessage,
                                defaultChild: Center(child: CircularProgressIndicator()),
                                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                                  if (snapshot.value != null && snapshot.value is Map) {
                                    Map<String, dynamic> caregiverMessage = Map<String, dynamic>.from(snapshot.value as Map);
                                    caregiverMessage['key'] = snapshot.key ?? '';
                                    return SizeTransition(
                                      sizeFactor: animation,
                                      child: messageBubble(caregiverMessages: caregiverMessage),
                                    );
                                  } else {
                                    return SizedBox(); // fallback for null/malformed data
                                  }
                                },
                              ),
                            ),
                          ),


                          //               Container(
            //                 padding: EdgeInsets.all(7),
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(12),
            //                   border: Border.all(color: Colors.black)
            //                 ),
            //                 child: Column(
            //                   children: [
            //                     FirebaseAnimatedList(
            //                       query: dbRefCaregiverMessage,
            //                       defaultChild: Center(child: CircularProgressIndicator()),
            //                       itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            //                         // Ensure data is not null and is a Map
            //                         if (snapshot.value != null && snapshot.value is Map) {
            //                           Map<String, dynamic> caregiverMessageMapForData = Map<String, dynamic>.from(snapshot.value as Map);
            //                           caregiverMessageMapForData['key'] = snapshot.key ?? '';
            //                           print('//////////////////////${caregiverMessageMapForData['isUrgent']}/////////////////////////////////////////////////////');
            //                           return SizeTransition(
            //                             sizeFactor: animation,
            //                             child: messageBubble(caregiverMessages: caregiverMessageMapForData),
            //                           );
            //                         } else {
            //                           return SizedBox(); // Or show an error placeholder
            //                         }
            //                       },
            //                     )
            //
            //                     //                     FirebaseAnimatedList(
            // // query: dbRefCaregiverMessage,
            // // itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            // //   Map caregiverMessages = snapshot.value as Map;
            // //   caregiverMessages['key'] = snapshot.key;
            // //   if (snapshot.value != null && snapshot.value is Map) {
            // //     Map caregiverMessages = Map<String, dynamic>.from(snapshot.value as Map);
            // //     caregiverMessages['key'] = snapshot.key;
            // //     return messageBubble(caregiverMessages: caregiverMessages);
            // //   } else {
            // //     return SizedBox(); // or show "Invalid data" message
            // //   }
            // //   // return messageBubble(caregiverMessages: caregiverMessages);
            // // }
            // //                     ),
            //                     // messageBubble("keep safe bby", "12:00 am", true),
            //                     // messageBubble("don’t forget to take antobiotic", "05:00 am", true),
            //                     // messageBubble("takecare!", "08:15 pm", false),
            //                   ],
            //                 ),
            //               ),
////////////////////////////////////////////////////////////////////////////////////////////
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              StatefulBuilder(
                                builder: (context, setLocalState) {
                                  return Checkbox(
                                    activeColor: Color(0xff4979FB),
                                    value: isMessageUrgent,
                                    onChanged: (value) {
                                      setState(() {
                                        isMessageUrgent = value!;
                                      });
                                      setLocalState(() {}); // update locally too
                                    },
                                  );
                                },
                              ),
                              Text("Urgent")
                            ],
                          ),

                          TextField(
                            controller: caregiverMessageController,
                            decoration: InputDecoration(
                              hintText: "Type your message",
                              suffixIcon: IconButton(onPressed: () async{
                                Map<String, dynamic> caregiverMessagesMap = {
                                  'isUrgent':isMessageUrgent,
                                  'message': caregiverMessageController.text,
                                  'sender':authProvider.databaseUser!.userName!,
                                  'timestamp': '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                                };
                                try {
                                  await dbCaregiverMessage.push().set(caregiverMessagesMap);
                                  caregiverMessageController.clear();
                                  setState(() {});
                                } catch (e) {
                                  print("Error sending message: $e");
                                }
                                // await FirebaseDatabase.instance.ref('caregiverMessages').set({
                                //   'isUrgent':isMessageUrgent,
                                //   'message': caregiverMessageController.text,
                                //   'sender':authProvider.databaseUser!.userName!,
                                //   'timestamp': '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                                // });
                              },icon:Icon(Icons.send, color: Color(0xff4979FB))),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );

        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return Dialog(
        //       insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //       child: Padding(
        //         padding: const EdgeInsets.all(16),
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text(
        //               'Quick Message',
        //               style: GoogleFonts.inter(
        //                   fontSize: 25,
        //                   fontWeight: FontWeight.w500,
        //                   color: Colors.black),
        //             ),
        //             const SizedBox(height: 20),
        //             // Sample messages
        //             Column(
        //               children: [
        //                 messageBubble("keep safe bby", "12:00 am", true),
        //                 messageBubble("don’t forget to take antobiotic", "05:00 am", true),
        //                 messageBubble("takecare!", "08:15 pm", false),
        //               ],
        //             ),
        //             const Spacer(),
        //             // Urgent checkbox with label
        //             Row(
        //               children: [
        //                 // Checkbox(
        //                 //   activeColor: Color(0xff4979FB),
        //                 //   value: isMessageUrgent,
        //                 //   onChanged: (value) {
        //                 //     setState(() {
        //                 //       isMessageUrgent = value!;
        //                 //     });
        //                 //   },
        //                 // ),
        //                 StatefulBuilder(
        //                   builder: (BuildContext context, StateSetter setState) {
        //                     return Row(
        //                       children: [
        //                         Checkbox(
        //                           activeColor: Color(0xff4979FB),
        //                           value: isMessageUrgent,
        //                           onChanged: (value) {
        //                             setState(() {
        //                               isMessageUrgent = value!;
        //                             });
        //                           },
        //                         ),
        //                         Text("Urgent"),
        //                       ],
        //                     );
        //                   },
        //                 ),
        //
        //                 Text("Argent")
        //               ],
        //             ),
        //             // Input field
        //             TextField(
        //               decoration: InputDecoration(
        //                 hintText: "Type your message",
        //                 suffixIcon: Icon(Icons.send, color: Colors.blue),
        //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // );

        // showDialog(context: context, builder: (context) =>
        //     Padding(
        //       padding: const EdgeInsets.only(left: 30,right: 30,top: 100,bottom: 100),
        //       child:
        //       Container(
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(20),
        //
        //         ),
        //         child: Column(
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.all(12),
        //               child: Text(
        //                 'Quick Message',
        //                 style: GoogleFonts.getFont('Inter',
        //                     fontSize: 25,
        //                     fontWeight: FontWeight.w500,color: Colors.black),
        //                 textScaler:
        //                 TextScaler.linear(ScaleSize.textScaleFactor(context)),
        //               ),
        //             ),
        //             Checkbox(
        //               activeColor: Color(0xff4979FB),
        //               value: isMessageUrgent,
        //               onChanged: (value) {
        //                 setState(() {
        //                   isMessageUrgent = value!;
        //                 });
        //               },
        //             ),
        //             // Text(
        //             //   "Ongoing",
        //             //   style: GoogleFonts.getFont(
        //             //     'Poppins', fontWeight: FontWeight.w500,
        //             //     // fontSize: 14,
        //             //   ),
        //             //   textScaler:
        //             //   TextScaler.linear(ScaleSize.textScaleFactor(context)),
        //             // ),
        //
        //             // Checkbox(value: value, onChanged: onChanged)
        //             // Icon(CupertinoIcons.heart)
        //           ],
        //         ),
        //       ),
        //     ),);
      },
        backgroundColor: Color(0xff4979FB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.chat,color: Colors.white,),
      ): null,
      body: SafeArea(
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
                        // '${authProvider.databaseUser!.userName!.characters.first.toUpperCase()}${authProvider.databaseUser!.userName!.substring(1)}',
                        '${(authProvider.databaseUser!.userName!.characters.first.toUpperCase())}${authProvider.databaseUser!.userName!.split(' ')[0].substring(1)}',

                        style: GoogleFonts.getFont('Poppins',
                            fontWeight: FontWeight.w500, color: Colors.grey[700]),
                        textScaler:
                            TextScaler.linear(ScaleSize.textScaleFactor(context)),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed:() => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlertsScreen(),
                      ))
                      , icon: Icon(Icons.notifications)),
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreenPage(),
                        )),
                    icon: Icon(Icons.settings, size: 30),
                  ),
                  // IconButton(
                  //   onPressed: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => (PillAnimationScreen(uid: uid!,
                  //           newMedicine: newMedicine!,)),
                  //       )),
                  //   icon: Icon(Icons.settings, size: 30),
                  // ),
      
                ],
              ),
      
              SizedBox(height: 20),
              authProvider.databaseUser!.patientOrCaregiver! == "Cargiver" ?Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8),
                child: PatientTreatmentProgress(),
              ):Text(''),
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
                                    'charging':data.charging
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
                          dynamic avgSpO2 = data['avgSpO2'] ?? 0.0;
                          bool fingerPlaced = data['fingerPlaced'] ?? false;
                          int liveBPM = data['liveBPM'] ?? 0;
                          dynamic liveSpO2= data['liveSpO2'] ?? 0;
                          int processing= data['processing'] ?? 0;
                          String status = data['status'] ?? 'Stopped';
      
                          return HealthMetricsCard(
                            healthMatrixData:{
                              'avgBPM': avgBPM,
                              'avgSpO2': avgSpO2,
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
      ),
    );
  }
}
