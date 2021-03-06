import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:tap_debouncer/tap_debouncer.dart';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../models/currently_playing.dart';
import '../widgets/party_builder.dart';
import '../widgets/participants_list.dart';
import '../models/participant.dart';
import '../models/party.dart';
import 'error_screen.dart';
import 'loading_screen.dart';
import '../utils/spotify_api.dart';
import '../utils/firestore_values.dart' as fs;
import '../widgets/party_app_bar_title.dart';
import '../widgets/rounded_divider.dart';
import '../widgets/playback_controller.dart';
import '../widgets/party_settings.dart';
import 'select_tracks_screen.dart';
import '../utils/analytics.dart';

class HostScreen extends StatefulWidget {
  static const routeName = '/host';
  final analytics = FirebaseAnalytics.instance;
  late final String hostToken;

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
    final appInfo = await _firestore.collection(fs.Collection.appInfo).doc(fs.SpotifyAppInfo.document).get();
    widget.hostToken = await getAuthenticationToken(
      clientId: appInfo.get(fs.SpotifyAppInfo.clientId),
      redirectUrl: appInfo.get(fs.SpotifyAppInfo.redirectUrl),
    );
    participant = Participant(
      name: await _getDisplayName(widget.hostToken),
      host: true,
    );

    CurrentlyPlaying current = CurrentlyPlaying(track: null, isPlaying: false);

    var docRef = await _firestore.collection(fs.Collection.parties).add({
      fs.Party.participants: [participant.toFirestoreObject()],
      fs.Party.songsToQueue: 3,
      fs.Party.currentlyPlaying: current.toFirestoreObject(),
    });
    _partyId = docRef.id;

    widget.analytics.logHostParty(code: docRef.id);

    return docRef.id;
  }

  /// Returns the display name of the current Spotify user.
  Future<String> _getDisplayName(String token) async {
    String url = "https://api.spotify.com/v1/me";
    final response = await http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
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
      await queueTrack(widget.hostToken, track);
    }
    await _firestore.collection(fs.Collection.parties).doc(party.id).update({fs.Party.queuedTracks: []});
    widget.analytics.logQueueAllTracks(tracks);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _createParty(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final partyId = snapshot.data.toString();

          FocusScope.of(context).unfocus();

          return PartyBuilder(
            partyId: partyId,
            builder: (context, party) => Scaffold(
              appBar: AppBar(
                title: PartyAppBarTitle(party.code),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    RoundedDivider(),
                    Text(
                      "Search",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Focus(
                      onFocusChange: (isFocused) {
                        if (isFocused) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SelectTracksScreen(
                                partyId: partyId,
                                userId: participant.id,
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              decoration: InputDecoration(hintText: 'Search for songs to queue'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RoundedDivider(),
                    Expanded(
                      child: ParticipantsList(
                        participants: party.participants,
                        tracks: party.queuedTracks,
                        songsToQueue: party.songsToQueue,
                      ),
                    ),
                    RoundedDivider(height: 4.0),
                    PartySettings(
                      selected: party.songsToQueue,
                      onSelect: (selected) {
                        _firestore.collection(fs.Collection.parties).doc(partyId).update(
                          {fs.Party.songsToQueue: selected},
                        );
                      },
                    ),
                    Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: party.isConnected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        firstChild: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              'Is everyone ready?',
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            TapDebouncer(
                              onTap: () async {
                                await queueAllSongs(party);
                              },
                              builder: (_, onTap) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: OutlinedButton(
                                    onPressed: onTap,
                                    child: Text(
                                      'Queue all songs',
                                      style:
                                          Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        secondChild: Center(
                          child: AutoSizeText(
                            'It\'s way too quiet in here\n'
                            'Play some music with your Spotify account to get this party started',
                            style: Theme.of(context).textTheme.headline3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    RoundedDivider(height: 4.0),
                    PlaybackController(
                      partyId: partyId,
                      hostToken: widget.hostToken,
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
