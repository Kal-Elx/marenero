class Collection {
  const Collection._();
  static const parties = 'parties';
  static const appInfo = 'app_info';
}

class Party {
  const Party._();
  static const code = 'code';
  static const participants = 'participants';
  static const accessToken = 'token';
  static const songsToQueue = 'songs_to_queue';
  static const queuedTracks = 'tracks';
  static const currentlyPlaying = 'currently_playing';
}

class Participant {
  const Participant._();
  static const id = 'id';
  static const name = 'name';
  static const host = 'host';
}

class MyTrack {
  const MyTrack._();
  static const uri = 'uri';
  static const name = 'name';
  static const artists = 'artists';
  static const imageObjects = 'imageObjects';
  static const uid = 'uid';
}

class CurrentlyPlaying {
  const CurrentlyPlaying._();
  static const track = 'track';
  static const isPlaying = 'isPlaying';
}

class SpotifyAppInfo {
  const SpotifyAppInfo._();
  static const document = 'spotify';
  static const clientId = 'client_id';
  static const redirectUrl = 'redirect_url';
}
