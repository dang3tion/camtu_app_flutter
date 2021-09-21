import 'package:camtu_app/view/component/home/MenuBottom.dart';
import 'package:camtu_app/view/page/home/HomePage.dart';
import 'package:camtu_app/view/page/user/Login.dart';
import 'package:camtu_app/view/page/user/Registy.dart';
import 'package:camtu_app/view/page/user/RegistyType.dart';
import 'package:camtu_app/view/page/user/RouterPage.dart';
import 'package:camtu_app/view/page/room/SystemRoomPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: RouterPage()));
}
