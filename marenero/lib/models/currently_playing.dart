import 'package:marenero/models/my_track.dart';

class CurrentlyPlaying {
  final MyTrack? track;
  final bool isPlaying;

  CurrentlyPlaying({required this.track, required this.isPlaying});
}
