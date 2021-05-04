import 'package:flutter/material.dart';

class ParticipantsList extends StatelessWidget {
  final List<String> participants;

  ParticipantsList({required this.participants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: participants.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(
          participants[i],
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
