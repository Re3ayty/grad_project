import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../model/medication_box_data.dart';

class DashboardData {
  final double temperature;
  final double humidity;
  final int batteryPercentage;
  final String status;
  final bool charging;

  DashboardData({
    required this.temperature,
    required this.humidity,
    required this.batteryPercentage,
    required this.status,
    required this.charging,
  });
}

Stream<DashboardData> getCombinedDashboardStream() {
  final humAndTempStream = FirebaseDatabase.instance
      .ref()
      .child("(BOX)Hum&Temp")
      .onValue
      .map((event) => event.snapshot.value as Map);

  final batteryStream = FirebaseDatabase.instance
      .ref()
      .child("battery")
      .onValue
      .map((event) => event.snapshot.value as Map);

  final statusStream = FirebaseDatabase.instance
      .ref()
      .child("devices")
      .onValue
      .map((event) => event.snapshot.value as Map);

  return Rx.combineLatest3<Map, Map, Map, DashboardData>(
    humAndTempStream,
    batteryStream,
    statusStream,
    (humAndTemp, battery, deviceStatus) {
      return DashboardData(
        temperature: (humAndTemp['temperature'] ?? 0).toDouble(),
        humidity: (humAndTemp['humidity'] ?? 0).toDouble(),
        batteryPercentage: (battery['percentage'] ?? 0).toInt(),
        status: deviceStatus['status'] ?? 'offline',
        charging: battery['charging'] ?? false
      );
    },
  );
}

class MedicationBoxDao {
  static CollectionReference<Map<String, dynamic>> getMedicationBoxCollection(
      String uid) {
    var db = FirebaseFirestore.instance;
    return db.collection('usersInfo').doc(uid).collection('vitals');
  }

  static Future<void> addVitalsToUser(String uid, MedicationBoxData boxData) {
    var vitalsCollection = getMedicationBoxCollection(uid);
    return vitalsCollection.add(boxData.toFireStore());
  }

  static Future<List<MedicationBoxData>> getMedicationData(String uid) async {
    var vitalsCollection = getMedicationBoxCollection(uid);
    var snapshot = await vitalsCollection.get();
    return snapshot.docs
        .map((doc) => MedicationBoxData.fromFireStore(doc.id, doc.data()))
        .toList();
  }

  static Future<List<MedicationBoxData>> getHistoryVitalsForUser(
      String uid) async {
    var historyVitalsCollection = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(uid)
        .collection('vitals_history');
    var snapshot = await historyVitalsCollection.get();
    return snapshot.docs
        .map((doc) => MedicationBoxData.fromFireStore(doc.id, doc.data()))
        .toList();
  }

  static Future<void> moveVitalsToHistory(String uid, String vitalsID) async {
    var vitalsCollection = getMedicationBoxCollection(uid);
    var docRef = vitalsCollection.doc(vitalsID);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      var historyVitalsCollection = FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(uid)
          .collection('vitals_history');
      await historyVitalsCollection.doc(vitalsID).set(docSnapshot.data()!);
      await docRef.delete();
    }
  }

  static Future<void> deleteVitalsForUser(String uid, String vitalsId) async {
    var vitalsCollection = getMedicationBoxCollection(uid);
    var docRef = vitalsCollection.doc(vitalsId);
    await docRef.delete();
  }
}
