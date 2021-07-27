import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
class InputNumberCount extends StatefulWidget {
_InputNumberCountState input;
  @override
  _InputNumberCountState createState(){
    return input=new _InputNumberCountState();
  }
  getNumber(){
    return input.getNumber();
  }
}

class _InputNumberCountState extends State<InputNumberCount> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "1"; // Setting the initial value for the field.
  }
getNumber(){
    return this._controller.text;
}
  @override
  Widget build(BuildContext context) {
    return
    Container(
      margin: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Divider(height: 1,color: Colors.grey[500]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Số lượng câu hỏi:',style: TextStyle(
                fontSize: 16,color: Colors.grey[700]
              ),),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 100.0,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey[400],
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          controller: _controller,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: false,
                            signed: true,
                          ),

                        ),
                      ),
                      Container(
                        height: 38.0,
                        width: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: InkWell(
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 18.0,
                                ),
                                onTap: () {
                                  int currentValue = int.parse(_controller.text);
                                  setState(() {
                                    currentValue++;
                                    _controller.text = (currentValue)
                                        .toString(); // incrementing value
                                  });
                                },
                              ),
                            ),
                            InkWell(
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 18.0,
                              ),
                              onTap: () {
                                int currentValue = int.parse(_controller.text);
                                setState(() {
                                  print("Setting state");
                                  currentValue--;
                                  _controller.text =
                                      (currentValue >1? currentValue : 1)
                                          .toString(); // decrementing value
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),Divider(height: 1,color: Colors.grey[500],)
        ],
      ),
    )
     ;
  }
}
