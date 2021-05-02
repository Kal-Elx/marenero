import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class CodeInput extends StatelessWidget {
  final void Function(String) onComplete;

  CodeInput({
    required this.onComplete,
  });

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(12.0),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: PinPut(
        fieldsCount: 5,
        fieldsAlignment: MainAxisAlignment.spaceBetween,
        textStyle: const TextStyle(fontSize: 24.0),
        eachFieldHeight: 56.0,
        eachFieldWidth: 48.0,
        submittedFieldDecoration: pinPutDecoration,
        followingFieldDecoration: pinPutDecoration,
        selectedFieldDecoration:
            pinPutDecoration.copyWith(border: Border.all()),
        pinAnimationType: PinAnimationType.fade,
        onSubmit: onComplete,
      ),
    );
  }
}
