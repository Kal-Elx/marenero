import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

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
