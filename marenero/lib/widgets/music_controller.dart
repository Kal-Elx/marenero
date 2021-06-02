import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MusicController extends StatefulWidget {
  final bool forHost;

  MusicController({required this.forHost});

  @override
  _MusicControllerState createState() => _MusicControllerState();
}

class _MusicControllerState extends State<MusicController>
    with TickerProviderStateMixin {
  bool playing = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  void _togglePlaying() {
    setState(() {
      playing = !playing;
      playing ? _animationController.reverse() : _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'title',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                      ),
                ),
                AutoSizeText(
                  ['artists'].join(', '),
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
            onPressed: () {},
            icon: Icon(Icons.skip_next_outlined),
          ),
        SizedBox(width: 30),
      ],
    );
  }
}
