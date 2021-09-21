import 'package:camtu_app/model/Notitfy.dart';
import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/room/ComponentRoom.dart';
import 'package:camtu_app/view/component/home/MenuBottom.dart';
import 'package:camtu_app/view/component/home/TabNavigator.dart';
import 'package:camtu_app/view/page/room/TupleQuotes.dart';
import 'package:camtu_app/view/page/home/ListRoomPage.dart';
import 'package:camtu_app/view/page/user/PersonalPage.dart';
import 'package:camtu_app/view/page/room/SystemRoomPage.dart';
import 'package:camtu_app/services/NotifycationServices.dart';
import 'package:camtu_app/services/RoomServices.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserAccount user;
  const HomePage(this.user) ;

  @override
  _HomePageState createState() => _HomePageState(this.user);
}



class _HomePageState extends State<HomePage> {
  UserAccount user ;
  var count=false;
  _HomePageState(this.user) {



    List<Widget> pages = [
      new ListRoomPage(),
      new Scaffold(
          appBar: AppBar(
            title: Text('Chat'),
          )),
      new Scaffold(
        appBar: AppBar(
          title: Text('Thông báo'),
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      new PersonalPage(user),
    ];

  }
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

    if  (AccountServices.useracount.typeUser == false) {
      AccountServices().getListRoom(AccountServices.id).listen((event)async {
        event.forEach((element) {
          element.listen((room) async{
            await  NotifycationServices()
                .getStateOfRoom(room.idRoom, AccountServices.id)
                .then((event) {
              if (event != 'unread') {
                RoomServices().getRequestUser(room.idRoom, false).listen((e) {
                  if (e.length > 0&&AccountServices.useracount.typeUser==false) {
                    DateTime date = DateTime.now();
                    Notify not = Notify(
                        phoneNo: AccountServices.id,
                        date: date.toString(),
                        type: 'request',
                        content: [room.idRoom, room.nameRoom, e.length],
                        state: 'unread');
                    NotifycationServices().addNotifycation(not).listen((event) {

                    });
                  }
                });
              }
            });
          });
        });
      });
      AccountServices().getListRoom(AccountServices.id).listen((event) async{
        event.forEach((element) {
          element.first.then((room) {
            RoomServices().getListTurple(room.idRoom).listen((lstTur) {
              lstTur.forEach((ee) {
                ee.listen((turple)async {
                  if (turple.isDeadLine()) {
                    await  NotifycationServices()
                        .getStateTurple(turple.id, AccountServices.id)
                        .then((event) {
                      if (event != 'true') {
                        Notify not = Notify(
                            phoneNo: AccountServices.id,
                            date: turple.deadLine,
                            type: 'deadline',
                            content: [
                              turple.id,
                              turple.name,
                              turple.deadLine,
                              room.nameRoom
                            ],
                            state: 'unread');
                        NotifycationServices()
                            .addNotifycation(not)
                            .listen((event) {

                        });
                      }
                    });
                  }
                  ;
                });
              });
            });
          });
        });
      });
    }else if(AccountServices.useracount.typeUser==true){
      AccountServices().getListRoom(AccountServices.id).listen((event) {
        event.forEach((element) {
          element.listen((room) {
            RoomServices().getListTurpleOfUser(room.idRoom,AccountServices.id).listen((lstTur) {
              lstTur.forEach((ee) {
                ee.listen((turple) async{
                  if (turple.isDeadLine()) {
                    await    NotifycationServices()
                        .getStateTurple(turple.id, AccountServices.id)
                        .then((event) {
                      if (event != 'true') {
                        Notify nte = Notify(
                            phoneNo: AccountServices.id,
                            date: turple.deadLine,
                            type: 'deadline',
                            content: [
                              turple.id,
                              turple.name,
                              turple.deadLine,
                              room.nameRoom
                            ],
                            state: 'unread');
                        NotifycationServices()
                            .addNotifycation(nte)
                            .listen((event) {

                        });
                      }
                    });
                  }
                  ;
                });
              });
            });
          });
        });
      });




    }
    super.initState();
    _pageController = new PageController();
    if(this.user==null){
      Navigator.of(context).pop();
      Navigator.popAndPushNamed(context, "/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return await   AccountServices().logout(context);
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
             height: 90,
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
              items: [ BottomNavigationBarItem(
                  icon: Icon(Icons.house, size: 35),
                  title: Text(
                    "Room",
                    style: TextStyle(fontSize: 14),
                  )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      size: 35,
                    ),
                    title: Text(
                      "Chat",
                      style: TextStyle(fontSize: 14),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications_active_outlined, size: 35),
                    title: StreamBuilder<int>(
                        stream: NotifycationServices().countUnred(AccountServices.id),
                        builder: (context, snapshot) {
                          if(snapshot.data==null || snapshot
                              .hasError||snapshot.connectionState==ConnectionState.waiting){
                            return Text(
                              "Thông báo",
                              style: TextStyle(fontSize: 14),
                            );
                          }
                          return Text(
                            snapshot.data>0?"Thông báo(${snapshot.data})":"Thông báo",
                            style: TextStyle(fontSize: 14),
                          );
                        }
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_pin, size: 35),
                    title: Text(
                      "Tài khoản",
                      style: TextStyle(fontSize: 14),
                    )),],
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

    if(tabItem=='Page3'){
      count=true;
    }
    if(count==true&&tabItem!='Page3'){
      count=false;
      NotifycationServices().readingNotify(AccountServices.id);
    }
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