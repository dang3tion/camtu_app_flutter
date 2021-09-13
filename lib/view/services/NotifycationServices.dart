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
    return doc
        .doc(not.phoneNo)
        .collection("Notify")
        .add(map)
        .then((value) => true)
        .catchError((onError) => false)
        .asStream();
  }

  Notify mapDocument(QueryDocumentSnapshot query) {
    return Notify(
        id: query.id,
        state: query.get('state'),
        content: query.get('content'),
        type: query.get('type'),
        date: query.get('datetime'));
  }

  Stream<List<Notify>> getNotify(String phoneNo) {
   return doc
        .doc(phoneNo)
        .collection('Notify')
        .orderBy('datetime', descending: true)
        .snapshots()
        .map((event) {
      List<Notify> list = [];
      event.docs.forEach((element) {
        Notify no = mapDocument(element);
        no.phoneNo = phoneNo;
        list.add(no);
      });
      return list;
    });
    return null;
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
  Stream<String> getStateOfRoom(String roomId,String phoneNo){
    return doc.doc(phoneNo).collection('Notify').orderBy('datetime',descending: true).snapshots().map((event){
      if(event.docs.isEmpty) return 'null';
        var count=0;
      for(var i=0;i<event.size;i++) {
        if (event.docs[i].get('type') == 'requestMember'&&event.docs[i].get('content')[0]==roomId) {
          return event.docs[i].get('state');
        }
        if (count == 10) break;
        count++;
      }
      return 'read';
    });
  }
}
