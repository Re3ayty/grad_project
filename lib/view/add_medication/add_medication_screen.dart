import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import '../Auth/select_page.dart';
import '../filling/filling.dart';
import 'multiSelesctDialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import '../../viewModel/medicine_dao.dart';
import '../../model/user_medicine.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  Color borderColorDose = Color(0xffF9F9F9);
  Color borderColorContainer = Color(0xffF9F9F9);
  Color borderColorIntake = Color(0xffF9F9F9);
  String intakeText = 'Add intake time';
  TextEditingController medicineController = TextEditingController();
  List<String> medicineList = [];
  MedicineUser? newMedicine;
  List<int> usedContainerNumbers = [];

  final formKey = GlobalKey<FormState>();
  int doseAmount = 0;
  int containerNumber = 0;
  DateTime? startDate;
  DateTime? endDate;
  bool isOngoing = false;
  String frequency = 'Daily';
  List<String> selectedDays = [];
  final List<String> days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
  List<TimeOfDay> intakeTimes = [];
  Future<void> selectTime(BuildContext context, [int? index]) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: index != null ? intakeTimes[index] : TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (index != null) {
          intakeTimes[index] = picked;
        } else {
          intakeTimes.add(picked);
        }
      });
    }
    if (intakeTimes.length != 0) {
      setState(() {
        intakeText = 'Add another intake time';
      });
    }
  }

  void editTime(int index) {
    selectTime(context, index);
  }

  void deleteTime(int index) {
    setState(() {
      intakeTimes.removeAt(index);
    });
  }

  void selectFrequency(BuildContext context) async {
    switch (await showDialog<FrequencyOption>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Frequency',
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                textScaler: TextScaler.linear(
                  ScaleSize.textScaleFactor(context),
                )),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FrequencyOption.daily);
                },
                child: Text('Daily',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    textScaler: TextScaler.linear(
                      ScaleSize.textScaleFactor(context),
                    )),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FrequencyOption.specificDays);
                },
                child: Text('Specific Days',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    textScaler: TextScaler.linear(
                      ScaleSize.textScaleFactor(context),
                    )),
              ),
            ],
          );
        })) {
      case FrequencyOption.daily:
        setState(() {
          frequency = 'Daily';
          selectedDays.clear();
        });
        break;
      case FrequencyOption.specificDays:
        selectDays();
        break;
      case null:
        break;
    }
  }

  void selectDays() async {
    final List<String> daysSelected = await showDialog<List<String>>(
            context: context,
            builder: (BuildContext context) {
              return MultiSelectDialog(
                days: days,
                selectedDays: selectedDays,
              );
            }) ??
        [];
    setState(() {
      selectedDays = daysSelected;
      frequency =
          selectedDays.isEmpty ? 'Specific Days' : selectedDays.join(', ');
    });
  }

  @override
  void initState() {
    super.initState();
    loadMedicineData();
    fetchUserContainerNumbers();
  }

  void fetchUserContainerNumbers() async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    String? uid = authProvider.firebaseAuthUser?.uid;

    if (uid != null) {
      List<int> usedNumbers = await MedicineDao.getUsedContainerNumbers(uid);
      setState(() {
        usedContainerNumbers = usedNumbers;
      });
    }
  }

  Future<void> saveMedication() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    String? uid = authProvider.firebaseAuthUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    List<String> formattedIntakeTimes =
        intakeTimes.map((time) => time.format(context)).toList();
    newMedicine = MedicineUser(
      medName: medicineController.text,
      dose: doseAmount,
      containerNumber: containerNumber,
      ongoing: isOngoing,
      frequency: frequency,
      startDate: startDate,
      endDate: isOngoing ? null : endDate,
      intakeTimes: formattedIntakeTimes,
    );

    //save to firestore
    try {
      await MedicineDao.addMedicineToUser(uid, newMedicine!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Medication added successfully")));
      Navigator.pop(context); // Navigate back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falied to add medication: $e")));
    }
  }

  Future<void> loadMedicineData() async {
    final String data =
        await rootBundle.loadString('assets/data_set/medicine.csv');
    List<String> lines = LineSplitter.split(data).toList();

    List<String> medicines = lines.skip(1).map((line) {
      List<String> values = line.split(',');
      return values[1]; // Extracting the "English Name" column
    }).toList();

    setState(() {
      medicineList = medicines;
    });
  }

  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Add Medicines',
          style: GoogleFonts.getFont(
            'Poppins', fontWeight: FontWeight.w500,
            // fontSize: 18,
          ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        )),
      ),
      body: Padding(
        padding: EdgeInsets.all(h * 0.02),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /////////////////////// Medication name ///////////////////////////////////
              Text(
                'Medication name',
                textScaler:
                    TextScaler.linear(ScaleSize.textScaleFactor(context)),
                style: GoogleFonts.getFont(
                  'Poppins', fontWeight: FontWeight.w500,
                  // fontSize: 14,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.02),
                child: TypeAheadFormField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    cursorColor: Color(0xff4979FB),
                    controller: medicineController,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff4979FB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Panadol',
                      suffixIcon:
                          Icon(CupertinoIcons.search, color: Colors.grey),
                      hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Color(0xffF9F9F9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffF9F9F9)),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return medicineList.where((medicine) =>
                        medicine.toLowerCase().contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  onSuggestionSelected: (String suggestion) {
                    medicineController.text = suggestion;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a medication name';
                    }
                    return null;
                  },
                ),
              ),
              /////////////////////// Dose Amount/Container //////////////////////////
              Padding(
                padding: EdgeInsets.only(bottom: h * 0.02),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(h * 0.0111),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Dose Amount',
                                style: GoogleFonts.getFont(
                                  'Poppins', fontWeight: FontWeight.w500,
                                  // fontSize: 14,
                                ),
                                textScaler: TextScaler.linear(
                                    ScaleSize.textScaleFactor(context)),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: doseAmount > 1
                                        ? () {
                                            setState(() {
                                              doseAmount--;
                                            });
                                          }
                                        : null,
                                  ),
                                  Text(
                                    '$doseAmount',
                                    style: GoogleFonts.getFont(
                                      'Poppins', fontWeight: FontWeight.w400,
                                      // fontSize: 13,
                                    ),
                                    textScaler: TextScaler.linear(
                                        ScaleSize.textScaleFactor(context)),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: doseAmount < 3
                                        ? () {
                                            setState(() {
                                              doseAmount++;
                                            });
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColorDose,
                            ),
                            color: Color(0xffF9F9F9),
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(h * 0.0111),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Container number',
                                style: GoogleFonts.getFont(
                                  'Poppins', fontWeight: FontWeight.w500,
                                  // fontSize: 14,
                                ),
                                textScaler: TextScaler.linear(
                                    ScaleSize.textScaleFactor(context)),
                              ),
                              DropdownButton<int>(
                                value: containerNumber,
                                items: List.generate(6, (index) => index + 1)
                                    .map((num) => DropdownMenuItem(
                                        value: num,
                                        enabled: !usedContainerNumbers
                                            .contains(containerNumber),
                                        child: Text(
                                          '$num',
                                          style: GoogleFonts.getFont(
                                            'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: usedContainerNumbers
                                                    .contains(containerNumber)
                                                ? Colors.grey
                                                : Colors.black,
                                            // fontSize: 13,
                                          ),
                                          textScaler: TextScaler.linear(
                                              ScaleSize.textScaleFactor(
                                                  context)),
                                        )))
                                    .toList(),
                                onChanged: (value) async {
                                  if (value != null &&
                                      !usedContainerNumbers.contains(value)) {
                                    setState(() {
                                      containerNumber = value;                                    });
                                  } else {
                                    print("Container number $value is already in use.")
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: borderColorContainer),
                            color: Color(0xffF9F9F9),
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    )
                  ],
                ),
              ),
              //////////////////////////////// Start Date //////////////////////////
              Padding(
                padding: EdgeInsets.only(bottom: h * 0.02),
                child: Container(
                  width: w * 100.0,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: EdgeInsets.all(h * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: GoogleFonts.getFont(
                            'Poppins', fontWeight: FontWeight.w500,
                            // fontSize: 14,
                          ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a start date';
                              } else if (value == 'null-null-null') {
                                return 'Enter a start date';
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: Color(0xff4979FB),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4979FB)),
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Color(0xffF9F9F9),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xffF9F9F9))),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  startDate = pickedDate;
                                });
                              }
                            },
                            controller: TextEditingController(
                                text:
                                    '${startDate?.day}-${startDate?.month}-${startDate?.year}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ////////////////////// end date //////////////////////////////////////

              if (!isOngoing)
                Container(
                  width: w * 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: EdgeInsets.all(h * 0.0111),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: GoogleFonts.getFont(
                            'Poppins', fontWeight: FontWeight.w500,
                            // fontSize: 14,
                          ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a end date';
                              } else if (value == 'null-null-null') {
                                return 'Enter a end date';
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: Color(0xff4979FB),
                              ),
                              fillColor: Color(0xffF9F9F9),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4979FB)),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xffF9F9F9))),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  endDate = pickedDate;
                                });
                              }
                            },
                            controller: TextEditingController(
                                text:
                                    '${endDate?.day}-${endDate?.month}-${endDate?.year}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Row(
                children: [
                  Checkbox(
                    activeColor: Color(0xff4979FB),
                    value: isOngoing,
                    onChanged: (value) {
                      setState(() {
                        isOngoing = value!;
                      });
                    },
                  ),
                  Text(
                    "Ongoing",
                    style: GoogleFonts.getFont(
                      'Poppins', fontWeight: FontWeight.w500,
                      // fontSize: 14,
                    ),
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                ],
              ),
              ////////////////// Frequency //////////////////////////////////////
              Padding(
                padding: EdgeInsets.only(bottom: h * 0.02),
                child: Container(
                  width: w * 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: EdgeInsets.all(h * 0.0111),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frequency',
                          style: GoogleFonts.getFont(
                            'Poppins', fontWeight: FontWeight.w500,
                            // fontSize: 14,
                          ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              suffixIcon: IconButton(
                                  onPressed: () => selectFrequency(context),
                                  icon: Icon(
                                    Icons.navigate_next,
                                    color: Colors.grey,
                                  )),
                              fillColor: Color(0xffF9F9F9),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4979FB)),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xffF9F9F9))),
                            ),
                            readOnly: true,
                            onTap: () => selectFrequency(context),
                            controller:
                                TextEditingController(text: '$frequency'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ///////////////////////// Intake Time //////////////////////////////
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: borderColorIntake),
                    color: Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: EdgeInsets.all(h * 0.0111),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intake Times',
                        style: GoogleFonts.getFont(
                          'Poppins', fontWeight: FontWeight.w500,
                          // fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(
                            ScaleSize.textScaleFactor(context)),
                      ),
                      for (int i = 0; i < intakeTimes.length; i++)
                        ListTile(
                          title: Text(intakeTimes[i].format(context)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Color(0xff4979FB),
                                ),
                                onPressed: () => editTime(i),
                              ),
                              if (intakeTimes.length > 1)
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteTime(i);
                                  },
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => selectTime(context),
                      icon: Icon(
                        CupertinoIcons.plus_app_fill,
                        color: Color(0xff4979FB),
                      )),
                  Text(
                    intakeText,
                    style: GoogleFonts.getFont(
                      'Poppins', fontWeight: FontWeight.w500,
                      // fontSize: 14,
                    ),
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  )
                ],
              ),
              SizedBox(
                height: 47,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xff4979FB)),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  onPressed: () {
                    bool isDoseMissing = doseAmount == 0;
                    bool isContainerMissing = containerNumber == 0;
                    bool isIntakeMissing = intakeTimes.isEmpty;
                    setState(() {
                      borderColorDose = isDoseMissing
                          ? Colors.red.shade800
                          : Colors.transparent;
                      borderColorContainer = isContainerMissing
                          ? Colors.red.shade800
                          : Colors.transparent;
                      borderColorIntake = isIntakeMissing
                          ? Colors.red.shade800
                          : Colors.transparent;
                    });

                    if (isDoseMissing ||
                        isContainerMissing ||
                        isIntakeMissing) {
                      return;
                    }
                    //initialize authProvider and MedicineUser to save in the filled.dart file
                    var authProvider =
                        Provider.of<AppAuthProvider>(context, listen: false);
                    String? uid = authProvider.firebaseAuthUser?.uid;
                    List<String> formattedIntakeTimes = intakeTimes
                        .map((time) => time.format(context))
                        .toList();
                    newMedicine = MedicineUser(
                      medName: medicineController.text,
                      dose: doseAmount,
                      containerNumber: containerNumber,
                      ongoing: isOngoing,
                      frequency: frequency,
                      startDate: startDate,
                      endDate: isOngoing ? null : endDate,
                      intakeTimes: formattedIntakeTimes,
                    );
                    // logOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PillAnimationScreen(
                                  uid: uid!,
                                  newMedicine: newMedicine!,
                                )));
                    // CategoryPage()
                    // ),
                    // );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Set up reminder',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),
                      ),
                      Icon(CupertinoIcons.bell, color: Colors.white),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void logOut() {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    authProvider.signOut();
  }
}

enum FrequencyOption { daily, specificDays }
