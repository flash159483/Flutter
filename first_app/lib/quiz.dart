import 'package:flutter/material.dart';

import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int index;
  final Function press;

  Quiz({
    @required this.questions,
    @required this.index,
    @required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[index]['question']),
        ...(questions[index]['answer'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(() => press(answer['score']), answer['text']);
        }).toList()
      ],
    );
  }
}
