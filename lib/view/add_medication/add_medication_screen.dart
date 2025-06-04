import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
import '../medicicent_current_history/medication_current_history.dart';

class AddMedicationScreen extends StatefulWidget {
  final MedicineUser? medicine; //to edit
  final bool isEditing; //differentiation flag between add and edit

  const AddMedicationScreen({Key? key, this.medicine, this.isEditing = false})
      : super(key: key);

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
  late DatabaseReference dbRef;
  String frequency = 'Daily';
  List<String> selectedDays = [];
  bool isRunning = false;
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

  void editIntakeTime(int index) {
    selectTime(context, index);
  }

  void deleteIntakeTime(int index) {
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
    dbRef = FirebaseDatabase.instance.ref().child('medications');
    loadMedicineData();
    fetchUserContainerNumbers();

    //pre-fill if isEditing is true
    if (widget.isEditing && widget.medicine != null) {
      medicineController.text = widget.medicine!.medName ?? '';
      doseAmount = widget.medicine!.dose ?? 0;
      containerNumber = widget.medicine!.containerNumber ?? 0;
      isOngoing = widget.medicine!.ongoing ?? false;
      frequency = widget.medicine!.frequency ?? 'Daily';
      startDate = widget.medicine!.startDate;
      endDate = widget.medicine!.endDate;
      intakeTimes = widget.medicine!.intakeTimes
              ?.map((time) {
                try {
                  // Parse the time string with AM/PM using DateFormat
                  final dateTime = DateFormat('HH:mm').parse(time);
                  return TimeOfDay.fromDateTime(dateTime);
                } catch (e) {
                  print("Invalid time format: $time");
                  return null; // Skip invalid times
                }
              })
              .where((time) => time != null) // Remove null values
              .cast<TimeOfDay>()
              .toList() ??
          [];
    }
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

  String formatTimeOfDay24Hour(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dateTime);
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
    final dateFormat = DateFormat('dd/MM/yyyy');
    String? formattedStartDate =
        startDate != null ? dateFormat.format(startDate!) : null;
    String? formattedEndDate =
        endDate != null ? dateFormat.format(endDate!) : null;
    List<String> formattedIntakeTimes =
        intakeTimes.map((time) => formatTimeOfDay24Hour(time)).toList();
    if (widget.isEditing && widget.medicine != null) {
      //update firestore
      try {
        await MedicineDao.updateMedicineForUser(uid, widget.medicine!.id!, {
          "med_name": medicineController.text,
          "dose": doseAmount,
          "container_no": containerNumber,
          "ongoing": isOngoing,
          "frequency": frequency,
          "start_date": formattedStartDate,
          "end_date": isOngoing ? null : formattedEndDate,
          "intake_times": formattedIntakeTimes,
        });
        await FirebaseDatabase.instance
            .ref()
            .child('medications')
            .child(widget.medicine!.id!)
            .update({
          'med_name': medicineController.text,
          'dose': doseAmount,
          'container_no': containerNumber,
          'ongoing': isOngoing,
          'frequency': frequency,
          'start_date': formattedStartDate,
          'end_date': isOngoing ? null : formattedEndDate,
          'intake_times': formattedIntakeTimes,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Medication updated successfully!")));
        Navigator.pop(context, {
          "isEditing": true,
          "updatedMedicine": widget.medicine!.copyWith(
            medName: medicineController.text,
            dose: doseAmount,
            containerNumber: containerNumber,
            ongoing: isOngoing,
            frequency: frequency,
            startDate: startDate,
            endDate: endDate,
            intakeTimes: formattedIntakeTimes,
          ),
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update medication: $e")));
      }
    } else {
      //save to firestore
      try {
        await MedicineDao.addMedicineToUser(uid, newMedicine!);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Medication added successfully")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add medication: $e")));
      }
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
                              widget.isEditing // when in editing mode, display containerNumber as text
                                  ? Text(
                                      '$containerNumber',
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    )
                                  : DropdownButton<int>(
                                      value: containerNumber,
                                      items: [0, 1, 2, 3, 4]
                                          .where((num) => !usedContainerNumbers
                                              .contains(num))
                                          .map((num) => DropdownMenuItem(
                                              value: num,
                                              child: Text(
                                                '$num',
                                                style: GoogleFonts.getFont(
                                                  'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  // color: usedContainerNumbers
                                                  //         .contains(containerNumber)
                                                  //     ? Colors.grey
                                                  //     : Colors.black,
                                                  // fontSize: 13,
                                                ),
                                                textScaler: TextScaler.linear(
                                                    ScaleSize.textScaleFactor(
                                                        context)),
                                              )))
                                          .toList(),
                                      onChanged: (value) async {
                                        if (value != null) {
                                          setState(() {
                                            containerNumber = value;
                                          });
                                          // } else {
                                          //   print(
                                          //       "Container number $value is already in use.");
                                          // }
                                        }
                                        ;
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
                          title: Text(
                            formatTimeOfDay24Hour(intakeTimes[i]),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Color(0xff4979FB),
                                ),
                                onPressed: () => editIntakeTime(i),
                              ),
                              if (intakeTimes.length > 1)
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteIntakeTime(i);
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
                  onPressed: () async {
                    if (isRunning) return; // Prevent multiple taps
                    setState(() {
                      isRunning = true;
                    });
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
                    if (formKey.currentState?.validate() == false) {
                      setState(() {
                        isRunning = false;
                      });
                      return;
                    }
                    if (isDoseMissing ||
                        isContainerMissing ||
                        isIntakeMissing) {
                      setState(() {
                        isRunning = false;
                      });
                      return;
                    }
                    try {
                      if (widget.isEditing && widget.medicine != null) {
                        //update firestore
                        await saveMedication();
                      } else {
                        //initialize authProvider and MedicineUser to save in the filled.dart file
                        var authProvider = Provider.of<AppAuthProvider>(context,
                            listen: false);
                        String? uid = authProvider.firebaseAuthUser?.uid;
                        List<String> formattedIntakeTimes = intakeTimes
                            .map((time) => formatTimeOfDay24Hour(time))
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

                        Map<dynamic, dynamic> medication = {
                          'container_no': containerNumber,
                          'dose': doseAmount,
                          'end_date':
                              '${endDate?.day}/${endDate?.month}/${endDate?.year}',
                          'frequency': frequency,
                          'intake_times': formattedIntakeTimes,
                          'med_name': medicineController.text,
                          'ongoing': isOngoing,
                          'start_date':
                              '${startDate?.day}/${startDate?.month}/${startDate?.year}'
                        };
                        // dbRef.push().set(medication);
                        if (uid == null) return;



                        DateFormat dateFormat = DateFormat('dd/MM/yyyy');

// Step 1: Add to Firestore and get the doc ID
                        final firestoreDocRef = await MedicineDao.addMedicineAndGetDocRef(
                          uid,
                          {
                            'med_name': medicineController.text,
                            'dose': doseAmount,
                            'container_no': containerNumber,
                            'ongoing': isOngoing,
                            'frequency': frequency,
                            'start_date': startDate != null ? dateFormat.format(startDate!) : null,
                            'end_date': endDate != null && !isOngoing ? dateFormat.format(endDate!) : null,
                            'intake_times': formattedIntakeTimes,
                          },
                        );

                        final String medId = firestoreDocRef.id; // ✅ use Firestore doc ID

// Step 2: Create the medicine model with this ID
                        newMedicine = MedicineUser(
                          id: medId,
                          medName: medicineController.text,
                          dose: doseAmount,
                          containerNumber: containerNumber,
                          ongoing: isOngoing,
                          frequency: frequency,
                          startDate: startDate,
                          endDate: isOngoing ? null : endDate,
                          intakeTimes: formattedIntakeTimes,
                        );

// Step 3: Save to Realtime DB using same ID
                        await FirebaseDatabase.instance.ref('medications').child(medId).set({
                          'id': medId,
                          'med_name': newMedicine!.medName,
                          'dose': newMedicine!.dose,
                          'container_no': newMedicine!.containerNumber,
                          'ongoing': newMedicine!.ongoing,
                          'frequency': newMedicine!.frequency,
                          'start_date': newMedicine!.startDate != null
                              ? dateFormat.format(newMedicine!.startDate!)
                              : null,
                          'end_date': newMedicine!.endDate != null
                              ? dateFormat.format(newMedicine!.endDate!)
                              : null,
                          'intake_times': newMedicine!.intakeTimes,
                        });

                        // logOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PillAnimationScreen(
                                      uid: uid!,
                                      newMedicine: newMedicine!,
                                    )));
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          isRunning = false;
                        });
                      }
                    }

                    // CategoryPage()
                    // ),
                    // );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.isEditing ? 'Update' : 'Next',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),
                      ),
                      Icon(CupertinoIcons.right_chevron, color: Colors.white),
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
