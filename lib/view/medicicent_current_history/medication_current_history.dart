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
      // print("Fetched medicines: $medicines"); //debug
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        currentMedicines = medicines;
        filteredMedicines = List.from(currentMedicines);
        // print("filtered medicines: $filteredMedicines"); //debug
      });
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
    String medicineId = currentMedicines[index].id!;
    try {
      await MedicineDao.moveMedicineToHistory(uid!, medicineId);
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        historyMedicines.add(currentMedicines[index]);
        currentMedicines.removeAt(index);
        filteredMedicines = List.from(currentMedicines);
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
                      children: [
                        ListView.builder(
                          itemCount: filteredMedicines.length,
                          itemBuilder: (context, index) {
                            // print("building card for index: $index"); //debug
                            return MedicineCard(
                              name:
                                  filteredMedicines[index].medName ?? "Unknown",
                              frequency: filteredMedicines[index].frequency ??
                                  "Unknown",
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
                              name: filteredHistoryMedicines[index].medName ??
                                  "Unknown",
                              frequency:
                                  filteredHistoryMedicines[index].frequency ??
                                      "Unknown",
                              schedule:
                                  filteredHistoryMedicines[index].intakeTimes ??
                                      [],
                              isHistory: true,
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
  final String frequency;
  final List<String> schedule;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool
      isHistory; //to indicate that a card is in history to remove edit and delete buttons

  MedicineCard(
      {required this.name,
      required this.frequency,
      required this.schedule,
      this.onDelete,
      this.onEdit,
      this.isHistory = false});

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
                    onTap: onDelete,
                    child: Icon(Icons.delete_forever, color: Colors.red),
                  ),
                ],
              ),
      ),
    );
  }
}
