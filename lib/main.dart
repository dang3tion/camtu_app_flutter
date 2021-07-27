import 'package:camtu_app/view/component/home/MenuBottom.dart';
import 'package:camtu_app/view/page/HomePage.dart';
import 'package:camtu_app/view/page/Login.dart';
import 'package:camtu_app/view/page/Registy.dart';
import 'package:camtu_app/view/page/RegistyType.dart';
import 'package:camtu_app/view/page/RouterPage.dart';
import 'package:camtu_app/view/component/room/SystemRoomPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: RouterPage()));
}
