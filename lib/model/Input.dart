import 'package:flutter/cupertino.dart';

class InputController {
  GlobalKey<FormState> _key=new GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();


  getKey() {
    return this._key;
  }

  getController() {
    return this._controller;
  }

  bool validate() {
    return _key.currentState.validate();
  }

  String getText() {
    return this._controller.text;
  }
}
