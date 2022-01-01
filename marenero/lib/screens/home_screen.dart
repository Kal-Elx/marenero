import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:marenero/design/text_logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../utils/firestore_values.dart' as fs;
import '../utils/analytics.dart';
import 'enter_name_screen.dart';
import 'host_screen.dart';

class HomeScreen extends StatefulWidget {
  final analytics = FirebaseAnalytics.instance;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = FirebaseFirestore.instance;
  String partyCode = "";
  bool partyCodeError = false;

  // manage state of modal progress HUD widget
  bool _isLoading = false;

  Future<void> joinParty() async {
    if (await _partyExists(code: partyCode)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EnterNameScreen(
            partyCode: partyCode,
          ),
        ),
      );
      widget.analytics.logJoinParty(code: partyCode);
    } else {
      setState(() {
        partyCodeError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'We didn\'t recognize that party code. Please check and try again.',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _partyExists({required String code}) async {
    // start the modal progress HUD
    setState(() {
      _isLoading = true;
    });
    final partySnapshot =
        await _firestore.collection(fs.Collection.parties).where(fs.Party.code, isEqualTo: code).get();
    setState(() {
      _isLoading = false;
    });
    return partySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        progressIndicator: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.white)),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Connecting to party",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        color: Colors.black,
        opacity: 2 / 3,
        child: Container(
          width: screenSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextLogo('Marenero'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  width: 320,
                  height: 138,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 4),
                        child: TextField(
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyText1!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: partyCodeError ? Colors.red : Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: partyCodeError ? Colors.red : Colors.black),
                            ),
                            hintText: 'Party Code',
                            hintStyle: theme.textTheme.bodyText1!.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (text) {
                            partyCode = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 4, 15, 0),
                        child: TextButton(
                          child: Text(
                            "Join Party",
                            style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: theme.backgroundColor,
                              minimumSize: Size(320, 55)),
                          onPressed: joinParty,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  'or',
                  style: theme.textTheme.bodyText1!.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextButton.icon(
                  label: Text(
                    "Host Party",
                    style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  icon: RotatedBox(
                    quarterTurns: 3,
                    child: Icon(Icons.contactless),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color.fromRGBO(30, 215, 96, 1.0),
                    minimumSize: Size(300, 55),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => HostScreen(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 380),
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Host a party and share the code with your friends',
                      style: theme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Put a few good songs in the queue, we shuffle them for you',
                      style: theme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Enjoy the music, can you guess who queued which song?',
                      style: theme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
