import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/services/RoomServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteServices {
  CollectionReference turple = FirebaseFirestore.instance.collection('Tuple');

  Future<bool> saveListQuote(turpleId, List<Quote> listQuote) async {
    return await turple
        .doc(turpleId)
        .collection("Quote")
        .get()
        .then((value) async {
      if (value.docs.length == 0) {
        listQuote.forEach((qu) async {
          Map<String, dynamic> map = {
            'Question': qu.question,
            'Answers': qu.answers,
            'Index': qu.index,
            'TurpleId': turpleId
          };
          bool war = await turple
              .doc(turpleId)
              .collection("Quote")
              .add(map)
              .then((value) {
            return true;
          }).catchError((onError) {
            return true;
          });
          if (!war) {
            return false;
          }
        });
        return true;
      } else {
        value.docs.asMap().forEach((index, value) async {
          Map<String, dynamic> map = {
            'Question': listQuote[index].question,
            'Answers': listQuote[index].answers,
            'Index': listQuote[index].index,
            'TurpleId': turpleId
          };
          bool war = await value.reference.set(map).then((value) {
            return true;
          }).catchError((onError) {
            return false;
          });
          if (!war) {
            return false;
          }
        });
        return true;
      }
    });
  }


  Stream<Quote> getQuote(turpleId, quoteId) {
    return this
        .turple
        .doc(turpleId)
        .collection("Quote")
        .doc(quoteId)
        .snapshots()
        .map((event) {
          return mapFromDoc(event);
    });
  }

  Quote mapFromDoc(DocumentSnapshot doc) {
    List<dynamic>listAnswers= doc.get("Answers");
    return new Quote(
        id: doc.id,
        question: doc.get("Question"),
        answers: listAnswers.map((e){
          return e.toString();
        }).toList(),
        index: doc.get("Index"));
  }

  Stream<List<Quote>> getListQuote(turpleId) {
    return this
        .turple
        .doc(turpleId)
        .collection("Quote")
        .snapshots()
        .map((event) {
      List<Quote> listQuote = [];
      event.docs.forEach((doc) {
        listQuote.add(mapFromDoc(doc));
      });
      return listQuote;
    });
  }

  Future<List<Quote>> getListQuoteFuture(turpleId) {
    return this
        .turple
        .doc(turpleId)
        .collection("Quote").get()
        .then((event) {
      List<Quote> listQuote = [];
      event.docs.forEach((doc) {
        listQuote.add(mapFromDoc(doc));
      });
      return listQuote;
    });
  }
}
