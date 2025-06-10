import 'package:hcs_grad_project/viewModel/firbase_realtime_dao.dart';

class FingerPrintsData {
  int? id;
  String? fingerprintName;

  FingerPrintsData({
    this.id,
    this.fingerprintName,
  });

  FingerPrintsData.fromFireStore(String docID, Map<String, dynamic>? data)
      : this(
          id: data?['id'] != null
              ? int.tryParse(data!['id'].toString())
              : null,
          fingerprintName: data?['fingerprintName'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'fingerprintName': fingerprintName,
    };
  }

  FingerPrintsData copyWith({
    int? id,
    String? fingerprintName,
    String? fingerprint,
  }) {
    return FingerPrintsData(
      id: id ?? this.id,
      fingerprintName: fingerprintName ?? this.fingerprintName,
    );
  }
}
