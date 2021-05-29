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

  addSelectedCallback(selectedTrack) {
    setState(() {
      selected.add(selectedTrack);
      // TODO: Add to Firebase.
    });
  }

  removeSelectedCallback(selectedTrack) {
    setState(() {
      selected.remove(selectedTrack);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("SELECT YOUR BANGERS:"),
            SelectedTracksList(
              tracks: selected,
              songsToQueue: party.songsToQueue,
              removeSelectedCallback: removeSelectedCallback,
            ),
            Expanded(
              child: SearchTracks(
                spotifyAuthToken: party.spotifyToken,
                userid: widget.userId,
                selectTrackCallback: addSelectedCallback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
