import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String _userId = 'guest-${Random().nextInt(100)}';

  Future<void> _findParty({
    required String code,
    required void Function(String partyId) onFoundParty,
  }) async {
    final partySnapshot = await _firestore
        .collection(fs.Collection.parties)
        .where(fs.Party.code, isEqualTo: code)
        .get();
    if (partySnapshot.docs.isNotEmpty) {
      var id = partySnapshot.docs.first.id;
      await _firestore.collection(fs.Collection.parties).doc(id).update({
        fs.Party.participants: FieldValue.arrayUnion([_userId])
      });
      onFoundParty(id);
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
          child: CodeInput(
            onComplete: (code) => _findParty(
              code: code,
              onFoundParty: (partyId) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => GuestScreen(partyId: partyId),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
