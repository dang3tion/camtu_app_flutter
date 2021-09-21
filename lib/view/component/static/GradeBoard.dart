import 'dart:async';

import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/ScoreDetail.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/page/room/QuotePage.dart';
import 'package:camtu_app/services/QuoteServices.dart';
import 'package:camtu_app/services/RoomServices.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../static/PersonalDetail.dart';

class GradeBoard extends StatefulWidget {
  final Turple turple;

  const GradeBoard(this.turple);

  @override
  _GradeBoardState createState() => _GradeBoardState(this.turple);
}

class _GradeBoardState extends State<GradeBoard> {
  Turple turple;
  bool loading = false;

  _GradeBoardState(this.turple);


  Widget createUser(UserAccount user,ScoreDetail sc) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuotePage(this.turple,user,false)));
      },
      child: Container(height: 100,
        child: Card(
          child: Row(
            children: [Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.avatar??''),
              ),
            ),
              Expanded(
                child: Container(
                  child: ListTile(subtitle:  Text(sc.state!='complete'?'':'Nộp bài lúc: '+ parseDate(DateTime.parse(sc.upDate),),style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                    title: Container(
           margin: EdgeInsets.all(0),
                      padding: EdgeInsets.zero,
                      child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name ),

                          StreamBuilder<List<Quote>>(
                            stream: QuoteServices().getListQuote(this.turple.id),
                            builder: (ctx, snaps) {
                              if (snaps.hasError ||
                                  snaps.connectionState ==
                                      ConnectionState.waiting) {
                                return Container();
                              }
                              return StreamBuilder<List<Quote>>(
                                  stream: RoomServices().getQuoteUser(
                                      this.turple.roomId,
                                      this.turple.id,
                                      user.phoneNo),
                                  builder: (context, snap) {
                                    if (snap.hasError ||
                                        snap.connectionState ==
                                            ConnectionState.waiting) {
                                      return Container();
                                    }
                                    int count = 0;
                                    if (this.turple.isDeadLine()) {
                                      for (var i = 0; i < snaps.data.length; i++) {
                                        for (var j = 0; j < snap.data.length; j++) {
                                          if (snaps.data[i].id == snap.data[j].id &&
                                              snaps.data[i].index ==
                                                  snap.data[j].index) {
                                            count++;
                                            break;
                                          }
                                        }
                                      }
                                    } else {
                                      snap.data.forEach((element) {
                                        if (element.index != -1) {
                                          count++;
                                        }
                                      });
                                    }
                                    return Text(sc.state!='complete'?'Chưa hoàn thành':'${(count/this.turple.number).toStringAsFixed(2)} điểm - ${count}/${this.turple.number} câu'
                                      ,style: TextStyle(color: Color(0xffFFF8741E), fontSize: 16),
                                    );
                                  });
                            },
                          ),

                        ],
                      ),
                    ),
                    trailing: PopupMenuButton(
                        onSelected: (value){        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PersonalDetail(user)));

                        },
                        icon: Icon(Icons.more_vert_rounded),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 0,
                              child: GestureDetector(

                                  child: Text('Thông tin cá nhân'))),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    StreamController<int> stream;
      stream=StreamController.broadcast(onListen: (){
      int count=0;
      RoomServices().getListScore(this.turple.roomId,this.turple.id).listen((event) {
        if(event.length==0){
          stream.sink.add(count);
          return;
        }
        event.forEach((element) {
         element.listen((event) {
           if(event.state=='complete'){
             count++;
           }
           stream.sink.add(count);
         });
        });
      });

    });

    return loading
        ? LoadingWidget()
        : Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text('Bảng điểm'),
            centerTitle: true,
          ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              decoration:
              BoxDecoration(color: Colors.grey[100], boxShadow: [
                BoxShadow(color: Colors.grey[500], offset: Offset(0, 1))
              ]),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              margin: EdgeInsets.only(bottom: 1),
              child: Row(
                children: [
                  Icon(
                    Icons.quick_contacts_mail,
                    color: Colors.grey[600],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  StreamBuilder<int>(
                      stream: stream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          print(snapshot.error);
                          return LoadingWidget();
                        }
                        return Text('Số thành viên hoàn thành bài tập: ${snapshot.data}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ));
                      }
                  )
                ],
              ),
            ),
            Container(
              child: StreamBuilder<List<Stream<ScoreDetail>>>(
                  stream:
                  RoomServices().getListScore(this.turple.roomId,this.turple.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError ||
                        snapshot.connectionState ==
                            ConnectionState.waiting) {
                      return LoadingWidget();
                    }
                         List<StreamController> streamUser=[];
                    snapshot.data.forEach((element) {
                      StreamController<ScoreDetail> st;
                      st=new StreamController<ScoreDetail>.broadcast(onListen: (){
                        element.listen((event) {
                          if(event!=null){
                            st.sink.add(event);
                          }
                        });
                      });
                      streamUser.add(st);
                    });


                    return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: SingleChildScrollView(
                        child: Column(
                            children: streamUser.map((e) {
                              return StreamBuilder<ScoreDetail>(
                                  stream: e.stream,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.hasError ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Container();
                                    }
                                    return StreamBuilder<UserAccount>(

                                      stream: AccountServices().getUser(snapshot.data.userId),

                                      builder: (ctx,snap){
                                        if (snap.hasError ||
                                            snap.connectionState ==
                                                ConnectionState.waiting) {
                                          return Container();
                                        }
                                        return createUser(snap.data,snapshot.data);
                                      },
                                    );
                                  });
                            }).toList()),
                      ),
                    );
                  }),
            )
          ]),
        ),
      ),
    );
  }
  String parseDate(DateTime date){
    return '${date.hour}:${date.minute}   ${date.day}-${date.month}-${date.year}';
  }
}
