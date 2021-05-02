import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/firestore_values.dart' as fs;

class Party {
  String id;
  String code;
  bool started;

  Party({
    required this.id,
    required this.code,
    required this.started,
  });

  /// Creates an instance from a Firestore object.
  factory Party.fromFirestoreObject(DocumentSnapshot snapshot) {
    final data = snapshot.data()!;
    return Party(
      id: snapshot.id,
      code: data[fs.Party.code],
      started: data[fs.Party.started],
    );
  }
}
