import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
import 'package:marenero/widgets/select_tracks/search_tracks.dart';
import 'package:marenero/widgets/select_tracks/selected_tracks_list.dart';

class SelectTracksScreen extends StatefulWidget {
  final String partyId;
  final String userId;

  const SelectTracksScreen({
    required this.partyId,
    required this.userId,
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
                'code', // TODO: Fix me
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                '${1 + 1} party people', // TODO: Fix me
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
                    // TODO: Fix me
                    spotifyAuthToken: 'widget.spotifyAuthToken',
                    userid: widget.userId,
                  ),
                )
              ],
            )));
  }
}
