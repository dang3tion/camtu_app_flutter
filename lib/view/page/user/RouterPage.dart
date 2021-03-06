import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/page/home/HomePage.dart';
import 'package:camtu_app/view/page/user/Login.dart';
import 'package:camtu_app/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class RouterPage extends StatelessWidget {
  const RouterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => Login(),
        '/home': (_) => HomePage(AccountServices.useracount),
      },
      initialRoute: "/",
    );
  }
}
