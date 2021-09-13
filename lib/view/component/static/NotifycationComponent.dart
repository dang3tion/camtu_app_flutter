import 'package:camtu_app/model/Notitfy.dart';
import 'package:camtu_app/view/services/NotifycationServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class NotifycationComponent extends StatefulWidget {
  final Notify noti;

  const NotifycationComponent({this.noti}) ;

  @override
  _NotifycationComponentState createState() => _NotifycationComponentState(this.noti);
}

class _NotifycationComponentState extends State<NotifycationComponent> {
  Notify noti;
  _NotifycationComponentState(this.noti);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // DateTime date=DateTime.now();
        // Notify not=Notify(phoneNo: AccountServices.id,date:date.toString(),type: 'yeasdfeu cau',content: ['asasdfdfa','2','3'],state: 'aaaa' );
        //
        // NotifycationServices().addNotifycation(not).listen((event) {
        //   print(event);
        // });

        // NotifycationServices().countUnred(AccountServices.id).listen((event) {
        //   print(event);
        //   NotifycationServices().getNotify(AccountServices.id).listen((event) {
        //     event.forEach((element) {
        //       print(element.date);
        //     });
        //   });
        // });

      },
      child: Container(
        child: Card(child: Container(
          height: 70,
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu,color: Colors.white,)),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.75,
              child:
              RichText(maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(fontSize: 17,color: Colors.grey[700],wordSpacing: 3.5),
                  children: [
                    TextSpan(text: 'Yêu cầu tham gia Room '),
                    TextSpan(text: 'Vatlj â â ',style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: 'Đã được chấp nhận')
                  ]
                ),

              )

              ,)
          ],),
        ),),
      ),
    );
  }
}
