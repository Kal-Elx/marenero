import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marenero/models/participant.dart';
import 'package:marenero/screens/guest_screen.dart';

import '../widgets/code_input.dart';
import '../utils/firestore_values.dart' as fs;

class JoinPartyScreen extends StatefulWidget {
  static const routeName = '/join';

  @override
  _JoinPartyScreenState createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  final _firestore = FirebaseFirestore.instance;
  String _username = '';
  bool _usernameSubmitted = false;

  Future<void> _findParty({
    required String code,
    required void Function(String partyId, String userId) onFoundParty,
  }) async {
    final partySnapshot = await _firestore
        .collection(fs.Collection.parties)
        .where(fs.Party.code, isEqualTo: code)
        .get();
    if (partySnapshot.docs.isNotEmpty) {
      var partyId = partySnapshot.docs.first.id;
      final user = Participant(name: _username);
      await _firestore.collection(fs.Collection.parties).doc(partyId).update({
        fs.Party.participants: FieldValue.arrayUnion(
          [user.toFirestoreObject()],
        )
      });
      onFoundParty(partyId, user.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There is no party with that code. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            child: !_usernameSubmitted
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your name'),
                          style: Theme.of(context).textTheme.bodyText1,
                          onChanged: (text) {
                            _username = text;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _usernameSubmitted = true;
                              });
                            },
                            child: Text('Continue'),
                          ),
                        ),
                      ])
                : CodeInput(
                    onComplete: (code) => _findParty(
                      code: code,
                      onFoundParty: (partyId, userId) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => GuestScreen(
                              partyId: partyId,
                              userId: userId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
