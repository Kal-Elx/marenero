// See also: https://developer.spotify.com/documentation/web-api/reference/#object-trackobject
class MyTrack {
  final String spotifyURI;
  final String name;
  final List<String> artists;

  MyTrack({
    required this.spotifyURI,
    required this.name,
    required this.artists,
  });

  factory MyTrack.fromJson(Map<String, dynamic> trackObject) {
    List<String> artists = [];
    for (Map<String, dynamic> artistObject in trackObject['artists'] as List) {
      artists.add(artistObject['name'] as String);
    }
    return MyTrack(
      spotifyURI: trackObject['uri'] as String,
      name: trackObject['name'] as String,
      artists: artists,
    );
  }

  // TODO: Add to/from Firestore object functionality here?
}
