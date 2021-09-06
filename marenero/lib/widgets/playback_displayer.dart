import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marenero/models/currently_playing.dart';
import 'dart:async';

class PlaybackDisplayer extends StatefulWidget {
  final CurrentlyPlaying current;
  PlaybackDisplayer({required this.current});

  @override
  _PlaybackDisplayerState createState() => _PlaybackDisplayerState();
}

class _PlaybackDisplayerState extends State<PlaybackDisplayer>
    with TickerProviderStateMixin {
  bool waiting = false;
  bool isPlaying = false;

  late AnimationController _animationController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        value: widget.current.isPlaying ? 1 : 0,
        vsync: this,
        duration: Duration(milliseconds: 250));

    // Update player state once immediatley.
    _updatePlayerState();

    // Update player state periodicly.
    _timer = new Timer.periodic(Duration(milliseconds: 1000),
        (Timer t) async => {_updatePlayerState()});
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _updatePlayerState() async {
    setState(() {
      if (!waiting) {
        isPlaying = widget.current.isPlaying;
        widget.current.isPlaying
            ? _animationController.forward()
            : _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.current.track != null)
          Image.network(
            widget.current.track!
                    .imageObjects[widget.current.track!.imageObjects.length - 1]
                ['url'],
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  widget.current.track?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                AutoSizeText(
                  widget.current.track?.artists.join(', ') ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        Padding(
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            color: Colors.grey,
            progress: _animationController,
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Padding(
          child: Icon(
            Icons.skip_next_outlined,
            color: Colors.grey,
          ),
          padding: const EdgeInsets.all(8.0),
        ),
      ],
    );
  }
}
