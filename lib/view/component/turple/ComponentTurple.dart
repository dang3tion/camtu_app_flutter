import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/GradeBoard.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/page/room/QuotePage.dart';
import 'package:camtu_app/services/QuoteServices.dart';
import 'package:camtu_app/services/RoomServices.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ComponentTurple extends StatefulWidget {
  final Turple turple;

  const ComponentTurple(this.turple);

  @override
  _ComponentTurpleState createState() => _ComponentTurpleState(this.turple);
}

class _ComponentTurpleState extends State<ComponentTurple> {
  Turple turple;
  DateTime deadLine;
  DateTime update;

  _ComponentTurpleState(this.turple) {
    this.deadLine = this.turple.getDeadDate();
    this.update = this.turple.getUpDate();
  }

  @override
  Widget build(BuildContext context) {
    bool user = AccountServices.useracount.typeUser;

    // student
    if (user) {
      return StreamBuilder<Turple>(
          stream: RoomServices().getState(this.turple.roomId,
              AccountServices.useracount.phoneNo, this.turple.id),
          builder: (context, snapshot) {
            if (snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {


                  if(snapshot.data.state=='complete'){
                    return QuotePage(
                        this.turple, AccountServices.useracount, false);
                  }
                  return QuotePage(
                      this.turple, AccountServices.useracount, true);
                }));
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                  AccountServices.useracount.phoneNo),
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
                                return CircularPercentIndicator(
                                  radius: 80,
                                  lineWidth: 4,
                                  percent:  count / this.turple.number,
                                  progressColor: Color(
                                      this.turple.isDeadLine() ||
                                              snapshot.data.state == 'complete'
                                          ? 0xffFF0076FF
                                          : 0xffFF00FF7B),
                                  circularStrokeCap: CircularStrokeCap.square,
                                  animation: true,
                                  center: Center(
                                    child: RichText(textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500),
                                          text:

                                          '${count}/${this.turple.number}',
                                          children: [
                                          TextSpan(
                                                text:
                                                this.turple.isDeadLine()?'\n${((count / this.turple.number) * 10).toStringAsFixed(2)}':'',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xffFFEE3F3F),
                                                    fontWeight: FontWeight.w500))
                                          ]),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        this.turple.isDeadLine()
                                            ? 'Bài tập đã kết thúc'
                                            : 'Hạn nộp bài: ${this.deadLine.hour}:${this.deadLine.minute == 0 ? '00' : this.deadLine.minute} / ${this.deadLine.day}-${this.deadLine.month}-${this.deadLine.year}',
                                        style: TextStyle(color: Colors.white,fontSize: 15),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xffFF338DDB))
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: ListTile(
                                      title: Text(
                                        this.turple.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(this.turple.isDeadLine()
                                          ? ''
                                          : snapshot.data.state == 'complete'
                                              ? 'Đã nộp bài tập'
                                              : 'Bài tập chưa được nộp'),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          showModalBottom();
                                        },
                                        icon: Icon(
                                          Icons.more_vert_rounded,
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                              value: 0,
                                              child: Text(
                                                'Chi tiết',
                                                style: TextStyle(fontSize: 15),
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuotePage(
                      this.turple, AccountServices.useracount, true)));
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 80,
                  lineWidth: 4,
                  percent: this.turple.state == 'create' ? 0 : 1,
                  progressColor: Color(0xffFF0076FF),
                  circularStrokeCap: CircularStrokeCap.square,
                  animation: true,
                  center: Text(
                    '${this.turple.number}/${this.turple.number}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  this.turple.isDeadLine()
                                      ? 'Bài tập đã kết thúc'
                                      : 'Hạn nộp bài: ${this.deadLine.hour}:${this.deadLine.minute == 0 ? '00' : this.deadLine.minute} / ${this.deadLine.day}-${this.deadLine.month}-${this.deadLine.year}',
                                  style: TextStyle(color: Colors.white,fontSize: 15),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(this.turple.isDeadLine()
                                              ? 0xffFFB19F00
                                              : 0xffFF64B100))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ListTile(
                                title: Text(
                                  this.turple.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                    this.turple.state.toString() == 'create'
                                        ? '(Chưa thiết lập câu hỏi)'
                                        : '(Bài tập đã được giao)'),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 0),
                                child: PopupMenuButton(
                                  onSelected: (value) {
                                    if(value==0){
                                      showModalBottom();
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return GradeBoard(this.turple);
                                      }));
                                    }

                                  },
                                  icon: Icon(
                                    Icons.more_vert_rounded,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 0,
                                        child: Text(
                                          'Chi tiết',
                                          style: TextStyle(fontSize: 15),
                                        )),
                                    this.turple.state == 'complete'
                                        ? PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                              'Bảng điểm',
                                              style: TextStyle(fontSize: 15),
                                            ))
                                        : null
                                  ],
                                ))
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void showModalBottom() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Thông tin bài tập',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    ListTile(
                      title: Text('Tên'),
                      subtitle: Text(this.turple.name),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('Người tạo'),
                      subtitle: StreamBuilder<UserAccount>(
                          stream: AccountServices().getUser(this.turple.userId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return Text('Chưa cập nhật');
                            }
                            return Text(snapshot.data.name);
                          }),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('Ngày tạo'),
                      subtitle: Text(
                          '${this.update.day}-${this.update.month}-${this.update.year}'),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('Số lượng câu hỏi'),
                      subtitle: Text(this.turple.number.toString()),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('Hạn nộp bài'),
                      subtitle: Text(
                          '${this.deadLine.hour}:${this.deadLine.minute} / ${this.deadLine.day}-${this.deadLine.month}-${this.deadLine.year}'),
                    ),
                    Divider(
                      height: 2,
                    )
                  ],
                ),
              ),
            ));
  }
}
