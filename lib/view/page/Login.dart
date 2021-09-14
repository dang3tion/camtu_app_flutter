import 'dart:math';

import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/page/ForgotPassword.dart';
import 'package:camtu_app/view/page/RegistyType.dart';
import 'package:camtu_app/view/page/RouterPage.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'HomePage.dart';

class Login extends StatefulWidget {
  final FirebaseApp app;

  const Login({this.app});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userName = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  bool loading = false;
  var _nameKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormState>();
  bool obscureText = true;
  RegExp phoneCheck = new RegExp(
    r'(84|0[3|5|7|8|9])+([0-9]{8})\b',
    caseSensitive: false,
    multiLine: false,
  );
  RegExp isNumber =
      new RegExp(r'^[0-9]*$', caseSensitive: false, multiLine: false);
  RegExp emailCheck = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false, multiLine: false);

  void check() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TypeUser()));
    });
  }

  Widget loadingWidget() {
    return Container(
      color: Color(0xffFF009BB6),
      child: Center(
        child: SpinKitWave(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    checkIsLogin();
  }

  checkIsLogin() async {
    AccountServices ac = new AccountServices();
    ac.checkIsLogin().then((value) {
      if (value == true) {
        AccountServices().user.listen((value) {
          if (value != null) {
            AccountServices.useracount = value;
            AccountServices.id=value.phoneNo;
            Navigator.popAndPushNamed(context, '/home');
          }
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingWidget()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.cyan[500],
              title: Text('Chào mừng bạn đến với Cẩm tú'),
            ),
            body: Center(
                child: Container(
              margin: EdgeInsets.only(bottom: 60),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/icon.jpg'),
                      radius: 90,
                    ),
                    SizedBox(height: 60),
                    Form(
                      key: _nameKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Trường không được bỏ trống";
                            } else if (isNumber.hasMatch(value)) {
                              if (!phoneCheck.hasMatch(value)) {
                                return "Số điện thoại không hợp lệ";
                              }
                            } else if (!emailCheck.hasMatch(value)) {
                              return "Email không hợp lệ";
                            }
                            return null;
                          },
                          controller: userName,
                          decoration: InputDecoration(
                              labelText: 'Tên tài khoản',
                              hintText: 'Nhập email hoặc số điện thoại',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _passKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mật khẩu không được bỏ trống";
                            } else if (value.length < 6) {
                              return "Mật khẩu phải lớn hơn 6 chữ số";
                            }
                            return null;
                          },
                          controller: pass,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: Icon(obscureText
                                    ? Icons.security
                                    : Icons.remove_red_eye),
                              ),
                              labelText: 'Mật khẩu',
                              hintText: 'Nhập mật khẩu',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => VerifyPhonePage()));
                          },
                          child: Text(
                            'Quên mật khẩu',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          )),
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 55,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          color: Colors.cyan,
                          onPressed: () {
                            if (_nameKey.currentState.validate() &&
                                _passKey.currentState.validate()) {
                              if (phoneCheck.hasMatch(userName.text)) {
                                setState(() {
                                  loading = true;
                                });
                                UserAccount u = new UserAccount(
                                    phoneNo: userName.text,
                                    password: pass.text);
                                AccountServices().login(u).then((value) {
                                  if (AccountServices().user != null) {
                                    AccountServices().user.listen((value) {
                                      AccountServices.useracount = value;
                                      Navigator.popAndPushNamed(
                                          context, '/home');
                                    });
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    ScaffoldMessenger.of(this.context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Tên tài khoản hoặc mật khẩu không hợp lệ"),
                                    ));
                                  }
                                  ;
                                });
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                UserAccount u = new UserAccount(
                                    email: userName.text, password: pass.text);
                                AccountServices().login(u).then((value) {
                                  AccountServices().user.listen((value) {
                                    if (value != null) {
                                      AccountServices.useracount = value;
                                      Navigator.popAndPushNamed(
                                          context, '/home');
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Tên tài khoản hoặc mật khẩu không hợp lệ"),
                                      ));
                                    }
                                  });
                                });
                              }
                            }
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 55,
                        child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: Colors.blueAccent)))),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TypeUser()));
                          },
                          child: Text(
                            'Tạo tài khoản',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
  }
}
