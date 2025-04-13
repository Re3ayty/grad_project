// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_routes_new.dart';
// import '../../utils/dialog_utils.dart';
// import '../../utils/responsive_text.dart';
// import '../../viewModel/provider/app_auth_provider.dart';
// import 'login.dart';
//
// class SignUp extends StatefulWidget {
//   // final Function() onClickedSignUp;
//   const SignUp({Key? Key,}): super(key:Key);
//
//   @override
//   State<SignUp> createState() => SignUpState();
// }
//
// class SignUpState extends State<SignUp> {
//   bool privacyPolicyChecked = false;
//
//   // final String userName;
//   Color privacyPolicyCheckColor = Colors.grey;
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final nameController = TextEditingController();
//
//   final formKey = GlobalKey<FormState>();
//   String privacyPolicyText = '';
//   bool obsecure = true;
//   bool obsecureConf = true;
//
//   void dispose() {
//     // TODO: implement dispose
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadPrivacyPolicy();
//   }
//
//   Future<void> loadPrivacyPolicy() async {
//     String loadedText = await rootBundle.loadString(
//         'assets/data_set/hcs_privacy_policy.txt');
//     setState(() {
//       privacyPolicyText = loadedText;
//     });
//   }
//
//   Widget build(BuildContext context) {
//     dynamic h = MediaQuery
//         .of(context)
//         .size
//         .height;
//     dynamic w = MediaQuery
//         .of(context)
//         .size
//         .width;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Sign Up',
//           style: GoogleFonts.getFont('Poppins', fontWeight: FontWeight.w500,
//           ),
//           textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//                     child: Text('Name *',
//                       style: GoogleFonts.getFont(
//                         'Poppins', fontWeight: FontWeight.w500,
//                       ),
//                       textScaler: TextScaler.linear(
//                           ScaleSize.textScaleFactor(context)),
//                     ),
//                   ),
//                   TextFormField(
//                     cursorColor: Color(0xff4979FB),
//                     controller: nameController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your name',
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff4979FB),
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter a user name';
//                       }
//                       else {
//                         return null;
//                       }
//                     },
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//                     child: Text('Email *',
//                       style: GoogleFonts.getFont(
//                         'Poppins', fontWeight: FontWeight.w500,
//                       ),
//                       textScaler: TextScaler.linear(
//                           ScaleSize.textScaleFactor(context)),
//                     ),
//                   ),
//                   TextFormField(
//                     cursorColor: Color(0xff4979FB),
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your email',
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff4979FB),
//                         ),
//                       ),
//                     ),
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (email) =>
//                     email != null && !EmailValidator.validate(email)
//                         ? 'Enter a valid Email'
//                         : null,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//                     child: Text('Password *',
//                       style: GoogleFonts.getFont(
//                         'Poppins', fontWeight: FontWeight.w500,
//                       ),
//                       textScaler: TextScaler.linear(
//                           ScaleSize.textScaleFactor(context)),
//                     ),
//                   ),
//                   TextFormField(
//                     cursorColor: Color(0xff4979FB),
//                     controller: passwordController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your password',
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
//                       suffixIcon: IconButton(onPressed: () {
//                         setState(() {
//                           obsecure = !obsecure;
//                         });
//                       }, icon: Icon(obsecure ? Icons.visibility_off : Icons
//                           .visibility),
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff4979FB),
//                         ),
//                       ),
//                     ),
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (value) {
//                       if (value != null && value.length < 8) {
//                         return 'enter minimum 8 characters';
//                       }
//                       else if (!value!.contains(RegExp(r'[A-Z]'))) {
//                         return 'the password must contain a capital letter';
//                       }
//                       else if (!value!.contains(RegExp(r'[a-z]'))) {
//                         return 'the password must contain a lower case letter';
//                       }
//                       else if (!value!.contains(RegExp(r'[0-9]'))) {
//                         return 'the password must contain a number';
//                       }
//                       else {
//                         return null;
//                       }
//                     },
//                     obscureText: obsecure,
//                     obscuringCharacter: '*',
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//                     child: Text('Confirm Password *',
//                       style: GoogleFonts.getFont(
//                         'Poppins', fontWeight: FontWeight.w500,
//                       ),
//                       textScaler: TextScaler.linear(
//                           ScaleSize.textScaleFactor(context)),
//                     ),
//                   ),
//                   TextFormField(
//                     cursorColor: Color(0xff4979FB),
//                     decoration: InputDecoration(
//                       hintText: 'Re-enter your password',
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
//                       suffixIcon: IconButton(onPressed: () {
//                         setState(() {
//                           obsecureConf = !obsecureConf;
//                         });
//                       }, icon: Icon(obsecureConf ? Icons.visibility_off : Icons
//                           .visibility),
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff6A6A6A63),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xff4979FB),
//                         ),
//                       ),
//                     ),
//                     obscureText: obsecureConf,
//                     obscuringCharacter: '*',
//                     validator: (value) {
//                       if (value != passwordController.text.trim()) {
//                         return 'The password is not the same';
//                       }
//                       else if (value!.isEmpty) {
//                         return 'Please confirm the password';
//                       }
//                       else {
//                         return null;
//                       }
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Checkbox(
//                         activeColor: Color(0xff4979FB),
//                         side: BorderSide(color: privacyPolicyCheckColor),
//                         value: privacyPolicyChecked,
//                         onChanged: (value) {
//                           setState(() {
//                             privacyPolicyChecked = value!;
//                           });
//                         },
//                       ),
//                       Text("I agree to the", style: GoogleFonts.getFont(
//                         'Inter', fontWeight: FontWeight.w500,
//                         // fontSize: 14,
//                       ),
//                         textScaler: TextScaler.linear(
//                             ScaleSize.textScaleFactor(context)),
//                       ),
//                       TextButton(
//
//                         onPressed: () => showPrivacyPolicyDialog(),
//                         child: Text(
//                           'Privacy Policy', style: GoogleFonts.getFont('Inter',
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xff4979FB),
//                         ),
//
//                           textScaler: TextScaler.linear(ScaleSize
//                               .textScaleFactor(context)),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                   Center(
//                     child: Container(
//                       width: w * 0.83,
//                       height: h * 0.07,
//                       margin: EdgeInsetsDirectional.only(
//                           top: h * 0.02, bottom: h * 0.02),
//                       child: ElevatedButton(
//                           onPressed: () {
//                             createAccount(
//                               emailController.text,
//                               passwordController.text,
//                               nameController.text,
//                             );
//                           },
//                           child: Text('Next',
//                             style: GoogleFonts.getFont(
//                               'Inter', fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ), textAlign: TextAlign.center,
//                             textScaler: TextScaler.linear(
//                                 ScaleSize.textScaleFactor(context)),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xff4979FB),)
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Already have an account?  ',
//                           style: GoogleFonts.getFont('Inter',
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff717784)
//                           ), textAlign: TextAlign.center,
//                           textScaler: TextScaler.linear(ScaleSize
//                               .textScaleFactor(context)),
//                         ),
//                         TextButton(
//                           onPressed: () =>
//                               Navigator.pushReplacement(context,
//                                   MaterialPageRoute(
//                                     builder: (context) => LogIn(),)
//                               ),
//                           child: Text('Sign In',
//                             style: GoogleFonts.getFont(
//                                 'Inter', fontWeight: FontWeight.w500,
//                                 color: Color(0xff4979FB)
//                             ),
//                             textScaler: TextScaler.linear(
//                                 ScaleSize.textScaleFactor(context)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   //
//   // void createAccount(String email, String password, String userName) async {
//   //   var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
//   //   if (formKey.currentState?.validate() == false) {
//   //     return;
//   //   }
//   //
//   //   // create account register user
//   //
//   //   try {
//   //     DialogUtils.showLoadingDialog(context, message: 'Create Account...');
//   //     await authProvider.register(
//   //         email: email,
//   //         userName: userName,
//   //         password: password);
//   //     DialogUtils.hideDialog(context);
//   //     DialogUtils.showMessageDialog(context,
//   //         message: 'Registration Successfully',
//   //         posActionTitle: 'Login', posAction: () {
//   //           Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
//   //         });
//   //   } on FirebaseAuthException catch (e) {
//   //     DialogUtils.hideDialog(context);
//   //     if (e.code == 'weak-password') {
//   //       DialogUtils.showMessageDialog(context,
//   //           message: 'The password provided is too weak.',
//   //           posActionTitle: 'Try Again');
//   //     } else if (e.code == 'email-already-in-use') {
//   //       DialogUtils.showMessageDialog(context,
//   //         message:
//   //         'The account already exists for that email, try anothe account.',
//   //         posActionTitle: 'Ok'
//   //         ,posAction: () =>Navigator.pop(context) ,);
//   //     }
//   //   } catch (e) {
//   //     DialogUtils.hideDialog(context);
//   //     DialogUtils.showMessageDialog(context,
//   //         message: e.toString(), posActionTitle: 'Ok');
//   //   }
//   // }
//
//   // void createAccount(String email, String password, String userName) async {
//   //   var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
//   //   setState(() {
//   //     // Change color to red if the checkbox is not checked
//   //     privacyPolicyCheckColor = privacyPolicyChecked ? Colors.grey : Colors.red;
//   //   });
//   //
//   //   if (formKey.currentState?.validate() == false|| !privacyPolicyChecked) {
//   //     return;
//   //   }
//   //   try {
//   //     DialogUtils.showLoadingDialog(context, message: 'Create Account...');
//   //     await authProvider.register(
//   //         email: email,
//   //         userName: userName,
//   //         password: password);
//   //     if (context.mounted) {
//   //       DialogUtils.hideDialog(context);
//   //     }
//   //     // DialogUtils.hideDialog(context);
//   //     // DialogUtils.showMessageDialog(context,
//   //     //     message: 'Registration Successfully',
//   //     //     posActionTitle: 'Login',
//   //     //     posAction: () {
//   //     //       Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
//   //     //     });
//   //     if (context.mounted) {
//   //       DialogUtils.showMessageDialog(
//   //         context,
//   //         message: 'Registration Successfully',
//   //         posActionTitle: 'Login',
//   //         posAction: () {
//   //           Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
//   //         },
//   //       );
//   //     }
//   //   } on FirebaseAuthException catch (e) {
//   //     // DialogUtils.hideDialog(context);
//   //     if (context.mounted) {
//   //       DialogUtils.hideDialog(context);
//   //     }
//   //     if (e.code == 'weak-password') {
//   //       DialogUtils.showMessageDialog(context,
//   //           message: 'The password provided is too weak.',
//   //           posActionTitle: 'Try Again');
//   //
//   //     } else if (e.code == 'email-already-in-use') {
//   //       DialogUtils.showMessageDialog(context,
//   //         message:
//   //         'The account already exists for that email, try anothe account.',
//   //         posActionTitle: 'Ok'
//   //         ,posAction: () =>Navigator.pop(context) ,);
//   //     }
//   //   } catch (e) {
//   //     if (context.mounted) {
//   //       DialogUtils.hideDialog(context);
//   //     }
//   //     // DialogUtils.hideDialog(context);
//   //     DialogUtils.showMessageDialog(context,
//   //         message: e.toString(), posActionTitle: 'Ok');
//   //   }
//   // }
//
//
//   void showPrivacyPolicyDialog() {
//     showDialog(
//       context: context,
//       builder: (context) =>
//           AlertDialog(
//             title: Center(child: const Text("Privacy Policy")),
//             content: SizedBox(
//               width: double.maxFinite,
//               child: SingleChildScrollView(
//                 child: Text(privacyPolicyText),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     privacyPolicyChecked = true;
//                     privacyPolicyCheckColor = Colors.grey;
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: const Text("I Agree"),
//               ),
//             ],
//           ),
//     );
//   }
//
//   // //////////////////////////////////////////////////////working/////////////////
// //   void createAccount(String email, String password, String userName) async {
// //     var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
// //
// //     setState(() {
// //       privacyPolicyCheckColor = privacyPolicyChecked ? Colors.grey : Colors.red;
// //     });
// //
// //     if (formKey.currentState?.validate() == false || !privacyPolicyChecked) {
// //       return;
// //     }
// //
// //     try {
// //       // Show loading dialog
// //       DialogUtils.showLoadingDialog(context, message: 'Creating Account...');
// //
// //       // Register user
// //       await authProvider.register(
// //         email: email,
// //         userName: userName,
// //         password: password,
// //       );
// //
// //       // Ensure the dialog is closed before proceeding
// //       if (Navigator.canPop(context)) {
// //         Navigator.pop(context);
// //       }
// //
// //       // Show success message
// //       if (context.mounted) {
// //         DialogUtils.showMessageDialog(
// //           context,
// //           message: 'Registration Successfully',
// //           posActionTitle: 'Login',
// //           posAction: () {
// //             Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
// //           },
// //         );
// //       }
// //     } on FirebaseAuthException catch (e) {
// //       // Ensure the dialog is closed before showing error message
// //       if (Navigator.canPop(context)) {
// //         Navigator.pop(context);
// //       }
// //
// //       if (e.code == 'weak-password') {
// //         DialogUtils.showMessageDialog(
// //           context,
// //           message: 'The password provided is too weak.',
// //           posActionTitle: 'Try Again',
// //         );
// //       } else if (e.code == 'email-already-in-use') {
// //         DialogUtils.showMessageDialog(
// //           context,
// //           message: 'The account already exists for that email. Try another account.',
// //           posActionTitle: 'Ok',
// //           posAction: () => Navigator.pop(context),
// //         );
// //       }
// //     } catch (e) {
// //       // Ensure the dialog is closed before showing error message
// //       if (Navigator.canPop(context)) {
// //         Navigator.pop(context);
// //       }
// //
// //       DialogUtils.showMessageDialog(
// //         context,
// //         message: e.toString(),
// //         posActionTitle: 'Ok',
// //       );
// //     }
// //   }
// //
// //
// // }
//   void createAccount(String email, String password, String userName) async {
//     var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
//
//     setState(() {
//       privacyPolicyCheckColor = privacyPolicyChecked ? Colors.grey : Colors.red;
//     });
//
//     if (formKey.currentState?.validate() == false || !privacyPolicyChecked) {
//       return;
//     }
//
//     try {
//       // Show loading dialog
//       DialogUtils.showLoadingDialog(context, message: 'Creating Account...');
//
//       // Register user
//       await authProvider.register(
//         email: email,
//         userName: userName,
//         password: password,
//       );
//
//       // Send email verification
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//       }
//
//       // Ensure the dialog is closed
//       if (Navigator.canPop(context)) {
//         Navigator.pop(context);
//       }
//
//       if (context.mounted) {
//         DialogUtils.showMessageDialog(
//           context,
//           message: 'Registration successful! A verification email has been sent to your email address.',
//           posActionTitle: 'OK',
//           posAction: () {
//             Navigator.pushReplacementNamed(context, AppRoutes.roleSection);
//           },
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       if (Navigator.canPop(context)) {
//         Navigator.pop(context);
//       }
//
//       if (e.code == 'weak-password') {
//         DialogUtils.showMessageDialog(
//           context,
//           message: 'The password provided is too weak.',
//           posActionTitle: 'Try Again',
//         );
//       } else if (e.code == 'email-already-in-use') {
//         DialogUtils.showMessageDialog(
//           context,
//           message: 'The account already exists for that email. Try another account.',
//           posActionTitle: 'OK',
//           posAction: () => Navigator.pop(context),
//         );
//       }
//     } catch (e) {
//       if (Navigator.canPop(context)) {
//         Navigator.pop(context);
//       }
//       DialogUtils.showMessageDialog(
//         context,
//         message: e.toString(),
//         posActionTitle: 'OK',
//       );
//     }
//   }
// }
//
