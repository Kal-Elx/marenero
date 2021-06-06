import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';
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
  bool isPlaying = true;
  MyTrack? currentTrack;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        value: isPlaying ? 1 : 0,
        vsync: this,
        duration: Duration(milliseconds: 450));

    // Update player state once immediatley.
    _updatePlayerState();

    // Update player state periodicly.
    new Timer.periodic(Duration(milliseconds: 1000),
        (Timer t) async => {_updatePlayerState()});
  }

  void _updatePlayerState() async {
    final Map<String, dynamic> _currentlyPlaying =
        await currentlyPlaying(widget.spotifyToken);
    isPlaying = _currentlyPlaying['isPlaying'] as bool;
    currentTrack = _currentlyPlaying['track'] as MyTrack;

    isPlaying ? _animationController.forward() : _animationController.reverse();
  }

  void _togglePlaying() async {
    isPlaying ? _animationController.reverse() : _animationController.forward();

    final Map<String, dynamic> _currentlyPlaying =
        await currentlyPlaying(widget.spotifyToken);

    setState(() {
      isPlaying = _currentlyPlaying['isPlaying'] as bool;
      currentTrack = _currentlyPlaying['track'] as MyTrack;
    });

    isPlaying
        ? await pausePlayback(widget.spotifyToken)
        : await resumePlayback(widget.spotifyToken);
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
        if (currentTrack != null)
          Image.network(
            currentTrack!.imageObjects[currentTrack!.imageObjects.length - 1]
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
                  currentTrack?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                      ),
                ),
                AutoSizeText(
                  currentTrack?.artists.join(', ') ?? "",
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
