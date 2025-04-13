import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/view/Auth/sign_up.dart';
import 'package:provider/provider.dart';
import '../../utils/app_routes_new.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import '../role_selection/role_selection.dart';
import 'forgotPasswordPage.dart';




class LogIn extends StatefulWidget {

  const LogIn({Key? Key}): super(key:Key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final emailController= TextEditingController();
  final passwordController=TextEditingController();
  bool obsecure=true;



  @override

  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return
      Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Login',style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
        ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Email *',
                      style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                                    ),
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                    ),
                  ),
                      TextFormField(
                        cursorColor: Color(0xff4979FB),
                        controller: emailController,
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
                        padding:  EdgeInsets.only(top:h*0.02),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Password *',style:GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                          ),
                            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                          ),
                        ),
                      ),
                      TextFormField(
                        cursorColor: Color(0xff4979FB),
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 13) ,
                          suffixIcon: IconButton(onPressed: ()
                          {
                            setState(() {
                              obsecure= !obsecure;
                            });
                          }, icon: Icon(obsecure ? Icons.visibility_off : Icons.visibility,),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color:Color(0xff6A6A6A63),
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

                        obscureText: obsecure ,
                        obscuringCharacter: '*',
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass(),)),
                          child: Text('Forgot Password?',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,color: Color(0xff4979FB)
                          ),
                            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                          textAlign: TextAlign.end,
                          ),
                          style: ButtonStyle(alignment: Alignment.centerRight),
                        ),
                      ),
                      Container(
                        width: w*0.83,
                        height: h*0.07,
                        margin: EdgeInsetsDirectional.only(top: h*0.02,bottom: h*0.02),
                        child: ElevatedButton(
                            onPressed:() => loginMethod(emailController.text.trim(), passwordController.text),
                            child: Text('Next',
                              style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w600,color: Colors.white,
                            ),textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4979FB),)
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don’t have an account?',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,
                              color: Color(0xff717784)
                          ),textAlign: TextAlign.center,
                            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>RoleSection() ,)
                            ),
                            child: Text('Sign up',
                              style: GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,
                                color: Color(0xff4979FB)
                            ),
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: w*0.4,
                            color: Color(0xffE5E7EB),
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('OR',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w500,
                                color: Color(0xff717784)
                            ),textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            ),
                          ),
                          Container(
                            width: w*0.4,
                            color: Color(0xffE5E7EB),
                            height: 2,
                          ),


                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor:MaterialStatePropertyAll(Colors.white)),
                        onPressed: () async {
                          await signInWithFacebook();
                          },
                                    child: Row(
                                      children: [
                                        Icon(Icons.facebook,color: Colors.blue.shade700 ,),
                                        Expanded(child: Center(child: Text('Sign in with Facebook',style:GoogleFonts.getFont('Inter',fontWeight: FontWeight.w600,
                                            color: Color(0xff101623)
                                        ),textAlign: TextAlign.center,
                                          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                        ),)),
                                      ],
                                    ),
                                  ),

                    ],
                  ),
          ),
        ),
      ),
    );

  }
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success && result.accessToken != null) {
        final accessToken = result.accessToken!.tokenString;

        final facebookAuthCredential = FacebookAuthProvider.credential(accessToken);

        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

        Navigator.pushReplacementNamed(context, AppRoutes.homePageRoute);
      } else if (result.status == LoginStatus.cancelled) {
        DialogUtils.showMessageDialog(
          context,
          message: 'Facebook login was cancelled',
          posActionTitle: 'OK',
        );
      } else {
        DialogUtils.showMessageDialog(
          context,
          message: 'Facebook login failed: ${result.message}',
          posActionTitle: 'OK',
        );
      }
    } catch (e) {
      DialogUtils.showMessageDialog(
        context,
        message: 'An error occurred during Facebook login:\n$e',
        posActionTitle: 'OK',
        posAction: () => Navigator.pop(context),
      );
    }
  }



  void loginMethod(String email, String password) async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    // showDialog(context: context,
    //   barrierDismissible: false,
    //   builder: (context) => Center(child: CircularProgressIndicator()),);
    //login
    try {
      DialogUtils.showLoadingDialog(context, message: 'plz, wait...');
      await authProvider.login(email, password);
      DialogUtils.hideDialog(context);
      Navigator.pushReplacementNamed(context, AppRoutes.homePageRoute);

    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        DialogUtils.showMessageDialog(
          context,
          message: 'Wrong email or password',
          posActionTitle: 'Try Again',
          posAction:() => Navigator.pop(context),
        );
      }

    }
  }
}



//
// ////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// class SignInPage extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   Future<User?> _signInWithGoogle() async {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     UserCredential userCredential = await _auth.signInWithCredential(credential);
//     return userCredential.user;
//   }
//
//   Future<User?> _signInWithFacebook() async {
//     final LoginResult result = await FacebookAuth.instance.login();
//     final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
//
//     UserCredential userCredential = await _auth.signInWithCredential(credential);
//     return userCredential.user;
//   }
//
//   Future<User?> _signInWithApple() async {
//     final appleCredential = await SignInWithApple.getAppleIDCredential(scopes: [
//       AppleIDAuthorizationScopes.email,
//       AppleIDAuthorizationScopes.fullName,
//     ]);
//
//     final AuthCredential credential = OAuthProvider("apple.com").credential(
//       idToken: appleCredential.identityToken,
//       accessToken: appleCredential.authorizationCode,
//     );
//
//     UserCredential userCredential = await _auth.signInWithCredential(credential);
//     return userCredential.user;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _signInWithGoogle,
//               child: Text('Sign in with Google'),
//             ),
//             ElevatedButton(
//               onPressed: _signInWithFacebook,
//               child: Text('Sign in with Facebook'),
//             ),
//             ElevatedButton(
//               onPressed: _signInWithApple,
//               child: Text('Sign in with Apple'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to Sign Up page
//               },
//               child: Text("Don't have an account? Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
