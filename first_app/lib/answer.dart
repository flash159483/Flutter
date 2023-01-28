import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function press;
  final String answer;

  Answer(this.press, this.answer);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        child: Text(this.answer),
        onPressed: this.press,
      ),
    );
  }
}
