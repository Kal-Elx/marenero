class Collection {
  const Collection._();
  static const parties = 'parties';
}

class Party {
  const Party._();
  static const code = 'code';
  static const participants = 'participants';
  static const spotifyToken = 'spotify_token';
}

class Participant {
  const Participant._();
  static const id = 'id';
  static const name = 'name';
  static const host = 'host';
  static const queuedTracks = 'queued_tracks';
}
