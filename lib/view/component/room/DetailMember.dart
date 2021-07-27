import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/material.dart';

import '../static/PersonalDetail.dart';

class UserMember extends StatefulWidget {
  final String roomId;

  const UserMember(this.roomId);

  @override
  _UserMemberState createState() => _UserMemberState(this.roomId);
}

class _UserMemberState extends State<UserMember> {
  String roomId;
  bool loading = false;

  _UserMemberState(this.roomId);

  void showConfirm(UserAccount user) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Xóa ${user.name}'),
              content: Container(
                child: Text('Bạn muốn xóa người này ra khỏi nhóm?'),
              ),
              actions: [
                Divider(
                  height: 2,
                  color: Colors.grey[500],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      color: Colors.blueAccent,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await RoomServices()
                            .deleteMember(user.phoneNo, this.roomId)
                            .then((value) {
                          setState(() {
                            loading = false;
                          });
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Xác nhận',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                      color: Colors.grey[300],
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Hủy'),
                    )
                  ],
                ),
              ],
            ));
  }

  Widget createUser(UserAccount user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PersonalDetail(user)));
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
          ),
          title: Text(user.name),
          trailing:!user.typeUser
              ? Text(
                  'Admin',
                  style: TextStyle(color: Colors.lightBlue),
                )
              :(!AccountServices.useracount.typeUser)? PopupMenuButton(
            onSelected: (value){
                showConfirm(user);
            },
                  icon: Icon(Icons.more_vert_rounded),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                            child: GestureDetector(

                                child: Text('Xóa khỏi nhóm'))),
                      ]):Text(
            '',
            style: TextStyle(color: Colors.lightBlue),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget()
        : Scaffold(
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
                        StreamBuilder<List<Stream>>(
                          stream: RoomServices().getRequestUser(this.roomId, true),
                          builder: (context, snapshot) {
                            if (snapshot.hasError ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return LoadingWidget();
                            }
                            return Text('Tổng số thành viên: ${snapshot.data.length}',
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
                    child: StreamBuilder<List<Stream<UserAccount>>>(
                        stream:
                            RoomServices().getRequestUser(this.roomId, true),
                        builder: (context, snapshot) {
                          if (snapshot.hasError ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return LoadingWidget();
                          }

                          return Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: SingleChildScrollView(
                              child: Column(
                                  children: snapshot.data.map((e) {
                                return StreamBuilder<UserAccount>(
                                    stream: e,
                                    builder: (ctx, snapshot) {
                                      if (snapshot.hasError ||
                                          snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return Container();
                                      }
                                      return createUser(snapshot.data);
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
}
