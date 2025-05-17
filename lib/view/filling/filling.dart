import 'package:flutter/material.dart';
import 'package:hcs_grad_project/model/user_medicine.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../../viewModel/medicine_dao.dart';
import '../medicicent_current_history/medication_current_history.dart';

class PillAnimationScreen extends StatefulWidget {
  final String uid;
  final MedicineUser newMedicine;

  const PillAnimationScreen(
      {Key? key, required this.uid, required this.newMedicine})
      : super(key: key);
  @override
  _PillAnimationScreenState createState() => _PillAnimationScreenState();
}

class _PillAnimationScreenState extends State<PillAnimationScreen> {
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
                    text: 'Panadol ',
                    style: TextStyle(color: Color(0xff4979FB))),
                TextSpan(
                    text: 'in container 1',
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
                setState(() {
                  pillIndex++;
                });
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => ),
                //   );
              } else if (pillIndex == 4) {
                setState(() {
                  isRunning = true;
                });
                try {
                  await MedicineDao.addMedicineToUser(
                      widget.uid, widget.newMedicine);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Medicine added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MedicineScreen(
                              newMedicine: widget
                                  .newMedicine)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add medication: $e")));
                } finally {
                  setState(() {
                    isRunning = false;
                  });
                }
              }
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
