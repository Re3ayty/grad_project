import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hcs_grad_project/model/user_medicine.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import '../../viewModel/medicine_dao.dart';
import '../../viewModel/provider/app_auth_provider.dart';
import '../medicicent_current_history/medication_current_history.dart';

class PillAnimationScreen extends StatefulWidget {
  Map<String, dynamic> refillDatafromRealTime;
  final String uid;
  final MedicineUser newMedicine;
  final bool isRefill;

  PillAnimationScreen(
      {Key? key, required this.uid, this.isRefill = false,required this.newMedicine,required this.refillDatafromRealTime})
      : super(key: key);
  @override
  _PillAnimationScreenState createState() => _PillAnimationScreenState();
}

class _PillAnimationScreenState extends State<PillAnimationScreen> {

  String formatTimeOfDay24Hour(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
    DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dateTime);
  }
  DatabaseReference updatingRefill = FirebaseDatabase.instance.ref("refill");
  int pillIndex = 0;
  bool isRunning = false;

  final List<Offset> pillPositions = [
    Offset(0, -100), // Top
    Offset(100, 0), // Right
    Offset(0, 100), // Bottom
    Offset(-100, 0), // Left
  ];
  @override
  Widget build(BuildContext context) {

    bool confirm = widget.refillDatafromRealTime['confirm'];
    String request = widget.refillDatafromRealTime['request'];
    int slot = widget.refillDatafromRealTime['slot'];
    String state = widget.refillDatafromRealTime['state'];
    dynamic intakeTimes = widget.newMedicine!.intakeTimes
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

    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(
                    text: 'Place Pills ',
                    style: TextStyle(color: Color(0xff4979FB))),
                TextSpan(
                    text: 'in the container',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xff4979FB), width: 45),
                  ),
                ),
                for (int i = 0; i < pillIndex; i++)
                  Transform.translate(
                      offset: pillPositions[i],
                      child: Icon(
                        Symbols.pill,
                        size: 30,
                        color: Colors.white,
                      )),
              ],
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {

              if (isRunning) return; // Prevent multiple taps
              if (pillIndex < 4) {
                if((state=='in_progress'&& slot==(pillIndex+1)) ||
                    (state=='slot_2' && slot==(pillIndex+1)) ||
                    (state=='slot_3'&& slot==(pillIndex+1)) ||
                    (state=='slot_4'&& slot==(pillIndex+1)) )
                {
                  setState(() {
                    pillIndex++;
                  });
                  await updatingRefill.update({
                    "confirm": true,
                  });

                }
                // if(slot==pillIndex){
                // await updatingRefill.update({
                //   "confirm": true,
                // });
                // setState(() {
                //   pillIndex++;
                // });
                // }
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => ),
                //   );
              } else if (pillIndex == 4)
              {
                setState(() {
                  isRunning = true;
                });
                if (!widget.isRefill) {
                try {var authProvider = Provider.of<AppAuthProvider>(context,
                    listen: false);
                String? uid = authProvider.firebaseAuthUser?.uid;
                List<dynamic> formattedIntakeTimes = intakeTimes!.map((time) => formatTimeOfDay24Hour(time)).toList();
                Map<dynamic, dynamic> medication = {
                  'container_no': widget.newMedicine.containerNumber,
                  'dose': widget.newMedicine.dose,
                  'end_date':
                  '${widget.newMedicine.endDate?.day}/${widget.newMedicine.endDate?.month}/${widget.newMedicine.endDate?.year}',
                  'frequency': widget.newMedicine.frequency,
                  'intake_times': formattedIntakeTimes,
                  'med_name': widget.newMedicine.medName,
                  'ongoing': widget.newMedicine.ongoing,
                  'start_date':
                  '${widget.newMedicine.startDate?.day}/${widget.newMedicine.startDate?.month}/${widget.newMedicine.startDate?.year}'
                };
                // dbRef.push().set(medication);
                if (uid == null) return;



                DateFormat dateFormat = DateFormat('dd/MM/yyyy');

// Step 1: Add to Firestore and get the doc ID

                final firestoreDocRef = await MedicineDao.addMedicineAndGetDocRef(
                  uid,
                  {
                    'med_name': widget.newMedicine.medName,
                    'dose': widget.newMedicine.dose,
                    'container_no': widget.newMedicine.containerNumber,
                    'ongoing': widget.newMedicine.ongoing,
                    'frequency': widget.newMedicine.frequency,
                    'start_date': widget.newMedicine.startDate != null ? dateFormat.format(widget.newMedicine.startDate!) : null,
                    'end_date': widget.newMedicine.endDate != null && ! widget.newMedicine.ongoing! ? dateFormat.format(widget.newMedicine.endDate!) : null,
                    'intake_times': formattedIntakeTimes,
                  },
                );

                final String medId = firestoreDocRef.id; // ✅ use Firestore doc ID

// Step 2: Create the medicine model with this ID
//                 newMedicine = MedicineUser(
//                   id: medId,
//                   medName: widget.newMedicine.medName,
//                   dose: widget.newMedicine.dose,
//                   containerNumber: widget.newMedicine.containerNumber,
//                   ongoing: widget.newMedicine.ongoing,
//                   frequency: widget.newMedicine.frequency,
//                   startDate: widget.newMedicine.startDate,
//                   endDate: isOngoing ? null : endDate,
//                   intakeTimes: formattedIntakeTimes,
//                 );

// Step 3: Save to Realtime DB using same ID
                await FirebaseDatabase.instance.ref('medications').child(medId).set({
                  'id': medId,
                  'med_name': widget.newMedicine.medName,
                  'dose': widget.newMedicine.dose,
                  'container_no': widget.newMedicine.containerNumber,
                  'ongoing': widget.newMedicine.ongoing,
                  'frequency': widget.newMedicine.frequency,
                  'start_date': widget.newMedicine.startDate != null
                      ? dateFormat.format(widget.newMedicine.startDate!)
                      : null,
                  'end_date': widget.newMedicine.endDate != null
                      ? dateFormat.format(widget.newMedicine.endDate!)
                      : null,
                  'intake_times': widget.newMedicine.intakeTimes,
                });
                  // await MedicineDao.addMedicineToUser(
                  //     widget.uid, widget.newMedicine);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Medicine added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             MedicineScreen(newMedicine: widget.newMedicine)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add medication: $e")));
                } finally {
                  setState(() {
                    isRunning = false;
                  });
                }
              }else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Refill completed successfully!')),
                );
                Navigator.pop(context);
              }}
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff4979FB),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: Text(
              pillIndex < 4 ? 'Next' : 'Done',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
