import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
import 'package:marenero/widgets/party_builder.dart';
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

  callback(selectedTrack) {
    setState(() {
      selected.add(selectedTrack);
      // TODO: Add to Firebase.
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PartyBuilder(
      partyId: widget.partyId,
      builder: (context, party) => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                party.code,
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                '${party.participants.length} party people',
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
                    child:
                        SelectedTracksList(tracks: selected, songsToQueue: 3),
                  ),
                ],
              ),

              // Search tracks:
              Container(
                constraints: BoxConstraints(
                  maxHeight: screenSize.height / 3,
                ),
                child: SearchTracks(
                    spotifyAuthToken: party.spotifyToken,
                    userid: "lostboy1",
                    callback: callback),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
