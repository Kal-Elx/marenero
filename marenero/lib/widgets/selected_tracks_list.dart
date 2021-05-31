import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
import 'package:marenero/widgets/track_list_tile.dart';
//import 'package:spotify_sdk/models/track.dart';

class SelectedTracksList extends StatelessWidget {
  final List<MyTrack> tracks;
  final int songsToQueue;
  final Function(MyTrack) removeSelectedCallback;

  SelectedTracksList(
      {required this.tracks,
      required this.songsToQueue,
      required this.removeSelectedCallback});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: this.songsToQueue,
      shrinkWrap: true,
      separatorBuilder: (_, __) => Divider(
        thickness: 1.0,
        color: Colors.white12,
        height: 4.0,
        indent: 4.0,
      ),
      itemBuilder: (_, i) {
        return i < tracks.length
            ? TrackListTile(
                title: tracks[i].name,
                artists: tracks[i].artists,
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  color: Colors.white,
                  onPressed: () => removeSelectedCallback(tracks[i]),
                ),
              )
            : TrackListTile.placeholder(i);
      },
    );
  }
}
