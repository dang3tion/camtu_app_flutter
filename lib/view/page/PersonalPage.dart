import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  final UserAccount user;

  PersonalPage(this.user);

  @override
  _PersonalPageState createState() => _PersonalPageState(this.user);
}

class _PersonalPageState extends State<PersonalPage> {
  final UserAccount user;
  int index = 0;

  _PersonalPageState(this.user);

  Future<bool> backTab() async {
    setState(() {
      this.index = 0;
      return true;
    });
    return false;
  }

  void changeTab(index) {
    setState(() {
      this.index = index;
    });
  }

  Widget mainTab() {
    return StreamBuilder<UserAccount>(
      stream: AccountServices().user,
      builder: (context, snapshot) {
      if(snapshot.hasError||snapshot.connectionState==ConnectionState.waiting){
        return LoadingWidget();
      }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Quản lý tài khoản'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: GestureDetector(
                  onTap: (){
                    changeTab(1);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.avatar ),
                        radius: 35,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data.name,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 5),
                              Text(
                                snapshot.data.typeUser ? 'Học sinh' : 'Giáo viên',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[500],
              ),
              FlatButton(
                onPressed: () {
                  changeTab(1);
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Thông tin cá nhân'),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  changeTab(2);
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Cài đặt'),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  changeTab(3);
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.security_rounded),
                    title: Text('Đổi mật khẩu'),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  await AccountServices().logout(context);
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Đăng xuất'),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget getName() {
    Stream<DocumentSnapshot> users =
        FirebaseFirestore.instance.collection('Stream').doc('123').snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: users,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          print(snapshot.data['name']);
          return Text(
            snapshot.data['name'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19),
          );
        });
  }

  Widget personal() {
    return StreamBuilder<UserAccount>(
      stream: AccountServices().user,
      builder: (context, snapshot) {
        if(snapshot.hasError||snapshot.connectionState==ConnectionState.waiting){
          return LoadingWidget();
        }
        return WillPopScope(
          onWillPop: backTab,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  changeTab(0);
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
                          backgroundImage: NetworkImage(snapshot.data.avatar ?? ''),
                          radius: 80,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    snapshot.data.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Divider(),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                  leading: Icon(Icons.cake_outlined, size: 30),
                                  title: Text('Ngày sinh: ' + snapshot.data.birthday,
                                      style: TextStyle(fontSize: 18))),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.school_outlined,
                                  size: 30,
                                ),
                                title: snapshot.data.typeUser
                                    ? Text('Học tại ' + snapshot.data.nameSchool,
                                        style: TextStyle(fontSize: 18))
                                    : Text('Giảng dạy tại ' + snapshot.data.nameSchool,
                                        style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                leading: Icon(Icons.house_outlined, size: 30),
                                title: Text('Địa chỉ ' + snapshot.data.address,
                                    style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                  leading: Icon(Icons.email, size: 30),
                                  title: Text('Email: ' + snapshot.data.email,
                                      style: TextStyle(fontSize: 18))),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                  leading: Icon(Icons.phone, size: 30),
                                  title: Text('Số điện thoại: ' + snapshot.data.phoneNo,
                                      style: TextStyle(fontSize: 18)))
                            ]),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        );
      }
    );
  }

  Widget setting() {
    return WillPopScope(
      onWillPop: backTab,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              changeTab(0);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Chỉnh sửa thông tin cá nhân'),
          centerTitle: true,
        ),
        body: Container(
          child: Text('Cài đặt frame'),
        ),
      ),
    );
  }

  Widget changePass() {
    return WillPopScope(
      onWillPop: backTab,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              changeTab(0);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Đổi mật khẩu'),
          centerTitle: true,
        ),
        body: Container(
          child: Text('Đổi mật khẩu frame'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return mainTab();
      case 1:
        return personal();
      case 2:
        return setting();
      case 3:
        return changePass();
    }
  }
}
