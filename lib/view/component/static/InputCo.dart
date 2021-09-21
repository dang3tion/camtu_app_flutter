import 'package:camtu_app/view/component/static/Input.dart';
import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String label;
  final String hint;
  final bool isNumber;
  _inputTextState input;

  InputText(this.label, this.hint, this.isNumber) {
  }


  @override
  _inputTextState createState() {
    input = new _inputTextState(label, hint, isNumber);
    return input;
  }

  bool validate() {
    return input.validate();
  }

  String getText() {
    return input.getText();
  }


}

class _inputTextState extends State<InputText> {
  String label;
  String hint;
  bool isNumber;
  InputController input = new InputController();
  RegExp phoneCheck = new RegExp(
    r'(84|0[3|5|7|8|9])+([0-9]{8})\b',
    caseSensitive: false,
    multiLine: false,
  );
  RegExp isr = new RegExp(r'^[0-9]*$', caseSensitive: false, multiLine: false);
  RegExp emailCheck = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false, multiLine: false);

  _inputTextState(String label, String hint, bool isNumber) {
    this.label = label;
    this.hint = hint;
    this.isNumber = isNumber;
  }

  bool validate() {
    return input.validate();
  }

  String getText() {
    return input.getText();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Container(

        width: MediaQuery
            .of(context)
            .size
            .width * 0.85,
        child: Form(
          key: this.input.getKey(),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Trường không được bỏ trống";
              } else if (!isNumber) {
                if (!isr.hasMatch(value) || !phoneCheck.hasMatch(value)) {
                  return " Vui lòng nhập số đúng định dạng số điện thoại";
                }
              }
              return null;
            },

            keyboardType:
            isNumber ? TextInputType.multiline : TextInputType.number,
            controller: this.input.getController(),
            decoration: InputDecoration(
              prefixIcon: Icon(isNumber ? Icons.book_outlined : Icons.phone),
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
