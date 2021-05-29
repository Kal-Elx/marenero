import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/error_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/party_is_over_screen.dart';
import '../models/party.dart';
import '../utils/firestore_values.dart' as fs;

class PartyBuilder extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String partyId;
  final Widget Function(BuildContext context, Party party) builder;

  PartyBuilder({
    required this.partyId,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream:
          _firestore.collection(fs.Collection.parties).doc(partyId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return LoadingScreen();
          case ConnectionState.active:
            var partyDocument = snapshot.data as DocumentSnapshot;
            if (!partyDocument.exists) {
              return PartyIsOverScreen();
            }
            try {
              var party = Party.fromFirestoreObject(partyDocument);
              return party.code.isNotEmpty
                  ? builder(context, party)
                  : LoadingScreen();
            } on TypeError {
              //* Still loading. Waiting for cloud function to set values.
              return LoadingScreen();
            }
          case ConnectionState.done:
            return PartyIsOverScreen();
        }
      },
    );
  }
}
