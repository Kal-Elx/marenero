import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/firestore_values.dart' as fs;
import '../models/participant.dart';

class Party {
  String id;
  String code;
  List<Participant> participants;

  Party({
    required this.id,
    required this.code,
    required this.participants,
  });

  /// Creates an instance from a Firestore object.
  factory Party.fromFirestoreObject(DocumentSnapshot snapshot) {
    final data = snapshot.data()!;
    return Party(
      id: snapshot.id,
      code: data[fs.Party.code],
      participants: (data[fs.Party.participants] as List)
          .map((data) => Participant.fromFirestoreObject(data))
          .toList(),
    );
  }
}
