import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PartySettings extends StatefulWidget {
  final int selected;
  final void Function(int selected) onSelect;

  PartySettings({
    required this.selected,
    required this.onSelect,
  });

  @override
  State<PartySettings> createState() => _PartySettingsState(selected);
}

class _PartySettingsState extends State<PartySettings> {
  int selected;

  _PartySettingsState(this.selected);

  void onPressed(int number) {
    setState(() {
      selected = number;
    });
    widget.onSelect(number);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          'How many songs can you queue?',
          maxLines: 1,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NumberButton(
              active: 1 == selected,
              number: 1,
              onTap: () => onPressed(1),
            ),
            _NumberButton(
              active: 2 == selected,
              number: 2,
              onTap: () => onPressed(2),
            ),
            _NumberButton(
              active: 3 == selected,
              number: 3,
              onTap: () => onPressed(3),
            ),
          ],
        )
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  final bool active;
  final int number;
  final VoidCallback? onTap;

  const _NumberButton({
    required this.active,
    required this.number,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(18.0),
        shape: CircleBorder(
          side: BorderSide(color: active ? Colors.white : Colors.transparent),
        ),
      ),
      child: Text(
        '$number',
        style: Theme.of(context).textTheme.headline3,
      ),
      onPressed: onTap,
    );
  }
}
