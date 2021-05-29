import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
//import 'package:spotify_sdk/models/track.dart';

class SelectedTracksList extends StatelessWidget {
  final List<MyTrack> tracks;

  SelectedTracksList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tracks.length,
      shrinkWrap: true,
      itemBuilder: (_, i) => Card(
        child: ListTile(
          //leading: FlutterLogo(size: 72.0), TODO: Album cover image?
          title: Text(tracks[i].name),
          subtitle: Text(tracks[i].artists.join(', ')),
          trailing: Icon(Icons.remove_circle),
        ),
      ),
    );
  }
}
