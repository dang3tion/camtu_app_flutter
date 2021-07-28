import 'package:camtu_app/model/Quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompareQuoteComponent extends StatefulWidget {
  final Quote quote;
  final Quote mainQuote;

  CompareQuoteComponent(this.quote,this.mainQuote);

  _CompareQuoteComponent state;

  @override
  _CompareQuoteComponent createState() {
    state = _CompareQuoteComponent(this.quote,this.mainQuote);
    return state;
  }
}

class _CompareQuoteComponent extends State<CompareQuoteComponent>
    with AutomaticKeepAliveClientMixin<CompareQuoteComponent> {
  var index = -1;

  Quote quote;
  Quote mainQuote;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _CompareQuoteComponent(this.quote, this.mainQuote) {
    this.index = this.quote.index;

  }

  getQuote() {
    quote.index = index;
    return quote;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> createAnwser() {
      List<Widget> list = new List<Widget>();
      for (int i = 0; i < mainQuote.answers.length; i++) {
        list.add(Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:mainQuote.index==i&& mainQuote.index==quote.index ? Color(0xffFF25ABFF):mainQuote.index==i&& mainQuote.index!=quote.index ?Color(0xffFF00C9EE) :mainQuote.index!=i&& i==quote.index ?Color(
                  0xffFFB7B8B7): Colors.white,
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
                      i == mainQuote.index ? Color(0xffFFFFE62E) :mainQuote.index!=i&& i==quote.index? Color(0xffFFCDCDCD):Color(0xffFFFFBC00),
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
                  mainQuote.answers[i],
                  style: TextStyle(
                      fontSize: 16,
                      color: i == index ? Colors.white : Colors.black),
                ),
              )
            ],
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
                    mainQuote.question,
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
