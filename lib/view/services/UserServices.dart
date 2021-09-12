import 'dart:convert';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:crypto/crypto.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference doc = FirebaseFirestore.instance.collection('User');
  static UserAccount useracount;
  static String id;

  AccountServices() {}

  logout(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Xác nhận đăng xuất'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  'Bạn có muốn đăng xuất không?',
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
                        id = null;
                        final store = FlutterSecureStorage();
                        await store.delete(key: 'user');
                        Navigator.of(context).pop();
                        Navigator.popAndPushNamed(context, "/");
                      },
                      child: Text(
                        'Xác nhận',
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
                      child: Text('Hủy'),
                    )
                  ],
                ),
              ],
            ));
  }

  Future<bool> resetPassword(String phoneNo, String password) async {
    Map<String, dynamic> data = {
      'password': md5.convert(utf8.encode(password.trim())).toString(),
    };
    return await this.doc.doc(phoneNo).update(data).then((value) {
      return true;
    }).catchError((onError) => false);
  }

  Future registryUser(UserAccount user) async {
    Map<String, dynamic> data = {
      'name': user.name.trim(),
      'birthDate': user.birthday.trim(),
      'address': user.address.trim(),
      'id': user.userId.trim(),
      'school': user.nameSchool.trim(),
      'phoneNo': user.phoneNo,
      'email': user.email.trim(),
      'password': md5.convert(utf8.encode(user.password.trim())).toString(),
      'avatar': user.avatar.trim(),
      'type': user.typeUser,
    };
    try {
      await this.doc.doc(user.phoneNo).set(data);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkOtp(otp, id) async {
    PhoneAuthCredential phoneAuthCredential =
        PhoneAuthProvider.credential(verificationId: id, smsCode: otp);
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  UserAccount mapFromDocument(snapshot) {
    return UserAccount(
        userId: snapshot['id'],
        avatar: snapshot['avatar'],
        password: snapshot['password'],
        email: snapshot['email'],
        address: snapshot['address'],
        birthday: snapshot['birthDate'],
        name: snapshot['name'],
        nameSchool: snapshot['school'],
        phoneNo: snapshot['phoneNo'],
        typeUser: snapshot['type']);
  }

  Future<String> login(UserAccount user) async {
    if (user.phoneNo == null) {
      return await this.doc.get().then((QuerySnapshot querySnapshot) async {
        String x;
        querySnapshot.docs.forEach((QueryDocumentSnapshot doc) async {
          if (doc.get('email') == user.email &&
              doc.get('password') ==
                  md5.convert(utf8.encode(user.password)).toString()) {
            x = doc.id;
          }
        });
        id = x;
        return id;
      });
    } else {
      String phoneNo = user.phoneNo;
      if (phoneNo.startsWith('0')) {
        phoneNo = phoneNo.replaceFirst('0', '+84');
      } else if (phoneNo.startsWith('84')) {
        phoneNo = phoneNo.replaceFirst('84', '+84');
      }
      return await this.doc.get().then((QuerySnapshot querySnapshot) {
        String x;
        querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
          if (doc.id == phoneNo &&
              doc.get('password') ==
                  md5.convert(utf8.encode(user.password)).toString()) {
            x = doc.id;
          }
        });
        id = x;
        return id;
      });
    }
  }

  Future<bool> checkExistsEmail(String email) async {
    return await this.doc.get().then((QuerySnapshot querySnapshot) async {
      String x;
      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) async {
        if (doc.get('email') == email) {
          x = doc.id;
        }
      });
      if (x != null) {
        return true;
      } else {
        return false;
      }
    });
  }

  void rememberLogin(id) async {
    final store = FlutterSecureStorage();
    await store.write(key: 'user', value: id);
  }

  Future<bool> checkExistsPhoneNo(String phoneNo) async {
    return await doc
        .doc(phoneNo)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        return true;
      }
      return false;
    });
  }

  Future<bool> checkIsLogin() async {
    final store = FlutterSecureStorage();
    return await store.read(key: 'user').then((value) {
      if (value != null) {
        id = value;
        print('isLogin');
        return true;
      } else {
        print('not');
        return false;
      }
    });
  }

  Stream<List<Stream<Room>>> getListRoom(userId) {
    return doc.doc(userId).collection('Room').snapshots().map((query) {
      List<Stream<Room>> listRoom = [];
      query.docs.forEach((element) {
        listRoom.add(RoomServices().getRoom(element.id));
      });
      return listRoom;
    });
  }

  Future<bool> deleteRoom(String roomId, String userId) async {
    return await doc
        .doc(userId)
        .collection("Room")
        .doc(roomId)
        .delete()
        .then((value) {
      return true;
    }).catchError((onError) {
      return false;
    });
  }

  Future<bool> addRoom(String roomId, String userId) async {
    Map<String, dynamic> map = {'roomId': roomId};
    return await doc
        .doc(userId)
        .collection("Room")
        .doc(roomId)
        .set(map)
        .then((value) {
      return true;
    }).catchError((err) {
      return false;
    });
  }

  Stream<UserAccount> getUser(userId) {
    return doc.doc(userId).snapshots().map((data) {
      return mapFromDocument(data);
    });
  }

  Stream<List<Stream<UserAccount>>> getListUser(Stream<List<String>> arrId) {
    return arrId.map((arr) {
      List<Stream<UserAccount>> listUser = [];
      arr.forEach((element) {
        listUser.add(getUser(element));
      });
      return listUser;
    });
  }

  Stream<UserAccount> mapUser(DocumentReference doc) {
    Stream<DocumentSnapshot> stream = doc.snapshots();
    return stream.map((data) {
      rememberLogin(data.get('phoneNo'));
      return new UserAccount(
          userId: data.get('id'),
          avatar: data.get('avatar'),
          password: data.get('password'),
          email: data.get('email'),
          address: data.get('address'),
          birthday: data.get('birthDate'),
          name: data.get('name'),
          nameSchool: data.get('school'),
          phoneNo: data.get('phoneNo'),
          typeUser: data.get('type'));
    });
  }

  Stream<UserAccount> get user {
    if (id == null) {
      return null;
    } else {
      return mapUser(this.doc.doc(id));
    }
  }
}
