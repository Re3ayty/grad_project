// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hcs_grad_project/model/fingerprints.dart';
// import 'package:hcs_grad_project/viewModel/provider/app_auth_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../../utils/responsive_text.dart';
// import 'add_new_fingerprint.dart';
// import '../../viewModel/firbase_realtime_dao.dart';
//
// class FingerPrintScreen extends StatefulWidget {
//
//   const FingerPrintScreen({super.key});
//
//   @override
//   State<FingerPrintScreen> createState() => _FingerPrintScreenState();
// }
//
// class _FingerPrintScreenState extends State<FingerPrintScreen> {
//   DatabaseReference dbRefFingerPrintDelete = FirebaseDatabase.instance.ref("fingerprint/delete/status");
//   final updatingCommandsDeleteFingerprint = FirebaseDatabase.instance.ref("commands");
//   @override
//   void showSnackbar(String message, Color backgroundColor) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Center(child: Text(message)),
//         backgroundColor: backgroundColor,
//         duration: const Duration(seconds: 30),
//       ),
//     );
//   }
//   Widget build(BuildContext context) {
//     dynamic h = MediaQuery.of(context).size.height;
//     dynamic w = MediaQuery.of(context).size.width;
//     final uid = Provider.of<AppAuthProvider>(context, listen: false)
//             .firebaseAuthUser
//             ?.uid ??
//         '';
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Fingerprint',
//             style: GoogleFonts.getFont(
//               'Poppins', fontWeight: FontWeight.w500,
//               // fontSize: 18,
//             ),
//             textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
//           ),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             width: double.infinity,
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/Images/fingerPrint.png'),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 30, bottom: 40),
//                     child: Text(
//                       'To ensure you receive your medicine safely, please add your fingerprint.',
//                       style: GoogleFonts.getFont(
//                         'Inter',
//                         fontWeight: FontWeight.w300,
//                         fontSize: 20,
//                       ),
//                       textAlign: TextAlign.center,
//                       textScaler:
//                           TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Fingerprints',
//                       style: GoogleFonts.getFont(
//                         'Inter',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 20,
//                       ),
//                       textAlign: TextAlign.left,
//                       textScaler:
//                           TextScaler.linear(ScaleSize.textScaleFactor(context)),
//                     ),
//                   ),
//                   StreamBuilder<DatabaseEvent>(
//                   stream: dbRefFingerPrintDelete.onValue,
//                     builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//                     if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//                       final deleteStatus = snapshot.data!.snapshot.value.toString();
//                       // WidgetsBinding.instance.addPostFrameCallback((_) {
//                       //   if(deleteStatus=='Deleted') {
//                       //     showSnackbar('deleted successfully', Colors.green);
//                       //   }
//                       // });
//                       return StreamBuilder<List<FingerPrintsData>>(
//                         stream: FingerprintDao.getFingerprintsStream(uid),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: CircularProgressIndicator(),
//                             );
//                           } else if (snapshot.hasError) {
//                             return Text("Error loading fingerprints");
//                           }
//                           final fingerprints = snapshot.data ?? [];
//
//                           return Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Color(0xffF4F4F4)),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(10),
//                               child: Column(
//                                 children: [
//                                   // List of fingerprints
//                                   ListView.builder(
//                                     shrinkWrap: true,
//                                     physics: NeverScrollableScrollPhysics(),
//                                     itemCount: fingerprints.length,
//                                     itemBuilder: (context, index) {
//                                       return ListTile(
//                                         leading: Icon(Icons.fingerprint,
//                                             color: Color(0xff4979FB)),
//                                         title: Text(
//                                           '${fingerprints[index].fingerprintName ?? "Fingerprint ${index + 1}"} (ID: ${fingerprints[index].id ?? ""})',
//                                           style: GoogleFonts.getFont('Poppins',
//                                               fontWeight: FontWeight.w400),
//                                           textScaler: TextScaler.linear(
//                                               ScaleSize.textScaleFactor(context)),
//                                         ),
//                                         trailing: IconButton(
//                                           icon: Icon(Icons.delete,
//                                               color: Colors.red),
//                                           onPressed: () async {
//                                             if(deleteStatus=='Ready')
//                                             {
//                                               await updatingCommandsDeleteFingerprint.update({
//                                                 "deleteFingerprint": fingerprints[index].id,
//
//                                               });
//                                               if(deleteStatus=='Deleted')
//                                               {
//                                                 await FingerprintDao
//                                                     .deleteFingerprintForUser(uid,
//                                                     fingerprints[index].docID!);
//                                                 showSnackbar('deleted successfully', Colors.green);
//
//                                               }
//                                             // await FingerprintDao
//                                             //     .deleteFingerprintForUser(uid,
//                                             //         fingerprints[index].docID!);
//                                             }
//                                             // if(deleteStatus=='Deleted')
//                                             // {
//                                             //   await FingerprintDao
//                                             //       .deleteFingerprintForUser(uid,
//                                             //       fingerprints[index].docID!);
//                                             //   showSnackbar('deleted successfully', Colors.green);
//                                             //
//                                             // }
//                                           },
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   // "Add new fingerprint" tile
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(12),
//                                       color: Color(0xffF4F4F4),
//                                     ),
//                                     child: ListTile(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 AddNewFingerprint(),
//                                           ),
//                                         );
//                                       },
//                                       leading: Icon(
//                                         Icons.fingerprint,
//                                         color: Color(0xff4979FB),
//                                       ),
//                                       title: Text(
//                                         "Add new fingerprint",
//                                         style: GoogleFonts.getFont(
//                                           'Poppins', fontWeight: FontWeight.w400,
//                                           // fontSize: 14,
//                                         ),
//                                         textScaler: TextScaler.linear(
//                                             ScaleSize.textScaleFactor(context)),
//                                       ),
//                                       trailing: Icon(
//                                           Icons.arrow_forward_ios_rounded,
//                                           color: Colors.grey.shade400),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                     } else
//                     {
//                       return const Text('No status found');
//                     }
//                     },
//                   )
//                 ]),
//           ),
//         ));
//   }
// }
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
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
  final DatabaseReference dbRefDeleteStatus = FirebaseDatabase.instance.ref("fingerprint/delete/status");
  final DatabaseReference dbRefDeleteCommand = FirebaseDatabase.instance.ref("commands/deleteFingerprint");

  StreamSubscription<DatabaseEvent>? deleteListener;
  String? deletingFingerprintId;

  @override
  void initState() {
    super.initState();
    _listenForDeletedStatus();
  }

  void _listenForDeletedStatus() {
    deleteListener = dbRefDeleteStatus.onValue.listen((event) async {
      final status = event.snapshot.value?.toString();
      if (status == "Deleted" && deletingFingerprintId != null) {
        final uid = Provider.of<AppAuthProvider>(context, listen: false).firebaseAuthUser?.uid ?? '';
        await FingerprintDao.deleteFingerprintForUser(uid, deletingFingerprintId!);
        // await dbRefDeleteStatus.set("Idle");
        if (mounted) {
          showSnackbar("Fingerprint deleted successfully", Colors.green);
        }
        setState(() {
          deletingFingerprintId = null;
        });
      }
    });
  }

  @override
  void dispose() {
    deleteListener?.cancel();
    super.dispose();
  }

  void showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AppAuthProvider>(context, listen: false).firebaseAuthUser?.uid ?? '';
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fingerprint',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset('assets/Images/fingerPrint.png'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'To ensure you receive your medicine safely, please add your fingerprint.',
                style: GoogleFonts.inter(fontWeight: FontWeight.w300, fontSize: 20),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fingerprints',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 20),
                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
              ),
            ),
            StreamBuilder<List<FingerPrintsData>>(
              stream: FingerprintDao.getFingerprintsStream(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error loading fingerprints");
                }

                final fingerprints = snapshot.data ?? [];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xffF4F4F4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fingerprints.length,
                          itemBuilder: (context, index) {
                            final fingerprint = fingerprints[index];

                            return ListTile(
                              leading: const Icon(Icons.fingerprint, color: Color(0xff4979FB)),
                              title: Text(
                                '${fingerprint.fingerprintName ?? "Fingerprint ${index + 1}"} (ID: ${fingerprint.id ?? ""})',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                                textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Center(child: const Text("Confirm Deletion"
                                        ,style: TextStyle(fontSize: 20),
                                      )
                                      ),
                                      content: const Text("Are you sure you want to delete this fingerprint?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true && fingerprint.id != null && fingerprint.docID != null) {
                                    await dbRefDeleteCommand.set(fingerprint.id);
                                    await dbRefDeleteStatus.set("Ready");
                                    setState(() {
                                      deletingFingerprintId = fingerprint.docID;
                                    });
                                  }
                                }
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xffF4F4F4),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddNewFingerprint(),
                                ),
                              );
                            },
                            leading: const Icon(Icons.fingerprint, color: Color(0xff4979FB)),
                            title: Text(
                              "Add new fingerprint",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
