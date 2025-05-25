import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../utils/app_routes_new.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';

class CaregiverRole extends StatefulWidget {
  const CaregiverRole({super.key});

  @override
  State<CaregiverRole> createState() => _CaregiverRoleState();
}

class _CaregiverRoleState extends State<CaregiverRole> {
  bool showPatientIdField = false;
  bool privacyPolicyChecked = false;
// Controls visibility of Patient ID field
  final formKey = GlobalKey<FormState>();
  var value = -1;
  // final dateController = TextEditingController();
  final boxSerialController = TextEditingController();
  final medicalConditionController = TextEditingController();
  final patientIdController = TextEditingController();
  Color privacyPolicyCheckColor = Colors.grey;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final relationController = TextEditingController();
  bool allowCaregiverView = false;
  String? fullPhoneNumber;

  final patientOrCaregiverState = 'Cargiver';
  String genderValue = '';
  String privacyPolicyText = '';
  bool obsecure = true;
  bool obsecureConf = true;
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadPrivacyPolicy();
  }

  Future<void> loadPrivacyPolicy() async {
    String loadedText =
        await rootBundle.loadString('assets/data_set/hcs_privacy_policy.txt');
    setState(() {
      privacyPolicyText = loadedText;
    });
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // actionsPadding: EdgeInsets.only(right: screenWidth * 0.05),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.05),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.rocket, color: Colors.blue),
                CircularProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                  value: 1,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            right: screenWidth * 0.03,
            left: screenWidth * 0.03,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  child: Column(
                    children: [
                      Text(
                        "Caregiver",
                        style: GoogleFonts.getFont('Poppins',
                            fontWeight: FontWeight.w500, fontSize: 30),
                        textScaler: TextScaler.linear(
                            ScaleSize.textScaleFactor(context)),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Caregiver information to ensure proper care.",
                        style: GoogleFonts.getFont('Poppins',
                            fontWeight: FontWeight.w400, color: Colors.grey),
                        textScaler: TextScaler.linear(
                            ScaleSize.textScaleFactor(context)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Name * ",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name is required";
                    }
                    if (!RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                      return "Alphabet only";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Email *',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid Email'
                          : null,
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Password *',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecure = !obsecure;
                        });
                      },
                      icon: Icon(
                          obsecure ? Icons.visibility_off : Icons.visibility),
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != null && value.length < 8) {
                      return 'enter minimum 8 characters';
                    } else if (!value!.contains(RegExp(r'[A-Z]'))) {
                      return 'the password must contain a capital letter';
                    } else if (!value!.contains(RegExp(r'[a-z]'))) {
                      return 'the password must contain a lower case letter';
                    } else if (!value!.contains(RegExp(r'[0-9]'))) {
                      return 'the password must contain a number';
                    } else {
                      return null;
                    }
                  },
                  obscureText: obsecure,
                  obscuringCharacter: '*',
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Confirm Password *',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureConf = !obsecureConf;
                        });
                      },
                      icon: Icon(obsecureConf
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                  obscureText: obsecureConf,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value != passwordController.text.trim()) {
                      return 'The password is not the same';
                    } else if (value!.isEmpty) {
                      return 'Please confirm the password';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Date of birth * ",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  onTap: () {
                    _selectDate(context);
                  },
                  readOnly: true,
                  controller: dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: Color(0xff4979FB),
                    ),
                    hintText: 'mm/dd/yyyy',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Date is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Phone no *",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(height: screenHeight * 0.01),
                IntlPhoneField(
                  validator: (p0) {
                    if (p0!.isValidNumber()) {
                      return "Date is required";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (phone) {
                    fullPhoneNumber = phone.completeNumber;
                  },
                  cursorColor: Color(0xff4979FB),
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Gender * ",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        '-Select a gender-',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.linear(
                            ScaleSize.textScaleFactor(context)),
                      ),
                      value: -1,
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Female',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.linear(
                            ScaleSize.textScaleFactor(context)),
                      ),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Male',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.linear(
                            ScaleSize.textScaleFactor(context)),
                      ),
                      value: 2,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (value == 2) {
                        genderValue = 'Male';
                      } else if (value == 1) {
                        genderValue = 'Female';
                      } else if (value == -1) {
                        genderValue = '';
                      }
                    });
                  },
                  value: value,
                  borderRadius: BorderRadius.circular(12),
                  decoration: InputDecoration(
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Relationship * ",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  controller: relationController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Relationship is required";
                    }
                    if (!RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                      return "Alphabet only";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Sister',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Medical condition ",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  controller: medicalConditionController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'That\'s gonna help us provide better care.',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Box serial number * ",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler:
                      TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  controller: boxSerialController,
                  enabled: !showPatientIdField,
                  validator: (value) {
                    if (!showPatientIdField && value!.isEmpty) {
                      return "Serial number is required";
                    }
                    if (!showPatientIdField &&
                        !RegExp(r'^[0-9]').hasMatch(value!)) {
                      return "Numbers only";
                    }
                    if (value!.length != 8) {
                      return "It must be 8 digits";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '12345678',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Checkbox(
                      activeColor: Color(0xff4979FB),
                      value: showPatientIdField,
                      onChanged: (bool? value) {
                        setState(() {
                          showPatientIdField = value ??
                              false; // Toggle Patient ID field visibility
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPatientIdField = !showPatientIdField;
                        });
                      },
                      child: Text(
                        'Patient has an account',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
                if (showPatientIdField) ...[
                  Text(
                    "Patient Id * ",
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextFormField(
                    cursorColor: Color(0xff4979FB),
                    controller: patientIdController,
                    validator: (value) {
                      if (showPatientIdField && value!.isEmpty) {
                        return "Patient ID is required";
                      }
                      if (showPatientIdField &&
                          !RegExp(r'^[0-9]').hasMatch(value!)) {
                        return "Numbers only";
                      }
                      if (showPatientIdField && value!.length != 6) {
                        return "It must be 6 digits";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'XXXXXX',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.035,
                      ),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xff4979FB),
                        ),
                      ),
                    ),
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      activeColor: Color(0xff4979FB),
                      side: BorderSide(color: privacyPolicyCheckColor),
                      value: privacyPolicyChecked,
                      onChanged: (value) {
                        setState(() {
                          privacyPolicyChecked = value!;
                        });
                      },
                    ),
                    Text(
                      "I agree to the",
                      style: GoogleFonts.getFont(
                        'Inter', fontWeight: FontWeight.w500,
                        // fontSize: 14,
                      ),
                      textScaler:
                          TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                    TextButton(
                      onPressed: () => showPrivacyPolicyDialog(),
                      child: Text(
                        'Privacy Policy',
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontWeight: FontWeight.w500,
                          color: Color(0xff4979FB),
                        ),
                        textScaler: TextScaler.linear(
                            ScaleSize.textScaleFactor(context)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4979FB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        createAccount(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          dateController.text.isNotEmpty
                              ? DateFormat('dd/MM/yyyy')
                                  .parse(dateController.text)
                              : DateTime.now(),
                          fullPhoneNumber ?? phoneController.text,
                          genderValue,
                          patientOrCaregiverState,
                          allowCaregiverView,
                          relationController.text,
                          medicalConditionController.text,
                        );
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: const Text("Privacy Policy")),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(privacyPolicyText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                privacyPolicyChecked = true;
                privacyPolicyCheckColor = Colors.grey;
              });
              Navigator.pop(context);
            },
            child: const Text("I Agree"),
          ),
        ],
      ),
    );
  }

  void createAccount(
      String email,
      String password,
      String userName,
      DateTime dateOfBirth,
      String phone,
      String gender,
      String patientOrCaregiver,
      bool allowCaregiverView,
      String relationship,
      [String? medicalCondition]) async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);

    setState(() {
      privacyPolicyCheckColor = privacyPolicyChecked ? Colors.grey : Colors.red;
    });

    if (formKey.currentState?.validate() == false ||
        !privacyPolicyChecked ||
        genderValue == '') {
      return;
    }

    try {
      // Show loading dialog
      DialogUtils.showLoadingDialog(context, message: 'Creating Account...');

      // Register user
      await authProvider.register(
        email: email,
        userName: userName,
        password: password,
        dateOfBirth: dateOfBirth,
        phone: phone,
        gender: gender,
        relationship: relationship,
        medicalCondition: medicalCondition!.isEmpty ? "" : medicalCondition,
        patientOrCaregiver: patientOrCaregiver,
        allowCaregiverView: allowCaregiverView,
      );

      // Send email verification
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      // Ensure the dialog is closed
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (context.mounted) {
        DialogUtils.showMessageDialog(
          context,
          message:
              'Registration successful! A verification email has been sent to your email address. Please login',
          posActionTitle: 'OK',
          posAction: () {
            Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (e.code == 'weak-password') {
        DialogUtils.showMessageDialog(
          context,
          message: 'The password provided is too weak.',
          posActionTitle: 'Try Again',
        );
      } else if (e.code == 'email-already-in-use') {
        DialogUtils.showMessageDialog(
          context,
          message:
              'The account already exists for that email. Try another account.',
          posActionTitle: 'OK',
          posAction: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      DialogUtils.showMessageDialog(
        context,
        message: e.toString(),
        posActionTitle: 'OK',
      );
    }
  }

  var finalSelectedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? userSelectedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800),
        lastDate: DateTime.now());
    if (userSelectedDate != null && userSelectedDate != selectedDate)
      setState(() {
        selectedDate = userSelectedDate;
        dateController.value = TextEditingValue(
            text:
                '${userSelectedDate.day}/${userSelectedDate.month}/${userSelectedDate.year}');
      });
  }
}
