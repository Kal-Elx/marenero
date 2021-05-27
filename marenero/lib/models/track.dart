// See also: https://developer.spotify.com/documentation/web-api/reference/#object-trackobject
class Track {
  final String spotifyURI;
  final String name;
  final List<String> artists;

  Track({
    required this.spotifyURI,
    required this.name,
    required this.artists,
  });

  factory Track.fromJson(Map<String, dynamic> trackObject) {
    List<String> artists = [];
    for (Map<String, dynamic> artistObject in trackObject['artists'] as List) {
      artists.add(artistObject['name'] as String);
    }
    return Track(
      spotifyURI: trackObject['uri'] as String,
      name: trackObject['name'] as String,
      artists: artists,
    );
  }

  // TODO: Add to/from Firestore object functionality here?
}
