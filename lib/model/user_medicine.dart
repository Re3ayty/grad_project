class MedicineUser {
  String? id;
  String? containerNumber;
  int? dose;
  String? frequency;
  String? medName;
  bool? ongoing;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? intakeTimes;

  MedicineUser({
    this.id,
    this.containerNumber,
    this.medName,
    this.dose,
    this.frequency,
    this.ongoing,
    this.startDate,
    this.endDate,
    this.intakeTimes,
  });

  MedicineUser.fromFireStore(Map<String, dynamic>? data)
      : this(
          id: data?['id'],
          containerNumber: data?['container_no'],
          medName: data?['med_name'],
          frequency: data?['frequency'],
          dose: data?['dose'],
          ongoing: data?['ongoing'],
          startDate: data?['start_date'] != null
              ? DateTime.parse(data!['start_date'])
              : null,
          endDate: data?['end_date'] != null
              ? DateTime.parse(data!['end_date'])
              : null,
          intakeTimes: data?['intake_times'] != null
              ? List<String>.from(data!['intake_times'])
              : [],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'container_no': containerNumber,
      'med_name': medName,
      'dose': dose,
      'ongoing': ongoing,
      'frequency': frequency,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'intake_times': intakeTimes,
    };
  }
}
