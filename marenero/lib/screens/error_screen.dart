import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Oh no, something went wrong',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
