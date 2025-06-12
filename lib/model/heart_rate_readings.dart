import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HeartRateData {
  String? id;
  dynamic avgBPM;
  dynamic avgSpO2;
  DateTime? lastUpdated;

  HeartRateData({
    this.id,
    this.avgBPM,
    this.avgSpO2,
    this.lastUpdated,
  });

  HeartRateData.fromFireStore(String docID, Map<String, dynamic>? data)
      : this(
          id: docID,
          avgBPM: data?['avg_BPM'] != null
              ? int.tryParse(data!['avg_BPM'].toString())
              : null,
          avgSpO2: data?['avg_SpO2'] != null
              ? int.tryParse(data!['avg_SpO2'].toString())
              : null,
          lastUpdated: data?['last_updated'] is Timestamp
              ? (data?['last_updated'] as Timestamp).toDate()
              : data?['last_updated'] != null
                  ? DateFormat('dd/MM/yyyy HH:mm').parse(data!['last_updated'])
                  : null,
        );
  Map<String, dynamic> toFireStore() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return {
      'avg_bpm': avgBPM,
      'avg_spo2': avgSpO2,
      'last_updated':
          lastUpdated != null ? dateFormat.format(lastUpdated!) : null,
    };
  }
}
