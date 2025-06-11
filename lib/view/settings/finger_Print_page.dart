import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/model/fingerprints.dart';
import 'package:hcs_grad_project/viewModel/provider/app_auth_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/responsive_text.dart';
import 'add_new_fingerprint.dart';
import '../../viewModel/firbase_realtime_dao.dart';

class FingerPrintScreen extends StatefulWidget {
  const FingerPrintScreen({super.key});

  @override
  State<FingerPrintScreen> createState() => _FingerPrintScreenState();
}

class _FingerPrintScreenState extends State<FingerPrintScreen> {
  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    final uid = Provider.of<AppAuthProvider>(context, listen: false)
            .firebaseAuthUser
            ?.uid ??
        '';
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Fingerprint',
            style: GoogleFonts.getFont(
              'Poppins', fontWeight: FontWeight.w500,
              // fontSize: 18,
            ),
            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/Images/fingerPrint.png'),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    child: Text(
                      'To ensure you receive your medicine safely, please add your fingerprint.',
                      style: GoogleFonts.getFont(
                        'Inter',
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      textScaler:
                          TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Fingerprints',
                      style: GoogleFonts.getFont(
                        'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                      textScaler:
                          TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                  ),
                  StreamBuilder<List<FingerPrintsData>>(
                      stream: FingerprintDao.getFingerprintsStream(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error loading fingerprints");
                        }
                        final fingerprints = snapshot.data ?? [];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xffF4F4F4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                // List of fingerprints
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: fingerprints.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Icon(Icons.fingerprint,
                                          color: Color(0xff4979FB)),
                                      title: Text(
                                        '${fingerprints[index].fingerprintName ?? "Fingerprint ${index + 1}"} (ID: ${fingerprints[index].id ?? ""})',
                                        style: GoogleFonts.getFont('Poppins',
                                            fontWeight: FontWeight.w400),
                                        textScaler: TextScaler.linear(
                                            ScaleSize.textScaleFactor(context)),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          await FingerprintDao
                                              .deleteFingerprintForUser(uid,
                                                  fingerprints[index].docID!);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                // "Add new fingerprint" tile
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xffF4F4F4),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddNewFingerprint(),
                                        ),
                                      );
                                    },
                                    leading: Icon(
                                      Icons.fingerprint,
                                      color: Color(0xff4979FB),
                                    ),
                                    title: Text(
                                      "Add new fingerprint",
                                      style: GoogleFonts.getFont(
                                        'Poppins', fontWeight: FontWeight.w400,
                                        // fontSize: 14,
                                      ),
                                      textScaler: TextScaler.linear(
                                          ScaleSize.textScaleFactor(context)),
                                    ),
                                    trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.grey.shade400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                ]),
          ),
        ));
  }
}
