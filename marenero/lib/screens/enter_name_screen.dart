import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../models/participant.dart';
import '../utils/firestore_values.dart' as fs;
import 'guest_screen.dart';
import 'party_is_over_screen.dart';

class EnterNameScreen extends StatefulWidget {
  static const routeName = '/enter';
  final String partyCode;

  EnterNameScreen({required this.partyCode});

  @override
  _EnterNameScreenState createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String _name = "";

  void _onPressed() {
    setState(() {
      _isLoading = true;
    });
    _enterParty(
      code: widget.partyCode,
      name: _name,
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
    );
  }

  Future<void> _enterParty({
    required String code,
    required String name,
    required void Function(String partyId, String userId) onFoundParty,
  }) async {
    final partySnapshot =
        await _firestore.collection(fs.Collection.parties).where(fs.Party.code, isEqualTo: code).get();
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => PartyIsOverScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
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
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Your name',
                            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onChanged: (text) {
                            _name = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 4, 15, 0),
                        child: TextButton(
                          child: Text(
                            "Enter",
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Theme.of(context).backgroundColor,
                              minimumSize: Size(320, 55)),
                          onPressed: _onPressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
