import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../models/currently_playing.dart';
import '../utils/spotify_api.dart';
import '../utils/firestore_values.dart' as fs;

class PlaybackController extends StatefulWidget {
  final String partyId;
  final String hostToken;

  PlaybackController({required this.partyId, required this.hostToken});

  @override
  _PlaybackControllerState createState() => _PlaybackControllerState();
}

class _PlaybackControllerState extends State<PlaybackController> with TickerProviderStateMixin {
  CurrentlyPlaying current = CurrentlyPlaying(track: null, isPlaying: false);
  bool waiting = false;
  bool isPlaying = false;

  late AnimationController _animationController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(value: current.isPlaying ? 1 : 0, vsync: this, duration: Duration(milliseconds: 250));

    // Update player state once immediatley.
    _updatePlayerState();

    // Update player state periodicly.
    _timer = new Timer.periodic(Duration(milliseconds: 1000), (Timer t) async => {_updatePlayerState()});
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _updatePlayerState() async {
    current = await currentlyPlaying(widget.hostToken);

    FirebaseFirestore.instance
        .collection(fs.Collection.parties)
        .doc(widget.partyId)
        .update({fs.Party.currentlyPlaying: current.toFirestoreObject()});

    setState(() {
      if (!waiting) {
        isPlaying = current.isPlaying;
        current.isPlaying ? _animationController.forward() : _animationController.reverse();
      }
    });
  }

  void _togglePlaying() async {
    waiting = true;
    var animation = isPlaying ? _animationController.reverse() : _animationController.forward();

    isPlaying = !isPlaying;
    setState(() {}); // Make animation happen.

    if (current.track == null) {
      await animation;
    } else {
      isPlaying ? await resumePlayback(widget.hostToken) : await pausePlayback(widget.hostToken);
    }

    waiting = false;
    _updatePlayerState();
  }

  void _skipToNext() async {
    await skipToNext(widget.hostToken);
    _updatePlayerState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (current.track != null)
          Image.network(
            current.track!.imageObjects[current.track!.imageObjects.length - 1]['url'],
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  current.track?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                AutoSizeText(
                  current.track?.artists.join(', ') ?? "",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: _togglePlaying,
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _animationController,
          ),
        ),
        IconButton(
          onPressed: _skipToNext,
          icon: Icon(Icons.skip_next_outlined),
        ),
      ],
    );
  }
}
