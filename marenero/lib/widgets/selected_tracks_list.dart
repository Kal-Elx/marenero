import 'package:flutter/material.dart';

import '../models/my_track.dart';
import '../widgets/track_list_tile.dart';

class SelectedTracksList extends StatelessWidget {
  final List<MyTrack> tracks;
  final int songsToQueue;
  final Function(MyTrack) removeSelectedCallback;

  SelectedTracksList({required this.tracks, required this.songsToQueue, required this.removeSelectedCallback});

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
                cover: Image.network(
                  tracks[i].imageObjects[tracks[i].imageObjects.length - 1]['url'],
                  height: 50.0,
                  width: 50.0,
                ),
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
