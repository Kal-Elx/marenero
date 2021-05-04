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

  Future<void> _findParty(String code) async {
    final partySnapshot = await _firestore
        .collection(fs.Collection.parties)
        .where(fs.Party.code, isEqualTo: code)
        .get();
    if (partySnapshot.docs.isNotEmpty) {
      var id = partySnapshot.docs.first.id;
      await _firestore.collection(fs.Collection.parties).doc(id).update({
        fs.Party.participants:
            FieldValue.arrayUnion(['guest-${Random().nextInt(100)}'])
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
