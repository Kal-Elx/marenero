import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../widgets/party_builder.dart';
import '../widgets/search_tracks.dart';
import '../widgets/selected_tracks_list.dart';
import '../utils/firestore_values.dart' as fs;
import '../models/my_track.dart';
import '../widgets/rounded_divider.dart';
import '../utils/analytics.dart';

class SelectTracksScreen extends StatefulWidget {
  final String partyId;
  final String userId;
  final analytics = FirebaseAnalytics.instance;

  SelectTracksScreen({
    required this.partyId,
    required this.userId,
  });

  @override
  State<SelectTracksScreen> createState() => _SelectTracksScreenState();
}

class _SelectTracksScreenState extends State<SelectTracksScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 1.0, // Start expanded
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  addSelectedCallback(MyTrack selectedTrack) {
    selectedTrack.uid = widget.userId;
    FirebaseFirestore.instance.collection(fs.Collection.parties).doc(widget.partyId).update({
      fs.Party.queuedTracks: FieldValue.arrayUnion([selectedTrack.toFirestoreObject()])
    });
    widget.analytics.logAddTrack(selectedTrack);
  }

  removeSelectedCallback(MyTrack selectedTrack) {
    FirebaseFirestore.instance.collection(fs.Collection.parties).doc(widget.partyId).update({
      fs.Party.queuedTracks: FieldValue.arrayRemove([selectedTrack.toFirestoreObject()])
    });
    widget.analytics.logRemoveTrack(selectedTrack);
  }

  @override
  Widget build(BuildContext context) {
    return PartyBuilder(
        partyId: widget.partyId,
        builder: (context, party) {
          final selectedTracks = party.queuedTracks.where((track) => track.uid == widget.userId).toList();
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Column(
                  children: [
                    Text(
                      party.code.replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)} "),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    Text(
                      '${party.participants.length} party people',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              resizeToAvoidBottomInset: true,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedDivider(),
                    Text(
                      party.songsToQueue == 1 ? 'Select a banger' : 'Select ${party.songsToQueue} bangers',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizeTransition(
                      sizeFactor: _animation,
                      axis: Axis.vertical,
                      axisAlignment: 1.0,
                      child: SelectedTracksList(
                        tracks: selectedTracks,
                        songsToQueue: party.songsToQueue,
                        removeSelectedCallback: removeSelectedCallback,
                      ),
                    ),
                    RoundedDivider(),
                    selectedTracks.length < party.songsToQueue
                        ? Expanded(
                            child: SearchTracks(
                              spotifyToken: party.partyToken,
                              userid: widget.userId,
                              selectTrackCallback: addSelectedCallback,
                              onFocusChange: (isFocused) {
                                if (isFocused) {
                                  _controller.reverse();
                                } else {
                                  _controller.forward();
                                }
                              },
                            ),
                          )
                        : OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Return to the dance floor',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
