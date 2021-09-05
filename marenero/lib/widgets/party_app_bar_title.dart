import 'package:flutter/material.dart';

class PartyAppBarTitle extends StatelessWidget {
  final String code;

  const PartyAppBarTitle(this.code);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 4.0),
        Text(
          'Show this code to your friends',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 4.0),
        Text(
          code.replaceAllMapped(
              RegExp(r".{2}"), (match) => "${match.group(0)} "),
          style: Theme.of(context).textTheme.headline2,
        ),
      ],
    );
  }
}
