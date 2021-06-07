import 'package:flutter/material.dart';

class DisplayNameInput extends StatelessWidget {
  final void Function(String) onSubmit;
  String name = "";

  DisplayNameInput({
    required this.onSubmit,
    this.name = "",
  });

  void _onPressed() {
    onSubmit(name);
  }

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(12.0),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter your name'),
            style: Theme.of(context).textTheme.bodyText1,
            onChanged: (text) {
              name = text;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: OutlinedButton(
              onPressed: _onPressed,
              child: Text('Continue'),
            ),
          ),
        ]);
  }
}
