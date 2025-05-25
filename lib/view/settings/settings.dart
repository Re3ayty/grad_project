import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/view/settings/privacy_policy.dart';
import 'package:hcs_grad_project/view/settings/user_edit_info.dart';
import 'package:provider/provider.dart';

import '../../../../utils/dialog_utils.dart';
import '../../../../viewModel/provider/app_auth_provider.dart';
import '../../utils/responsive_text.dart';
import '../Auth/login.dart';
import 'finger_Print_page.dart';


class SettingsScreenPage extends StatefulWidget {
  const SettingsScreenPage({super.key});

  @override
  State<SettingsScreenPage> createState() => _SettingsScreenPageState();
}

class _SettingsScreenPageState extends State<SettingsScreenPage> {
  bool isDarkMode = false;
  bool notificationsOn = true;
  String selectedLanguage = 'EN';
  void _showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                Text("Choose Language", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                Divider(),
                Expanded(
                  child: ListView(
                    children: ['EN', 'AR'].map((lang) {
                      return ListTile(
                        title: Text(lang),
                        trailing: selectedLanguage == lang ? Icon(Icons.check, color: Color(0xff4979FB)) : null,
                        onTap: () {
                          Navigator.pop(ctx);
                          Future.delayed(Duration(milliseconds: 100), () {
                            if (mounted) {
                              setState(() {
                                selectedLanguage = lang;
                              });
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    var authProvider = Provider.of<AppAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(

        title: Text('Settings',
          style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
            // fontSize: 18,
          ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

        ),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/Images/app_logo_icon.png"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    //todo change image
                    '${authProvider.databaseUser!.userName!.characters.first.toUpperCase()}${authProvider.databaseUser!.userName!.substring(1)}',
                    style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                      fontSize: 20
                    ),
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                  ),
                  Text('Patient', style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500, color: Colors.grey
                  ),
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                  Divider(height: 50,color: Colors.grey.shade300,),
                  //your profile
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xffF4F4F4)
                    ),
                    child: ListTile(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileEditScreen()));},
                      leading: Icon(
                        CupertinoIcons.person,
                        color: Color(0xff4979FB),

                      ),
                      title: Text(
                        "Profile",
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey.shade400),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF4F4F4)
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => FingerPrintScreen(),));
                      },
                      leading: Icon(
                        Icons.fingerprint,
                        color: Color(0xff4979FB),

                      ),
                      title: Text(
                        "FingerPrint",
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey.shade400),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF4F4F4)
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.language_outlined,
                        color: Color(0xff4979FB),

                      ),
                      title: Text(
                        "Language",
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                      ),
                      trailing: Text(
                        selectedLanguage,
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                          // fontSize: 18,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),),
                      onTap: () => _showLanguageBottomSheet(context),

                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF4F4F4)
                    ),
                    child: ListTile(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileEditScreen()));
                      },
                      leading: Icon(CupertinoIcons.circle_lefthalf_fill,
                        color: Color(0xff4979FB),

                      ),

                      title: Text(
                        "Theme",
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                      ),
                      trailing: _buildThemeToggle(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF4F4F4)
                    ),
                    child: ListTile(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileEditScreen()));
                      },
                      leading: Icon(
                        Icons.notifications_none_outlined,
                        color: Color(0xff4979FB),

                      ),
                      title: Text(
                        "Notifications",
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                      ),
                      trailing: _buildNotificationToggle()
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF4F4F4)
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => PrivacyPolices(),));
                      },
                      leading: Icon(
                        Icons.privacy_tip_outlined,
                        color: Color(0xff4979FB),

                      ),
                      title: Text(
                        "Privacy Police",
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey.shade400),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF4F4F4)
                    ),
                    child: ListTile(
                      onTap: ()
                      {DialogUtils.showMessageDialog(context,message: 'Are you sure you want to log out?',posActionTitle: 'yes',posAction: () {
                        logOut();
                        Navigator.push(context,MaterialPageRoute(builder: (context) => LogIn(),));
                      },negActionTitle: 'No',negAction: () {
                        Navigator.pop(context);
                      }
                        ,);
                      },
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xff4979FB),

                      ),
                      title: Text(
                        "Log Out",
                        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey.shade400),
                    ),
                  ),
                  SizedBox(height: 20),


                  //logout
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void logOut() {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    authProvider.signOut();
  }

Widget _buildThemeToggle() {
  return GestureDetector(
    onTap: () {
      setState(() {
        isDarkMode = !isDarkMode;
      });
    },
    child: Container(
      width: 100,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [

          AnimatedAlign(
            alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Container(
              width: 50,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff4979FB),
                // shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Light",
              style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                  color: !isDarkMode ? Colors.white : Colors.black,
                // fontSize: 18,
              ),
              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),),
                    // style: TextStyle(fontSize: 12, color: !isDarkMode ? Colors.white : Colors.black)),
                Text("Dark", style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                  // fontSize: 18,
                ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),),
              ],
            ),
          ),
        ],
      ),
    ),
  );

}
  Widget _buildNotificationToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          notificationsOn = !notificationsOn;
        });
      },
      child: Container(
        width: 100,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            AnimatedAlign(
              alignment: notificationsOn ? Alignment.centerRight : Alignment.centerLeft,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                width: 50,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff4979FB),
                  // shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ON",
                      style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                        color: !notificationsOn ? Colors.white : Colors.black,
                        // fontSize: 18,
                      ),),
                      // style: TextStyle(fontSize: 12, color: !notificationsOn ? Colors.white : Colors.black)),
                  Text("OFF", style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
                    color: notificationsOn ? Colors.white : Colors.black,
                    // fontSize: 18,
                  ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
