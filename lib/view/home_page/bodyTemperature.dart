// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:material_symbols_icons/material_symbols_icons.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../utils/responsive_text.dart';
//
// class BodyTemperature extends StatefulWidget {
//   Map<String, dynamic> patientTempData;
//   BodyTemperature({required this.patientTempData,});
//
//   @override
//   State<BodyTemperature> createState() => _BodyTemperatureState();
// }
//
// class _BodyTemperatureState extends State<BodyTemperature> {
//   DatabaseReference updatingCommandsHeart = FirebaseDatabase.instance.ref("commands");
//
//
//   @override
//   Widget build(BuildContext context) {
//     String bodyTempStatus=widget.patientTempData['status'];
//     dynamic temperatureC=widget.patientTempData['temperatureC'];
//     dynamic temperatureF =widget.patientTempData['temperatureF'];
//     bool istemperatureCworking= temperatureC!=0;
//     bool istemperatureFworking= temperatureF!=0;
//     bool isCTempH= false;
//     bool isCTempL= false;
//     Color ctempColor=Colors.black;
//     if (temperatureC>=36 && temperatureC<=37.5)
//     {
//       ctempColor= Colors.green;
//     }
//     else if(temperatureC<36 && temperatureC!=0 )
//     {
//       ctempColor= Colors.blue;
//       isCTempL=true;
//
//     }
//     else if(temperatureC>37.5)
//     {
//        isCTempH= true;
//       ctempColor= Colors.red;
//
//     }
//     String measureButton='Measure';
//     bool bothTemperatureWorking= istemperatureCworking|| istemperatureFworking;
//     dynamic h = MediaQuery.of(context).size.height;
//     dynamic w = MediaQuery.of(context).size.width;
//     if(bothTemperatureWorking)
//     {
//       setState(() {
//         measureButton='Stop';
//       });
//     }
//     else if(!bothTemperatureWorking)
//     {
//       setState(() {
//         measureButton='Measure';
//       });
//     }
//     return Container(
//       margin: EdgeInsets.only(top: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Color.fromRGBO(101, 193, 223, 1),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             // spreadRadius: 2,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title with icon
//             Row(
//               children: [
//                 Icon(Icons.thermostat,color: Color.fromRGBO(101, 193, 223, 1),),
//                 Text(
//                   "Body Temperature",
//                   style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
//                       fontSize: 11
//
//                   ),
//                   textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                 ),
//               ],
//             ),
//             SizedBox(height: 7),
//
//             // Contact and Call button
//
//                  Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ConstrainedBox(
//                       constraints: BoxConstraints(
//                         // maxWidth: constraints.maxWidth * 0.5,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 4),
//                             child: Row(
//                               children: [
//                                 Stack(
//                                   children:[ Padding(
//                                     padding: const EdgeInsets.only(right: 3),
//                                     child: Text(
//                                       'C',
//                                       style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
//                                           fontSize: 13,
//                                       ),
//                                       textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 3),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(1000),
//                                           border: Border.all(color: Colors.black),
//                                         ),
//                                         width: 4,
//                                         height: 4,
//                                       ),
//                                     ),
//
//                                 ],
//                                 alignment: Alignment.topRight),
//                                 Text(
//                                   ' : ',
//                                   style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
//                                       fontSize: 13,
//                                   ),
//                                   textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Text(
//                                   '${temperatureC}${isCTempH?' H':''}${isCTempL?' L':''}',
//                                   style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
//                                     fontSize: 13,color: ctempColor,
//                                   ),
//                                   textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//
//                             ),
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 4),
//                             child: Row(
//                               children: [
//                                 Stack(
//                                     children:[ Padding(
//                                       padding: const EdgeInsets.only(right: 6),
//                                       child: Text(
//                                         'F',
//                                         style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
//                                             fontSize: 13,
//                                         ),
//                                         textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 3),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(1000),
//                                             border: Border.all(color: Colors.black),
//                                           ),
//                                           width: 4,
//                                           height: 4,
//                                         ),
//                                       ),
//
//                                     ],
//                                     alignment: Alignment.topRight),
//                                 Text(
//                                   ' : ',
//                                   style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
//                                       fontSize: 13,
//                                   ),
//                                   textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Text(
//                                   '${temperatureF}${isCTempH?' H':''}${isCTempL?' L':''}',
//                                   style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
//                                     fontSize: 13,color: ctempColor,
//                                   ),
//                                   textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed:() async {
//                     if(!bothTemperatureWorking){
//                     await updatingCommandsHeart.update({
//                     "patientTemp": true,
//                     });
//                     // showMeasurementDialog(context);
//                     }
//                     else
//                     {
//                     await updatingCommandsHeart.update({
//                     "patientTemp": false,
//                     });
//                     }},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:Color(0xffE5E4E3),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         measureButton,
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/responsive_text.dart';

class BodyTemperature extends StatefulWidget {
  Map<String, dynamic> patientTempData;
  BodyTemperature({required this.patientTempData});

  @override
  State<BodyTemperature> createState() => _BodyTemperatureState();
}

class _BodyTemperatureState extends State<BodyTemperature> {
  DatabaseReference updatingCommandsHeart = FirebaseDatabase.instance.ref("commands");

  @override
  Widget build(BuildContext context) {
    String bodyTempStatus = widget.patientTempData['status'];
    dynamic temperatureC = widget.patientTempData['temperatureC'];
    dynamic temperatureF = widget.patientTempData['temperatureF'];

    bool istemperatureCworking = temperatureC != 0;
    bool istemperatureFworking = temperatureF != 0;

    bool isCTempH = false;
    bool isCTempL = false;
    Color ctempColor = Colors.black;

    if (temperatureC >= 36 && temperatureC <= 37.5) {
      ctempColor = Colors.green;
    } else if (temperatureC < 36 && temperatureC != 0) {
      ctempColor = Colors.blue;
      isCTempL = true;
    } else if (temperatureC > 37.5) {
      isCTempH = true;
      ctempColor = Colors.red;
    }

    bool bothTemperatureWorking = istemperatureCworking || istemperatureFworking;
    String measureButton = bothTemperatureWorking ? 'Stop' : 'Measure';

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
            // Title
            Row(
              children: [
                Icon(Icons.thermostat, color: Color.fromRGBO(101, 193, 223, 1)),
                Text(
                  "Body Temperature",
                  style: GoogleFonts.getFont('Poppins', fontWeight: FontWeight.w500, fontSize: 11),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),
            SizedBox(height: 7),

            // Temperature & Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Text(
                                      'C',
                                      style: GoogleFonts.getFont('Poppins', fontWeight: FontWeight.w400, fontSize: 13),
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
                              ),
                              Text(
                                ' : ',
                                style: GoogleFonts.getFont('Poppins', fontWeight: FontWeight.w400, fontSize: 13),
                                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${temperatureC}${isCTempH ? ' H' : ''}${isCTempL ? ' L' : ''}',
                                style: GoogleFonts.getFont('Poppins',
                                    fontWeight: FontWeight.w400, fontSize: 13, color: ctempColor),
                                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Text(
                                      'F',
                                      style: GoogleFonts.getFont('Poppins', fontWeight: FontWeight.w400, fontSize: 13),
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
                              ),
                              Text(
                                ' : ',
                                style: GoogleFonts.getFont('Poppins', fontWeight: FontWeight.w400, fontSize: 13),
                                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${temperatureF}${isCTempH ? ' H' : ''}${isCTempL ? ' L' : ''}',
                                style: GoogleFonts.getFont('Poppins',
                                    fontWeight: FontWeight.w400, fontSize: 13, color: ctempColor),
                                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (bodyTempStatus == 'Running') ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
                ElevatedButton(
                  onPressed: () async {
                    if (!bothTemperatureWorking) {
                      await updatingCommandsHeart.update({
                        "patientTemp": true,
                      });
                    } else {
                      await updatingCommandsHeart.update({
                        "patientTemp": false,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffE5E4E3),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    measureButton,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
