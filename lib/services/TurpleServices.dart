import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:camtu_app/view/page/room/TupleQuotes.dart';
import 'package:camtu_app/services/QuoteServices.dart';
import 'package:camtu_app/services/RoomServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TurpleServices {
  CollectionReference col = FirebaseFirestore.instance.collection('Tuple');

  Future<bool> createTurple(Turple turple) async {
    Map<String, dynamic> map = {
      'roomid': turple.roomId,
      'name': turple.name,
      'userid': turple.userId,
      'deadline': turple.deadLine,
      'updatetime': turple.bornLine,
      'quoteno': turple.number,
    };
    return await col.add(map).then((value) async {
      await  QuoteServices().saveListQuote(value.id,initialQuote(turple));
      return await RoomServices().addTurple(value.id, turple.roomId);
    }).catchError((onError) {
      return false;
    });
  }

  List<Quote> initialQuote(Turple turple) {
    List<Quote> list = [];
    for (var i = 0; i < turple.number; i++) {
      Quote quote = new Quote();
      quote.question = '';
      quote.answers = ['', ''];
      quote.index=0;
      list.add(quote);
    }
    return list;
  }

  Turple mapTurple(doc, state) {
    return new Turple(
      id: doc.id,
      name: doc.get('name'),
      roomId: doc.get('roomid'),
      number: doc.get('quoteno'),
      deadLine: doc.get('deadline'),
      userId: doc.get('userid'),
      bornLine: doc.get('updatetime'),
      state: state,
      quotes: [],
    );
  }

  Stream<Turple> getTurple(turpleId, state) {
    return col.doc(turpleId).snapshots().map((doc) {
      return mapTurple(doc, state);
    });
  }
}
