import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:flutter/cupertino.dart';

class DetailWork{
  UserAccount user;
  String state;
  String score;
  List<Quote> quotes;
  DetailWork({@required this.user,@required this.state,@required this.score,@required this.quotes});
}