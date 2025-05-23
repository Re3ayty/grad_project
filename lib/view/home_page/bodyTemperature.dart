import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/responsive_text.dart';

class BodyTemperature extends StatefulWidget {
  Map<String, dynamic> patientTempData;
  BodyTemperature({required this.patientTempData,});

  @override
  State<BodyTemperature> createState() => _BodyTemperatureState();
}

class _BodyTemperatureState extends State<BodyTemperature> {

  @override
  Widget build(BuildContext context) {
    String bodyTempStatus=widget.patientTempData['status'];
    int temperatureC=widget.patientTempData['temperatureC'];
    int temperatureF =widget.patientTempData['temperatureF'];
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromRGBO(101, 193, 223, 1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            // spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
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
                Icon(Icons.thermostat,color: Color.fromRGBO(101, 193, 223, 1),),
                Text(
                  "Body Temperature",
                  style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                      fontSize: 11

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
                          Row(
                            children: [
                              Stack(
                                children:[ Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Text(
                                    'C',
                                    style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                                        fontSize: 15
                                    ),
                                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(1000),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      width: 4,
                                      height: 4,
                                    ),
                                  ),

                              ],
                              alignment: Alignment.topRight),
                              Text(
                                ' : ${temperatureC}',
                                style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                                    fontSize: 15
                                ),
                                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                          ),

                          Row(
                            children: [
                              Stack(
                                  children:[ Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Text(
                                      'F',
                                      style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                                          fontSize: 15
                                      ),
                                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1000),
                                          border: Border.all(color: Colors.black),
                                        ),
                                        width: 4,
                                        height: 4,
                                      ),
                                    ),

                                  ],
                                  alignment: Alignment.topRight),
                              Text(
                                ' : ${temperatureF}',
                                style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                                    fontSize: 15
                                ),
                                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xffE5E4E3),
                        padding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Measure",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
