import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowDialog  {
  showDialogWidget(context,confirm,message,function) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(confirm),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              message,
              textAlign: TextAlign.justify,
            ),
          ),
          actions: [
            Divider(
              height: 2,
              color: Colors.grey[500],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  color: Color(0xffFF00E5E5),
                  onPressed: (){  Navigator.of(context).pop();
                    function();

    },
                    child: Text(
                    'Xác nhận',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  color: Colors.grey[300],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Hủy'),
                )
              ],
            ),
          ],
        ));
  }
  showToast(message,context){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text(
          message),
    ));
  }
}
