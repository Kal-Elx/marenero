import 'package:flutter/material.dart';

class HostScreen extends StatelessWidget {
  static const routeName = '/host';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: Text(
          'Host party',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
