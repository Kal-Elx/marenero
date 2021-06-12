import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextLogo extends StatelessWidget {
  late final String text;

  TextLogo(String text) {
    this.text = text.replaceAll(' ', '\n');
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: 1,
      style: Theme.of(context).textTheme.headline1!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
      textAlign: TextAlign.center,
    );
  }
}
