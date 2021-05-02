import 'package:flutter/material.dart';

class PartyIsOverDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sorry, this party is over.',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
