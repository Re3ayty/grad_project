import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../utils/app_routes_new.dart';

class CaregiverRole extends StatefulWidget {
  const CaregiverRole({super.key});

  @override
  State<CaregiverRole> createState() => _CaregiverRoleState();
}

class _CaregiverRoleState extends State<CaregiverRole> {
  bool showPatientIdField = false; // Controls visibility of Patient ID field
  final formkey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final boxSerialController = TextEditingController();
  final patientIdController = TextEditingController();

  @override
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
            key: formkey,
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
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Caregiver information to ensure proper care.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Name * ",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name is required";
                    }
                    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return "Only alphabetic characters";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
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
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Relationship * ",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  cursorColor: Color(0xff4979FB),
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
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Phone no ",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                IntlPhoneField(
                  cursorColor: Color(0xff4979FB),
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
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff4979FB),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Box serial number * ",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
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
                    if (!showPatientIdField && !RegExp(r'^[0-9]').hasMatch(value!)) {
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
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
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
                          showPatientIdField = value ?? false; // Toggle Patient ID field visibility
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
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextFormField(
                    cursorColor: Color(0xff4979FB),
                    controller: patientIdController,
                    validator: (value) {
                      if (showPatientIdField && value!.isEmpty) {
                        return "Patient ID is required";
                      }
                      if (showPatientIdField && !RegExp(r'^[0-9]').hasMatch(value!)) {
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
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xff4979FB),
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (!formkey.currentState!.validate()) {
                          return;
                        }
                        Navigator.pushNamed(context,AppRoutes.homePageRoute);
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
}
