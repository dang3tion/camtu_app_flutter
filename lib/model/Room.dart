import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:flutter/cupertino.dart';

class Room{
  String userId;
  String userName;
  String time;
  String idRoom;
  String nameRoom;
List<Turple> tuples;

  Room({@required this.userId,@required this.userName,@required this.time,@required this.idRoom,@required this.nameRoom, this.tuples});
}