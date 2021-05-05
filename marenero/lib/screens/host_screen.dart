import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/party_setup/lobby.dart';
import '../widgets/information/error_display.dart';
import '../widgets/information/loading_display.dart';
import '../utils/spotify_api.dart';
import '../utils/firestore_values.dart' as fs;

class HostScreen extends StatelessWidget {
  static const routeName = '/host';
  final _firestore = FirebaseFirestore.instance;
  late final String _spotifyAuthToken;
  late final String _displayName;

  /// Authenticates Spotify user and creates a party session on firestore.
  Future<String> _createParty() async {
    _spotifyAuthToken = await getAuthenticationToken();
    _displayName = await _getDisplayName();

    var docRef = await _firestore.collection(fs.Collection.parties).add({
      fs.Party.participants: [_displayName],
    });
    return docRef.id;
  }

  /// Returns the display name of the current Spotify user.
  Future<String> _getDisplayName() async {
    String url = "https://api.spotify.com/v1/me";
    final response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer $_spotifyAuthToken'});
    var responseData = json.decode(response.body);
    return responseData["display_name"];
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: FutureBuilder(
          future: _createParty(),
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
              print(snapshot.error);
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
