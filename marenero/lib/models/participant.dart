import 'package:uuid/uuid.dart';

import '../utils/firestore_values.dart' as fs;

class Participant {
  static final uuid = Uuid();

  final String id;
  final String name;
  final bool host;
  final List<String> queuedTracks;

  const Participant._({
    required this.id,
    required this.name,
    required this.host,
    required this.queuedTracks,
  });

  Participant({
    required this.name,
    this.host = false,
  })  : id = uuid.v1(),
        queuedTracks = [];

  /// Creates an instance from a Firestore object.
  factory Participant.fromFirestoreObject(Map<String, dynamic> data) {
    return Participant._(
      id: data[fs.Participant.id],
      name: data[fs.Participant.name],
      host: data[fs.Participant.host],
      queuedTracks: data[fs.Participant.queuedTracks],
    );
  }

  Map<String, dynamic> toFirestoreObject() {
    return {
      fs.Participant.id: id,
      fs.Participant.name: name,
      fs.Participant.host: host,
      fs.Participant.queuedTracks: queuedTracks,
    };
  }
}
