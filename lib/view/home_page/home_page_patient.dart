import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/view/settings/settings.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import 'box_status_card.dart';
import 'medication_reminder.dart';
import 'emngercy.dart';
import 'heart.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
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
                      BoxStatusCard(),
                      SizedBox(height: 10),
                      EmergencyContactCard(),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: HealthMetricsCard()),
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
