import 'package:firebase_analytics/firebase_analytics.dart';

import '../models/my_track.dart';

extension Analytics on FirebaseAnalytics {
  Future<void> logHostParty({required String code}) async {
    await logEvent(name: 'host_party', parameters: {'code': code});
    await setUserProperty(name: 'role', value: 'host');
  }

  Future<void> logJoinParty({required String code}) async {
    await logEvent(name: 'join_party', parameters: {'code': code});
    await setUserProperty(name: 'role', value: 'guest');
  }

  Future<void> logAddTrack(MyTrack track) => logEvent(name: 'add_track', parameters: track.toAnalyticsObject());

  Future<void> logRemoveTrack(MyTrack track) => logEvent(name: 'remove_track', parameters: track.toAnalyticsObject());

  Future<void> logQueueAllTracks(List<MyTrack> tracks) => logEvent(
        name: 'add_track',
        parameters: {
          'count': tracks.length,
          'tracks': tracks.map((track) => track.toAnalyticsObject()).toList(growable: false),
        },
      );
}

extension on MyTrack {
  Map<String, dynamic> toAnalyticsObject() => {
        'title': name,
        'artists': artists,
        'uri': uri,
      };
}
