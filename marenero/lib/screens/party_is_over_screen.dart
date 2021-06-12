import 'package:flutter/material.dart';

class PartyIsOverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          "Sorry, this party is over.\nYou don't have to go home but you can't stay here.",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
