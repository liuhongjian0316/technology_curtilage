import 'package:flutter/material.dart';
import 'package:technology_curtilage/views/publish/publish.dart';
import 'navigation_icon_view.dart';
import '../global_config.dart';
import 'package:technology_curtilage/views/home/home_page.dart';
import 'package:technology_curtilage/views/idea/idea_page.dart';
import 'package:technology_curtilage/views/market/market_page.dart';
import 'package:technology_curtilage/views/notice/notice_page.dart';
import 'package:technology_curtilage/views/my/my_page.dart';

class Index extends StatefulWidget {

  @override
  State<Index> createState() => new _IndexState();
}

class _IndexState extends State<Index> with TickerProviderStateMixin{

  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: new Icon(Icons.assignment),
        title: new Text("首页"),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.all_inclusive),
        title: new Text("想法"),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.add),
        title: new Text("发布"),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.add_alert),
        title: new Text("通知"),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.perm_identity),
        title: new Text("我的"),
        vsync: this,
      ),
    ];
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _pageList = <StatefulWidget>[
      new HomePage(),
      new IdeaPage(),
      new PublishPage(),
      new NoticePage(),
      new MyPage()
    ];
    _currentPage = _pageList[_currentIndex];
  }

  void _rebuild() {
    setState((){});
  }

  @override
  void dispose() {
    super.dispose();
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) => navigationIconView.item)
            .toList(),
      currentIndex: _currentIndex,
      fixedColor: Colors.blue,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
          if(index  != 2){
            setState((){
              _navigationViews[_currentIndex].controller.reverse();
              _currentIndex = index;
              _navigationViews[_currentIndex].controller.forward();
              _currentPage = _pageList[_currentIndex];
            });
          }else{
            //发布触发事件
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                elevation: 20.0,
                isScrollControlled: true,
                builder: (BuildContext bc) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: 25.0,
                        width: double.infinity,
                        color: Colors.black54,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            )),
                      ),
                      Container(
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding:
                          EdgeInsets.only(top: 33.0, bottom: 33.0),
                          child: new Row(
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new Icon(Icons.keyboard_arrow_down),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    //头像半径
                                    radius: 10,
                                    //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                                    backgroundImage: NetworkImage(
                                        'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'
                                    ),
                                  ),
                                  new Text('   '),
                                  new Text('今天是你加入技术宅的第929天')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
      }
    );

    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
            child: _currentPage
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
      theme: GlobalConfig.themeData
    );
  }

}