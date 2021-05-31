import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/participant.dart';
import '../models/my_track.dart';

class ParticipantsList extends StatelessWidget {
  final List<Participant> participants;
  final List<MyTrack> tracks;
  final int songsToQueue;

  ParticipantsList({
    required this.participants,
    required this.tracks,
    required this.songsToQueue,
  });

  Widget _participantStatus(BuildContext context, String uid) {
    final int queudSongs = tracks.where((track) => track.uid == uid).length;

    if (queudSongs >= songsToQueue) {
      return Icon(Icons.done);
    } else {
      return AutoSizeText(
        '$queudSongs/$songsToQueue',
        style: Theme.of(context).textTheme.bodyText1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          'Party people',
          maxLines: 1,
          style: Theme.of(context).textTheme.headline3,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: participants.length,
            itemBuilder: (_, i) => ListTile(
              title: AutoSizeText(
                participants[i].name,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              leading:
                  Icon(participants[i].host ? Icons.music_note_outlined : null),
              trailing: _participantStatus(context, participants[i].id),
            ),
          ),
        ),
      ],
    );
  }
}
