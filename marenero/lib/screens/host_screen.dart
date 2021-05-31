import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:marenero/widgets/party_settings.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'dart:convert';

import '../widgets/party_builder.dart';
import '../widgets/participants_list.dart';
import '../models/participant.dart';
import '../models/party.dart';
import '../models/my_track.dart';
import 'error_screen.dart';
import 'loading_screen.dart';
import '../utils/spotify_api.dart';
import '../utils/firestore_values.dart' as fs;
import '../widgets/party_app_bar_title.dart';
import '../widgets/selects_tracks_button.dart';
import '../widgets/rounded_divider.dart';

class HostScreen extends StatefulWidget {
  static const routeName = '/host';

  @override
  _HostScreenState createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  final _firestore = FirebaseFirestore.instance;
  late final Participant participant;
  String? _partyId;

  @override
  void dispose() {
    super.dispose();
    _cleanUp();
  }

  /// Authenticates Spotify user and creates a party session on firestore.
  Future<String> _createParty() async {
    final spotifyAuthToken = await getAuthenticationToken();
    participant = Participant(
      name: await _getDisplayName(spotifyAuthToken),
      host: true,
    );

    var docRef = await _firestore.collection(fs.Collection.parties).add({
      fs.Party.spotifyToken: spotifyAuthToken,
      fs.Party.participants: [participant.toFirestoreObject()],
      fs.Party.songsToQueue: 3,
    });
    _partyId = docRef.id;
    return docRef.id;
  }

  /// Returns the display name of the current Spotify user.
  Future<String> _getDisplayName(String token) async {
    String url = "https://api.spotify.com/v1/me";
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    var responseData = json.decode(response.body);
    return responseData["display_name"];
  }

  /// Deletes the current party when the host leaves.
  void _cleanUp() {
    if (_partyId != null) {
      _firestore.collection(fs.Collection.parties).doc(_partyId).delete();
    }
  }

  Future<void> queueAllSongs(Party party) async {
    final tracks = party.queuedTracks;
    tracks.shuffle();
    for (final track in tracks) {
      await queueTrack(party.spotifyToken, track);
    }
    await _firestore
        .collection(fs.Collection.parties)
        .doc(party.id)
        .update({fs.Party.queuedTracks: []});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _createParty(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var partyId = snapshot.data.toString();

          return PartyBuilder(
            partyId: partyId,
            builder: (context, party) => Scaffold(
              appBar: AppBar(
                title: PartyAppBarTitle(party.code),
              ),
              floatingActionButton: SelectTracksButton(
                partyId: partyId,
                userId: participant.id,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    RoundedDivider(),
                    PartySettings(
                      selected: party.songsToQueue,
                      onSelect: (selected) {
                        _firestore
                            .collection(fs.Collection.parties)
                            .doc(partyId)
                            .update(
                          {fs.Party.songsToQueue: selected},
                        );
                      },
                    ),
                    RoundedDivider(),
                    Expanded(
                      child: ParticipantsList(
                        participants: party.participants,
                        tracks: party.queuedTracks,
                        songsToQueue: party.songsToQueue,
                      ),
                    ),
                    RoundedDivider(),
                    TapDebouncer(
                      onTap: () async {
                        await queueAllSongs(party);
                      },
                      builder: (_, onTap) {
                        return OutlinedButton(
                          onPressed: onTap,
                          child: Text('Queue all songs'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return ErrorScreen();
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
