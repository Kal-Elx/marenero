import 'package:flutter/material.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final browser = Browser.detectOrNull();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          browser?.browser.contains('Safari') ?? false
              ? "Oh no, something went wrong and it's most likely because of your browser\nTry Google Chrome instead"
              : 'Oh no, something went wrong',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
