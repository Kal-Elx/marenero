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
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  'Marenero',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(HostScreen.routeName);
                    },
                    child: Text('Host party'),
                  ),
                  SizedBox(height: 30.0),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(JoinPartyScreen.routeName);
                    },
                    child: Text('Join party'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
