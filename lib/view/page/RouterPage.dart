import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/page/HomePage.dart';
import 'package:camtu_app/view/page/Login.dart';
import 'package:camtu_app/view/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({Key key}) : super(key: key);
  @override
  _RouterPageState createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
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
