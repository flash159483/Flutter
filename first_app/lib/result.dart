import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int score;
  final Function reset;

  String get result {
    String result_text = 'You did it!';
    if (this.score <= 10) {
      result_text = 'You are awesome!';
    } else if (this.score <= 18) {
      result_text = 'You are awful!';
    } else if (this.score <= 25) {
      result_text = 'You are bad!';
    } else {
      result_text = 'Try Again';
    }

    return result_text;
  }

  Result(this.score, this.reset);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Center(
            child: Text(
              this.result,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          OutlinedButton(
              onPressed: this.reset,
              child: Text("Do the test again"),
              style: OutlinedButton.styleFrom(
                  primary: Colors.orange,
                  side: BorderSide(color: Colors.black)))
        ],
      ),
    );
  }
}
