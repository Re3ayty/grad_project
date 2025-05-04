import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hcs_grad_project/utils/app_routes_new.dart';
import 'package:hcs_grad_project/view/Auth/login.dart';
import 'package:hcs_grad_project/view/Auth/select_page.dart';
import 'package:hcs_grad_project/view/Auth/sign_up.dart';
import 'package:hcs_grad_project/view/add_medication/add_medication_screen.dart';
import 'package:hcs_grad_project/view/home_page/home_page.dart';
import 'package:hcs_grad_project/view/home_page/home_page_patient.dart';
import 'package:hcs_grad_project/view/medicicent_current_history/medication_current_history.dart';
import 'package:hcs_grad_project/view/role_selection/caregiver_role.dart';
import 'package:hcs_grad_project/view/role_selection/patient_role.dart';
import 'package:hcs_grad_project/view/role_selection/role_selection.dart';
import 'package:hcs_grad_project/view/splash_screen/splash_screen.dart';
import 'package:hcs_grad_project/viewModel/provider/app_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await AwesomeNotifications().initialize('assets/Images/blue_outline_logo_without_name.png',
  //     [
  //       NotificationChannel(
  //         channelGroupKey: 'Basic_notification_group',
  //           channelKey: 'Basic_notification', channelName: 'High Temperature', channelDescription: 'if temp got higher')
  //     ]
  // );
  runApp(ChangeNotifierProvider<AppAuthProvider>(
      create: (context) => AppAuthProvider(), child: const MyApp()));
}
final navigatorKey=GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        print(settings.name);
        switch (settings.name) {
          case AppRoutes.addMedicationRoute:
            {
              return MaterialPageRoute(
                builder: (context) => AddMedicationScreen(),
              );
            }
          case AppRoutes.homePageRoute:
            {
              return MaterialPageRoute(
                builder: (context) => HomePage(),
              );
            }
          case AppRoutes.loginRoute:
            {
              return MaterialPageRoute(
                builder: (context) => LogIn(),
              );
            }
          case AppRoutes.splashRoute:
            {
              return MaterialPageRoute(
                builder: (context) => Splash(),
              );
            }
          case AppRoutes.selectAuthRoute:
            {
              return MaterialPageRoute(
                builder: (context) => SelectPage(),
              );
            }
          case AppRoutes.roleSection:
            {
              return MaterialPageRoute(
                builder: (context) => RoleSection(),
              );
            }
          case AppRoutes.caregiverRole:
            {
              return MaterialPageRoute(
                builder: (context) => CaregiverRole(),
              );
            }
          case AppRoutes.patientRole:
            {
              return MaterialPageRoute(
                builder: (context) => PatientRole(),
              );
            }
          case AppRoutes.medicineScreen:
            {
              return MaterialPageRoute(
                builder: (context) => MedicineScreen(),
              );
            }
          case AppRoutes.patientDashboard:
            {
              return MaterialPageRoute(
                builder: (context) => PatientDashboard(),
              );
            }
        }
      },
      initialRoute: AppRoutes.splashRoute,
    );
  }
}
