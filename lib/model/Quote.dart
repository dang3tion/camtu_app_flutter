import 'package:flutter/cupertino.dart';

class Quote {
  String id;
  String question;
  List<String> answers = [];
  int index;
  Quote(
      {@required this.id,
      @required this.question,
      @required this.answers,
      @required this.index});

  addAnswer(String answer) {
    this.answers.add(answer);
  }

  @override
  String toString() {
    return 'Quote{id: $id, question: $question, answers: $answers, index: $index}';
  }
}
