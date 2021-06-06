import 'package:flutter/material.dart';

import '../screens/select_tracks_screen.dart';

class SelectTracksButton extends StatelessWidget {
  final String partyId;
  final String userId;

  const SelectTracksButton({
    required this.partyId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SelectTracksScreen(
              partyId: partyId,
              userId: userId,
            ),
          ),
        );
      },
      child: const Icon(Icons.search),
    );
  }
}
