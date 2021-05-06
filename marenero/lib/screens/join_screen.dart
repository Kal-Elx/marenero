import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/party_setup/code_input.dart';
import '../widgets/party_setup/lobby.dart';
import '../utils/firestore_values.dart' as fs;

class JoinScreen extends StatefulWidget {
  static const routeName = '/join';

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _firestore = FirebaseFirestore.instance;
  String? _partyId;
  String _userId = 'guest-${Random().nextInt(100)}';

  @override
  void dispose() {
    super.dispose();
    _cleanUp();
  }

  Future<void> _findParty(String code) async {
    final partySnapshot = await _firestore
        .collection(fs.Collection.parties)
        .where(fs.Party.code, isEqualTo: code)
        .get();
    if (partySnapshot.docs.isNotEmpty) {
      var id = partySnapshot.docs.first.id;
      await _firestore.collection(fs.Collection.parties).doc(id).update({
        fs.Party.participants: FieldValue.arrayUnion([_userId])
      });
      setState(() {
        _partyId = id;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There is no party with that code. Try again.')),
      );
    }
  }

  /// Removes the user from the party when the user leaves.
  void _cleanUp() {
    print('Cleaning up');
    if (_partyId != null) {
      _firestore.collection(fs.Collection.parties).doc(_partyId).update({
        fs.Party.participants: FieldValue.arrayRemove([_userId])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: Center(
          child: _partyId == null
              ? CodeInput(
                  onComplete: _findParty,
                )
              : Lobby(partyId: _partyId!),
        ),
      ),
    );
  }
}
