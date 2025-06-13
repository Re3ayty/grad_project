import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/view/home_page/vital_sign_history.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import '../alerts/alerts_screen.dart';
import '../chatBot/chatBot.dart';
import '../medicicent_current_history/medication_current_history.dart';
import 'home_page_patient.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}
//
// class _HomePageState extends State<HomePage> {
//   final dbRefFingerprintEnrolledStatus = FirebaseDatabase.instance.ref("emergency");
//   int bottom_navigation_bar_index=0;
// void showSnackbar(String message, Color backgroundColor, void action) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('emergency call'),
//         action: SnackBarAction(label: 'done', onPressed: () {
//           action;
//         },),
//         backgroundColor: backgroundColor,
//         duration: const Duration(seconds: 30),
//       ),
//     );
//   }
//   Future<void> updateDatabaseAlert()
//   async {
//     await dbRefFingerprintEnrolledStatus.update({
//       "alert": false,
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return initScreen();
//   }
//
//   Widget initScreen() {
//     var authProvider = Provider.of<AppAuthProvider>(context);
//     List<Widget> screenList=
//     [
//       PatientDashboard(),
//       MedicineScreen(),
//       HeartRateHistoryApp(),
//       Geminichatbot(appUser: authProvider.databaseUser!),
//     ];
//     Size size = MediaQuery.of(context).size;
//
//
//
//
//
//
//     return StreamBuilder<DatabaseEvent>(
//       stream: dbRefFingerprintEnrolledStatus.onValue,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(width:15,height:15,child: const CircularProgressIndicator());
//         }
//         if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//           final data = snapshot.data!.snapshot.value as Map;
//           bool alert = data['alert'] ?? 0;
//           String timestamp = data['timestamp'] ?? 0;
//           return Scaffold(
//
//               backgroundColor: Colors.white,
//               // drawer: DrawerWidget(),
//               bottomNavigationBar: BottomNavigationBar(
//                 selectedItemColor: Color(0xff4979FB),
//                 unselectedItemColor: Colors.grey,
//                 showUnselectedLabels: false,
//                 onTap: (index) {
//                   if(alert==true)
//                   {
//                     showSnackbar('There is an Emergency at ${timestamp}',Colors.red,updateDatabaseAlert);
//                   }
//                   setState(() {
//                     bottom_navigation_bar_index=index;
//                   });
//                 },
//                 currentIndex:bottom_navigation_bar_index ,
//                 items:const [
//                   BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home" ),
//                   BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medication"),
//                   BottomNavigationBarItem(icon: Icon(Icons.history), label: "Vitals History"),
//                   BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Assistant"),
//                 ],
//               ),
//               // appBar: AppBar(
//               //
//               //   iconTheme: IconThemeData(color: Colors.white),
//               //
//               //   backgroundColor: Colors.blue,
//               //
//               //   actions: [
//               //     GestureDetector(
//               //       child: Container(
//               //         margin: EdgeInsets.only(right: 10),
//               //         child: IconButton(
//               //           onPressed: (){},
//               //           icon: Icon(Icons.notifications_rounded,
//               //             color: Colors.white,),
//               //         ),
//               //       ),
//               //     ),
//               //
//               //   ],
//               // ),
//               body:screenList.elementAt(bottom_navigation_bar_index)
//           );
//         } else if (snapshot.hasError) {
//           return Text("Error: ${snapshot.error}");
//         }
//         else {
//           return const Text('No status found');
//         }
//       },
//     );
//     //   Scaffold(
//     //
//     //     backgroundColor: Colors.white,
//     //   // drawer: DrawerWidget(),
//     //     bottomNavigationBar: BottomNavigationBar(
//     //       selectedItemColor: Color(0xff4979FB),
//     //         unselectedItemColor: Colors.grey,
//     //       showUnselectedLabels: false,
//     //       onTap: (index) {
//     //         setState(() {
//     //           bottom_navigation_bar_index=index;
//     //         });
//     //       },
//     //       currentIndex:bottom_navigation_bar_index ,
//     //       items:const [
//     //       BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home" ),
//     //       BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medication"),
//     //       BottomNavigationBarItem(icon: Icon(Icons.history), label: "Vitals History"),
//     //       BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Assistant"),
//     //       ],
//     //     ),
//     //     // appBar: AppBar(
//     //     //
//     //     //   iconTheme: IconThemeData(color: Colors.white),
//     //     //
//     //     //   backgroundColor: Colors.blue,
//     //     //
//     //     //   actions: [
//     //     //     GestureDetector(
//     //     //       child: Container(
//     //     //         margin: EdgeInsets.only(right: 10),
//     //     //         child: IconButton(
//     //     //           onPressed: (){},
//     //     //           icon: Icon(Icons.notifications_rounded,
//     //     //             color: Colors.white,),
//     //     //         ),
//     //     //       ),
//     //     //     ),
//     //     //
//     //     //   ],
//     //     // ),
//     //     body:screenList.elementAt(bottom_navigation_bar_index)
//     // );
//   }
// }
class _HomePageState extends State<HomePage> {
  final dbRefFingerprintEnrolledStatus = FirebaseDatabase.instance.ref("emergency");
  int bottom_navigation_bar_index = 0;
  bool emergencyShown = false;

  @override
  void initState() {
    super.initState();

    dbRefFingerprintEnrolledStatus.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        final bool alert = data['alert'] ?? false;
        final String timestamp = data['timestamp'] ?? '';

        if (alert && !emergencyShown) {
          emergencyShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEmergencySnackbar(timestamp);
          });
        }
      }
    });
  }
  void _showEmergencySnackbar(String timestamp) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text('🚨'),
            SizedBox(width: 50,),
            Expanded(child: Center(child: Text('\t \t Emergency alert \n$timestamp'))),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(days: 1), // Effectively infinite
        action: SnackBarAction(
          label: 'Seen',
          textColor: Colors.white,
          onPressed: () async {
            await dbRefFingerprintEnrolledStatus.update({"alert": false});
            emergencyShown = false;
            ScaffoldMessenger.of(context).clearSnackBars(); // Dismiss snackbar after seen
          },
        ),
      ),
    );
  }

  // void _showEmergencySnackbar(String timestamp) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Row(
  //         children: [
  //           Text('🚨 Emergency alert at \n     $timestamp'),
  //         ],
  //       ),
  //       backgroundColor: Colors.red,
  //       duration: const Duration(seconds: 30),
  //       action: SnackBarAction(
  //         label: 'Seen',
  //         textColor: Colors.white,
  //         onPressed: () async {
  //           await dbRefFingerprintEnrolledStatus.update({"alert": false});
  //           emergencyShown = false;
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AppAuthProvider>(context);
    List<Widget> screenList = [
      PatientDashboard(),
      MedicineScreen(),
      HeartRateHistoryPage(),
      Geminichatbot(appUser: authProvider.databaseUser!),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xff4979FB),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        currentIndex: bottom_navigation_bar_index,
        onTap: (index) {
          setState(() {
            bottom_navigation_bar_index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medication"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Vitals History"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Assistant"),
        ],
      ),
      body: screenList.elementAt(bottom_navigation_bar_index),
    );
  }
}
