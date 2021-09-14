import 'package:camtu_app/model/Notitfy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotifycationServices {
  var doc = FirebaseFirestore.instance.collection('User');

  Stream<bool> addNotifycation(Notify not) {
    Map<String, dynamic> map = {
      'datetime': not.date,
      'content': not.content,
      'type': not.type,
      'state': not.state,
    };
    print(map);
    return doc
        .doc(not.phoneNo)
        .collection("Notify")
        .add(map)
        .then((value) => true)
        .catchError((onError) => false)
        .asStream();
  }

  Notify mapDocument(DocumentSnapshot query) {
    return Notify(
        id: query.id,
        state: query.get('state'),
        content: query.get('content'),
        type: query.get('type'),
        date: query.get('datetime'));
  }

  Stream<List<Stream<Notify>>> getNotify(String phoneNo) {
    return doc
        .doc(phoneNo)
        .collection('Notify')
        .orderBy('datetime', descending: true)
        .snapshots()
        .map((event) {
      List<Stream<Notify>> list = [];
      event.docs.forEach((element) {
        list.add(element.reference.snapshots().map((doc) {
          Notify no = mapDocument(doc);
          no.phoneNo = phoneNo;
          return no;
        }));
      });
      return list;
    });
  }

  Stream<int> countUnred(String phoneNo) {
    return doc
        .doc(phoneNo)
        .collection('Notify')
        .where('state', isEqualTo: 'unread')
        .snapshots()
        .map((event) {
      return event.size;
    });
  }
  Future<bool> readingNotify(String phoneNo) {
    return doc
        .doc(phoneNo)
        .collection('Notify')
        .where('state', isEqualTo: 'unread').get().then((value){
       value.docs.forEach((element) {
         element.reference.update({'state':'read'});
       });
       return true;
    });


  }
  Future<String> getStateOfRoom(String roomId, String phoneNo) async {
    return await doc
        .doc(phoneNo)
        .collection('Notify')
        .orderBy('datetime', descending: true)
        .get()
        .then((event) {
      var count = 0;
      for (var i = 0; i < event.size; i++) {
        if (event.docs[i].get('type') == 'request' &&
            event.docs[i].get('content')[0] == roomId) {
          return event.docs[i].get('state');
        }
        if (count == 10) break;
        count++;
      }
      return 'read';
    });
  }

  Future<String> getStateTurple(String turpleId, String phoneNo) async {
    return await doc
        .doc(phoneNo)
        .collection('Notify')
        .where('type', isEqualTo: 'deadline')
        .get()
        .then((event) {
      if (event.docs.isEmpty) return 'null';
      for (var i = 0; i < event.size; i++) {
        if (event.docs[i].get('content')[0].toString() == turpleId.toString()) {
          return 'true';
        }
      }
      return 'false';
    });
  }
}
