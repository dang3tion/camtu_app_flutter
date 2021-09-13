import 'package:camtu_app/model/Notitfy.dart';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/room/ComponentRoom.dart';
import 'package:camtu_app/view/component/home/MenuBottom.dart';
import 'package:camtu_app/view/component/home/TabNavigator.dart';
import 'package:camtu_app/view/component/turple/TupleQuotes.dart';
import 'package:camtu_app/view/page/ListRoomPage.dart';
import 'package:camtu_app/view/page/NotifycationPage.dart';
import 'package:camtu_app/view/page/PersonalPage.dart';
import 'package:camtu_app/view/component/room/SystemRoomPage.dart';
import 'package:camtu_app/view/services/NotifycationServices.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserAccount user;

  const HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState(this.user);
}

class _HomePageState extends State<HomePage> {
  UserAccount user;

  _HomePageState(this.user) {
    List<Widget> pages = [
      new ListRoomPage(),
      new Scaffold(
          appBar: AppBar(
        title: Text('Chat'),
      )),
      NotifycationPage(),
      new PersonalPage(user),
    ];
  }

  double fontSize = 16;
  double size = 36;
  String _currentPage = "Page1";
  List<String> pageKeys = ["Page1", "Page2", "Page3", "Page4", "Page5"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
    "Page4": GlobalKey<NavigatorState>(),
    "Page5": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;
  PageController _pageController = new PageController();

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    if (this.user == null) {
      Navigator.of(context).pop();
      Navigator.popAndPushNamed(context, "/");
    }
  }

  @override
  Widget build(BuildContext context) {
    // try {
    if (AccountServices.useracount.typeUser == false) {
      AccountServices().getListRoom(AccountServices.id).listen((event) {
        event.forEach((element) {
          element.listen((room) {
            NotifycationServices()
                .getStateOfRoom(room.idRoom, AccountServices.id)
                .listen((event) {
                  print(event);
              if (event != 'unread') {
                RoomServices().getRequestUser(room.idRoom, false).listen((e) {
                  if (e.length > 0) {
                    DateTime date = DateTime.now();
                    Notify not = Notify(
                        phoneNo: AccountServices.id,
                        date: date.toString(),
                        type: 'requestMember',
                        content: [room.idRoom, room.nameRoom, e.length],
                        state: 'unread');
                    NotifycationServices().addNotifycation(not).listen((event) {
                      print(event);
                    });
                  }
                });
              }
            });
          });
        });
      });
    }
    // } catch (e) {}
    return WillPopScope(
      onWillPop: () async {
        return await AccountServices().logout(context);
      },
      child: Scaffold(
          body: Stack(children: <Widget>[
            _buildOffstageNavigator("Page1"),
            _buildOffstageNavigator("Page2"),
            _buildOffstageNavigator("Page3"),
            _buildOffstageNavigator("Page4"),
            _buildOffstageNavigator("Page5"),
          ]),
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.09,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: 1,
              )
            ]),
            child: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.lightBlue,
              unselectedItemColor: Colors.grey[600],
              elevation: 50,
              currentIndex: _selectedIndex,
              backgroundColor: const Color(0xFFFFFFFF),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.house, size: this.size),
                    title: Text(
                      "Room",
                      style: TextStyle(fontSize: this.fontSize),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      size: this.size,
                    ),
                    title: Text(
                      "Chat",
                      style: TextStyle(fontSize: this.fontSize),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications_active_outlined,
                        size: this.size),
                    title: Text(
                      "Thông báo",
                      style: TextStyle(fontSize: this.fontSize),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_pin, size: this.size),
                    title: Text(
                      "Tài khoản",
                      style: TextStyle(fontSize: this.fontSize),
                    )),
              ],
              onTap: (int index) {
                _selectTab(pageKeys[index], index);
              },
            ),
          )),
    );
  }

  // onTap: (index) {
  // setState(() {
  // _selectedIndex = index;
  // _pageController.animateToPage(index,
  // duration: Duration(milliseconds: 300),
  // curve: Curves.easeIn);
  // });
  // }
  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
        user: this.user,
      ),
    );
  }

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }
}
