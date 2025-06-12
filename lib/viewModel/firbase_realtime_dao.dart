import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../model/heart_rate_readings.dart';
import '../model/body_temp_readings.dart';
import '../model/fingerprints.dart';

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
    return db.collection('usersInfo').doc(uid).collection('heartRate_readings');
  }

  static Future<void> addVitalsToUser(String uid, HeartRateData boxData) {
    var heartRateCollection = getMedicationBoxCollection(uid);
    return heartRateCollection.add(boxData.toFireStore());
  }

  static Future<List<HeartRateData>> getMedicationData(String uid) async {
    var heartRateCollection = getMedicationBoxCollection(uid);
    var snapshot = await heartRateCollection.get();
    return snapshot.docs
        .map((doc) => HeartRateData.fromFireStore(doc.id, doc.data()))
        .toList();
  }

  static Future<void> deleteVitalsForUser(String uid, String vitalsId) async {
    var heartRateCollection = getMedicationBoxCollection(uid);
    var docRef = heartRateCollection.doc(vitalsId);
    await docRef.delete();
  }
}

class BodyTempDao {
  static CollectionReference<Map<String, dynamic>> getBodyTempCollection(
      String uid) {
    var db = FirebaseFirestore.instance;
    return db.collection('usersInfo').doc(uid).collection('bodyTemp_readings');
  }

  static Future<void> addBodyTempToUser(
      String uid, BodyTempReadings bodyTempData) {
    var bodyTempCollection = getBodyTempCollection(uid);
    return bodyTempCollection.add(bodyTempData.toFireStore());
  }

  static Future<List<BodyTempReadings>> getBodyTempData(String uid) async {
    var bodyTempCollection = getBodyTempCollection(uid);
    var snapshot = await bodyTempCollection.get();
    return snapshot.docs
        .map((doc) => BodyTempReadings.fromFireStore(doc.id, doc.data()))
        .toList();
  }

  static Future<void> deleteBodyTempForUser(
      String uid, String bodyTempId) async {
    var bodyTempCollection = getBodyTempCollection(uid);
    var docRef = bodyTempCollection.doc(bodyTempId);
    await docRef.delete();
  }
}

class FingerprintDao {
  static CollectionReference<Map<String, dynamic>> getFingerprintCollection(
      String uid) {
    var db = FirebaseFirestore.instance;
    return db.collection('usersInfo').doc(uid).collection('fingerprints');
  }

  static Future<void> addFingerprintToUser(
      String uid, FingerPrintsData fingerprintData) {
    var fingerprintCollection = getFingerprintCollection(uid);
    return fingerprintCollection.add(fingerprintData.toFireStore());
  }

  static Future<List<FingerPrintsData>> getFingerprintData(String uid) async {
    var fingerprintCollection = getFingerprintCollection(uid);
    var snapshot = await fingerprintCollection.get();
    return snapshot.docs
        .map((doc) => FingerPrintsData.fromFireStore(doc.id, doc.data()))
        .toList();
  }

  static Future<void> deleteFingerprintForUser(
      String uid, String docID) async {
    var fingerprintCollection = getFingerprintCollection(uid);
    var docRef = fingerprintCollection.doc(docID);
    await docRef.delete();
  }

  static Future<List<int>> getUsedIDs(String uid) async {
    var fingerprintCollection = getFingerprintCollection(uid);
    var querySnapshot = await fingerprintCollection.get();

    return querySnapshot.docs
        .map((doc) => int.tryParse(doc.data()['id']?.toString() ?? '') ?? 0)
        .where((num) => num >= 1 && num <= 127)
        .toList();
  }

  static Stream<List<FingerPrintsData>> getFingerprintsStream(String uid) {
    return FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(uid)
        .collection('fingerprints')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FingerPrintsData.fromFireStore(doc.id, doc.data()))
            .toList());
  }
}
