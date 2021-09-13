import 'package:camtu_app/model/Input.dart';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/room/ComponentRoom.dart';
import 'package:camtu_app/view/component/static/Dialog.dart';
import 'package:camtu_app/view/component/static/InputCo.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/component/room/SystemRoomPage.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/material.dart';

class ListRoomPage extends StatefulWidget {
  @override
  _ListRoomPageState createState() => _ListRoomPageState();
}

class _ListRoomPageState extends State<ListRoomPage> {
  InputText inputText;
  var loadingCreate = false;

  Stream<List<Room>> rooms;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return loadingCreate
        ? LoadingWidget()
        : Scaffold(
      resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('Danh sách các Room'),
              centerTitle: true,
            ),
            body: Container(
                decoration: BoxDecoration(color: Colors.grey[000]),
                padding: EdgeInsets.fromLTRB(0, 20, 0, 70),
                child: StreamBuilder<List<Stream<Room>>>(
                    stream: AccountServices().getListRoom(AccountServices.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Stream<Room>>> snapshot) {
                      if (snapshot.hasError ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget();
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                              children: snapshot.data
                              .map((e) => StreamBuilder<Room>(
                            stream: e,
                            builder: (context, snapshot) {
                              if (snapshot.data==null||snapshot.hasError ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return Container();
                              }


                              return ComponentRoom(snapshot.data);}
                        ))
                          .toList(),

                          ),
                        );
                      }
                    })),
            floatingActionButton: StreamBuilder<UserAccount>(
                stream: AccountServices().user,
                builder: (ctx, AsyncSnapshot<UserAccount> snapshot) {
                  if (snapshot.hasError ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget();
                  }
                  if (!snapshot.data.typeUser) {
                    inputText = InputText('Tên Room', "Nhập tên Room", true);
                    return FloatingActionButton.extended(
                      heroTag: null,
                      icon: Icon(Icons.add),
                      label: Text('Thêm'),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.60,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 20),
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 250),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Tạo Room mới',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          inputText,
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                onPressed: () {
                                                  ShowDialog().showDialogWidget(
                                                      context,
                                                      'Xác nhận tạo Room',
                                                      'Bạn có muốn tạo Room mới?',
                                                      () {
                                                    if (inputText.validate()) {
                                                      AccountServices()
                                                          .user
                                                          .listen(
                                                              (event) async {
                                                        Navigator.of(
                                                                this.context)
                                                            .pop();
                                                        setState(() {
                                                          loadingCreate = true;
                                                        });
                                                        await RoomServices()
                                                            .createRoom(
                                                                event.userId,
                                                                event.name,
                                                                inputText
                                                                    .getText(),
                                                                event.phoneNo)
                                                            .then((value) {
                                                          setState(() {
                                                            loadingCreate =
                                                                false;
                                                          });
                                                          if (value) {
                                                            showToast(
                                                                'Tạo Room mới thành công',
                                                                this.context);
                                                          } else {
                                                            showToast(
                                                                'Có lỗi xảy ra, vui lòng thử lại.',
                                                                this.context);
                                                          }
                                                        });
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  'Xác nhận',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.blueAccent,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 25),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      },
                    );
                  } else {
                    inputText = InputText('ID Room', "Nhập ID Room", true);
                    return FloatingActionButton.extended(
                      heroTag: null,
                      icon: Icon(Icons.add),
                      label: Text('Tham gia'),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.60,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 20),
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 250),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Gửi yêu cầu tham gia Room',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          inputText,
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                onPressed: () async {
                                                  if (inputText.validate()) {
                                                    setState(() {
                                                      loadingCreate = true;
                                                    });
                                                    Navigator.of(context).pop();
                                                    await RoomServices()
                                                        .joinRoom(
                                                            AccountServices.id,
                                                            inputText.getText())
                                                        .then((value) {
                                                      showToast(
                                                          value, this.context);
                                                      setState(() {
                                                        loadingCreate = false;
                                                      });
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'Xác nhận',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.blueAccent,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 25),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      },
                    );
                  }
                }));
  }

  showToast(message, context) {
    ShowDialog().showToast(message, context);
  }
}
