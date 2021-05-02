import 'package:flutter/material.dart';

class Code extends StatelessWidget {
  final String code;

  Code(this.code);

  @override
  Widget build(BuildContext context) {
    return Text(
      code,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
