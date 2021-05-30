// See also: https://developer.spotify.com/documentation/web-api/reference/#object-trackobject

import '../utils/firestore_values.dart' as fs;

class MyTrack {
  final String spotifyURI;
  final String name;
  final List<String> artists;
  String? uid;

  MyTrack({
    required this.spotifyURI,
    required this.name,
    required this.artists,
    this.uid,
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

  /// Creates an instance from a Firestore object.
  factory MyTrack.fromFirestoreObject(Map<String, dynamic> data) {
    return MyTrack(
      spotifyURI: data[fs.MyTrack.uri],
      name: data[fs.MyTrack.name],
      artists: data[fs.MyTrack.artists],
      uid: data[fs.MyTrack.uid],
    );
  }

  Map<String, dynamic> toFirestoreObject() {
    return {
      fs.MyTrack.uri: spotifyURI,
      fs.MyTrack.name: name,
      fs.MyTrack.artists: artists,
      fs.MyTrack.uid: uid,
    };
  }
}
