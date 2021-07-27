import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/view/component/static/InputAnswer.dart';
import 'package:camtu_app/view/component/static/InputCo.dart';
import 'package:camtu_app/view/component/static/InputQuestion.dart';
import 'package:flutter/material.dart';

class CreatingQuoteComponents extends StatefulWidget {
  final Quote quote;
  CreatingQuoteComponents(this.quote) ;
  _CreatingQuoteComponentsState state;

  @override
  _CreatingQuoteComponentsState createState() {
    state = _CreatingQuoteComponentsState(this.quote);
    return state;
  }


}

class _CreatingQuoteComponentsState extends State<CreatingQuoteComponents>
    with AutomaticKeepAliveClientMixin<CreatingQuoteComponents> {
  int answerNo = 2;
  int _indexAnswers = 1;
  Quote quote ;
  InputQuestion inputQuestion ;
  List<InputAnswer> listAnswer = [];

  _CreatingQuoteComponentsState(this.quote) {
   this._indexAnswers=this.quote.index;
    inputQuestion = new InputQuestion(this.quote.question.toString());
    inputQuestion.createState();
    answerNo=this.quote.answers.length;
      for(var i=0;i<this.quote.answers.length;i++){
        InputAnswer inp=new InputAnswer(i, this.quote.answers[i]);
        inp.createState();
        listAnswer.add(inp);
      }
  }

  Quote getQuote() {
    quote.question = inputQuestion.state.getText();
    List<String> list = [];
    for (var i = 0; i < listAnswer.length; i++) {
      if (i < 2) {
        list.add(listAnswer[i].state.getText());
      } else if (i > 1 && (listAnswer[i].state.getText().isNotEmpty)) {
        list.add(listAnswer[i].state.getText());
      }

    }
    quote.answers = list;
    quote.index = _indexAnswers;
    print(quote);
    return this.quote;
  }

  bool validate() {
    return inputQuestion.state.validate() &&
        listAnswer[0].state.validate() &&
        listAnswer[1].state.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: inputQuestion,
            ),
            Column(
              children: listAnswer.map((e) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(color: Colors.grey[700], offset: Offset(0, 0))
                      ]),
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _indexAnswers = e.index;
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            width: 40,
                            height: 40,
                            color: _indexAnswers == e.index
                                ? Color(0xffFF14F5AE)
                                : Color(0xffFFFFBC00),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + e.index),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: e),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.grey[600], offset: Offset(1, 1))
              ], color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
              width: MediaQuery.of(context).size.width * 0.9,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    answerNo++;
                    this.listAnswer.add(new InputAnswer(answerNo,''));
                  });
                },
                child: Text(
                  'Thêm câu trả lời',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
