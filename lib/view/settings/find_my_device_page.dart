import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/dialog_utils.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import 'add_new_fingerprint.dart';

class FindMyDevice extends StatefulWidget {
  const FindMyDevice({super.key});

  @override
  State<FindMyDevice> createState() => _FindMyDeviceState();
}

class _FindMyDeviceState extends State<FindMyDevice> {
  final dbRefBatteryPercentage=
  FirebaseDatabase.instance.ref("battery/percentage");
  final updatingCommandsFindMyDevice = FirebaseDatabase.instance.ref("commands");
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AppAuthProvider>(context);
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    int? batteryLife;
    return Scaffold(
        appBar: AppBar(

          title: Text('Find My Device',
            style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
              // fontSize: 18,
            ),
            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

          ),
          centerTitle: true,

        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(

            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/Images/emergencyBox.png',width: 255,),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF4F4F4)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text('${(authProvider.databaseUser!.userName!.characters.first.toUpperCase())}${authProvider.databaseUser!.userName!.split(' ')[0].substring(1)}\'s Box'
                                  ,style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w600,fontSize: 20
                                                    // fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                              
                                                ),
                              ),
                            ),
                            Icon(CupertinoIcons.battery_25,color: Colors.green,),
                            SizedBox(
                              width: 10,
                            ),
                            StreamBuilder<DatabaseEvent>(
                              stream: dbRefBatteryPercentage.onValue,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                                  final percentage = snapshot.data!.snapshot.value.toString();
                                  batteryLife= int.parse(percentage);

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                   Text('${batteryLife}%',
                                     style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                                       // fontSize: 18,
                                     ),
                                     textAlign: TextAlign.center,
                                     textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                                   );
                                  });

                                  return Text('${batteryLife}%',
                                    style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                                      // fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,

                                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                                  );
                                } else {
                                  return const Text('No status found');
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text('Activate a sound alert to effortlessly locate your lost device. With just a tap hear your device\'s sound and reclaim it quickly.',
                              style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                              // fontSize: 14,
                            ),
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4979FB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                                await updatingCommandsFindMyDevice.update({
                                  "findMyDevice": true,
                                });
                              DialogUtils.showMessageDialog(
                              context,
                              message: 'Ringing...',
                              posActionTitle: 'Ok',
                              posAction:() async {
                                await updatingCommandsFindMyDevice.update({
                                  "findMyDevice": false,
                                });
                                Navigator.pop(context);},
                            );},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.ring_volume,color: Colors.white,),
                                SizedBox(width: 10),
                                Text(
                                  'Play Sound',
                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
