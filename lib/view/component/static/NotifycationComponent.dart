import 'package:camtu_app/model/Notitfy.dart';
import 'package:camtu_app/view/services/NotifycationServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifycationComponent extends StatefulWidget {
  final Notify noti;

  const NotifycationComponent(this.noti);

  @override
  _NotifycationComponentState createState() =>
      _NotifycationComponentState(this.noti);
}

class _NotifycationComponentState extends State<NotifycationComponent> {
  Notify noti;

  _NotifycationComponentState(this.noti);

  List<TextSpan> createText() {
    List<Widget> list = [];
    if (noti.type == 'deadline') {
      //   turple.id,
      // turple.name,
      // turple.deadLine,
      // room.nameRoom
      return [
        TextSpan(text: 'Bài tập ', style: TextStyle(fontSize: 19), children: [
          TextSpan(
              text: noti.content[1],
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.blueAccent)),
          TextSpan(text: ' thuộc Room '),
          TextSpan(
              text: noti.content[3],
              style: TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: ' đã kết thúc.')
        ]),
      ];
    } else if (noti.type == 'accept') {
      return [
        TextSpan(
            text: 'Yêu cầu tham gia Room ',
            style: TextStyle(fontSize: 19),
            children: [
              TextSpan(text: noti.content[0]),
              TextSpan(text: ' đã được chập nhận. '),
            ]),
      ];
    } else if (noti.type == 'request') {
      // content: [room.idRoom, room.nameRoom, e.length],
      return [
        TextSpan(text: 'Có  ', style: TextStyle(fontSize: 19), children: [
          TextSpan(text: noti.content[2].toString()),
          TextSpan(text: ' yêu cầu tham gia Room '),
          TextSpan(text: noti.content[1].toString()),
        ]),
      ];
    } else {
      // content: [
      //   roomId,
      //   turpleId.name,
      //   turpleId.id,
      //   turpleId.deadLine
      // ],
      return [
        TextSpan(text: 'Bài tập', style: TextStyle(fontSize: 19), children: [
          TextSpan(text: noti.content[1]),
          TextSpan(text: ' tại Room có mã '),
          TextSpan(text: noti.content[0]),
          TextSpan(text: ' ,hạn nộp bài vào lúc'),
          TextSpan(text: noti.content[3]),
        ]),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
        child: Card(
          child: Container(color:this.noti.state=='unread'? Colors.white:Color(0xff65E3E3E3),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // Button color
                      child: InkWell(
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              noti.type == 'deadline'
                                  ? Icons.domain_verification_outlined
                                  : noti.type == 'request'
                                      ? Icons.person_add_rounded
                                      : noti.type == 'give'
                                          ? Icons.library_books_outlined
                                          : Icons
                                              .supervised_user_circle_rounded,
                              color: Colors.white,size: 30,
                            )),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[700],
                                wordSpacing: 3.5),
                            children: createText()),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[700],
                                wordSpacing: 3.5),
                            children: [
                              TextSpan(
                                  text: noti.date,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                            ]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
