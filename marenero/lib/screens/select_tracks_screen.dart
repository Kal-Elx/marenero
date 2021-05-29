import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
import 'package:marenero/widgets/select_tracks/search_tracks.dart';
import 'package:marenero/widgets/select_tracks/selected_tracks_list.dart';
import 'package:spotify_sdk/models/track.dart';

class SelectTracksScreen extends StatelessWidget {
  final String spotifyAuthToken;
  SelectTracksScreen({
    required this.spotifyAuthToken,
  });
  List<MyTrack> selected = [];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Selected tracks:
                Column(
                  children: [
                    Text("SELECT YOUR BANGERS:"),
                    Container(
                      // TODO: Make this a StreamBuilder, or stateful.
                      constraints: BoxConstraints(
                        maxHeight: screenSize.height / 3,
                      ),
                      child: SelectedTracksList(tracks: selected),
                    ),
                  ],
                ),

                // Search tracks:
                Container(
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height / 3,
                    ),
                    child: SearchTracks(
                        spotifyAuthToken: spotifyAuthToken, userid: "lostboy1"))
              ],
            )));
  }
}
