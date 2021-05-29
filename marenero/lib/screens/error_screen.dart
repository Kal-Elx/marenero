import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Something went wrong.',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}