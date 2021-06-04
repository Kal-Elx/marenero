import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TrackListTile extends StatelessWidget {
  final String title;
  final List<String> artists;
  final Widget? cover;
  final Widget? trailing;
  final bool placeholder;

  const TrackListTile({
    required this.title,
    required this.artists,
    this.cover,
    this.trailing,
    this.placeholder = false,
  });

  factory TrackListTile.placeholder(int position) {
    switch (position) {
      case 0:
        return TrackListTile(
          title: 'Your favorite song',
          artists: ['Your favorite band'],
          placeholder: true,
        );
      case 1:
        return TrackListTile(
          title: 'The song that has been stuck in your head all week',
          artists: ['By that guy whos name you always forget'],
          placeholder: true,
        );
      default:
        return TrackListTile(
          title: "That song you're embaresed that you like",
          artists: ['Generic teen pop star'],
          placeholder: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: cover ?? null,
      title: AutoSizeText(
        title,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: placeholder ? Colors.white54 : Colors.white,
            ),
      ),
      subtitle: AutoSizeText(
        artists.join(', '),
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: placeholder ? Colors.white30 : Colors.white70),
      ),
      trailing: trailing ?? Icon(null),
    );
  }
}
