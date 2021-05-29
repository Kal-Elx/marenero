import 'package:flutter/material.dart';

import 'host_screen.dart';
import 'join_party_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Marenero',
              style: Theme.of(context).textTheme.headline1,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(HostScreen.routeName);
              },
              child: Text('Host party'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(JoinPartyScreen.routeName);
              },
              child: Text('Join party'),
            ),
          ],
        ),
      ),
    );
  }
}
