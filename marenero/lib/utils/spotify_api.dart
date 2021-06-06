import 'package:marenero/models/currently_playing.dart';
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
        scope:
            'app-remote-control user-read-playback-state user-modify-playback-state playlist-read-private playlist-modify-public user-read-currently-playing');
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

Future<List<MyTrack>> searchTracks(String spotifyToken, String input,
    [int limit = 10]) async {
  List<MyTrack> searchedTracks = [];

  String url =
      "https://api.spotify.com/v1/search?q=${input.replaceAll(' ', '%20')}&type=track&market=SE&limit=$limit";
  final response = await http
      .get(Uri.parse(url), headers: {'Authorization': 'Bearer $spotifyToken'});
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

Future<bool> queueTrack(String spotifyToken, MyTrack track) async {
  var queryParameters = {'uri': track.uri};
  var uri =
      Uri.https('api.spotify.com', '/v1/me/player/queue', queryParameters);
  final response =
      await http.post(uri, headers: {'Authorization': 'Bearer $spotifyToken'});
  return response.statusCode == 204;
}

Future<bool> resumePlayback(String spotifyToken) async {
  var uri = Uri.https('api.spotify.com', '/v1/me/player/play');
  final response =
      await http.put(uri, headers: {'Authorization': 'Bearer $spotifyToken'});
  return response.statusCode == 204;
}

Future<bool> pausePlayback(String spotifyToken) async {
  var uri = Uri.https('api.spotify.com', '/v1/me/player/pause');
  final response =
      await http.put(uri, headers: {'Authorization': 'Bearer $spotifyToken'});
  return response.statusCode == 204;
}

Future<bool> skipToNext(String spotifyToken) async {
  var uri = Uri.https('api.spotify.com', '/v1/me/player/next');
  final response =
      await http.post(uri, headers: {'Authorization': 'Bearer $spotifyToken'});
  return response.statusCode == 204;
}

Future<bool> isPlaying(String spotifyToken) async {
  var uri = Uri.https('api.spotify.com', '/v1/me/player');
  final response =
      await http.get(uri, headers: {'Authorization': 'Bearer $spotifyToken'});

  final responseData = json.decode(response.body);

  try {
    final isPlaying = responseData['is_playing'] as bool;
    return isPlaying;
  } catch (error) {
    print("Error in isPlaying: $error");
    return false;
  }
}

Future<CurrentlyPlaying> currentlyPlaying(String spotifyToken) async {
  var uri = Uri.https('api.spotify.com', '/v1/me/player/currently-playing');
  final response =
      await http.get(uri, headers: {'Authorization': 'Bearer $spotifyToken'});

  if (response.statusCode == 200) {
    try {
      final responseData = json.decode(response.body);
      final isPlaying = responseData['is_playing'] as bool;
      final trackObject = responseData['item'];
      final track = MyTrack.fromJson(trackObject);
      return CurrentlyPlaying(track: track, isPlaying: isPlaying);
    } catch (error) {
      print("Error in currentlyPlaying: $error");
    }
  }
  return CurrentlyPlaying(track: null, isPlaying: false);
}
