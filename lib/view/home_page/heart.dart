import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import 'history_screen.dart';

class HealthMetricsCard extends StatefulWidget {
  Map<String, dynamic> healthMatrixData;
  HealthMetricsCard({
    required this.healthMatrixData,
  });

  @override
  State<HealthMetricsCard> createState() => _HealthMetricsCardState();
}

class _HealthMetricsCardState extends State<HealthMetricsCard> {
  DatabaseReference updatingCommandsHeart =
      FirebaseDatabase.instance.ref("commands");

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AppAuthProvider>(context);
    int avgBPM = widget.healthMatrixData['avgBPM'];
    dynamic avgSpO2 = widget.healthMatrixData['avgSpO2'];
    bool fingerPlaced = widget.healthMatrixData['fingerPlaced'];
    int liveBPM = widget.healthMatrixData['liveBPM'];
    int liveSpO2 = widget.healthMatrixData['liveSpO2'];
    int processing = widget.healthMatrixData['processing'];
    String status = widget.healthMatrixData['status'];
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    String bpmState = 'normal';
    String SpO2State = '';
    final double oxygenPercent = 98;
    final clampedPercent = oxygenPercent.clamp(0.0, 100.0);
    bool isLiveBPMworking = liveBPM != 0;
    bool isLiveSpO2working = liveBPM != 0;
    bool bothLiveWorking = isLiveBPMworking || isLiveSpO2working;
    String measureButton = '';
    String? usersGender = authProvider.databaseUser!.gender;
    DateTime? userDateOfBirth = authProvider.databaseUser!.dateOfBirth;
    int? usersAge = ((userDateOfBirth!).year) - DateTime.now().year;
    if (usersGender == 'Female') {
      if (usersAge <= 25) {
        if (liveBPM < 64) {
          bpmState = 'low';
        } else if (liveBPM > 80) {
          bpmState = 'high';
        } else {
          bpmState = 'normal';
        }
      } else if (usersAge >= 26 && usersAge <= 35) {
        {
          if (liveBPM < 64) {
            bpmState = 'low';
          } else if (liveBPM > 81) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge >= 36 && usersAge <= 45) {
        {
          if (liveBPM < 65) {
            bpmState = 'low';
          } else if (liveBPM > 82) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge >= 46 && usersAge <= 55) {
        {
          if (liveBPM < 66) {
            bpmState = 'low';
          } else if (liveBPM > 83) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge >= 56 && usersAge <= 65) {
        {
          if (liveBPM < 64) {
            bpmState = 'low';
          } else if (liveBPM > 82) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge > 65) {
        {
          if (liveBPM < 64) {
            bpmState = 'low';
          } else if (liveBPM > 81) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      }
    } else if (usersGender == 'Male') {
      if (usersAge <= 25) {
        if (liveBPM < 62) {
          bpmState = 'low';
        } else if (liveBPM > 73) {
          bpmState = 'high';
        } else {
          bpmState = 'normal';
        }
      } else if (usersAge >= 26 && usersAge <= 35) {
        {
          if (liveBPM < 62) {
            bpmState = 'low';
          } else if (liveBPM > 73) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge >= 36 && usersAge <= 45) {
        {
          if (liveBPM < 63) {
            bpmState = 'low';
          } else if (liveBPM > 75) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge >= 46 && usersAge <= 55) {
        {
          if (liveBPM < 64) {
            bpmState = 'low';
          } else if (liveBPM > 76) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge >= 56 && usersAge <= 65) {
        {
          if (liveBPM < 62) {
            bpmState = 'low';
          } else if (liveBPM > 75) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      } else if (usersAge > 65) {
        {
          if (liveBPM < 62) {
            bpmState = 'low';
          } else if (liveBPM > 73) {
            bpmState = 'high';
          } else {
            bpmState = 'normal';
          }
        }
      }
    }
    if (liveSpO2 < 95) {
      SpO2State = 'Low';
    }

    // void showMeasurementDialog(BuildContext context) {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return StatefulBuilder(
    //         builder: (context, setDialogState) {
    //           late Timer timer;
    //
    //           void startPolling() {
    //             timer = Timer.periodic(Duration(milliseconds: 300), (_) {
    //               setDialogState(() {
    //                 // Updates the dialog with the latest values
    //                 fingerPlaced = widget.healthMatrixData['fingerPlaced'];
    //                 processing = widget.healthMatrixData['processing'];
    //                 status = widget.healthMatrixData['status'];
    //               });
    //
    //               if (processing >= 100) {
    //                 Navigator.of(context).pop();
    //                 timer.cancel();// Auto close
    //               }
    //             });
    //           }
    //
    //           // Start polling after first frame
    //           WidgetsBinding.instance.addPostFrameCallback((_) {
    //             startPolling();
    //           });
    //
    //           return AlertDialog(
    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //             content: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 if (!fingerPlaced)
    //                   Text("Please place your finger", style: TextStyle(color: Colors.red)),
    //                 if (fingerPlaced && status == "Running")
    //                   Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       CircularProgressIndicator(),
    //                       // CircularProgressIndicator(
    //                       //   value: processing / 100,
    //                       //   backgroundColor: Colors.grey[200],
    //                       //   color: Colors.redAccent,
    //                       // ),
    //                       SizedBox(width: 15),
    //                       Text("loading..."),
    //                     ],
    //                   ),
    //               ],
    //             ),
    //             actions: [
    //               TextButton(
    //                 child: Text("Close"),
    //                 onPressed: () {
    //                   if (timer.isActive) timer.cancel();
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           );
    //         },
    //       );
    //     },
    //   );
    // }z
    void showMeasurementDialog(BuildContext context) {
      late Timer timer;
      bool dialogClosed = false;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              void startPolling() {
                timer = Timer.periodic(Duration(milliseconds: 300), (_) {
                  if (dialogClosed) return;

                  // Get updated values from the parent widget
                  final bool latestFinger =
                      widget.healthMatrixData['fingerPlaced'];
                  final int latestProcessing =
                      widget.healthMatrixData['processing'];
                  final String latestStatus = widget.healthMatrixData['status'];

                  if (mounted) {
                    setDialogState(() {
                      fingerPlaced = latestFinger;
                      processing = latestProcessing;
                      status = latestStatus;
                    });
                  }

                  if (latestFinger &&
                      latestStatus == "Running" &&
                      latestProcessing >= 100) {
                    if (timer.isActive) timer.cancel();
                    dialogClosed = true;
                    Navigator.of(context).pop();
                  }
                });
              }

              // Only start polling once
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!dialogClosed) startPolling();
              });

              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!fingerPlaced)
                      Text(
                        "Please place your finger",
                      ),
                    if (fingerPlaced && status == "Running")
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 15),
                          Text("loading..."),
                        ],
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text("Close"),
                    onPressed: () {
                      dialogClosed = true;
                      if (timer.isActive) timer.cancel();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
    if (!bothLiveWorking) {
      setState(() {
        measureButton = 'Measure';
      });
    } else if (!fingerPlaced) {
      setState(() {
        measureButton = 'Please place your finger';
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.4),
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
                Icon(
                  CupertinoIcons.heart,
                  color: Color(0xffE94358),
                ),
                SizedBox(width: 5),
                Text(
                  "Heart Rate",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),

            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(top: w * 0.02, bottom: w * 0.03),
              child: Center(
                child: Text(
                  "${liveBPM} Bpm",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: w * 0.03),
              child: Center(
                child: Text(
                  "You have ${bpmState} Bpm",
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.inactiveGray,
                      fontSize: 10),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
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
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: w * 0.05, bottom: w * 0.05),
              child: Center(
                child: AnimatedCircularPercent(
                  percent: liveSpO2 / 100,
                  color: Colors.blueAccent,
                  label: "Oxygen",
                  labelColor: Colors.blueAccent,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: w * 0.05),
              child: Center(
                child: Text(
                  "${SpO2State} Oxygen level",
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.inactiveGray,
                      fontSize: 10),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ),
            ),

            // Bottom Button
            Center(
              child: Container(
                width: w * 0.4,
                height: w * 0.05,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xffE5E4E3))),
                  onPressed: () async {
                    if (!bothLiveWorking) {
                      await updatingCommandsHeart.update({
                        "healthMonitor": 'START',
                      });
                      showMeasurementDialog(context);
                    }
                  },
                  child: Text(
                    'Measure'
                    // bothLiveWorking?'STOP': "Measure"
                    ,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                  },
                  child: Text(
                    'Measure Log',
                    style: GoogleFonts.getFont('Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xff98A2B3)),
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)),
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
    required this.percent,
    required this.color,
    required this.label,
    required this.labelColor,
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
          Text(
            "${(clampedPercent * 100).toInt()}%",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: labelColor,
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
