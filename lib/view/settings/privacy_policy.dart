import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/responsive_text.dart';


class PrivacyPolices extends StatelessWidget {
  const PrivacyPolices({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(

          title: Text('Privacy Police',
            style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
              // fontSize: 18,
            ),
            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

          ),
          centerTitle: true,

        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('''Privacy Policy for (Re3ayty) Mobile Application

Effective Date: 1/1/2025
Last Updated: 1/3/2025

Thank you for using Re3ayty. Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our mobile application.

1. Information We Collect
We collect the following types of information to provide and improve our services:

a. Personal Information
- Name
- Contact information (email, phone number)
- Date of birth
- Medical history (if provided)
- GPS location (for emergency assistance)

b. Health Data
- Medication schedules
- Heart rate level
- Oxygen level
- Drug interaction data

c. Device and Usage Information
- IP address
- Device information (model, OS version)
- Log data and usage analytics

2. How We Use Your Information
We use your information to:
- Provide real-time medication reminders
- Monitor and manage your health data
- Enable remote access for authorized caregivers
- Send emergency alerts to designated contacts
- Improve and personalize user experience
- Ensure security and compliance with healthcare regulations

3. Data Sharing and Disclosure
We do not sell your personal information. We may share your data with:
- Healthcare providers or caregivers (with your consent)
- Emergency services in case of critical alerts
- Cloud storage providers for secure backup
- Legal authorities if required by law

4. Data Security
We implement industry-standard security measures, including:
- Data encryption (both in transit and at rest)
- Secure authentication (including fingerprint access)
- Restricted access to personal health data

5. User Rights and Control
You have the right to:
- Access, update, or delete your personal data
- Opt-out of non-essential notifications
- Withdraw consent for data processing

6. Third-Party Services
The app may integrate with third-party services (e.g., cloud storage, chatbot AI). These services have their own privacy policies, and we encourage users to review them.

7. Changes to This Privacy Policy
We may update this Privacy Policy from time to time. Any changes will be communicated through the app.

8. Contact Us
If you have any questions about this Privacy Policy, please contact us at:
Email: hcs.ra3ayty.team@gmail.com

By using the Re3ayty Mobile Application, you agree to the terms outlined in this Privacy Policy.
'''),
                    Container(
                      width: w * 0.8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4979FB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}
