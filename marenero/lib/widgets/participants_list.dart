import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/participant.dart';

class ParticipantsList extends StatelessWidget {
  final List<Participant> participants;
  final int songsToQueue;

  ParticipantsList({
    required this.participants,
    required this.songsToQueue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          'Your friends',
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
              trailing: AutoSizeText(
                '${participants[i].queuedTracks.length}/$songsToQueue',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
