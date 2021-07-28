import 'package:camtu_app/model/Quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImplementQuote extends StatefulWidget {
  final Quote quote;
  final bool type;
   ImplementQuote(this.quote,this.type);
   _ImplementQuoteState state;
  @override
  _ImplementQuoteState createState() {
    state=_ImplementQuoteState(this.quote,this.type);
    return state;
  }
}


class _ImplementQuoteState extends State<ImplementQuote>   with AutomaticKeepAliveClientMixin<ImplementQuote>{
  var index = -1;
  Quote quote;
  bool type;
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  _ImplementQuoteState(this.quote,this.type){
    this.index=this.quote.index;

  }
  Quote getQuote(){
      quote.index=index;
      return quote;
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> createAnwser() {
      List<Widget> list = new List<Widget>();
      for (int i = 0; i <quote.answers.length; i++) {
        list.add(GestureDetector(
          onTap: () {
            if(this.type){
              setState(() {
                index = i;
              });
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: i == index ? Color(0xffFF25ABFF) : Colors.white,
                borderRadius: BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color:
                        i == index ? Color(0xffFFFFE62E) : Color(0xffFFFFBC00),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + i),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    quote.answers[i]
                    ,
                    style: TextStyle(
                        fontSize: 16,
                        color: i == index ? Colors.white : Colors.black),
                  ),
                )
              ],
            ),
          ),
        ));
      }
      return list;
    }

    return Container(
      child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[600],
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              spreadRadius: 0)
                        ]),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      quote.question,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: createAnwser(),
                ),
              )
            ],
          ),
        ),
    );
  }
}
