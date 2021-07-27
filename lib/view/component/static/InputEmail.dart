import 'package:flutter/material.dart';

class InputEmail extends StatefulWidget {
  final String label;
  final String hint;

  InputEmail(this.label, this.hint);

  _InputEmailState input;

  @override
  _InputEmailState createState() {
    input = _InputEmailState(this.label, this.hint);
    return input;
  }
  bool validate() {
    return input.validate();
  }

  String getText() {
    return input.getText();
  }
}

class _InputEmailState extends State<InputEmail> {
  final String label;
  final String hint;
  String value;
  var _key = new GlobalKey<FormState>();
  var _controller = new TextEditingController();

  _InputEmailState(this.label, this.hint);

  RegExp emailCheck = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false, multiLine: false);

  String getText() {
    return _controller.text;
  }

  bool validate() {
    return _key.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Form(
          key: _key,
          child: TextFormField(
            controller: _controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Trường không được bỏ trống";
              } else if (!emailCheck.hasMatch(value)) {
                return "Nhập đúng định dạng email";
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: label,
              hintText: hint,
              border: UnderlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
