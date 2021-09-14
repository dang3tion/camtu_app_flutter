import 'package:camtu_app/model/Notitfy.dart';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/room/ComponentRoom.dart';
import 'package:camtu_app/view/component/static/Dialog.dart';
import 'package:camtu_app/view/component/static/InputCo.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/component/static/NotifycationComponent.dart';
import 'package:camtu_app/view/services/NotifycationServices.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/material.dart';

class NotifycationPage extends StatefulWidget {
  @override
  _NotifycationPageState createState() => _NotifycationPageState();
}

class _NotifycationPageState extends State<NotifycationPage> {
  InputText inputText;
  var loadingCreate = false;



  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Thông báo')
          ),
        ),
      body:  StreamBuilder<List<Stream<Notify>>>(
            stream: NotifycationServices().getNotify(AccountServices.id),
            builder: (context, snapshot) {
              if(snapshot.data==null || snapshot.connectionState==ConnectionState.waiting|| snapshot.hasError){
                return LoadingWidget();
              }
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  height: MediaQuery.of(context).size.height*0.8,
                  child: SingleChildScrollView(
                  child:Column(
                children: snapshot.data.map((e) => StreamBuilder<Notify>(
                  stream: e,
                  builder: (context, snap) {
                    if(snap.data==null || snap.connectionState==ConnectionState.waiting|| snap.hasError){
                      return LoadingWidget();
                    }
                    return new NotifycationComponent(snap.data);
                  }
                )).toList(),
              )

          ),
        ); }
      )
    );
  }

  showToast(message, context) {
    ShowDialog().showToast(message, context);
  }
}
