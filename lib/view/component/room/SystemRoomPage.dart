import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/view/component/room/DetailMember.dart';
import 'package:camtu_app/view/component/home/MenuBottom.dart';
import 'package:camtu_app/view/component/room/RequestRoom.dart';
import 'package:camtu_app/view/component/turple/TupleQuotes.dart';
import 'package:camtu_app/view/component/turple/QuotePage.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/material.dart';


class SystemRoomPage extends StatefulWidget {
  final Room room;
  const SystemRoomPage(this.room) ;

  @override
  _SystemRoomPageState createState() => _SystemRoomPageState(this.room);
}

class _SystemRoomPageState extends State<SystemRoomPage> {
  Room room ;
  _SystemRoomPageState(this.room);
  Widget roomSystem(){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(

          actions: [ Container(
              child: IconButton(
                  onPressed: (){}
                  ,
                  icon: Icon(Icons.settings_rounded,size: 26,)))],
          title: Text('${room.nameRoom}',style: TextStyle(fontSize: 18),),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.view_list),
                text: 'Hệ thống bài tập',
              ),
              Tab(
                icon: Icon(Icons.person_add),
                text: 'Yêu cầu',
              ),
              Tab(
                icon: Icon(Icons.group),
                text: 'Thành viên',
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              Container(child: TupleQuote(this.room,AccountServices.useracount),
              ),
              Container(
                child: RequestRoomComponent(this.room.idRoom),
              ),
              Container(
                child: UserMember(this.room.idRoom),
              )
            ],
          ),
        ),
    ),

    );
  }

  @override
  Widget build(BuildContext context) {


    return roomSystem();
  }
}
