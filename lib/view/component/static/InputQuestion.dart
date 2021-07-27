import 'package:camtu_app/model/Input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputQuestion extends StatefulWidget {
  String value;

  InputQuestion(this.value);

  _InputQuestionState state;
  @override
  _InputQuestionState createState() {

    state= _InputQuestionState(this.value);
    return state;
  }
}

class _InputQuestionState extends State<InputQuestion> {
  TextEditingController _controller = TextEditingController();

  var _key = new GlobalKey<FormState>();
  String value;
  _InputQuestionState(this.value){
    _controller.text=value;
  }
  getText() {
    return _controller.text;
  }

  validate() {
    return _key.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: TextFormField(
          controller: _controller,
          maxLines: 5,
          decoration: new InputDecoration(
              alignLabelWithHint: true,
              fillColor: Colors.white,
              filled: true,
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey[700])),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey[700])),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey[700])),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey[700])),
              labelText: 'Tiêu đề câu hỏi',
              labelStyle: TextStyle(fontSize: 20, color: Colors.grey[700]),
              hintText: 'Nhập câu hỏi',
              hintStyle: TextStyle(fontSize: 18),
              contentPadding: const EdgeInsets.all(16.0)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Trường không được bỏ trống';
            }
            return null;
          }),
    );
  }
}
//
// class InputQuestion extends StatefulWidget {
//   final String value;
//
//   InputQuestion(this.value);
//   _InputQuestionState input;
//
//   @override
//   _InputQuestionState createState() {
//     input = _InputQuestionState(this.value);
//     return input;
//   }
// }
//
// class _InputQuestionState extends State<InputQuestion> {
//   TextEditingController _controller = TextEditingController();
//   var _key = new GlobalKey<FormState>();
//   String value;
//
//   _InputQuestionState(this.value){
//     _controller.text=value;
//   }
//
//   getText() {
//     return _controller.text;
//   }
//
//   validate() {
//     return _key.currentState.validate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _key,
//       child: TextFormField(
//           controller: _controller,
//           maxLines: 5,
//           decoration: new InputDecoration(
//               alignLabelWithHint: true,
//               fillColor: Colors.white,
//               filled: true,
//               focusedErrorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Colors.grey[700])),
//               errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Colors.grey[700])),
//               enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Colors.grey[700])),
//               focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Colors.grey[700])),
//               labelText: 'Tiêu đề câu hỏi',
//               labelStyle: TextStyle(fontSize: 20, color: Colors.grey[700]),
//               hintText: 'Nhập câu hỏi',
//               hintStyle: TextStyle(fontSize: 18),
//               contentPadding: const EdgeInsets.all(16.0)),
//           validator: (value) {
//             if (value.isEmpty) {
//               return 'Trường không được bỏ trống';
//             }
//             return null;
//           }),
//     );
//   }
// }
