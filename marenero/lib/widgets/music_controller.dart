import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marenero/models/currently_playing.dart';
import 'package:marenero/utils/spotify_api.dart';
import 'dart:async';

class MusicController extends StatefulWidget {
  final bool forHost;
  final String spotifyToken;

  MusicController({required this.forHost, required this.spotifyToken});

  @override
  _MusicControllerState createState() => _MusicControllerState();
}

class _MusicControllerState extends State<MusicController>
    with TickerProviderStateMixin {
  CurrentlyPlaying current = CurrentlyPlaying(track: null, isPlaying: false);
  bool waiting = false;
  bool isPlaying = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        value: current.isPlaying ? 1 : 0,
        vsync: this,
        duration: Duration(milliseconds: 250));

    // Update player state once immediatley.
    _updatePlayerState();

    // Update player state periodicly.
    new Timer.periodic(Duration(milliseconds: 1000),
        (Timer t) async => {_updatePlayerState()});
  }

  void _updatePlayerState() async {
    current = await currentlyPlaying(widget.spotifyToken);

    setState(() {
      if (!waiting) {
        isPlaying = current.isPlaying;
        current.isPlaying
            ? _animationController.forward()
            : _animationController.reverse();
      }
    });
  }

  void _togglePlaying() async {
    waiting = true;
    var animation = isPlaying
        ? _animationController.reverse()
        : _animationController.forward();

    isPlaying = !isPlaying;
    setState(() {}); // Make animation happen.

    if (current.track == null) {
      await animation;
    } else {
      isPlaying
          ? await resumePlayback(widget.spotifyToken)
          : await pausePlayback(widget.spotifyToken);
    }

    waiting = false;
    _updatePlayerState();
  }

  void _skipToNext() async {
    await skipToNext(widget.spotifyToken);
    _updatePlayerState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (current.track != null)
          Image.network(
            current.track!.imageObjects[current.track!.imageObjects.length - 1]
                ['url'],
            height: 50.0,
            width: 50.0,
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
                      ),
                ),
                AutoSizeText(
                  current.track?.artists.join(', ') ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        if (widget.forHost)
          IconButton(
            onPressed: _togglePlaying,
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animationController,
            ),
          ),
        if (widget.forHost)
          IconButton(
            onPressed: _skipToNext,
            icon: Icon(Icons.skip_next_outlined),
          ),
      ],
    );
  }
}
