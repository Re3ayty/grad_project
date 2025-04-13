import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_routes_new.dart';
import '../../utils/responsive_text.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/Images/transparent_logo_blue.png",width: w*0.4, height: h*0.2),
                  Padding(
                    padding: EdgeInsets.only(top: h*0.0111,bottom: h*0.0111),
                    child: Text('Let’s get started!',style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w700,
                      // fontSize: MediaQuery.textScalerOf(context).scale(MediaQuery.of(context).size.width * 0.07)
                    ),
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                  ),
                  Text('Login to enjoy all of our feature for better you',style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,color: Color(0xff717784),
                      // fontSize: MediaQuery.textScalerOf(context).scale(MediaQuery.of(context).size.width * 0.05)
                  ),textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h*0.05,bottom: h*0.02),
                    child: SizedBox(
                      width: w*0.8,
                      height: h*0.07,
                      child:
                      ElevatedButton(onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
                      },
                          child: Text('Login',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,color: Colors.white,
                      ),textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff4979FB)),
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),)
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: w*0.8,
                    height: h*0.07,
                    child:
                    ElevatedButton(onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.roleSection);
                    },
                      child: Text('Sign Up',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,color: Color(0xff4979FB),
                      ),textAlign: TextAlign.center,
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.white),
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32),side: BorderSide(color: Color(0xff4979FB))),)
                      ),
                    ),

                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
