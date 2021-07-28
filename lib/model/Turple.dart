import 'package:camtu_app/model/DetailWork.dart';
import 'package:camtu_app/model/Quote.dart';
import 'package:flutter/cupertino.dart';

class Turple {
  String id;
  String name;
  String userId;
  String roomId;
  int number;
  String deadLine;
  String bornLine;
  String state;
  List<Quote> quotes=[];
  List<DetailWork> deatailWorks=[];
  Turple(
      { this.id, this.name,
       this.roomId,
      this.number,
       this.deadLine,
      this.userId,
      this.bornLine,
      this.state,
       this.quotes,this.deatailWorks});

  DateTime getUpDate() {
    return DateTime.parse(this.bornLine);
  }
  DateTime getDeadDate() {
    return DateTime.parse(this.deadLine);
  }

  isDeadLine() {
    DateTime now = DateTime.now();
    return getDeadDate().isBefore(now);
  }
}
