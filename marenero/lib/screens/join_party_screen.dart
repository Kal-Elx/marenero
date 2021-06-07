import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marenero/models/participant.dart';
import 'package:marenero/screens/guest_screen.dart';
import 'package:marenero/widgets/displayname_input.dart';

import '../widgets/code_input.dart';
import '../utils/firestore_values.dart' as fs;

class JoinPartyScreen extends StatefulWidget {
  static const routeName = '/join';

  @override
  _JoinPartyScreenState createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  final _firestore = FirebaseFirestore.instance;
  String name = '';
  bool nameSubmitted = false;

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
      final user = Participant(name: name);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AutoSizeText(
                  !nameSubmitted
                      ? 'What do they call you?'
                      : 'What is the party code?',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: !nameSubmitted
                      ? DisplayNameInput(
                          onSubmit: (input) {
                            setState(() {
                              name = input;
                              nameSubmitted = true;
                            });
                          },
                          name: "",
                        )
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
