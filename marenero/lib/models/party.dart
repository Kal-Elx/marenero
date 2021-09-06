import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marenero/models/currently_playing.dart';

import '../utils/firestore_values.dart' as fs;
import '../models/participant.dart';
import '../models/my_track.dart';

class Party {
  final String id;
  final String code;
  final String partyToken;
  final List<Participant> participants;
  final int songsToQueue;
  final List<MyTrack> queuedTracks;
  final CurrentlyPlaying currentlyPlaying;

  Party({
    required this.id,
    required this.code,
    required this.partyToken,
    required this.participants,
    required this.songsToQueue,
    required this.queuedTracks,
    required this.currentlyPlaying,
  });

  /// Creates an instance from a Firestore object.
  factory Party.fromFirestoreObject(DocumentSnapshot snapshot) {
    final data = snapshot.data()!;
    return Party(
      id: snapshot.id,
      code: data[fs.Party.code],
      partyToken: data[fs.Party.accessToken],
      participants: (data[fs.Party.participants] as List)
          .map((data) => Participant.fromFirestoreObject(data))
          .toList(),
      songsToQueue: data[fs.Party.songsToQueue],
      queuedTracks: (data[fs.Party.queuedTracks] as List)
          .map((data) => MyTrack.fromFirestoreObject(data))
          .toList(),
      currentlyPlaying:
          CurrentlyPlaying.fromFirestoreObject(data[fs.Party.currentlyPlaying]),
    );
  }
}
