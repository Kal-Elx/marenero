import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/party_setup/lobby.dart';
import '../widgets/information/error_display.dart';
import '../widgets/information/loading_display.dart';
import '../utils/firestore_values.dart' as fs;

class HostScreen extends StatelessWidget {
  static const routeName = '/host';
  final _firestore = FirebaseFirestore.instance;

  /// Creates a party session on firestore.
  Future<String> createParty() async {
    var docRef = await _firestore.collection(fs.Collection.parties).add({});
    return docRef.id;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: FutureBuilder(
          future: createParty(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var partyId = snapshot.data.toString();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Lobby(partyId: partyId),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Start the party'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return ErrorDisplay();
            } else {
              return LoadingDisplay();
            }
          },
        ),
      ),
    );
  }
}
