import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firestore_values.dart' as fs;

import '../widgets/party_builder.dart';
import '../widgets/party_app_bar_title.dart';
import '../widgets/participants_list.dart';

class GuestScreen extends StatefulWidget {
  final String partyId;

  const GuestScreen({
    required this.partyId,
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
    // _firestore.collection(fs.Collection.parties).doc(_partyId).update({
    //   fs.Party.participants: FieldValue.arrayRemove([_userId])
    // });
  }

  @override
  Widget build(BuildContext context) {
    return PartyBuilder(
      partyId: widget.partyId,
      builder: (context, party) => Scaffold(
        appBar: AppBar(
          title: PartyAppBarTitle(party.code),
        ),
        body: Column(
          children: [
            Divider(),
            Expanded(
              child: ParticipantsList(
                participants: party.participants,
                songsToQueue: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
