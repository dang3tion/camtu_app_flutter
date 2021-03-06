import 'dart:math';

import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/page/user/ForgotPassword.dart';
import 'package:camtu_app/view/page/user/RegistyType.dart';
import 'package:camtu_app/view/page/user/RouterPage.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../home/HomePage.dart';

class ResetPasswordPage extends StatefulWidget {
  String phoneNo;
  ResetPasswordPage(this.phoneNo);
  @override
  _ResetPasswordPage createState() => _ResetPasswordPage(this.phoneNo);
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  var phoneNo;
  _ResetPasswordPage(this.phoneNo);
  TextEditingController pass1 = new TextEditingController();
  TextEditingController pass2 = new TextEditingController();
  bool loading = false;
  var _pass1Key = GlobalKey<FormState>();
  var _pass2Key = GlobalKey<FormState>();
  bool obscureText = true;

  Widget loadingWidget() {
    return Container(
      color: Color(0xffFF009BB6),
      child: Center(
        child: SpinKitCircle(
          color: Colors.white,
        ),
      ),
    );
  }

  speratePhone(String text) {
    var count = 0;
    var result = '';
    for (var i = 0; i < text.length; i++) {
      if (count == 3) {
        count = 1;
        result += ' ' + text[i];
      } else {
        result += text[i];
        count++;
      }
    }
    return result;
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
              title: Text('L???y l???i m???t kh???u'),
            ),
            body: Center(
                child: Container(
              margin: EdgeInsets.only(bottom: 60),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Thi???t l???p m???t kh???u m???i cho t??i kho???n',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      speratePhone('+8490129032'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _pass1Key,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "M???t kh???u kh??ng ???????c b??? tr???ng";
                            } else if (value.length < 6) {
                              return "M???t kh???u ph???i l???n h??n 6 ch??? s???";
                            }
                            return null;
                          },
                          controller: pass1,
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
                              labelText: 'M???t kh???u m???i',
                              hintText: 'Nh???p m???t kh???u m???i',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _pass2Key,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim() != this.pass1.text.trim()) {
                              return "M???t kh???u kh??ng kh???p";
                            }
                            return null;
                          },
                          controller: pass2,
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
                              labelText: 'Nh???p l???i m???t kh???u',
                              hintText: 'Nh???p m???t kh???u',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                            if(_pass1Key.currentState.validate()&&_pass2Key.currentState.validate()){
                              setState(() {
                                this.loading=true;
                              });
                              AccountServices().resetPassword(phoneNo,pass1.text.trim()).then((value){
                                if(value){
                                  Navigator
                                      .popAndPushNamed(
                                      context, '/');
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(SnackBar(
                                    content: Text("?????i m???t kh???u th??nh c??ng"),
                                  ));
                                }else{
                                  Navigator
                                      .popAndPushNamed(
                                      context, '/');
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(SnackBar(
                                    content: Text("G???p s??? c??? t???m th???i, vui l??ng th??? l???i sau v??i ph??t"),
                                  ));
                                }

                              });

                            }

                          },
                          child: Text(
                            'X??c nh???n',
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
