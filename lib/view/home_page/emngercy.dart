import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/responsive_text.dart';

class EmergencyContactCard extends StatelessWidget {
  final String contactName;
  final String contactNumber;

  const EmergencyContactCard({
    Key? key,
    this.contactName = "Tarek.M (Son)",
    this.contactNumber = "+1 236658901",
  }) : super(key: key);

  void _makePhoneCall(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: contactNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the phone app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.fromRGBO(255, 215, 216, 1),
          width: 2,
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
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Icon(CupertinoIcons.bell_fill,color: Colors.red,),
                SizedBox(width: w*0.02),
                Text(
                  "Emergency Contact",
                  style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                    fontSize: 10

                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),
            SizedBox(height: 7),

            // Contact and Call button
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contactName,
                        style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                            fontSize: 9
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            contactNumber,
                            style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                                fontSize: 9,
                              color: Colors.grey[800],
                            ),

                            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _makePhoneCall(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Call",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
