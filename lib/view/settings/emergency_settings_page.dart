import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/responsive_text.dart';
import 'add_new_fingerprint.dart';
import 'find_my_device_page.dart';

class EmergencySettingsPage extends StatefulWidget {
  const EmergencySettingsPage({super.key});

  @override
  State<EmergencySettingsPage> createState() => _EmergencySettingsPageState();
}

class _EmergencySettingsPageState extends State<EmergencySettingsPage> {
  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(

          title: Text('Emergency',
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
                Image.asset('assets/Images/emergencyImage.png'),

                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffF4F4F4)
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => FindMyDevice(),));
                            },
                            leading: Icon(
                              Icons.location_on_outlined,
                              color: Color(0xff4979FB),

                            ),
                            title: Text(
                              "Find My Device",
                              style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                                // fontSize: 14,
                              ),
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey.shade400),
                          ),
                          margin: EdgeInsets.all(8),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffF4F4F4)
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => AddNewFingerprint(),));
                            },
                            leading: Icon(
                              Icons.perm_contact_calendar_outlined,
                              color: Color(0xff4979FB),

                            ),
                            title: Text(
                              "Emergency Contact",
                              style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                                // fontSize: 14,
                              ),
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey.shade400),
                          ),
                          margin: EdgeInsets.all(8),
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
