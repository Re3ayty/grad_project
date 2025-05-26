import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MedicationBoxData {
  String? id;
  double? bodyTemperature;
  double? avgBPM;
  double? avgSpO2;
  List<String>? fingerPrints;
  DateTime? lastUpdated;

  MedicationBoxData({
    this.id,
    this.bodyTemperature,
    this.avgBPM,
    this.avgSpO2,
    this.fingerPrints,
    this.lastUpdated,
  });

  MedicationBoxData.fromFireStore(String docID, Map<String, dynamic>? data)
      : this(
          id: docID,
          bodyTemperature: data?['body_temperature'] != null
              ? double.tryParse(data!['body_temperature'].toString())
              : null,
          avgBPM: data?['avg_BPM'] != null
              ? double.tryParse(data!['avg_BPM'].toString())
              : null,
          avgSpO2: data?['avg_SpO2'] != null
              ? double.tryParse(data!['avg_SpO2'].toString())
              : null,
          fingerPrints: data?['fingerprints'] != null
              ? List<String>.from(data!['fingerprints'])
              : [],
          lastUpdated: data?['last_updated'] is Timestamp
              ? (data?['last_updated'] as Timestamp).toDate()
              : data?['last_updated'] != null
                  ? DateFormat('dd/MM/yyyy HH:mm').parse(data!['last_updated'])
                  : null,
        );
  Map<String, dynamic> toFireStore() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return {
      'body_temperature': bodyTemperature,
      'avg_bpm': avgBPM,
      'avg_spo2': avgSpO2,
      'finger_prints': fingerPrints,
      'last_updated':
          lastUpdated != null ? dateFormat.format(lastUpdated!) : null,
    };
  }
}
