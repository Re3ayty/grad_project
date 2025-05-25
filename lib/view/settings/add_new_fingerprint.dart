import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/responsive_text.dart';

class AddNewFingerprint extends StatefulWidget {
  const AddNewFingerprint({super.key});

  @override
  State<AddNewFingerprint> createState() => _AddNewFingerprintState();
}

class _AddNewFingerprintState extends State<AddNewFingerprint> {
  final fingerprintNameController = TextEditingController();
  final fingerprintIDController = TextEditingController();

  final dbRefFingerprintEnrolledStatus =
  FirebaseDatabase.instance.ref("fingerprint/enroll/status");
  final updatingCommandsEnrollFingerprint =
  FirebaseDatabase.instance.ref("commands");

  Color _iconColor = const Color(0xff4979FB);
  bool _hasHandledSuccess = false;
  String? _lastStatus;

  @override
  void dispose() {
    fingerprintNameController.dispose();
    fingerprintIDController.dispose();
    super.dispose();
  }

  Future<void> _startEnrollment() async {
    setState(() {
      _iconColor = const Color(0xff4979FB);
      _hasHandledSuccess = false;
      _lastStatus = null;
    });

    final idText = fingerprintIDController.text.trim();
    if (idText.isEmpty) {
      _showSnackbar('Please enter a fingerprint ID', Colors.red);
      return;
    }

    try {
      final id = int.parse(idText);
      await updatingCommandsEnrollFingerprint.update({
        "enrollFingerprint": id,
      });
    } catch (_) {
      _showSnackbar('Invalid fingerprint ID', Colors.red);
    }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _handleStatusChange(String status) {
    if (_lastStatus == status) return;
    _lastStatus = status;

    if (status == "✅ Fingerprint enrolled successfully!") {
      if (_hasHandledSuccess) return;

      _hasHandledSuccess = true;
      setState(() => _iconColor = Colors.green);

      _showSnackbar("Fingerprint enrolled successfully!", Colors.green);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop(); // Pop the screen after delay
        }
      });
    } else if (_isFailureStatus(status)) {
      setState(() => _iconColor = Colors.red);
      _showSnackbar("Enrollment failed: $status", Colors.red);
    }
  }


  bool _isFailureStatus(String status) {
    return [
      'Enrollment timeout - No finger detected',
      'Timeout waiting for finger removal',
      'Fingerprints did not match',
      'Could not find fingerprint features'
    ].contains(status);
  }

  // Widget _buildUIBasedOnStatus(String status) {
  //   switch (status) {
  //     case 'Ready':
  //       return SizedBox(
  //         width:270,
  //         child: ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xff4979FB),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //           ),
  //           onPressed: _startEnrollment,
  //           child: const Text('Start Enrollment', style: TextStyle(color: Colors.white,fontSize: 20)),
  //         ),
  //       );
  //     // case 'Waiting for valid finger to enroll as #20':
  //     //   return const Text('Place your finger on the sensor...');
  //     // case 'Image taken':
  //     //   return const Text('Image captured. Please wait...');
  //     // case 'Remove finger':
  //     //   return const Text('Please remove your finger.');
  //     // case 'Place same finger again':
  //     //   return const Text('Place the same finger again.');
  //     // case 'Prints matched!':
  //     //   return const Text('Fingerprints matched successfully.');
  //     // case 'Stored!':
  //     //   return Column(
  //     //     children: const [
  //     //       Text('Fingerprint enrolled successfully!'),
  //     //       Icon(Icons.check_circle, color: Colors.green),
  //     //     ],
  //     //   );
  //     default:
  //       if (_isFailureStatus(status)) {
  //         return Text('');
  //       }
  //       return Text('');
  //   }
  // }

  Widget _buildUIBasedOnStatus(String status) {
    final isFailure = _isFailureStatus(status);

    if (status == 'Ready' || isFailure) {
      return Column(
        children: [
          if (_iconColor==Colors.red)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Please retry',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          SizedBox(
            width: 270,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4979FB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _startEnrollment,
              child: Text(
                isFailure ? 'Retry Enrollment' : 'Start Enrollment',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink(); // returns nothing for other statuses
  }




  Widget _buildLabel(String text, BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
      ),
    );
  }

  // Widget _buildTextField(TextEditingController controller, String hint) {
  //   return TextFormField(
  //     cursorColor: const Color(0xff4979FB),
  //     controller: controller,
  //     decoration: InputDecoration(
  //       hintText: hint,
  //       hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Color(0xff6A6A6A63)),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Color(0xff4979FB)),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      cursorColor: const Color(0xff4979FB),
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff6A6A6A63)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff4979FB)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Shortens the height
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Fingerprint',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // _buildLabel('Name *', context),
              // _buildTextField(fingerprintNameController, 'Fingerprint name'),
              // const SizedBox(height: 10),
              // _buildLabel('ID *', context),
              // _buildTextField(fingerprintIDController, '1 - 127'),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildLabel('Name*', context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: _buildTextField(fingerprintNameController, 'Fingerprint name'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildLabel('ID*', context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: _buildTextField(fingerprintIDController, '1 - 127'),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              StreamBuilder<DatabaseEvent>(
                stream: dbRefFingerprintEnrolledStatus.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    final status = snapshot.data!.snapshot.value.toString();

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _handleStatusChange(status);
                    });

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            status,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 70,top: 40),
                          child: Icon(Icons.fingerprint, size: 200, color: _iconColor),
                        ),
                        _buildUIBasedOnStatus(status),
                      ],
                    );
                  } else {
                    return const Text('No status found');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
