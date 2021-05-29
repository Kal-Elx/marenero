import 'package:flutter/material.dart';

class PartyIsOverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Sorry, this party is over.',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
