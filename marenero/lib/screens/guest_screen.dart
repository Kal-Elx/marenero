import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firestore_values.dart' as fs;

import '../widgets/party_builder.dart';
import '../widgets/party_app_bar_title.dart';
import '../widgets/participants_list.dart';
import '../widgets/selects_tracks_button.dart';
import '../widgets/rounded_divider.dart';
import '../widgets/music_controller.dart';

class GuestScreen extends StatefulWidget {
  final String partyId;
  final String userId;

  const GuestScreen({
    required this.partyId,
    required this.userId,
  });

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    super.dispose();
    _cleanUp();
  }

  /// Removes the user from the party when the user leaves.
  void _cleanUp() {
    _firestore.collection(fs.Collection.parties).doc(widget.partyId).update({
      fs.Party.participants: FieldValue.arrayRemove([widget.userId])
    });
  }

  @override
  Widget build(BuildContext context) {
    return PartyBuilder(
      partyId: widget.partyId,
      builder: (context, party) => Scaffold(
        appBar: AppBar(
          title: PartyAppBarTitle(party.code),
        ),
        floatingActionButton: SelectTracksButton(
          partyId: party.id,
          userId: widget.userId,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              RoundedDivider(),
              Expanded(
                child: ParticipantsList(
                  participants: party.participants,
                  tracks: party.queuedTracks,
                  songsToQueue: party.songsToQueue,
                ),
              ),
              RoundedDivider(height: 4.0),
              MusicController(forHost: false),
            ],
          ),
        ),
      ),
    );
  }
}
