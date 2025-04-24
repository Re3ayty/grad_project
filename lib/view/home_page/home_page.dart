import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import '../alerts/alerts_screen.dart';
import '../chatBot/chatBot.dart';
import '../medicicent_current_history/medication_current_history.dart';
import 'home_page_patient.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int bottom_navigation_bar_index=0;
  List<Widget> screenList=
  [
    PatientDashboard(),
    MedicineScreen(),
    AlertsScreen(),
    ChatBot(),
  ];
  @override
  Widget build(BuildContext context) {
    return initScreen();
  }

  Widget initScreen() {
    var authProvider = Provider.of<AppAuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
      // drawer: DrawerWidget(),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              bottom_navigation_bar_index=index;
            });
          },
          currentIndex:bottom_navigation_bar_index ,
          items:const [
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home" ),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medication"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Assistant"),
          ],
        ),
        // appBar: AppBar(
        //
        //   iconTheme: IconThemeData(color: Colors.white),
        //
        //   backgroundColor: Colors.blue,
        //
        //   actions: [
        //     GestureDetector(
        //       child: Container(
        //         margin: EdgeInsets.only(right: 10),
        //         child: IconButton(
        //           onPressed: (){},
        //           icon: Icon(Icons.notifications_rounded,
        //             color: Colors.white,),
        //         ),
        //       ),
        //     ),
        //
        //   ],
        // ),
        body:screenList.elementAt(bottom_navigation_bar_index)
    );
  }
}