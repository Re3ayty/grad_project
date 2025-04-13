 //import 'package:provider/provider.dart';
 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/app_routes_new.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import '../add_medication/add_medication_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      // Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
      navigate(context);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3a60c9),
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(
              opacity: opacityAnimation.value,
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: Image.asset('assets/Images/trans_logo_white.png'),
              ),
            );
          },
        ),
      ),
    );
  }
  // void navigate(BuildContext context) async {
  //   var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
  //   if (authProvider.isLoggedInBefore()) {
  //     await authProvider.retrieveUserFromDatabase();
  //     Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
  //   } else {
  //     Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
  //   }
  // }
}
 void navigate(BuildContext context) async {
   var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
   if (authProvider.isLoggedInBefore()) {
     await authProvider.retrieveUserFromDatabase();
     Navigator.pushReplacementNamed(context, AppRoutes.homePageRoute);
   } else {
     Navigator.pushReplacementNamed(context, AppRoutes.selectAuthRoute);
   }
 }
