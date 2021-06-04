// See also: https://developer.spotify.com/documentation/web-api/reference/#object-trackobject

import '../utils/firestore_values.dart' as fs;

class MyTrack {
  final String uri;
  final String name;
  final List<String> artists;
  final List<Map<String, dynamic>> imageObjects;
  String? uid;

  MyTrack({
    required this.uri,
    required this.name,
    required this.artists,
    required this.imageObjects,
    this.uid,
  });

  factory MyTrack.fromJson(Map<String, dynamic> trackObject) {
    List<String> artists = [];
    for (Map<String, dynamic> artistObject in trackObject['artists'] as List) {
      artists.add(artistObject['name'] as String);
    }

    List<Map<String, dynamic>> imageObjects = trackObject['album']['images'];

    return MyTrack(
      uri: trackObject['uri'] as String,
      name: trackObject['name'] as String,
      artists: artists,
      imageObjects: imageObjects,
    );
  }

  /// Creates an instance from a Firestore object.
  factory MyTrack.fromFirestoreObject(Map<String, dynamic> data) {
    return MyTrack(
      uri: data[fs.MyTrack.uri],
      name: data[fs.MyTrack.name],
      artists: data[fs.MyTrack.artists],
      imageObjects: data[fs.MyTrack.imageObjects],
      uid: data[fs.MyTrack.uid],
    );
  }

  Map<String, dynamic> toFirestoreObject() {
    return {
      fs.MyTrack.uri: uri,
      fs.MyTrack.name: name,
      fs.MyTrack.artists: artists,
      fs.MyTrack.imageObjects: imageObjects,
      fs.MyTrack.uid: uid,
    };
  }
}
