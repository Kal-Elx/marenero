import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/party_builder.dart';
import 'search_tracks.dart';
import '../widgets/selected_tracks_list.dart';
import '../utils/firestore_values.dart' as fs;
import '../models/my_track.dart';
import '../widgets/rounded_divider.dart';

class SelectTracksScreen extends StatelessWidget {
  final String partyId;
  final String userId;

  const SelectTracksScreen({
    required this.partyId,
    required this.userId,
  });

  addSelectedCallback(MyTrack selectedTrack) {
    selectedTrack.uid = userId;
    FirebaseFirestore.instance
        .collection(fs.Collection.parties)
        .doc(partyId)
        .update({
      fs.Party.queuedTracks:
          FieldValue.arrayUnion([selectedTrack.toFirestoreObject()])
    });
  }

  removeSelectedCallback(MyTrack selectedTrack) {
    FirebaseFirestore.instance
        .collection(fs.Collection.parties)
        .doc(partyId)
        .update({
      fs.Party.queuedTracks:
          FieldValue.arrayRemove([selectedTrack.toFirestoreObject()])
    });
  }

  @override
  Widget build(BuildContext context) {
    return PartyBuilder(
        partyId: partyId,
        builder: (context, party) {
          final selectedTracks =
              party.queuedTracks.where((track) => track.uid == userId).toList();
          return Scaffold(
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundedDivider(),
                  Text(
                    party.songsToQueue == 1
                        ? 'Select a banger'
                        : 'Select ${party.songsToQueue} bangers',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SelectedTracksList(
                    tracks: selectedTracks,
                    songsToQueue: party.songsToQueue,
                    removeSelectedCallback: removeSelectedCallback,
                  ),
                  RoundedDivider(),
                  selectedTracks.length < party.songsToQueue
                      ? Expanded(
                          child: SearchTracks(
                            spotifyToken: party.spotifyToken,
                            userid: userId,
                            selectTrackCallback: addSelectedCallback,
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Return to the dance floor'),
                        ),
                ],
              ),
            ),
          );
        });
  }
}
