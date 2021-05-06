import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'code.dart';
import 'participants_list.dart';
import '../information/error_display.dart';
import '../information/loading_display.dart';
import '../information/party_is_over_display.dart';
import '../../models/party.dart';
import '../../utils/firestore_values.dart' as fs;

class Lobby extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String partyId;

  Lobby({
    required this.partyId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _firestore
            .collection(fs.Collection.parties)
            .doc(partyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorDisplay();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingDisplay();
            case ConnectionState.active:
              var partyDocument = snapshot.data as DocumentSnapshot;
              if (!partyDocument.exists) {
                return PartyIsOverDisplay();
              }
              try {
                var party = Party.fromFirestoreObject(partyDocument);
                return party.code.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Code(party.code),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 500,
                            ),
                            child: ParticipantsList(
                                participants: party.participants),
                          ),
                        ],
                      )
                    : LoadingDisplay();
              } on TypeError {
                //* Still loading. Waiting for cloud function to set values.
                return LoadingDisplay();
              }
            case ConnectionState.done:
              return PartyIsOverDisplay();
          }
        });
  }
}