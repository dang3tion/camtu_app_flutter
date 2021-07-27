import 'package:camtu_app/model/UserAccount.dart';
import 'package:flutter/material.dart';

class PersonalDetail extends StatelessWidget {
  final UserAccount user;

  const PersonalDetail(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Thông tin cá nhân'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                    radius: 80,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        leading: Icon(Icons.cake_outlined, size: 30),
                        title: Text('Ngày sinh: ' + user.birthday,
                            style: TextStyle(fontSize: 18))),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.school_outlined,
                        size: 30,
                      ),
                      title: user.typeUser
                          ? Text('Học tại ' + user.nameSchool,
                              style: TextStyle(fontSize: 18))
                          : Text('Giảng dạy tại ' + user.nameSchool,
                              style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(Icons.house_outlined, size: 30),
                      title: Text('Địa chỉ ' + user.address,
                          style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                        leading: Icon(Icons.email, size: 30),
                        title: Text('Email: ' + user.email,
                            style: TextStyle(fontSize: 18))),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                        leading: Icon(Icons.phone, size: 30),
                        title: Text('Số điện thoại: ' + user.phoneNo,
                            style: TextStyle(fontSize: 18)))
                  ]),
            ),
          ],
        )),
      ),
    );
  }
}
