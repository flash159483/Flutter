import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

void main() => runApp(myApp());

class myApp extends StatefulWidget {
  const myApp({Key key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  var _index = 0;
  var _total_score = 0;

  void _press(int score) {
    _total_score += score;
    setState(() {
      _index += 1;
    });
  }

  void _reset() {
    setState(() {
      _index = 0;
      _total_score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _questions = const [
      {
        'question': "what's your favorite color?",
        'answer': [
          {'text': 'blue', 'score': 5},
          {'text': 'black', 'score': 10},
          {'text': 'green', 'score': 3},
          {'text': 'yellow', 'score': 2},
        ],
      },
      {
        'question': "what's your favorite animal?",
        'answer': [
          {'text': 'dog', 'score': 3},
          {'text': 'cat', 'score': 10},
          {'text': 'sheep', 'score': 6},
          {'text': 'cow', 'score': 7},
        ],
      },
      {
        'question': "what's your favorite language?",
        'answer': [
          {'text': 'English', 'score': 6},
          {'text': 'Korean', 'score': 2},
          {'text': 'Python', 'score': 1},
        ],
      }
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App"),
        ),
        body: _index < _questions.length
            ? Quiz(
                index: _index,
                press: _press,
                questions: _questions,
              )
            : Result(_total_score, _reset),
      ),
    );
  }
}
