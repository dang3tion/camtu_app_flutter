import 'package:camtu_app/model/Quote.dart';
import 'package:camtu_app/model/Turple.dart';
import 'package:camtu_app/model/UserAccount.dart';
import 'package:camtu_app/view/component/static/Loading.dart';
import 'package:camtu_app/view/component/turple/CompareQuoteComponent.dart';
import 'package:camtu_app/view/component/turple/CreatingQuoteComponent.dart';
import 'package:camtu_app/view/component/turple/ImplementQuoteComponent.dart';
import 'package:camtu_app/view/component/static/Dialog.dart';
import 'package:camtu_app/view/services/QuoteServices.dart';
import 'package:camtu_app/view/services/RoomServices.dart';
import 'package:flutter/material.dart';

class QuotePage extends StatefulWidget {
  final Turple turple;
  final UserAccount user;
  final bool type;

  QuotePage(this.turple, this.user, this.type);

  @override
  _QuotePageState createState() =>
      _QuotePageState(this.turple, this.user, this.type);
}

class _QuotePageState extends State<QuotePage>
    with SingleTickerProviderStateMixin {
  Turple turple;
  UserAccount user;
  List<Widget> listTab = [];
  List<CreatingQuoteComponents> listCreate = [];
  List<ImplementQuote> listImpl = [];
  List<Quote> listImpl2 = [];
  TabController _tabController;
  bool type;

  _QuotePageState(this.turple, this.user, this.type) {
    //create tab
    for (var i = 0; i < this.turple.number; i++) {
      listTab.add(Container(
        width: 80,
        child: Tab(
          text: 'Câu ${i + 1}',
        ),
      ));
    }
    //
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: this.turple.number);
  }

  @override
  Widget build(BuildContext context) {
    RoomServices()
        .getQuote(this.turple.id, this.turple.roomId, this.user.phoneNo)
        .listen((event) {
      listImpl2 = [];
      event.forEach((element) {
        element.listen((quo) {
          listImpl2.add(quo);
        });
      });
    });
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(this.turple.name),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelStyle: TextStyle(fontSize: 15),
            isScrollable: true,
            tabs: listTab,
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFFA0C9FF), Color(0xffFFD3F9FF)])),
          child: this.user.typeUser
              ? this.turple.isDeadLine()
                  ? StreamBuilder<List<Quote>>(
                      stream: QuoteServices().getListQuote(this.turple.id),
                      builder: (ctx, mainQuote) {
                        if (mainQuote.hasError ||
                            mainQuote.connectionState ==
                                ConnectionState.waiting) {
                          return LoadingWidget();
                        }
                        return StreamBuilder<List<Quote>>(
                            stream: RoomServices().getQuoteUser(
                                this.turple.roomId,
                                this.turple.id,
                                this.user.phoneNo),
                            builder: (ctx, quote) {
                              if (quote.hasError ||
                                  quote.connectionState ==
                                      ConnectionState.waiting) {
                                return LoadingWidget();
                              }
                              List<Widget> listCompare = [];

                              for (var i = 0; i < mainQuote.data.length; i++) {
                                for (var j = 0; j < quote.data.length; j++) {
                                  if (mainQuote.data[i].id ==
                                      quote.data[j].id) {
                                    listCompare.add(CompareQuoteComponent(
                                        quote.data[j], mainQuote.data[i]));
                                    break;
                                  }
                                }
                              }
                              return TabBarView(
                                children: listCompare,
                                controller: _tabController,
                              );
                            });
                      })
                  : StreamBuilder<List<Stream<Quote>>>(
                      stream: RoomServices().getQuote(this.turple.id,
                          this.turple.roomId, this.user.phoneNo),
                      builder: (context, snapshot) {
                        if (snapshot.hasError ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return LoadingWidget();
                        }

                        listImpl = [];
                        List<Widget> stream = snapshot.data.map((e) {
                          return StreamBuilder<Quote>(
                              stream: e,
                              builder: (ctx, snap) {
                                if (snap.data == null ||
                                    snapshot.hasError ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return LoadingWidget();
                                }
                                ImplementQuote im =
                                    ImplementQuote(snap.data, this.type);
                                im.createState();
                                listImpl.add(im);
                                return im;
                              });
                        }).toList();
                        return TabBarView(
                          children: stream,
                          controller: _tabController,
                        );
                      })
              : StreamBuilder<List<Quote>>(
                  stream: QuoteServices().getListQuote(this.turple.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingWidget();
                    }
                    listCreate = [];
                    for (var i = 0; i < snapshot.data.length; i++) {
                      CreatingQuoteComponents c =
                          CreatingQuoteComponents(snapshot.data[i]);
                      c.createState();
                      listCreate.add(c);
                    }
                    return TabBarView(
                      children: listCreate,
                      controller: _tabController,
                    );
                  }),
        ),
        floatingActionButton: !this.type && this.user.typeUser
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: this.turple.state == 'complete' && !this.user.typeUser
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            heroTag: 'AddQuote',
                            label: Text('Lưu lại'),
                            icon: Icon(Icons.save),
                            onPressed: () async {
                              ShowDialog().showDialogWidget(
                                  context,
                                  'Xác nhận lưu lại',
                                  "Lưu lại thông tin thay đổi?", () {
                                if (this.user.typeUser) {
                                  RoomServices()
                                      .saveQuote(
                                          this.turple.roomId,
                                          this.turple.id,
                                          listImpl.map<Quote>((e) {
                                            return e.state.getQuote();
                                          }).toList(),
                                          false)
                                      .then((value) {
                                    if (value) {
                                      ShowDialog().showToast(
                                          'Lưu lại thành công', context);
                                    } else {
                                      ShowDialog().showToast(
                                          "Có lỗi xảy ra, vui lòng thử lại",
                                          context);
                                    }
                                  });
                                } else {
                                  QuoteServices()
                                      .saveListQuote(
                                          this.turple.id,
                                          listCreate.map((e) {
                                            return e.state.getQuote();
                                          }).toList())
                                      .then((value) {
                                    if (value) {
                                      ShowDialog().showToast(
                                          'Lưu lại thành công', context);
                                    } else {
                                      ShowDialog().showToast(
                                          "Có lỗi xảy ra, vui lòng thử lại",
                                          context);
                                    }
                                  });
                                }
                              });
                            },
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            heroTag: 'AddQuote',
                            label: Text(this.user.typeUser
                                ? 'Nộp bài'
                                : 'Giao bài tập'),
                            icon: Icon(Icons.book_outlined),
                            onPressed: () {
                              if (this.user.typeUser) {
                                ShowDialog().showDialogWidget(
                                    context,
                                    'confirm',
                                    'Bạn có muốn thực hiện nộp bài tập, sau khi nộp không thể chỉnh sửa?',
                                    () {
                                  if (validateIml()) {
                                    //   RoomServices()
                                    //       .saveQuote(
                                    //           this.turple.roomId,
                                    //           this.turple.id,
                                    //           listImpl.map<Quote>((e) {
                                    //             return e.state.getQuote();
                                    //           }).toList(),
                                    //           false)
                                    //       .then((value) {
                                    //     if (value) {
                                    //       print(this.turple.id);
                                    //       print(this.turple.roomId);
                                    //       RoomServices()
                                    //           .setStateTurpleUser(
                                    //               this.turple.roomId,
                                    //               this.user.phoneNo,
                                    //               this.turple.id,
                                    //               'complete')
                                    //           .then((value) {
                                    //         if (value) {
                                    //           Navigator.of(context).pop();
                                    //           ShowDialog().showToast(
                                    //               "Nộp bài thành công", context);
                                    //         } else {
                                    //           ShowDialog().showToast(
                                    //               "Có lỗi xảy ra vui lòng thử lại",
                                    //               context);
                                    //         }
                                    //       });
                                    //     } else {
                                    //       ShowDialog().showToast(
                                    //           "Có lỗi xảy ra, vui lòng thử lại",
                                    //           context);
                                    //     }
                                    //   });
                                  }
                                });
                              } else {
                                ShowDialog().showDialogWidget(
                                    context,
                                    'confirm',
                                    'Bạn có muốn thực hiện giao bài tập?', () {
                                  if (validate()) {
                                    QuoteServices()
                                        .saveListQuote(
                                            this.turple.id,
                                            listCreate.map((e) {
                                              return e.state.getQuote();
                                            }).toList())
                                        .then((value) {
                                      if (value) {
                                        RoomServices()
                                            .setStateTurple(this.turple.id,
                                                this.turple.roomId, "complete")
                                            .then((value) {
                                          if (value) {
                                            RoomServices().saveQuote(
                                                this.turple.roomId,
                                                this.turple.id,
                                                listCreate.map((e) {
                                                  return e.state.getQuote();
                                                }).toList(),
                                                true);
                                            Navigator.of(context).pop();
                                            ShowDialog().showToast(
                                                'Bài tập đã được giao',
                                                context);
                                          } else {
                                            ShowDialog().showToast(
                                                'Có lỗi phát sinh vui lòng thử lại',
                                                context);
                                          }
                                        });
                                      } else {
                                        ShowDialog().showToast(
                                            'Có lỗi phát sinh vui lòng thử lại',
                                            context);
                                      }
                                    });
                                  }
                                });
                              }
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FloatingActionButton.extended(
                            heroTag: 'AddQuote',
                            label: Text('Lưu lại'),
                            icon: Icon(Icons.save),
                            onPressed: () async {
                              ShowDialog().showDialogWidget(
                                  context,
                                  'Xác nhận lưu lại',
                                  "Lưu lại thông tin thay đổi?", () {
                                if (this.user.typeUser) {
                                  RoomServices()
                                      .saveQuote(
                                          this.turple.roomId,
                                          this.turple.id,
                                          listImpl.map<Quote>((e) {
                                            return e.state.getQuote();
                                          }).toList(),
                                          false)
                                      .then((value) {
                                    if (value) {
                                      ShowDialog().showToast(
                                          'Lưu lại thành công', context);
                                    } else {
                                      ShowDialog().showToast(
                                          "Có lỗi xảy ra, vui lòng thử lại",
                                          context);
                                    }
                                  });
                                } else {
                                  QuoteServices()
                                      .saveListQuote(
                                          this.turple.id,
                                          listCreate.map((e) {
                                            return e.state.getQuote();
                                          }).toList())
                                      .then((value) {
                                    if (value) {
                                      ShowDialog().showToast(
                                          'Lưu lại thành công', context);
                                    } else {
                                      ShowDialog().showToast(
                                          "Có lỗi xảy ra, vui lòng thử lại",
                                          context);
                                    }
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
              ),
      ),
    );
  }

  initTab(index) async {
    this._tabController.animateTo(index);
    await Future.delayed(Duration(milliseconds: 50));
  }

  validateQuestion(index) {
    return listCreate[index].state.getQuote().question.isNotEmpty;
  }

  validateAnwser(index) {
    for (var i = 0;
        i < listCreate[index].state.getQuote().answers.length;
        i++) {
      if (listCreate[index].state.getQuote().answers[i].isEmpty) {
        return false;
      }
    }
    return true;
  }

  validate() {
    for (var i = 0; i < listCreate.length; i++) {
      if (!validateAnwser(i) || !validateQuestion(i)) {
        initTab(i);
        ShowDialog().showToast("Nhập đầy đủ các trường thông tin", context);
        return false;
      }
    }
    return true;
  }

  validateQuoteAnswer(Quote quote) {
    if (quote.index == -1) {
      return false;
    }
    return true;
  }

  validateIml() {
    List<int> rememberIndex=[];
      for (var i = 0; i < listImpl2.length; i++) {
        var check = false;
        for (var j = 0; j < listImpl.length; j++) {
          if (listImpl[j].state.getQuote().id == listImpl2[i].id) {
            check = true;
            if (!validateQuoteAnswer(listImpl[j].state.getQuote())) {
              initTab(i);
              ShowDialog()
                  .showToast("Bạn chưa chọn đáp án cho câu này", context);
              return false;
            } else {
              break;
            }
          }
        }
        if (!check && !validateQuoteAnswer(listImpl2[i])) {
          initTab(i);
          ShowDialog().showToast("Bạn chưa chọn đáp án cho câu này", context);
          return false;
        }
      }
    return true;
  }
}
