import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'medication_reminder.dart'; // PillCard widget

class MedicationHistoryScreen extends StatefulWidget {
  @override
  _MedicationHistoryScreenState createState() =>
      _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  DateTime? selectedDate;
  bool datePicked = false;

  // Dynamic sample data with today/yesterday keys
  final String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String yesterdayKey = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 1)));

  late final Map<String, List<Map<String, dynamic>>> medicationHistory = {
    todayKey: [
      {'name': 'Panadol', 'time': '08:00 AM', 'status': 'taken'},
      {'name': 'Vitamin D', 'time': '09:00 PM', 'status': 'missed'},
    ],
    yesterdayKey: [
      {'name': 'Ibuprofen', 'time': '10:00 AM', 'status': 'taken'},
      {'name': 'Panadol', 'time': '06:00 PM', 'status': 'taken'},
    ],
    '2025-06-07': [
      {'name': 'Roaccutane', 'time': '10:15 PM', 'status': 'missed'},
    ],
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // Disallow future dates
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        datePicked = true;
      });
    }
  }

  DateTime _parseTime(String time, DateTime date) {
    final format = DateFormat('hh:mm a');
    final parsedTime = format.parse(time);
    return DateTime(
        date.year, date.month, date.day, parsedTime.hour, parsedTime.minute);
  }

  List<Widget> buildSection(String title, List<Map<String, dynamic>> meds) {
    if (meds.isEmpty) return [];

    return [
      SizedBox(height: 16),
      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      ...meds.map((med) {
        IconData icon;
        Color iconColor;
        Color timeColor;

        final now = DateTime.now();
        final medTime = _parseTime(med['time'], selectedDate ?? now);
        final hasStatus = med.containsKey('status');

        if (hasStatus) {
          switch (med['status']) {
            case 'taken':
              icon = Icons.check;
              iconColor = Colors.green;
              timeColor = Colors.green;
              break;
            case 'missed':
              icon = Icons.alarm;
              iconColor = Colors.red;
              timeColor = Colors.red;
              break;
            default:
              icon = Icons.hourglass_bottom;
              iconColor = Colors.blue;
              timeColor = Colors.blue;
          }
        } else {
          if (medTime.isAfter(now)) {
            icon = Icons.hourglass_bottom;
            iconColor = Colors.blue;
            timeColor = Colors.blue;
          } else {
            icon = Icons.alarm;
            iconColor = Colors.red;
            timeColor = Colors.red;
          }
        }

        return PillCard(
          icon: icon,
          iconColor: iconColor,
          name: med['name'],
          time: med['time'],
          timeColor: timeColor,
        );
      }).toList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final String selectedDateKey = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';

    final todayMeds = medicationHistory[todayKey] ?? <Map<String, dynamic>>[];
    final yesterdayMeds =
        medicationHistory[yesterdayKey] ?? <Map<String, dynamic>>[];
    final selectedDateMeds = selectedDate != null
        ? (medicationHistory[selectedDateKey] ?? <Map<String, dynamic>>[])
        : <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
        Text('Medication History', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        datePicked
                            ? 'Pick a date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'
                            : 'Pick a date',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            if (!datePicked) ...[
              ...buildSection('Today', todayMeds),
              ...buildSection('Yesterday', yesterdayMeds),
            ],

            if (datePicked)
              ...buildSection(
                  DateFormat('dd/MM/yyyy').format(selectedDate!), selectedDateMeds),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
