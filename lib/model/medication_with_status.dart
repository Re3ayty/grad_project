import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcs_grad_project/viewModel/medicine_dao.dart';
import 'package:intl/intl.dart';

class MedicationStatusData {
  String? id;
  String? medName;
  String? status;
  DateTime? notificationDate;

  MedicationStatusData({
    this.id,
    this.medName,
    this.status,
    this.notificationDate,
  });

  MedicationStatusData.fromFireStore(String docID, Map<String, dynamic>? data)
      : this(
          id: docID,
          medName: data?['medName'],
          status: data?['status'],
          notificationDate: data?['notification_date'] is Timestamp
              ? (data?['notification_date'] as Timestamp).toDate()
              : data?['notification_date'] != null
                  ? DateFormat('dd/MM/yyyy HH:mm')
                      .parse(data!['notification_date'])
                  : null,
        );

  Map<String, dynamic> toFireStore() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return {
      'medName': medName,
      'status': status,
      'notification_date': notificationDate != null
          ? dateFormat.format(notificationDate!)
          : null,
    };
  }

  MedicationStatusData copyWith({
    String? id,
    String? medName,
    String? status,
    DateTime? notificationDate,
  }) {
    return MedicationStatusData(
      id: id ?? this.id,
      status: status ?? this.status,
      medName: medName ?? this.medName,
      notificationDate: notificationDate ?? this.notificationDate,
    );
  }
}
