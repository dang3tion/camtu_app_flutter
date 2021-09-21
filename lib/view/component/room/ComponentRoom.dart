import 'package:camtu_app/model/Room.dart';
import 'package:camtu_app/view/page/room/SystemRoomPage.dart';
import 'package:flutter/material.dart';

class ComponentRoom extends StatefulWidget {
  final Room room;

  ComponentRoom(this.room);

  @override
  _ComponentRoomState createState() => _ComponentRoomState(room);
}

class _ComponentRoomState extends State<ComponentRoom> {
  Room room;

  _ComponentRoomState(this.room);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SystemRoomPage(room)));
        },
        child: Card(
          child: SizedBox(
            height: 70,
            child: Center(
              child: ListTile(
                  title: Text(
                    room.nameRoom ?? 'row',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: ColorFiltered(
                        child: Image.network(
                            'https://www.maxpixel.net/static/photo/1x/Social-Group-Symbol-Icon-Community-Sociale-4399681.png'),
                        colorFilter: ColorFilter.mode(
                            Colors.blueAccent, BlendMode.color),
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text('Chi tiết Room'),
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text('Tên Room'),
                                      subtitle: Text(
                                        room.nameRoom,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                    ),
                                    ListTile(
                                      title: Text('Mã Room'),
                                      subtitle: Text(
                                        room.idRoom,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                    ),
                                    ListTile(
                                      title: Text('Người tạo'),
                                      subtitle: Text(
                                        room.userName,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                    ),
                                    ListTile(
                                      title: Text('Ngày tạo'),
                                      subtitle: Text(
                                        room.time,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                Divider(
                                  height: 2,
                                  color: Colors.grey[500],
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('Ok'),
                                  elevation: 10,
                                )
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.more_vert_rounded),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        padding: EdgeInsets.all(10),
                        child: Container(child: Text('Chi tiết')),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
// Container(
// width: MediaQuery.of(context).size.width*0.75,
// child: Column(
// mainAxisSize: MainAxisSize.min,
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// Container(
// margin: EdgeInsets.symmetric(
// vertical: 5),
// child: Text(
// 'Tên Room: ' + room.nameRoom)),
// Container(
// margin: EdgeInsets.symmetric(
// vertical: 5),
// child:
// Text('Mã room: ' + room.idRoom)),
// Container(
// margin: EdgeInsets.symmetric(
// vertical: 5),
// child: Text(
// 'Thời gian tạo: ' + room.time)),
// Container(
// margin: EdgeInsets.symmetric(
// vertical: 5),
// child: Text(
// 'Người tạo: ' + room.userId)),
// ],
// ),
// ),
