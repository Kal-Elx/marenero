import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
import 'package:marenero/widgets/select_tracks/search_tracks.dart';
import 'package:marenero/widgets/select_tracks/selected_tracks_list.dart';

class SelectTracksScreen extends StatefulWidget {
  final String spotifyAuthToken;
  final String code;
  final int participants;
  SelectTracksScreen({
    required this.spotifyAuthToken,
    required this.code,
    required this.participants,
  });

  @override
  State<SelectTracksScreen> createState() => _SelectTracksScreenState();
}

class _SelectTracksScreenState extends State<SelectTracksScreen> {
  List<MyTrack> selected = [];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                widget.code,
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                '${widget.participants} party people',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
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
                    spotifyAuthToken: widget.spotifyAuthToken,
                    userid: "lostboy1",
                  ),
                )
              ],
            )));
  }
}
