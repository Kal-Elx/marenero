class Collection {
  const Collection._();
  static const parties = 'parties';
}

class Party {
  const Party._();
  static const code = 'code';
  static const participants = 'participants';
  static const spotifyToken = 'spotify_token';
  static const songsToQueue = 'songs_to_queue';
  static const queuedTracks = 'tracks';
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
  static const uid = 'uid';
}
