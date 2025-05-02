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

class MedicineScreen extends StatefulWidget {
  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  int selectedIndex = 1;
  List<MedicineUser> currentMedicines = [];
  List<MedicineUser> historyMedicines = [];
  List<MedicineUser> filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    fetchCurrentMedicines();
  }

  void fetchCurrentMedicines() async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    String? uid = authProvider.firebaseAuthUser?.uid;

    if (uid != null) {
      List<MedicineUser> medicines = await MedicineDao.getMedicinesForUser(uid);
      setState(() {
        currentMedicines = medicines;
        filteredMedicines = List.from(currentMedicines);
      });
    }
  }

  void deleteMedicine(int index) {
    setState(() {
      historyMedicines.add(currentMedicines[index]);
      currentMedicines.removeAt(index);
      filteredMedicines = List.from(currentMedicines);
    });
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
              onChanged: filterMedicines,
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
                      children: [
                        ListView.builder(
                          itemCount: filteredMedicines.length,
                          itemBuilder: (context, index) {
                            return MedicineCard(
                              name:
                                  filteredMedicines[index].medName ?? "Unknown",
                              schedule:
                                  filteredMedicines[index].intakeTimes ?? [],
                              onDelete: () => deleteMedicine(index),
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddMedicationScreen(
                                      isEditing: true,
                                      medicine: currentMedicines[index],
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  if (result["isEditing"] == true) {
                                    setState(() {
                                      currentMedicines[index] =
                                          result["updatedMedicine"];
                                      filteredMedicines =
                                          List.from(currentMedicines);
                                    });
                                  }
                                }
                              },
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: historyMedicines.length,
                          itemBuilder: (context, index) {
                            return MedicineCard(
                              name:
                                  filteredMedicines[index].medName ?? "Unknown",
                              schedule:
                                  filteredMedicines[index].intakeTimes ?? [],
                              onDelete: () {},
                              onEdit: () {},
                            );
                          },
                        ),
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
              setState(() {
                currentMedicines.add(result["newMedicine"]);
                filteredMedicines = List.from(currentMedicines);
              });
            }
          }
        },
        // onPressed: addMedicine,
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Color(0xff4979FB).withOpacity(0.9),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String name;
  final List<String> schedule;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  MedicineCard(
      {required this.name,
      required this.schedule,
      required this.onDelete,
      required this.onEdit});

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
          schedule.isNotEmpty ? schedule.join(", ") : "No schedule available",
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
          style: GoogleFonts.getFont(
            'Poppins', fontWeight: FontWeight.w500,
            // fontSize: 14,
          ),
        ),
        trailing: Row(
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
              onTap: onDelete,
              child: Icon(Icons.delete_forever, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
