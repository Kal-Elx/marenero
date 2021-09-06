import 'package:marenero/models/my_track.dart';
import '../utils/firestore_values.dart' as fs;

class CurrentlyPlaying {
  final MyTrack? track;
  final bool isPlaying;

  CurrentlyPlaying({required this.track, required this.isPlaying});

  factory CurrentlyPlaying.fromJson(Map<String, dynamic> data) {
    return CurrentlyPlaying(
      track: MyTrack.fromJson(data['track'] as Map<String, dynamic>),
      isPlaying: data['isPlaying'] as bool,
    );
  }

  /// Creates an instance from a Firestore object.
  factory CurrentlyPlaying.fromFirestoreObject(Map<String, dynamic> data) {
    if (data['track'] == null) {
      return CurrentlyPlaying(track: null, isPlaying: false);
    } else {
      return CurrentlyPlaying(
        track: MyTrack.fromFirestoreObject(data['track']),
        isPlaying: data['isPlaying'] as bool,
      );
    }
  }

  Map<String, dynamic> toFirestoreObject() {
    if (track == null) {
      return {
        fs.CurrentlyPlaying.track: null,
        fs.CurrentlyPlaying.isPlaying: false
      };
    } else {
      return {
        fs.CurrentlyPlaying.track: track!.toFirestoreObject(),
        fs.CurrentlyPlaying.isPlaying: isPlaying
      };
    }
  }
}
