import 'package:flutter/material.dart';

class PartyAppBarTitle extends StatelessWidget {
  final String code;

  const PartyAppBarTitle(this.code);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Show this code to your friends',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          code,
          style: Theme.of(context).textTheme.headline1,
        ),
      ],
    );
  }
}
