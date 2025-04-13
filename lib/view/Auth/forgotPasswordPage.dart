import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/responsive_text.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _emailController= TextEditingController();

  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async{

    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent! check your email'),
            );
          }
      );

    }on FirebaseAuthException catch (e)
    {
      print(e);
      Fluttertoast.showToast(msg: e.message.toString(),gravity: ToastGravity.BOTTOM,backgroundColor:Colors.purple);

    }
  }
  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Forget password',style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
        ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
      ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/Images/blue_outline_logo_without_name.png',width: w*0.4,height: h*0.2,),
                    Padding(
                      padding: EdgeInsets.only(top:h*0.0111, bottom: h*0.08),
                      child: Text('Enter your email to reset your password',style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,color: Color(0xff717784),
                      ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: h*0.015),
                      child: SizedBox(
                          width: double.infinity,
                          child: Text('Email *',style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                          ),
                            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                          ),),
                    ),
                    TextFormField(
                      cursorColor: Color(0xff4979FB),
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff4979FB),
                          ),
                        ),
                      ),
                
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h*0.06),
                      child: SizedBox(
                        width: w*0.8,
                        height: h*0.07,
                        child: ElevatedButton(
                          onPressed:() => resetPassword(),
                          child: Text('Reset',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,color: Colors.white,
                          ),textAlign: TextAlign.center,
                            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4979FB),
                              alignment: Alignment.center
                          ),
                
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text('Return to',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,
                          color: Color(0xff717784)
                        ),textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                        ),
                        TextButton(onPressed: () => Navigator.pop(context),
                            child:
                            Text('Login',style: GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,
                              color: Color(0xff4979FB)
                            ),textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            ),
                        )
                
                      ],
                    ),
                
                  ],
                  ),
              ),
            ),
          ),
        ),
    );
  }
}
