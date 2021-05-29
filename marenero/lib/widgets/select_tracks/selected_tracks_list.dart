import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
//import 'package:spotify_sdk/models/track.dart';

class SelectedTracksList extends StatelessWidget {
  final List<MyTrack> tracks;
  final int songsToQueue;
  final Function(MyTrack) removeSelectedCallback;

  SelectedTracksList(
      {required this.tracks,
      required this.songsToQueue,
      required this.removeSelectedCallback});

  _removeTrack(int i) {
    removeSelectedCallback(tracks[i]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.songsToQueue,
      shrinkWrap: true,
      itemBuilder: (_, i) => Card(
        color: Colors.lightGreen,
        child: i < tracks.length
            ? ListTile(
                //leading: FlutterLogo(size: 72.0), TODO: Album cover image?
                title: Text(tracks[i].name),
                subtitle: Text(tracks[i].artists.join(', ')),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  color: Colors.white,
                  onPressed: () => _removeTrack(i),
                ),
              )
            : ListTile(),
      ),
    );
  }
}
