import 'dart:typed_data';

import 'package:intl/intl.dart';

class MedicineUser {
  String? id;
  int? containerNumber;
  int? dose;
  String? frequency;
  String? medName;
  bool? ongoing;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? intakeTimes;

  MedicineUser({
    this.id,
    this.containerNumber,
    this.medName,
    this.dose,
    this.frequency,
    this.ongoing,
    this.startDate,
    this.endDate,
    this.intakeTimes,
  });

  MedicineUser.fromFireStore(String docId, Map<String, dynamic>? data)
      : this(
          id: docId, //assigned by firestore (document ID)
          containerNumber: data?['container_no'] != null
              ? int.tryParse(data!['container_no'].toString())
              : null, //tp avoid type mismatch
          medName: data?['med_name'],
          frequency: data?['frequency'],
          dose: data?['dose'],
          ongoing: data?['ongoing'],
          startDate: data?['start_date'] != null
              ? DateFormat('dd/MM/yyyy').parse(data!['start_date'])
              : null,
          endDate: data?['end_date'] != null
              ? DateFormat('dd/MM/yyyy').parse(data!['end_date'])
              : null,
          intakeTimes: data?['intake_times'] != null
              ? List<String>.from(data!['intake_times'])
              : [],
        );

  Map<String, dynamic> toFireStore() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return {
      'container_no': containerNumber,
      'med_name': medName,
      'dose': dose,
      'ongoing': ongoing,
      'frequency': frequency,
      'start_date': startDate != null ? dateFormat.format(startDate!) : null,
      'end_date': endDate != null ? dateFormat.format(endDate!) : null,
      'intake_times': intakeTimes,
    };
  }

  MedicineUser copyWith({
    String? id,
    int? containerNumber,
    String? medName,
    int? dose,
    String? frequency,
    bool? ongoing,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? intakeTimes,
  }) {
    return MedicineUser(
      id: id ?? this.id,
      containerNumber: containerNumber ?? this.containerNumber,
      medName: medName ?? this.medName,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      ongoing: ongoing ?? this.ongoing,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      intakeTimes: intakeTimes ?? this.intakeTimes,
    );
  }
}
