import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/component/turple/CompareQuoteComponent.dart';
import 'package:camtu_app/view/component/turple/CreatingQuoteComponent.dart';
import 'package:camtu_app/view/component/turple/ImplementQuoteComponent.dart';
import 'package:camtu_app/view/component/static/Dialog.dart';
import 'package:camtu_app/view/services/QuoteServices.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:flutter/material.dart';

class QuotePage extends StatefulWidget {
  final Turple turple;
  final UserAccount user;
  final bool type;

  QuotePage(this.turple, this.user, this.type);

  @override
  _QuotePageState createState() =>
      _QuotePageState(this.turple, this.user, this.type);
}

class _QuotePageState extends State<QuotePage>
    with SingleTickerProviderStateMixin {
  Turple turple;
  UserAccount user;
  List<Widget> listTab = [];
  List<CreatingQuoteComponents> listCreate = [];
  List<ImplementQuote> listImpl = [];
  List<Quote> listImpl2 = [];
  TabController _tabController;
  bool type;

  _QuotePageState(this.turple, this.user, this.type) {
    //create tab
    for (var i = 0; i < this.turple.number; i++) {
      listTab.add(Container(
        width: 80,
        child: Tab(
          text: 'Câu ${i + 1}',
        ),
      ));
    }
    //
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: this.turple.number);
  }


  @override
  Widget build(BuildContext context) {

  }
}
