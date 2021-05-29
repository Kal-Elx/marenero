//import 'package:spotify_sdk/models/track.dart';
import 'package:marenero/models/my_track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getAuthenticationToken() async {
  try {
    var authenticationToken = await SpotifySdk.getAuthenticationToken(
        clientId: env['CLIENT_ID'].toString(),
        redirectUrl: env['REDIRECT_URL'].toString(),
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'playlist-read-private, '
            'playlist-modify-public,user-read-currently-playing');
    //print('Got a token: $authenticationToken');
    return authenticationToken;
  } on PlatformException catch (e) {
    print(e.code);
    return Future.error('$e.code: $e.message');
  } on MissingPluginException {
    print('not implemented');
    return Future.error('not implemented');
  }
}

Future<List<MyTrack>> searchTracks(String spotifyAuthToken, String input,
    [int limit = 10]) async {
  List<MyTrack> searchedTracks = [];

  String url =
      "https://api.spotify.com/v1/search?q=${input.replaceAll(' ', '%20')}&type=track&market=SE&limit=$limit";
  final response = await http.get(Uri.parse(url),
      headers: {'Authorization': 'Bearer $spotifyAuthToken'});
  final responseData = json.decode(response.body);

  try {
    final trackObjects = responseData['tracks']['items'] as List;
    searchedTracks = trackObjects.map((t) => MyTrack.fromJson(t)).toList();
  } catch (error) {
    print("Error in searchTracks: $error");
    searchedTracks.clear();
  }

  return searchedTracks;
}
