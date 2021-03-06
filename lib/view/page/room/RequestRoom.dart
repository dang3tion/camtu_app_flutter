import 'package:camtu_app/model/Notitfy.dart';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/Dialog.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/component/static/PersonalDetail.dart';
import 'package:camtu_app/services/NotifycationServices.dart';
import 'package:camtu_app/services/RoomServices.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:flutter/material.dart';

class RequestRoomComponent extends StatefulWidget {
  final Room idRoom;

  RequestRoomComponent(this.idRoom);

  @override
  _RequestRoomComponentState createState() =>
      _RequestRoomComponentState(this.idRoom);
}

class _RequestRoomComponentState extends State<RequestRoomComponent> {
  Room idRoom;
  bool loading = false;

  _RequestRoomComponentState(this.idRoom);

  Widget createUser(UserAccount user) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PersonalDetail(user)));
        },
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      this.loading = true;
                    });
                    await RoomServices()
                        .acceptUser(user.phoneNo, idRoom.idRoom, true, 'member')
                        .then((value)async {
                       await   RoomServices().saveQuoteUser(this.idRoom.idRoom, user.phoneNo);
                      setState(() {
                        this.loading = false;
                      });
                    });
                    DateTime date=DateTime.now();
                    Notify not=Notify(phoneNo:user.phoneNo,date:date.toString(),type: 'accept',content: [this.idRoom.nameRoom,this.idRoom.idRoom],state: 'unread' );
                    NotifycationServices().addNotifycation(not);
                  },
                  color: Color(0xffFFEBFFFA),
                  child: Text(
                    'Ch???p nh???n',
                    style: TextStyle(color: Color(0xffFF00A4DB)),
                  ),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  onPressed: () async {

                    ShowDialog().showDialogWidget(context, 'X??c nh???n t??? ch???i',
                        'T??? ch???i ng?????i d??ng tham gia', () async {



                      await RoomServices()
                          .acceptUser(user.phoneNo, idRoom.idRoom, false, 'member')
                          .then((value) {


                      });
                    });
                  },
                  color: Colors.grey[100],
                  child: Text(
                    'T??? ch???i',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 1,
                  offset: Offset(0, 2),
                )
              ]),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.settings_rounded),
                      label: Text('Thi???t l???p'),
                    )
                  ],
                ),
              ),
            ),
            loading
                ? LoadingWidget()
                : StreamBuilder<List<Stream<UserAccount>>>(
                    stream: RoomServices().getRequestUser(this.idRoom.idRoom, false),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget();
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: snapshot.data
                              .map((e) => StreamBuilder<UserAccount>(
                                  stream: e,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.hasError ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return LoadingWidget();
                                    }
                                    return createUser(snapshot.data);
                                  }))
                              .toList(),
                        ),
                      );
                    })
          ])),
    );
  }
}
