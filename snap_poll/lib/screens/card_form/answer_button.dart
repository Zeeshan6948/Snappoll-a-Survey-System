import 'package:flutter/material.dart';

///[AnswerButton] class takes a  String ([answerText]) and
/// takes a function [onPressed]
/// as an argument
class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onPressed,
  });

  /// [answerText] get as an Arguments then use it in the [Text] field
  final String answerText;

  /// to get the function [onPressed] that will pass from another class
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      child: Text(answerText),
    );
  }
}
