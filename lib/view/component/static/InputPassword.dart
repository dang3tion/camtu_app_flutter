import 'package:flutter/material.dart';

class InputPass extends StatefulWidget {
  final String label;
  final String hint;
  String value;
   InputPass({@required this.label,@required this.hint,this.value}) ;
    _InputPassState input;
  @override
  _InputPassState createState() {
  input=  _InputPassState(label: this.label,hint: this.hint,value: this.value);
  return input;
  }
  bool validate() {
    return input.validate();
  }

  String getText() {
    return input.getText();
  }
  void setValue(String value){
    this.input.value=value;
  }
}

class _InputPassState extends State<InputPass> {
  bool obsecured=true;
  String value;
  final String label;
  final String hint;
  var _key = new GlobalKey<FormState>();
  var _controller = new TextEditingController();

  _InputPassState({@required this.label,@required this.hint,this.value});

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
          key:
          _key,
          child: TextFormField(
            controller: _controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Mật khẩu không được bỏ trống";
              }else if(value.length<6){
                return "Mật khẩu phải lớn hơn 6 chữ số";
              }else if(this.value!=null){
                if(_controller.text.trim()!=this.value.trim()){
                  return "Mật khẩu xác nhận không khớp";
                }
              }
              return null;
            },
            obscureText: obsecured,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.security),
              suffixIcon: IconButton(
                icon: Icon(obsecured
                    ? Icons.remove_red_eye
                    : Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(() {
                    obsecured = !obsecured;
                  });
                },
              ),
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
