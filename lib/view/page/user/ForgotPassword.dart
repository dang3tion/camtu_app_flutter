import 'dart:async';

import 'package:camtu_app/view/component/static/Input.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/DatePicker.dart';
import 'package:camtu_app/view/component/static/InputEmail.dart';
import 'package:camtu_app/view/component/static/InputPassword.dart';
import 'package:camtu_app/view/page/user/GetPasswordPage.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../component/static/InputCo.dart';

class OtpPage2 extends StatefulWidget {
  final String id;
  final String phoneNo;

  OtpPage2(this.id, this.phoneNo);

  @override
  _OtpPage2State createState() => _OtpPage2State(this.id, this.phoneNo);
}

class _OtpPage2State extends State<OtpPage2> {
  var _key = GlobalKey<FormState>();
  String id;
  String phoneNo;
  var optController = TextEditingController();
  int count = 90;
  bool loading = false;
  Timer timer;
  final isNumber =
  new RegExp(r'^[0-9]*$', caseSensitive: false, multiLine: false);

  _OtpPage2State(this.id, this.phoneNo) {
    this.id = id;
    this.phoneNo = phoneNo;
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

  void startTime() {
    count = 90;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (count > 0) {
          count -= 1;
        } else {
          timer.cancel();
        }
      });
    });
  }


  @override
  void dispose() {
    if(timer.isActive){
      timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingWidget()
        : SingleChildScrollView(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Mã OTP đã được gửi đến số điện thoại của bạn',
                    style:
                    TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      speratePhone(phoneNo),
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w700, fontSize: 16,fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Container(
                  child: Form(
                    key: _key,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Trường không được bỏ trống";
                          } else if (!isNumber.hasMatch(value)) {
                            return "Vui lòng nhập mã đúng định dạng OTP";
                          } else if (value.length < 6) {
                            return "Mã OTP gồm ít nhất 6 ký tự";
                          }
                          return null;
                        },
                        controller: optController,
                        decoration: InputDecoration(
                            labelText: 'Mã OTP',
                            hintText: 'Nhập mã OTP',
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      count > 0
                          ? 'Mã có hiệu lực: ${count} giây'
                          : 'Mã hết hạn vui lòng thử lại',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                          fontSize: 15)),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 40),
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: RaisedButton.icon(
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () async {
                              if (count == 0) {
                                setState(() {
                                  loading = true;
                                });
                                AccountServices ac =
                                new AccountServices();
                                String phoneNo = this.phoneNo;
                                if (phoneNo.startsWith('0')) {
                                  phoneNo =
                                      phoneNo.replaceFirst('0', '+84');
                                } else if (phoneNo.startsWith('84')) {
                                  phoneNo =
                                      phoneNo.replaceFirst('84', '+84');
                                }

                                await FirebaseAuth.instance
                                    .verifyPhoneNumber(
                                    phoneNumber: phoneNo,
                                    verificationCompleted: (id) {
                                      if(timer.isActive){
                                        timer.cancel();
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResetPasswordPage(this.phoneNo)));
                                    },
                                    verificationFailed:
                                        (verificationFailed) {
                                          Navigator
                                              .popAndPushNamed(
                                              context, '/');
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Gặp sự cố tạm thời, vui lòng thử lại sau vài phút"),
                                          ));
                                    },
                                    codeSent: (codeSent, token) {
                                      this.id = codeSent;
                                      loading = false;
                                      startTime();
                                    },
                                    timeout:
                                    const Duration(seconds: 90),
                                    codeAutoRetrievalTimeout:
                                        (verificationId) {
                                      print(verificationId);
                                    });
                              }
                            },
                            color: Color(0xffFF00E5E5),
                            label: Text(
                              'Gửi lại mã',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 40),
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () async {
                              AccountServices ac = new AccountServices();
                              setState(() {
                                loading=true;
                              });
                              await ac
                                  .checkOtp(
                                  this.optController.text, this.id)
                                  .then((value) async {
                                if (value) {

                                  if(timer.isActive){
                                    timer.cancel();
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResetPasswordPage(this.phoneNo)));
                                } else {
                                  setState(() {
                                    loading=false;
                                  });
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Sai mã OTP"),
                                  ));
                                }
                              });
                            },
                            color: Color(0xffFF00E5E5),
                            child: Text(
                              'Xác nhận',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class VerifyPhonePage extends StatefulWidget {

  VerifyPhonePage();

  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  bool showOtp = false;
  var _key = GlobalKey<FormState>();
  var optPhoneNo = TextEditingController();
  var phoneNo;
  var idCode;
  bool loading = false;
  RegExp phoneCheck = new RegExp(
    r'(84|0[3|5|7|8|9])+([0-9]{8})\b',
    caseSensitive: false,
    multiLine: false,
  );
  final isNumber =
  new RegExp(r'^[0-9]*$', caseSensitive: false, multiLine: false);


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
  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor:  Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
              Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[500],
        title: Text('Lấy lại mật khẩu'),
      ),
          body:  !showOtp
              ? loading
              ? loadingWidget()
              :SingleChildScrollView(
      child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Vui lòng nhập số điện thoại của bạn',
                      style:
                      TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                  ),
                  Container(
                    child: Form(
                      key: _key,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Trường không được bỏ trống";
                            } else if (!phoneCheck.hasMatch(value)) {
                              return "Vui lòng nhập đúng định dạng số điện thoại";
                            }
                            return null;
                          },
                          controller: optPhoneNo,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_android),
                              labelText: 'Số điện thoại',
                              hintText: 'Nhập đúng định dạng số điện thoại',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 40),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: RaisedButton.icon(

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () async {
                                  if(_key.currentState.validate()){
                                    setState(() {
                                      this.loading=true;
                                    });
                                    String phoneNo =optPhoneNo.text;
                                    if (phoneNo.startsWith('0')) {
                                      phoneNo = phoneNo.replaceFirst('0', '+84');
                                    } else if (phoneNo.startsWith('84')) {
                                      phoneNo = phoneNo.replaceFirst('84', '+84');
                                    }
                                      AccountServices().checkExistsPhoneNo(phoneNo).then((value) async{
                                        if(value){
                                          this.phoneNo=phoneNo;

                                          await FirebaseAuth.instance.verifyPhoneNumber(
                                              phoneNumber: phoneNo,
                                              verificationCompleted: (id) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                    builder: (context) => ResetPasswordPage(this.phoneNo)));
                                              },
                                              verificationFailed: (verificationFailed) {
                                                print(verificationFailed);
                                                setState(() {
                                                  this.loading = false;

                                                  Navigator
                                                      .popAndPushNamed(
                                                      context, '/');

                                                  ScaffoldMessenger.of(this.context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Gặp sự cố tạm thời, vui lòng thử lại sau vài phút"),
                                                  ));
                                                });
                                              },
                                              codeSent: (codeSent, token) {
                                                setState(() {
                                                      this.idCode=codeSent;
                                                      this.showOtp=true;
                                                });
                                              },
                                              timeout: const Duration(seconds: 90),
                                              codeAutoRetrievalTimeout: (verificationId) {
                                                print(verificationId);
                                              });
                                        }else{
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Số điện thoại không tồn tại"),
                                          ));
                                        }
                                        setState(() {
                                          this.loading=false;
                                        });
                                      });
                                  }
                                },
                                color: Color(0xffFF00E5E5),
                                label: Text(
                                  'Tiếp tục',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ), icon:Icon(Icons.arrow_back,color: Colors.white,)

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    ):OtpPage2(this.idCode, this.phoneNo),
        );
  }
}






