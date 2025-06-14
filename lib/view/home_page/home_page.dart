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

class _HomePageState extends State<HomePage> {

  int bottom_navigation_bar_index=0;

  @override
  Widget build(BuildContext context) {
    return initScreen();
  }

  Widget initScreen() {
    var authProvider = Provider.of<AppAuthProvider>(context);
    List<Widget> screenList=
    [
      PatientDashboard(),
      MedicineScreen(),
      HeartRateHistoryPage(),
      Geminichatbot(appUser: authProvider.databaseUser!),
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(

        backgroundColor: Colors.white,
      // drawer: DrawerWidget(),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xff4979FB),
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Vitals History"),
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