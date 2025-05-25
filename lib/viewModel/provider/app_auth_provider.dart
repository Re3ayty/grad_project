import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/app_user.dart';
import '../user_dao.dart';

class AppAuthProvider extends ChangeNotifier {
  AppUser? databaseUser;
  User? firebaseAuthUser;

  Future<void> register({
    required String email,
    required String password,
    required String userName,
    required DateTime dateOfBirth,
    required String phone,
    required String gender,
    String? medicalCondition,
    required String patientOrCaregiver,
    required bool allowCaregiverView,
    required String relationship,
  }) async {
    var userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    AppUser user = AppUser(
      id: userCredential.user?.uid,
      userName: userName,
      email: email,
      dateOfBirth: dateOfBirth,
      phone: phone,
      gender: gender,
      medicalCondition: medicalCondition!.isEmpty ? "" : medicalCondition,
      patientOrCaregiver: patientOrCaregiver,
      allowCaregiverView: allowCaregiverView,
      relationship: relationship,
    );
    await UsersDao.addUserToDatabase(user);
  }

  Future<void> login(String email, String password) async {
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    databaseUser = await UsersDao.readUserFromDatabase(credential.user!.uid);
    firebaseAuthUser = credential.user;
  }

  void signOut() {
    databaseUser = null;
    FirebaseAuth.instance.signOut();
  }

  bool isLoggedInBefore() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> retrieveUserFromDatabase() async {
    firebaseAuthUser = FirebaseAuth.instance.currentUser;
    databaseUser = await UsersDao.readUserFromDatabase(firebaseAuthUser!.uid);
  }

  Future<void> updateUserInfoLocally(Map<String, dynamic> updatedData) async {
    DateTime? parsedDateOfBirth;
    if (updatedData['dateOfBirth'] != null) {
      if (updatedData['dateOfBirth'] is String) {
        parsedDateOfBirth =
            DateFormat('dd/MM/yyyy').parse(updatedData['dateOfBirth']);
      } else if (updatedData['dateOfBirth'] is DateTime) {
        parsedDateOfBirth = updatedData['dateOfBirth'];
      }
    }
    databaseUser = databaseUser!.copyWith(
      userName: updatedData['userName'],
      email: updatedData['email'],
      phone: updatedData['phone'],
      gender: updatedData['gender'],
      dateOfBirth: parsedDateOfBirth,
      medicalCondition: updatedData['medicalCondition'],
      patientOrCaregiver: updatedData['patientOrCaregiver'],
      allowCaregiverView: updatedData['allowCaregiverView'],
      relationship: updatedData['relationship'],
    );
    notifyListeners();
  }
}
