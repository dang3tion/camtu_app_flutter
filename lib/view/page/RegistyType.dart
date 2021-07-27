import 'package:camtu_app/view/page/Registy.dart';
import 'package:flutter/material.dart';

class TypeUser extends StatelessWidget {
  const TypeUser();

  Widget createButton(String text, Icon icon, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        height: 60,
        child: RaisedButton.icon(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Color(0xffFF00A5A5), width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10)),
          color: Color(0xffFF00E5E5),
          onPressed: () {
            if(text=='Học sinh'){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistryPage(true)));
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistryPage(false)));
            }
          },
          label: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          icon: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[500],
        title: Text('Đăng ký'),
      ),
      body: Center(
        child: Transform.translate(
          offset: Offset(0, -60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  'Chọn loại tài khoản phù hợp dành cho bạn!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              createButton(
                  "Học sinh",
                  Icon(Icons.menu_book, size: 30, color: Colors.cyan[800]),
                  context),
              createButton(
                  "Giáo viên",
                  Icon(Icons.work_rounded, size: 30, color: Colors.cyan[800]),
                  context),
            ],
          ),
        ),
      ),
    );
  }
}
