import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_routes_new.dart';
import 'caregiver_role.dart';

class RoleSection extends StatelessWidget {
  const RoleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.05),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.rocket, color: Colors.blue),
                  CircularProgressIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.grey[300],
                    value: 0.50,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding:EdgeInsets.only(bottom:screenHeight*0.156,left: screenWidth*0.03),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Role Section",
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.003),
                        Text(
                          "Determine whether you are a patient, caregiver, or both.",
                          style: TextStyle(
                            fontSize: screenWidth * 0.044,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
          
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.only(top: screenHeight * 0.008),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),),),
                              onPressed: () {
                                Navigator.pushNamed(context,AppRoutes.patientRole);
                                },
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "I’m a Patient",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.015),
                                        Text(
                                          "Manage your health, medication schedules.",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.036,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.orange[100],
                                      child: Icon(
                                        Icons.medical_services_outlined,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          
                  Padding(
                    padding:EdgeInsets.only(top: screenHeight*0.03),
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.only(top: screenHeight * 0.008),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context,AppRoutes.caregiverRole);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "I’m a Caregiver",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.015),
                                          Text(
                                            "Monitor loved ones, real-time updates.",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.036,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.blue[100],
                                        child: Icon(
                                          Icons.handshake_outlined,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
          
                        ],
                      ),
                    ),
                  )
                ]
            ),
          ),
        )
    );
  }
}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hcs_grad_project/view/role_selection/patient_role.dart';
// import '../../utils/app_routes_new.dart';
// import 'caregiver_role.dart';
//
// class RoleSection extends StatelessWidget {
//   const RoleSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         // actionsPadding: EdgeInsets.only(right: screenWidth * 0.05),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: screenWidth * 0.05),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Icon(Icons.rocket, color: Colors.blue),
//                 CircularProgressIndicator(
//                   color: Colors.blue,
//                   backgroundColor: Colors.grey[300],
//                   value: 0.50,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(screenWidth * 0.03),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Role Section",
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.08,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.003),
//                 Text(
//                   "Determine whether you are a patient, caregiver, or both.",
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.044,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Expanded(
//             child: Center(
//               child:Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(screenWidth * 0.03),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blue, width: 0.5),
//                         borderRadius: BorderRadius.circular(6),),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           padding: EdgeInsets.only(top: screenHeight * 0.008),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: () {
//                           Navigator.pushNamed(context,AppRoutes.patientRole);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.all(screenWidth * 0.03),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "I’m a Patient",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.05,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.015),
//                                   Text(
//                                     "Manage your health, medication schedules.",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.036,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               CircleAvatar(
//                                 backgroundColor: Colors.orange[100],
//                                 child: Icon(
//                                   Icons.medical_services_outlined,
//                                   color: Colors.orange,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   Padding(
//                     padding: EdgeInsets.all(screenWidth * 0.03),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.blue, width: 0.5),
//                           borderRadius: BorderRadius.circular(6)),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           padding: EdgeInsets.only(top: screenHeight * 0.008),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: () {
//                           Navigator.pushNamed(context,AppRoutes.caregiverRole);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.all(screenWidth * 0.03),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "I’m a Caregiver",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.05,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.015),
//                                   Text(
//                                     "Monitor loved ones, real-time updates.",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.036,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               CircleAvatar(
//                                 backgroundColor: Colors.blue[100],
//                                 child: Icon(
//                                   Icons.handshake_outlined,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ) ,
//             ),
//           ),
//           ////////////////////////////////////////////////////////////////////
//           // SizedBox(height: screenHeight * 0.06),
//           // Padding(
//           //   padding: EdgeInsets.all(screenWidth * 0.03),
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //       border: Border.all(color: Colors.blue, width: 0.5),
//           //       borderRadius: BorderRadius.circular(6),),
//           //     child: ElevatedButton(
//           //       style: ElevatedButton.styleFrom(
//           //         backgroundColor: Colors.white,
//           //         padding: EdgeInsets.only(top: screenHeight * 0.008),
//           //         shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(10),
//           //         ),
//           //       ),
//           //       onPressed: () {
//           //         Navigator.push(context, MaterialPageRoute(builder: (context) => PatientRole(),));
//           //       },
//           //       child: Padding(
//           //         padding: EdgeInsets.all(screenWidth * 0.03),
//           //         child: Row(
//           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             Column(
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 Text(
//           //                   "I’m a Patient",
//           //                   style: TextStyle(
//           //                     fontSize: screenWidth * 0.05,
//           //                     fontWeight: FontWeight.bold,
//           //                     color: Colors.black,
//           //                   ),
//           //                 ),
//           //                 SizedBox(height: screenHeight * 0.015),
//           //                 Text(
//           //                   "Manage your health, medication schedules.",
//           //                   style: TextStyle(
//           //                     fontSize: screenWidth * 0.036,
//           //                     color: Colors.grey,
//           //                   ),
//           //                 ),
//           //               ],
//           //             ),
//           //             CircleAvatar(
//           //               backgroundColor: Colors.orange[100],
//           //               child: Icon(
//           //                 Icons.medical_services_outlined,
//           //                 color: Colors.orange,
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // // ),
//           //
//           // SizedBox(height: screenHeight * 0.02),
//           // Padding(
//           //   padding: EdgeInsets.all(screenWidth * 0.03),
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //         border: Border.all(color: Colors.blue, width: 0.5),
//           //         borderRadius: BorderRadius.circular(6)),
//           //     child: ElevatedButton(
//           //       style: ElevatedButton.styleFrom(
//           //         backgroundColor: Colors.white,
//           //         padding: EdgeInsets.only(top: screenHeight * 0.008),
//           //         shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(10),
//           //         ),
//           //       ),
//           //       onPressed: () {
//           //         Navigator.push(context, MaterialPageRoute(builder: (context) => CaregiverRole(),));
//           //       },
//           //       child: Padding(
//           //         padding: EdgeInsets.all(screenWidth * 0.03),
//           //         child: Row(
//           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             Column(
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 Text(
//           //                   "I’m a Caregiver",
//           //                   style: TextStyle(
//           //                     fontSize: screenWidth * 0.05,
//           //                     fontWeight: FontWeight.bold,
//           //                     color: Colors.black,
//           //                   ),
//           //                 ),
//           //                 SizedBox(height: screenHeight * 0.015),
//           //                 Text(
//           //                   "Monitor loved ones, real-time updates.",
//           //                   style: TextStyle(
//           //                     fontSize: screenWidth * 0.036,
//           //                     color: Colors.grey,
//           //                   ),
//           //                 ),
//           //               ],
//           //             ),
//           //             CircleAvatar(
//           //               backgroundColor: Colors.blue[100],
//           //               child: Icon(
//           //                 Icons.handshake_outlined,
//           //                 color: Colors.blue,
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//       ///////////////////////////////////////////////////////////////////////////////////
//
//           // SizedBox(height: screenHeight * 0.02),
//           // Padding(
//           //   padding: EdgeInsets.all(screenWidth * 0.03),
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //         border: Border.all(color: Colors.blue, width: 0.5),
//           //         borderRadius: BorderRadius.circular(6)),
//           //     child: ElevatedButton(
//           //       style: ElevatedButton.styleFrom(
//           //         backgroundColor: Colors.white,
//           //         padding: EdgeInsets.only(top: screenHeight * 0.008),
//           //         shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(10),
//           //         ),
//           //       ),
//           //       onPressed: () {},
//           //       child: Padding(
//           //         padding: EdgeInsets.all(screenWidth * 0.03),
//           //         child: Row(
//           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             Column(
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 Text(
//           //                   "Wellness Partner",
//           //                   style: TextStyle(
//           //                     fontSize: screenWidth * 0.05,
//           //                     fontWeight: FontWeight.bold,
//           //                     color: Colors.black,
//           //                   ),
//           //                 ),
//           //                 SizedBox(height: screenHeight * 0.015),
//           //                 Text(
//           //                   "Manage your own health and loved ones.",
//           //                   style: TextStyle(
//           //                     fontSize: screenWidth * 0.036,
//           //                     color: Colors.grey,
//           //                   ),
//           //                 ),
//           //               ],
//           //             ),
//           //             CircleAvatar(
//           //               backgroundColor: Colors.purple[100],
//           //               child: Icon(
//           //                 Icons.favorite_border,
//           //                 color: Colors.purpleAccent,
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//
//         ],
//       ),
//     );
//   }
// }
//
