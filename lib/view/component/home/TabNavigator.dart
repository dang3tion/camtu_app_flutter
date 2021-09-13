import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/page/ListRoomPage.dart';
import 'package:camtu_app/view/page/NotifycationPage.dart';
import 'package:camtu_app/view/page/PersonalPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
final UserAccount user;
  const TabNavigator({this.navigatorKey, this.tabItem,this.user});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "Page1")
      child = ListRoomPage();
    else if (tabItem == "Page2")
      child = Scaffold(
          appBar: AppBar(
        title: Text('Chat'),
      ));
    else if (tabItem == "Page3")
      child =new NotifycationPage();
    else if (tabItem == "Page4")
      child = new PersonalPage(user);
    else if (tabItem == "Page5") child = ListRoomPage();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
