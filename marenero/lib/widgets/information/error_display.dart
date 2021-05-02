import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Something went wrong.',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
