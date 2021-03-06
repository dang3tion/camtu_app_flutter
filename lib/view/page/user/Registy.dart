import 'dart:async';

import 'package:camtu_app/view/component/static/Input.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/DatePicker.dart';
import 'package:camtu_app/view/component/static/InputEmail.dart';
import 'package:camtu_app/view/component/static/InputPassword.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../component/static/InputCo.dart';

class OtpPage extends StatefulWidget {
  final String id;
  final UserAccount user;

  OtpPage(this.id, this.user);

  @override
  _OtpPageState createState() => _OtpPageState(this.id, this.user);
}

class _OtpPageState extends State<OtpPage> {
  var _key = GlobalKey<FormState>();
  String id;
  UserAccount user;
  var optController = TextEditingController();
  int count = 90;
  bool loading = false;
  Timer timer;
  final isNumber =
      new RegExp(r'^[0-9]*$', caseSensitive: false, multiLine: false);

  _OtpPageState(this.id, this.user) {
    this.id = id;
    this.user = user;
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
    }super.dispose();
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'M?? OTP ???? ???????c g???i ?????n s??? ??i???n tho???i c???a b???n',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '${user.phoneNo}',
                          style:
                          TextStyle(color: Colors.grey[700], fontSize: 16,fontStyle: FontStyle.italic),
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
                                  return "Tr?????ng kh??ng ???????c b??? tr???ng";
                                } else if (!isNumber.hasMatch(value)) {
                                  return "Vui l??ng nh???p m?? ????ng ?????nh d???ng OTP";
                                } else if (value.length < 6) {
                                  return "M?? OTP g???m ??t nh???t 6 k?? t???";
                                }
                                return null;
                              },
                              controller: optController,
                              decoration: InputDecoration(
                                  labelText: 'M?? OTP',
                                  hintText: 'Nh???p m?? OTP',
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
                                ? 'M?? c?? hi???u l???c: ${count} gi??y'
                                : 'M?? h???t h???n vui l??ng th??? l???i',
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
                                      String phoneNo = this.user.phoneNo;
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
                                                AccountServices ac =
                                                    new AccountServices();
                                                ac
                                                    .registryUser(this.user)
                                                    .then((value) {
                                                  Navigator
                                                      .popAndPushNamed(
                                                          context, '/');
                                                  ScaffoldMessenger.of(this.context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "T???o t??i kho???n th??nh c??ng"),
                                                  ));
                                                });
                                              },
                                              verificationFailed:
                                                  (verificationFailed) {
                                                print(verificationFailed);
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
                                    'G???i l???i m??',
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
                                        AccountServices ac =
                                            new AccountServices();
                                        ac
                                            .registryUser(this.user)
                                            .then((value) {
                                          Navigator.pushReplacementNamed(
                                              context, '/');
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "T???o t??i kho???n th??nh c??ng"),
                                          ));
                                        });
                                      } else {
                                        setState(() {
                                          loading=false;
                                        });
                                        ScaffoldMessenger.of(this.context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Sai m?? OTP"),
                                        ));
                                      }
                                    });
                                  },
                                  color: Color(0xffFF00E5E5),
                                  child: Text(
                                    'X??c nh???n',
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

class RegistryPage extends StatefulWidget {
  final bool type;

  const RegistryPage(this.type);

  @override
  _RegistryPageState createState() => _RegistryPageState(this.type);
}

class _RegistryPageState extends State<RegistryPage> {
  bool showOtp = false;
  String id = '';
  InputText name;
  DatePickerButton birthDate;
  InputText address;
  InputText idStudent;
  InputText nameSchool;
  InputText nameGrade;
  InputText phone;
  bool type;
  InputEmail email;
  InputPass pass;
  InputPass passValidate;
  UserAccount user;
  bool loading = false;

  _RegistryPageState(this.type) {
    name = new InputText("H??? v?? t??n", "Nh???p h??? t??n", true);
    birthDate = type
        ? new DatePickerButton("Ch???n ng??y sinh", DateTime(2020, 1, 1),
            DateTime(2020, 1, 1), DateTime(2000, 1, 1), false)
        : new DatePickerButton("Ch???n ng??y sinh", DateTime(2000, 1, 1),
            DateTime(2000, 1, 1), DateTime(1950, 1, 1), false);
    address = new InputText("?????a ch???", "Nh???p ?????a ch???", true);
    idStudent = type
        ? new InputText("M?? h???c sinh", "Nh???p m?? h???c sinh", true)
        : new InputText("M?? gi??o vi??n", "Nh???p m?? gi??o vi??n", true);
    nameSchool = new InputText("Tr?????ng h???c hi???n t???i", "Nh???p t??n tr?????ng", true);

    phone = type
        ? new InputText("S??? ??i???n tho???i ph??? huynh/ ng?????i gi??m h???",
            "Nh???p s??? ??i???n tho???i", false)
        : new InputText("S??? ??i???n tho???i ", "Nh???p s??? ??i???n tho???i", false);
    email = type
        ? new InputEmail("Email h???c sinh", "Nh???p email")
        : new InputEmail("Email gi???ng d???y", "Nh???p email");
    pass = new InputPass(label: "M???t kh???u", hint: "Nh???p m???t kh???u");
    passValidate = new InputPass(
        label: "X??c nh???n m???t kh???u", hint: "Nh???p m???t kh???u", value: '');
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

  bool validate() {
    return name.validate() &&
        address.validate() & idStudent.validate() &&
        nameSchool.validate() &&
        phone.validate() &&
        email.validate() &&
        pass.validate() &&
        passValidate.validate();
  }

  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (this.showOtp == true) {
          setState(() {
            this.showOtp = false;
            this.loading = false;
          });
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (showOtp == true) {
                setState(() {
                  this.showOtp = false;
                  this.loading = false;
                });
              } else {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.cyan[500],
          title: Text('????ng k??'),
        ),
        body: !showOtp
            ? loading
                ? loadingWidget()
                : SingleChildScrollView(
                    child: Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            name,
                            birthDate,
                            address,
                            idStudent,
                            nameSchool,
                            phone,
                            email,
                            pass,
                            passValidate,
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 20, 0, 40),
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: showConfirm,
                                  color: Color(0xffFF00E5E5),
                                  child: Text(
                                    'T???o t??i kho???n',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
            : OtpPage(this.id, this.user),
      ),
    );
  }
  void showConfirm() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('X??c nh???n t???o t??i kho???n'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  'C??c th??ng tin c???a b???n s??? ???????c ch??ng t??i qu???n l??, b???n c?? ch???p nh???n ??i???u kho???n n??y?',
                  textAlign: TextAlign.justify,
                ),
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
                      color: Color(0xffFF00E5E5),
                      onPressed: () async {
                        passValidate.setValue(pass.getText());
                        Navigator.pop(context);
                        if (validate()) {
                          if (pass.getText() == passValidate.getText()) {
                            setState(() {
                              this.loading = true;
                            });
                            String phoneNo =phone.getText();
                            if (phoneNo.startsWith('0')) {
                              phoneNo = phoneNo.replaceFirst('0', '+84');
                            } else if (phoneNo.startsWith('84')) {
                              phoneNo = phoneNo.replaceFirst('84', '+84');
                            }
                            this.user = new UserAccount(
                                avatar:
                                    'https://cdn.pixabay.com/photo/2018/04/18/18/56/user-3331257_960_720.png',
                                userId: idStudent.getText(),
                                name: name.getText(),
                                address: address.getText(),
                                birthday: birthDate.getDate(),
                                phoneNo: phoneNo,
                                nameSchool: nameSchool.getText(),
                                email: email.getText(),
                                password: pass.getText(),
                                typeUser: this.type);
                            AccountServices ac = new AccountServices();


                                AccountServices().checkExistsPhoneNo(phoneNo).then((value) async {

                              if (value) {
                                setState(() {
                                  this.loading = false;
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "S??? ??i???n tho???i ???? t???n t???i"),
                                  ));
                                });
                              } else {
                                AccountServices().checkExistsEmail(user.email).then((value) async{
                                  if(value){
                                    setState(() {
                                      this.loading = false;
                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Email ???? t???n t???i"),
                                      ));
                                    });
                                  }else {
                                    await FirebaseAuth.instance.verifyPhoneNumber(
                                        phoneNumber: phoneNo,
                                        verificationCompleted: (id) {
                                          AccountServices ac =
                                          new AccountServices();
                                          ac.registryUser(this.user).then((value) {
                                            Navigator.pushReplacementNamed(
                                                context, '/');
                                            ScaffoldMessenger.of(this.context)
                                                .showSnackBar(SnackBar(
                                              content:
                                              Text("T???o t??i kho???n th??nh c??ng"),
                                            ));
                                          });
                                        },
                                        verificationFailed: (verificationFailed) {
                                          print(verificationFailed);
                                          setState(() {
                                            this.loading = false;
                                            ScaffoldMessenger.of(this.context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "G???p s??? c??? t???m th???i, vui l??ng th??? l???i sau v??i ph??t"),
                                            ));
                                          });
                                        },
                                        codeSent: (codeSent, token) {
                                          setState(() {
                                            this.id = codeSent;
                                            print(this.id);
                                            showOtp = true;
                                          });
                                        },
                                        timeout: const Duration(seconds: 90),
                                        codeAutoRetrievalTimeout: (verificationId) {
                                          print(verificationId);
                                        });
                                  }
                                });

                              }
                            });
                          }
                        }
                      },
                      child: Text(
                        'X??c nh???n',
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
                      child: Text('H???y'),
                    )
                  ],
                ),
              ],
            ));
  }
}
