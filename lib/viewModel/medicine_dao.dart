import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_medicine.dart';

class MedicineDao {
  static CollectionReference<Map<String, dynamic>> getMedicinesCollection(
      String uid) {
    var db = FirebaseFirestore.instance;
    return db.collection('usersInfo').doc(uid).collection('medication_to_take');
  }
  static Future<DocumentReference> addMedicineAndGetDocRef(
      String uid, Map<String, dynamic> data) async {
    final docRef = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(uid)
        .collection('medication_to_take')
        .doc(); // Generate doc ID
    await docRef.set(data);
    return docRef;
  }

  static Future<void> addMedicineToUser(String uid, MedicineUser medicine) {
    var medicinesCollection = getMedicinesCollection(uid);
    return medicinesCollection.add(medicine.toFireStore());
  }

  static Future<MedicineUser?> getMedicineForUser(
      String uid, String medicineId) async {
    var medicinesCollection = getMedicinesCollection(uid);
    var docRef = medicinesCollection.doc(medicineId);
    var docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return MedicineUser.fromFireStore(docSnapshot.id, docSnapshot.data());
    }
    return null;
  }

  static Future<List<MedicineUser>> getMedicinesForUser(String uid) async {
    var medicinesCollection = getMedicinesCollection(uid);
    var snapshot = await medicinesCollection.get();
    return snapshot.docs
        .map((doc) => MedicineUser.fromFireStore(doc.id, doc.data()))
        .toList();
  }

  static Future<List<MedicineUser>> getHistoryMedicinesForUser(
      String uid) async {
    var historyCollection = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(uid)
        .collection('medication_history');
    var snapshot = await historyCollection.get();
    return snapshot.docs
        .map((doc) => MedicineUser.fromFireStore(doc.id, doc.data()))
        .toList();
  }

  static Future<void> updateMedicineForUser(
      String uid, String medicineId, Map<String, dynamic> updatedData) async {
    var medicinesCollection = getMedicinesCollection(uid);
    var docRef = medicinesCollection.doc(medicineId);
    await docRef.update(updatedData);
  }

  static Future<void> deleteMedicineForUser(
      String uid, String medicineId) async {
    var medicinesCollection = getMedicinesCollection(uid);
    var docRef = medicinesCollection.doc(medicineId);
    await docRef.delete();
  }

  static Future<void> moveMedicineToHistory(
      String uid, String medicineId) async {
    var medicinesCollection = getMedicinesCollection(uid);
    var docRef = medicinesCollection.doc(medicineId);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Copy the document to a "history" subcollection
      var historyCollection = FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(uid)
          .collection('medication_history');
      await historyCollection.doc(medicineId).set(docSnapshot.data()!);

      // Delete the original document from "medication_to_take"
      await docRef.delete();
    }
  }

  static Future<List<int>> getUsedContainerNumbers(String uid) async {
    var medicinesCollection = getMedicinesCollection(uid);
    var querySnapshot = await medicinesCollection.get();

    return querySnapshot.docs
        .map((doc) =>
            int.tryParse(doc.data()['container_no']?.toString() ?? '') ?? 0)
        .where((num) => num >= 1 && num <= 4)
        .toList();
  }

  static Stream<List<MedicineUser>> getCurrentMedicinesStream(String uid) {
    return FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(uid)
        .collection('medication_to_take')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicineUser.fromFireStore(doc.id, doc.data()))
            .toList());
  }

  static Stream<List<MedicineUser>> getHistoryMedicinesStream(String uid) {
    return FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(uid)
        .collection('medication_history')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicineUser.fromFireStore(doc.id, doc.data()))
            .toList());
  }
}
