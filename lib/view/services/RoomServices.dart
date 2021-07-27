import 'dart:math';

import 'package:camtu_app/model/DetailWork.dart';
import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/services/QuoteServices.dart';
import 'package:camtu_app/view/services/TurpleServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomServices {
  CollectionReference room = FirebaseFirestore.instance.collection('Room');

  randomId() {
    var rng = new Random();
    return String.fromCharCode((rng.nextInt(122 - 97) + 97)) +
        String.fromCharCode((rng.nextInt(25) + 65)) +
        ((rng.nextInt(9999) + 1000)).toString();
  }





  Future<bool> isRoomExists(idRoom) async {
    return await room.doc(idRoom).get().then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> deleteMember(idUser, idRoom) async {
    return await room
        .doc(idRoom)
        .collection('MemberUser')
        .doc(idUser)
        .delete()
        .then((value) async {
      return await AccountServices().deleteRoom(idRoom, idUser);
    }).catchError((onError) {
      return false;
    });
  }

  addTurple(turpleid, roomId) async {
    Map<String, dynamic> map = {'state': 'create', 'turple': turpleid};
    return await this
        .room
        .doc(roomId)
        .collection("Turple")
        .doc(turpleid)
        .set(map)
        .then((value) {
      return true;
    }).catchError((onError) {
      return false;
    });
  }
  Stream<List<Quote>> getQuoteUser(roomId,turpleId,userId){
    return this.room.doc(roomId).collection('MemberUser').doc(userId).collection("Turple").doc(turpleId)
        .collection("Quote").snapshots().map((event) {
        List<Quote> listQuote=[];
        event.docs.forEach((element) {
          listQuote.add(new Quote(id: element.id,index: element.get('index')));
        });
        return listQuote;
    });
  }
  Stream<List<Stream<Quote>>> getQuote(turpleId, roomId, userId) {
    return this
        .room
        .doc(roomId)
        .collection("MemberUser")
        .doc(userId)
        .collection("Turple")
        .doc(turpleId)
        .collection("Quote")
        .snapshots()
        .map((quote) {
      List<Stream<Quote>> list = [];
      quote.docs.forEach((element) {
        Stream<Quote> quo =
            QuoteServices().getQuote(turpleId, element.id).map((event) {
          event.index = element.get('index');
          return event;
        });
        list.add(quo);
      });
      return list;
    });
  }
  Stream<Turple> getState(String roomId, String userId, String turpleId){
       return  this
        .room
        .doc(roomId)
        .collection("MemberUser")
        .doc(userId)
        .collection("Turple")
        .doc(turpleId).snapshots().map((event){
          return Turple(state: event['state']);
       });

  }
  Future<bool> setStateTurpleUser(
      String roomId, String userId, String turpleId, String state) async {
    return await this
        .room
        .doc(roomId)
        .collection("MemberUser")
        .doc(userId)
        .collection("Turple")
        .doc(turpleId)
        .set({"state": state,"updateTime:":DateTime.now().toString()})
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<bool> saveQuote(roomId, turpleId, List<Quote> quote, type) async {
    return await this
        .room
        .doc(roomId)
        .collection("MemberUser")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.get('permission').toString() == 'member') {
          quote.asMap().forEach((index, value) async {
            Map<String, dynamic> map = {'index': type ? -1 : value.index};
            if (type) {
              await element.reference
                  .collection("Turple")
                  .doc(turpleId)
                  .set({'state': 'ready'});
            }
            bool war = await element.reference
                .collection("Turple")
                .doc(turpleId)
                .collection("Quote")
                .doc(value.id)
                .set(map)
                .then((value) => true)
                .catchError((onError) => false);
            if (war == false) {
              return false;
            }
          });
        }
      });
      return true;
    });
  }
  Future<bool> setStateTurple(turpleId, roomId, state) async {
    return await this
        .room
        .doc(roomId)
        .collection("Turple")
        .doc(turpleId)
        .set({'state': state,'updatetime':DateTime.now().toString()})
        .then((value) => true)
        .catchError((onError) => false);
  }

  Stream<List<Stream<Turple>>> getListTurple(roomId) {
    return this.room.doc(roomId).collection("Turple").snapshots().map((doc) {
      List<Stream<Turple>> listTup = [];
      doc.docs.forEach((va) {
        listTup.add(TurpleServices().getTurple(va.id, va.get("state")));
      });
      return listTup;
    });
  }

  Future<bool> acceptUser(idUser, idRoom, isAccept, permission) async {
    Map<String, dynamic> map = {'member': idUser, 'permission': permission};
    return await room
        .doc(idRoom)
        .collection('RequestedUser')
        .doc(idUser)
        .delete()
        .then((value) async {
      if (isAccept) {
        return await room
            .doc(idRoom)
            .collection('MemberUser')
            .doc(idUser)
            .set(map)
            .then((value) async {
          return await AccountServices().addRoom(idRoom, idUser).then((value) {
            return value;
          });
        }).catchError((onError) {
          return false;
        });
      } else {
        return true;
      }
    }).catchError((onError) {
      return false;
    });
  }

  Room mapRoom(document) {
    return new Room(
        userId: document.get('UserID'),
        userName: document.get('UserOwner'),
        time: document.get('UpdateTime'),
        idRoom: document.id,
        nameRoom: document.get('NameRoom'));
  }

  Stream<Room> getRoom(roomId) {
    return room.doc(roomId).snapshots().map((data) {
      return mapRoom(data);
    });
  }

  Future<String> joinRoom(idUser, idRoom) async {
    return await isRoomExists(idRoom).then((value) {
      if (value) {
        Map<String, dynamic> map = {
          'request': idUser,
        };
        return room
            .doc(idRoom)
            .collection("RequestedUser")
            .doc(idUser)
            .get()
            .then((value) {
          if (value.exists) {
            return "Bạn đã gửi yêu cầu tới Room này";
          } else {
            return room
                .doc(idRoom)
                .collection("RequestedUser")
                .doc(idUser)
                .set(map)
                .then((value) {
              return 'Đã gửi yêu cầu tham gia Room.';
            }).catchError((onError) => 'Có lỗi xảy ra vui lòng thử lại.');
          }
        });
      } else {
        return 'ID Room không tồn tại, vui lòng thử lại.';
      }
    });
  }

  Stream<List<Stream<UserAccount>>> getRequestUser(idRoom, isAccept) {
    if (!isAccept) {
      return AccountServices().getListUser(
          room.doc(idRoom).collection("RequestedUser").snapshots().map((doc) {
        List<String> list = [];
        doc.docs.forEach((element) {
          list.add(element.id);
        });
        return list;
      }));
    } else {
      return AccountServices().getListUser(
          room.doc(idRoom).collection("MemberUser").snapshots().map((doc) {
        List<String> list = [];
        doc.docs.forEach((element) {
          list.add(element.id);
        });
        return list;
      }));
    }
  }

  Future<bool> createRoom(userId, name, nameRoom, phoneNo) async {
    var idDoc = await createUniqueID();
    var date = new DateTime.now();
    Map<String, dynamic> map = {
      'UserID': userId,
      'PhoneNo': phoneNo,
      'UserOwner': name,
      "UpdateTime": date.toString(),
      'NameRoom': nameRoom
    };
    return await room.doc(idDoc).set(map).then((value) async {
      await acceptUser(phoneNo, idDoc, true, 'admin');
      return await AccountServices().addRoom(idDoc, phoneNo).then((value) {
        if (value) {
          return true;
        }
        return false;
      });
    }).catchError((err) => false);
  }

  createUniqueID() async {
    var idDoc = randomId();
    var unique = false;
    while (unique == false) {
      await room.doc(idDoc).get().then((value) {
        if (!value.exists) {
          unique = true;
        } else {
          idDoc = randomId();
        }
      });
    }
    return idDoc;
  }
}
