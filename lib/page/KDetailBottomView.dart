import 'package:flutter/material.dart';
import 'KStockOverview.dart';
import 'package:flutter/widgets.dart';

class KDetailBottomView extends StatefulWidget {
  @override
  _KDetailBottomViewState createState() => _KDetailBottomViewState();

//  static TabController of(BuildContext context) {
//    final _TabControllerScope scope = context.inheritFromWidgetOfExactType(_TabControllerScope);
//    return scope?.controller;
//  }
}

class _KDetailBottomViewState extends State<KDetailBottomView>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: '总览'),
    Tab(text: '资讯'),
    Tab(text: '公告'),
    Tab(text: '财务'),
    Tab(text: '简况')
  ];

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _statusBarHeight = MediaQuery.of(context).padding.top;
//    double _kLeadingWidth = kToolbarHeight;
    double screenHeight = MediaQuery.of(context).size.height;
    final double bottomContainerHeight = screenHeight - kToolbarHeight - _statusBarHeight;

        return Container(
          color: Colors.white,
          child: TabBar(
            controller: _controller,
            indicatorColor: Color(0xff1478F0),
            indicatorWeight: 3,
            unselectedLabelColor: Color(0xFF999999),
            labelColor: Color(0xFF333333),
            unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),
            labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
            labelPadding: EdgeInsets.symmetric(vertical: 5.0),
            indicatorPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: myTabs.map((Tab tab) {
              return Text(tab.text);
            }).toList(),
          ),
        );
  }
//  @override
//  Widget build(BuildContext context) {
//    return DefaultTabController(
//      length: myTabs.length,
//      initialIndex: 0,
//      child: Container(
////        height: 100,
//        child: Column(
//          children: <Widget>[
//            TabBar(
//              indicatorColor: Color(0xff1478F0),
//              indicatorWeight: 3,
//              unselectedLabelColor: Color(0xFF999999),
//              labelColor: Color(0xFF333333),
//              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),
//              labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
//              labelPadding: EdgeInsets.symmetric(vertical: 5.0),
//              indicatorPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
//              indicatorSize: TabBarIndicatorSize.label,
//              tabs: myTabs.map((Tab tab) {
//                return Text(tab.text);
//              }).toList(),
//            ),
//            Expanded(
//              child:TabBarView(
//                children: <Widget>[
//                  Container(
//                    height: 1000,
//                    child: KStockOverview()
//                  ),
//                  Text("2"),
//                  Text("3"),
//                  Text("4"),
//                  Text("5"),
//                ],
//              ) ,
//            )
//
//          ],
//        )
//      ) ,
//    );
//  }
}
