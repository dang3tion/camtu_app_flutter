import 'dart:ui';
import 'package:camtu_app/model/Input.dart';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/DatePicker.dart';
import 'package:camtu_app/view/component/turple/ImplementQuoteComponent.dart';
import 'package:camtu_app/view/component/static/Dialog.dart';
import 'package:camtu_app/view/component/static/InputNumberCount.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/component/turple/ComponentTurple.dart';
import 'package:camtu_app/view/component/turple/QuotePage.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:camtu_app/view/services/TurpleServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../static/InputCo.dart';

class TupleQuote extends StatefulWidget {
  final Room room;
  final UserAccount user;

  TupleQuote(this.room, this.user);

  @override
  _TupleQuoteState createState() => _TupleQuoteState(this.room, this.user);
}

// ListTile(
// title: Text('1111'),
// leading: CircleAvatar(
// backgroundImage: NetworkImage('https://png.pngtree.com/element_our/png_detail/20181206/avatar-vector-icon-png_262117.jpg'),
// ),
// )

class _TupleQuoteState extends State<TupleQuote> {
  Room room;
  UserAccount user;
  bool loading = false;

  _TupleQuoteState(this.room, this.user);

  InputText inputName = InputText('Tên bộ câu hỏi', "Nhập tên", true);
  DatePickerButton datePicker = DatePickerButton('Ngày hết hạn', DateTime.now(),
      DateTime(DateTime.now().year + 2, 1, 1), DateTime.now(), true);
  InputNumberCount numberQuore = InputNumberCount();

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SingleChildScrollView(
                child: StreamBuilder<List<Stream<Turple>>>(
                    stream: RoomServices().getListTurple(this.room.idRoom),
                    builder: (context, snapshot) {
                      if (snapshot.hasError ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget();
                      }
                      return Column(
                          children: snapshot.data.map((e) {
                        return StreamBuilder<Turple>(
                            stream: e,
                            builder: (ctx, snapshot) {
                              if (snapshot.hasError ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return Container();
                              }
                              if(snapshot.data.state=='create'&&AccountServices.useracount.typeUser==true){
                                return Container();
                              }
                              return ComponentTurple(snapshot.data);
                            });
                      }).toList());
                    }),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndDocked,
            floatingActionButton:this.user.typeUser?Container(): FloatingActionButton.extended(
              heroTag: 'AddTurple',
              onPressed: () {
                {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 20),
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Tạo bộ câu hỏi mới',
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                  inputName,
                                  SizedBox(
                                    height: 20,
                                  ),
                                  datePicker,
                                  numberQuore,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RaisedButton(
                                        onPressed: () {
                                          ShowDialog().showDialogWidget(
                                              context,
                                              'Xác nhận tạo bộ câu hỏi',
                                              'Bạn có muốn tạo bộ câu hỏi mới?',
                                              () {
                                            if (inputName.validate()) {
                                              Navigator.of(ctx).pop();
                                              setState(() {
                                                this.loading = true;
                                              });
                                              Turple tup = new Turple(
                                                  name: inputName.getText(),
                                                  roomId: this.room.idRoom,
                                                  number: int.parse(
                                                      numberQuore.getNumber()),
                                                  deadLine:
                                                      datePicker.getDateTime(),
                                                  userId: this.user.phoneNo,
                                                  bornLine:
                                                      DateTime.now().toString(),
                                                  state: 'create');
                                              TurpleServices()
                                                  .createTurple(
                                                      tup)
                                                  .then((value) {
                                                if (value) {
                                                  ShowDialog().showToast(
                                                      "Tạo bộ câu hỏi thành công",
                                                      this.context);
                                                } else {
                                                  ShowDialog().showToast(
                                                      "Có lỗi xảy ra vui lòng thử lại",
                                                      this.context);
                                                }
                                                setState(() {
                                                  this.loading = false;
                                                });
                                              });
                                            }
                                          });
                                        },
                                        child: Text(
                                          'Xác nhận',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.blueAccent,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                }
                ;
              },
              icon: Icon(Icons.add),
              label: Text('Thêm bộ câu hỏi mới'),
            ),
          );
  }
}
