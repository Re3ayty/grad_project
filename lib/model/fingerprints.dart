import 'package:hcs_grad_project/viewModel/firbase_realtime_dao.dart';

class FingerPrintsData {
  String? docID;
  int? id;
  String? fingerprintName;

  FingerPrintsData({
    this.docID,
    this.id,
    this.fingerprintName,
  });

  FingerPrintsData.fromFireStore(String docID, Map<String, dynamic>? data)
      : this(
        docID: docID,
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
    String? docID,
    int? id,
    String? fingerprintName,
    String? fingerprint,
  }) {
    return FingerPrintsData(
      docID: docID ?? this.docID,
      id: id ?? this.id,
      fingerprintName: fingerprintName ?? this.fingerprintName,
    );
  }
}
