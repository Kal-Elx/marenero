import 'package:flutter/material.dart';

class PartyIsOverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Sorry, this party is over\nShow up on time next time',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
