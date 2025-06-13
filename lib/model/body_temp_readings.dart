import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BodyTempReadings {
  String? id;
  double? bodyTempC;
  double? bodyTempF;
  DateTime? lastUpdated;

  BodyTempReadings({
    this.id,
    this.bodyTempC,
    this.bodyTempF,
    this.lastUpdated,
  });

  BodyTempReadings.fromFireStore(String docID, Map<String, dynamic>? data)
      : this(
          id: docID,
          bodyTempC: data?['temperatureC'] != null
              ? double.tryParse(data!['temperatureC'].toString())
              : null,
          bodyTempF: data?['temperatureF'] != null
              ? double.tryParse(data!['temperatureF'].toString())
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
      'temperatureC': bodyTempC,
      'temperatureF': bodyTempF,
      'last_updated':
          lastUpdated != null ? dateFormat.format(lastUpdated!) : null,
    };
  }
}
