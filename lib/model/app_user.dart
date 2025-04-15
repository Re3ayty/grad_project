class AppUser {
  String? id;
  String? userName;
  String? email;
  String? dateOfBirth;
  String? phone;
  String? gender;
  String? medicalCondition;
  String? patientOrCaregiver;
  bool? allowCaregiverView;
  String? relationship;


  AppUser({this.id, this.userName, this.email, this.dateOfBirth,this.phone,this.gender, this.medicalCondition,this.patientOrCaregiver,this.allowCaregiverView,this.relationship});

  AppUser.fromFireStore(Map<String, dynamic>? data)
      : this(
    id: data?['id'],
    userName: data?['userName'],
    email: data?['email'],
    dateOfBirth: data?['dateOfBirth'],
    phone: data?['phone'],
    gender: data?['gender'],
    medicalCondition: data?['medicalCondition'],
    patientOrCaregiver: data?['patientOrCaregiver'],
    allowCaregiverView: data?['allowCaregiverView'],
    relationship: data?['relationship'],

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
      'patientOrCaregiver':patientOrCaregiver,
      'allowCaregiverView':allowCaregiverView,
      'relationship':relationship,

    };
  }
}