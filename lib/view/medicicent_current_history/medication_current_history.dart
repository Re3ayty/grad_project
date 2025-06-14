import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcs_grad_project/utils/app_routes_new.dart';
import 'package:hcs_grad_project/view/add_medication/add_medication_screen.dart';
import 'package:hcs_grad_project/viewModel/provider/app_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../viewModel/medicine_dao.dart';
import '../../model/user_medicine.dart';

import '../../utils/responsive_text.dart';
import '../filling/filling.dart';

class MedicineScreen extends StatefulWidget {
  final MedicineUser? newMedicine;

  const MedicineScreen({Key? key, this.newMedicine}) : super(key: key);
  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 1;

  List<MedicineUser> currentMedicines = [];
  List<MedicineUser> historyMedicines = [];
  List<MedicineUser> filteredMedicines = [];
  List<MedicineUser> filteredHistoryMedicines = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchCurrentMedicines();
    fetchHistoryMedicines();
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          filteredMedicines = List.from(currentMedicines);
        });
      } else if (_tabController.index == 1) {
        setState(() {
          filteredHistoryMedicines = List.from(historyMedicines);
        });
      }
    });
    // filterHistoryMedicines();
    // filterMedicines();
  }

  @override
  void dipose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchCurrentMedicines() async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    String? uid = authProvider.firebaseAuthUser?.uid;

    if (uid != null) {
      List<MedicineUser> medicines = await MedicineDao.getMedicinesForUser(uid);
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        currentMedicines = medicines;
        filteredMedicines = List.from(currentMedicines);
      });
      moveEndedMedicinesToHistory();
    }
  }

  void fetchHistoryMedicines() async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    String? uid = authProvider.firebaseAuthUser?.uid;
    if (uid != null) {
      List<MedicineUser> medicines =
          await MedicineDao.getHistoryMedicinesForUser(uid);
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        historyMedicines = medicines;
        filteredHistoryMedicines = List.from(historyMedicines);
      });
    }
  }

  void deleteMedicine(int index) async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    String? uid = authProvider.firebaseAuthUser?.uid;

    if (uid == null || index < 0 || index >= currentMedicines.length) {
      // Ensure the index is valid and the user is authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid operation")),
      );
      return;
    }
    MedicineUser medicineToDelete = currentMedicines[index];
    String medicineId = medicineToDelete.id!;

    try {
      await MedicineDao.moveMedicineToHistory(uid!, medicineId);
      await FirebaseDatabase.instance
          .ref()
          .child('medications')
          .child(medicineId)
          .remove();
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        currentMedicines.remove(medicineToDelete);
        filteredMedicines = List.from(currentMedicines);
        historyMedicines.add(medicineToDelete);
        filteredHistoryMedicines = List.from(historyMedicines);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Medicine moved to history"),
        ),
      );
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to move medicine to history: $e"),
        ),
      );
    }
  }

  void moveEndedMedicinesToHistory() async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    String? uid = authProvider.firebaseAuthUser?.uid;
    if (uid == null) return;

    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    for (var medicine in List<MedicineUser>.from(currentMedicines)) {
      if (medicine.endDate != null) {
        DateTime enddate = DateTime(
          medicine.endDate!.year,
          medicine.endDate!.month,
          medicine.endDate!.day,
        );
        if (enddate.isBefore(today)) {
          try {
            await MedicineDao.moveMedicineToHistory(uid, medicine.id!);
          } catch (e) {}
        }
      }
    }
  }
  // void editMedicine(int index) {
  //   TextEditingController nameController =
  //       TextEditingController(text: currentMedicines[index].medName ?? "");
  //   TextEditingController scheduleController =
  //       TextEditingController(text: currentMedicines[index].intakeTimes?.join(", ") ??
  //           "");

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Edit Medicine"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: nameController,
  //               decoration: InputDecoration(labelText: "Medicine Name"),
  //             ),
  //             TextField(
  //               controller: scheduleController,
  //               decoration: InputDecoration(labelText: "Schedule"),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 currentMedicines[index] = currentMedicines[index].copyWith(
  //                   medName: nameController.text,
  //                   intakeTimes: scheduleController.text.split(", "),
  //                 );
  //                 filteredMedicines = List.from(currentMedicines);
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: Text("Save"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void filterMedicines(String query) {
    setState(() {
      filteredMedicines = currentMedicines
          .where((medicine) =>
              medicine.medName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void filterHistoryMedicines(String query) {
    setState(() {
      filteredHistoryMedicines = historyMedicines
          .where((medicine) =>
              medicine.medName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // void addMedicine() {
  //   TextEditingController nameController = TextEditingController();
  //   TextEditingController scheduleController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Add Medicine"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: nameController,
  //               decoration: InputDecoration(labelText: "Medicine Name"),
  //             ),
  //             TextField(
  //               controller: scheduleController,
  //               decoration: InputDecoration(labelText: "Schedule"),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 currentMedicines.add({
  //                   "name": nameController.text,
  //                   "schedule": scheduleController.text,
  //                 });
  //                 filteredMedicines = List.from(currentMedicines);
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: Text("Add"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Medicines",
          style: GoogleFonts.getFont(
            'Poppins', fontWeight: FontWeight.w500,
            // fontSize: 18,
          ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              cursorColor: Color(0xff4979FB),
              onChanged: (query) {
                if (_tabController.index == 0) {
                  //to search in current medicines
                  filterMedicines(query);
                } else {
                  //to search in history medicines
                  filterHistoryMedicines(query);
                }
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff4979FB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                hintText: 'Search',
                hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400, fontSize: 13),
                filled: true,
                fillColor: Color(0xffF9F9F9),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffF9F9F9)),
                ),
              ),
            ),
          ),
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Color(0xff4979FB),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Current"),
                      Tab(text: "History"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        StreamBuilder<List<MedicineUser>>(
                          stream: MedicineDao.getCurrentMedicinesStream(
                              Provider.of<AppAuthProvider>(context,
                                      listen: false)
                                  .firebaseAuthUser!
                                  .uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: Text("No medicines found."));
                            }
                            if (snapshot.hasData) {
                              if (currentMedicines != snapshot.data!) {
                                currentMedicines = snapshot.data!;
                              }
                              if (filteredMedicines.isEmpty) {
                                filteredMedicines = List.from(currentMedicines);
                              }
                            }
                            return ListView.builder(
                              itemCount: filteredMedicines.length,
                              itemBuilder: (context, index) {
                                return MedicineCard(
                                    medicine: filteredMedicines[index],

                                    name: filteredMedicines[index].medName ??
                                        "Unknown",
                                    frequency:
                                        filteredMedicines[index].frequency ??
                                            "Unknown",
                                    schedule:
                                        filteredMedicines[index].intakeTimes ??
                                            [],
                                    onDelete: () => deleteMedicine(index),
                                    onEdit: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddMedicationScreen(
                                                  isEditing: true,
                                                  medicine:
                                                      currentMedicines[index],
                                                )),
                                      );
                                      if (result != null) {
                                        // setState(() {
                                        //   currentMedicines[index] =
                                        //       MedicineUser.fromFireStore(
                                        //           result["uid"] ?? "",
                                        //           result
                                        //               as Map<String, dynamic>?);
                                        //   filteredMedicines =
                                        //       List.from(currentMedicines);
                                        // });
                                      }
                                    });
                              },
                            );
                          },
                        ),
                        StreamBuilder<List<MedicineUser>>(
                          stream: MedicineDao.getHistoryMedicinesStream(
                              Provider.of<AppAuthProvider>(context,
                                      listen: false)
                                  .firebaseAuthUser!
                                  .uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: Text("No medicines found."));
                            }

                            if (snapshot.hasData) {
                              if (historyMedicines != snapshot.data!) {
                                historyMedicines = snapshot.data!;
                              }
                              if (filteredHistoryMedicines.isEmpty) {
                                filteredHistoryMedicines =
                                    List.from(historyMedicines);
                              }
                            }

                            return ListView.builder(
                              itemCount: filteredHistoryMedicines.length,
                              itemBuilder: (context, index) {
                                return MedicineCard(
                                  name:
                                      filteredHistoryMedicines[index].medName ??
                                          "Unknown",
                                  frequency: filteredHistoryMedicines[index]
                                          .frequency ??
                                      "Unknown",
                                  schedule: filteredHistoryMedicines[index]
                                          .intakeTimes ??
                                      [],
                                  isHistory: true,
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMedicationScreen(
                      isEditing: false,
                    )),
          );
          if (result != null) {
            if (result["isEditing"] == false) {
              // setState(() {
              //   currentMedicines.add(MedicineUser.fromFireStore(
              //     result["newMedicine"]["uid"] ?? "",
              //     result["newMedicine"] as Map<String, dynamic>?,
              //   ));
              //   filteredMedicines = List.from(currentMedicines);
              // });
            }
          }
        },
        // onPressed: addMedicine,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff4979FB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String name;
  final MedicineUser? medicine;
  final String frequency;
  final List<String> schedule;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool
      isHistory; //to indicate that a card is in history to remove edit and delete buttons

  MedicineCard(
      {
         this.medicine, required this.name,
      required this.frequency,
      required this.schedule,
      this.onDelete,
      this.onEdit,
      this.isHistory = false});
  DatabaseReference refillData = FirebaseDatabase.instance.ref().child("refill");


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        title: Text(
          name,
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
          style: GoogleFonts.getFont(
            'Poppins', fontWeight: FontWeight.w500,
            // fontSize: 14,
          ),
        ),
        subtitle: Text(
          schedule.isNotEmpty
              ? "$frequency / ${schedule.join(", ")}"
              : "No schedule avaliable",
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
          style: GoogleFonts.getFont(
            'Poppins', fontWeight: FontWeight.w500,
            // fontSize: 14,
          ),
        ),
        trailing: isHistory
            ? null
            : // Show edit and delete buttons only if not in history
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    // onTap: () =>
                    //     Navigator.pushNamed(context, AppRoutes.addMedicationRoute),

                    child: Icon(Icons.edit, color: Color(0xff4979FB)),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {

                            return AlertDialog(
                              title: Center(
                                child: Text("Confirm Delete",style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500
                                  // fontSize: 14,
                                ),
                                  textAlign: TextAlign.center,
                                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                                ),
                              ),
                              content: Text(
                                  "Are you sure you want to delete this medication?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel",style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,color: Colors.black
                                      // fontSize: 14,
                                    ),
                                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                                    ),),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      if (onDelete != null) {
                                        onDelete!();
                                      }
                                    },
                                    child: Text(
                                      "Delete",style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,color: Colors.red
                                      // fontSize: 14,
                                    ),
                                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),

                                    ),),
                              ],
                            );
                          });
                    },
                    child: Icon(Icons.delete_forever, color: Colors.red),
                  ),
                  SizedBox(width: 10),
                  // GestureDetector(
                  //   onTap: () => Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               StreamBuilder<DatabaseEvent>(
                  //                 stream: refillData.onValue,
                  //                 builder: (context, snapshot) {
                  //                   if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  //                     final data = snapshot.data!.snapshot.value as Map;
                  //                     int slot = data['slot'] ?? 0;
                  //                     bool confirm = data['confirm'] ?? false;
                  //                     String state = data['state'] ?? 'complete';
                  //                     String request = data['request'] ?? 'processed';
                  //
                  //                     return PillAnimationScreen(
                  //                       uid: uid!,
                  //                       newMedicine: newMedicine!,
                  //                       refillDatafromRealTime:{
                  //                         'slot': slot,
                  //                         'confirm': confirm,
                  //                         'state': state,
                  //                         'request': request,
                  //                       },
                  //                     );
                  //                   } else if (snapshot.hasError) {
                  //                     return Text("Error: ${snapshot.error}");
                  //                   } else {
                  //                     return CircularProgressIndicator();
                  //                   }
                  //                 },
                  //               ))),
                  //   // onTap: () =>
                  //   //     Navigator.pushNamed(context, AppRoutes.addMedicationRoute),
                  //
                  //   child: Icon(Icons.replay_circle_filled, color:Colors.green),
                  // ),
                  // FutureBuilder<DocumentSnapshot>(
                  //   future: FirebaseFirestore.instance
                  //       .collection('usersInfo')
                  //       .doc(FirebaseAuth.instance.currentUser!.uid)
                  //       .collection('medication_to_take')
                  //       .doc(medicine!.medName!)
                  //       .get(),
                  //   builder: (context, firestoreSnapshot) {
                  //     if (!firestoreSnapshot.hasData || !firestoreSnapshot.data!.exists) {
                  //       return Icon(Icons.replay_circle_filled, color: Colors.grey); // default
                  //     }
                  //
                  //     int dose = int.tryParse(firestoreSnapshot.data!.get('dose').toString()) ?? 1;
                  //
                  //     return FutureBuilder<DatabaseEvent>(
                  //       future: FirebaseDatabase.instance
                  //           .ref()
                  //           .child('missedmed')
                  //           .child(medicine!.medName!)
                  //           .once(),
                  //       builder: (context, rtSnapshot) {
                  //         bool shouldRefill = false;
                  //
                  //         if (rtSnapshot.hasData && rtSnapshot.data!.snapshot.value != null) {
                  //           final data = rtSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  //
                  //           int acknowledgedCount = data.values
                  //               .where((value) => value.toString().toLowerCase() == 'acknowledged')
                  //               .length;
                  //
                  //           int maxAcks = (4 / dose).ceil();
                  //
                  //           if (acknowledgedCount >= maxAcks) {
                  //             shouldRefill = true;
                  //           }
                  //         }
                  //
                  //         return GestureDetector(
                  //           onTap: shouldRefill
                  //               ? () async {
                  //             var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
                  //             String? uid = authProvider.firebaseAuthUser?.uid;
                  //             if (uid == null) return;
                  //
                  //             await refillData.update({
                  //               "request": '${medicine?.containerNumber}[1,2,3,4]',
                  //             });
                  //
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => StreamBuilder<DatabaseEvent>(
                  //                   stream: refillData.onValue,
                  //                   builder: (context, snapshot) {
                  //                     if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  //                       final data = snapshot.data!.snapshot.value as Map;
                  //                       return PillAnimationScreen(
                  //                         uid: uid,
                  //                         newMedicine: medicine!,
                  //                         isRefill: true,
                  //                         refillDatafromRealTime: {
                  //                           'slot': data['slot'],
                  //                           'confirm': data['confirm'],
                  //                           'state': data['state'],
                  //                           'request': data['request'],
                  //                         },
                  //                       );
                  //                     } else {
                  //                       return Scaffold(body: Center(child: CircularProgressIndicator()));
                  //                     }
                  //                   },
                  //                 ),
                  //               ),
                  //             );
                  //           }
                  //               : null,
                  //           child: Icon(
                  //             Icons.replay_circle_filled,
                  //             color: shouldRefill ? Colors.green : Colors.grey,
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),

                  GestureDetector(
                    onTap: () async {
                      var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
                      String? uid = authProvider.firebaseAuthUser?.uid;
                      if (uid == null) return;

                      await refillData.update({
                        "request": '${medicine?.containerNumber}[1,2,3,4]',
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamBuilder<DatabaseEvent>(
                            stream: refillData.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                                final data = snapshot.data!.snapshot.value as Map;
                                int slot = data['slot'] ?? 0;
                                bool confirm = data['confirm'] ?? false;
                                String state = data['state'] ?? 'complete';
                                String request = data['request']?.toString() ?? 'processed';

                                return PillAnimationScreen(
                                  uid: uid,
                                  newMedicine: medicine!,
                                  isRefill: true,
                                  refillDatafromRealTime: {
                                    'slot': slot,
                                    'confirm': confirm,
                                    'state': state,
                                    'request': request,
                                  },
                                );
                              } else {
                                return Scaffold(
                                  body: Center(child: CircularProgressIndicator()),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.replay_circle_filled, color: Colors.green),
                  ),

                ],
              ),
      ),
    );
  }
}
