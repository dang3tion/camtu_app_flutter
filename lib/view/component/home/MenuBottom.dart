import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/view/component/room/ComponentRoom.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  const MenuButton();

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  int _currentIndex = 0;
_MenuButtonState();
  @override
  Widget build(BuildContext context) {
    return Container(
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
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFFFFFFF),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.house, size: 40),
              title: Text(
                "Room",
                style: TextStyle(fontSize: 16),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 40,
              ),
              title: Text(
                "Chat",
                style: TextStyle(fontSize: 16),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active_outlined, size: 40),
              title: Text(
                "Thông báo",
                style: TextStyle(fontSize: 16),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin, size: 40),
              title: Text(
                "Tài khoản",
                style: TextStyle(fontSize: 16),
              )),
        ],
        onTap: (index) {
          setState(() {
          });
        },
      ),
    );
  }
}
