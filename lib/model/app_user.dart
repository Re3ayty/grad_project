import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppUser {
  String? id;
  String? userName;
  String? email;
  DateTime? dateOfBirth;
  String? phone;
  String? gender;
  String? medicalCondition;
  String? patientOrCaregiver;
  bool? allowCaregiverView;
  String? relationship;
  String? profileImageBase64;

  AppUser(
      {this.id,
      this.userName,
      this.email,
      this.dateOfBirth,
      this.phone,
      this.gender,
      this.medicalCondition,
      this.patientOrCaregiver,
      this.allowCaregiverView,
      this.relationship,
      this.profileImageBase64});

  AppUser.fromFireStore(Map<String, dynamic>? data)
      : this(
          id: data?['id'],
          userName: data?['userName'],
          email: data?['email'],
          dateOfBirth: data?['dateOfBirth'] is Timestamp
              ? (data?['dateOfBirth'] as Timestamp).toDate()
              : data?['dateOfBirth'] != null
                  ? DateFormat('dd/MM/yyyy').parse(data!['dateOfBirth'])
                  : null,
          phone: data?['phone'],
          gender: data?['gender'],
          medicalCondition: data?['medicalCondition'],
          patientOrCaregiver: data?['patientOrCaregiver'],
          allowCaregiverView: data?['allowCaregiverView'],
          relationship: data?['relationship'],
          profileImageBase64: data?['profileImageBase64'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'phone': phone,
      'gender': gender,
      'medicalCondition': medicalCondition,
      'patientOrCaregiver': patientOrCaregiver,
      'allowCaregiverView': allowCaregiverView,
      'relationship': relationship,
      'profileImageBase64': profileImageBase64,
    };
  }

  AppUser copyWith({
    String? id,
    String? userName,
    String? email,
    DateTime? dateOfBirth,
    String? phone,
    String? gender,
    String? medicalCondition,
    String? patientOrCaregiver,
    bool? allowCaregiverView,
    String? relationship,
    String? profileImageBase64,
  }) {
    return AppUser(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      patientOrCaregiver: patientOrCaregiver ?? this.patientOrCaregiver,
      allowCaregiverView: allowCaregiverView ?? this.allowCaregiverView,
      relationship: relationship ?? this.relationship,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
    );
  }
}
