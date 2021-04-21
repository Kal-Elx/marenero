import 'package:flutter/material.dart';

class JoinScreen extends StatelessWidget {
  static const routeName = '/join';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: Text(
          'Join party',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
