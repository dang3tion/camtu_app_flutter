import 'package:camtu_app/model/Input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class InputAnswer extends StatefulWidget {
  int index;
  String value;

  InputAnswer(this.index, this.value);
  _InputAnswerState state;
  @override
  _InputAnswerState createState(){
    state=new _InputAnswerState(this.index,this.value);
    return state;
  }
}

class _InputAnswerState extends State<InputAnswer> {
  var _key = new GlobalKey<FormState>();

  TextEditingController _controller = new TextEditingController();
  int index;
  String value;

  _InputAnswerState(this.index,this.value){
    _controller.text=this.value;
  }
  getIndex() {
    return this.widget.index;
  }

  getText() {
    return this._controller.text;
  }

  validate() {
    return this._key.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Form(
        key: _key,
        child: Container(
          child: TextFormField(
            controller: _controller,
            maxLines: 1,
            decoration: new InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(width: 0)),
                focusedBorder:
                UnderlineInputBorder(borderSide: BorderSide(width: 0)),
                hintText: 'Nhập câu trả lời',
                labelStyle: TextStyle(fontSize: 17, color: Colors.blue),
                hintStyle: TextStyle(fontSize: 18),
                contentPadding: const EdgeInsets.all(16.0)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Trường không được bỏ trống';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
//
// class InputAnswer extends StatefulWidget {
//   final int index;
//   final String value;
//
//   InputAnswer(this.index, this.value);
//
//   _InputAnswerState inputAnswerState;
//
//   @override
//   _InputAnswerState createState() {
//     inputAnswerState = _InputAnswerState(this.index, this.value);
//     return inputAnswerState;
//   }
//
//   String getText() {
//     return this.inputAnswerState.getText();
//   }
//
//   validate() {
//     return this.inputAnswerState.validate();
//   }
// }
//
// class _InputAnswerState extends State<InputAnswer> {
//   var _key = new GlobalKey<FormState>();
//   TextEditingController _controller = new TextEditingController();
//   int index;
//   String value;
//
//   _InputAnswerState(this.index, this.value){
//     _controller.text=value;
//   }
//
//   getIndex() {
//     return this.index;
//   }
//
//   getText() {
//     return this._controller.text;
//   }
//
//   validate() {
//     return this._key.currentState.validate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Form(
//         key: _key,
//         child: Container(
//           child: TextFormField(
//             controller: _controller,
//             maxLines: 1,
//             decoration: new InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 enabledBorder:
//                     UnderlineInputBorder(borderSide: BorderSide(width: 0)),
//                 focusedBorder:
//                     UnderlineInputBorder(borderSide: BorderSide(width: 0)),
//                 hintText: 'Nhập câu trả lời',
//                 labelStyle: TextStyle(fontSize: 17, color: Colors.blue),
//                 hintStyle: TextStyle(fontSize: 18),
//                 contentPadding: const EdgeInsets.all(16.0)),
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Trường không được bỏ trống';
//               }
//               return null;
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
