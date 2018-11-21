import 'package:flutter/material.dart';
import 'KStockOverview.dart';

class KDetailBottomView extends StatefulWidget {
  @override
  _KDetailBottomViewState createState() => _KDetailBottomViewState();
}

class _KDetailBottomViewState extends State<KDetailBottomView> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: '总览'),
    Tab(text: '资讯'),
    Tab(text: '公告'),
    Tab(text: '财务'),
    Tab(text: '简况')
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      initialIndex: 0,
      child: Container(
//        height: 100,
        child: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: Color(0xff1478F0),
              indicatorWeight: 3,
              unselectedLabelColor: Color(0xFF999999),
              labelColor: Color(0xFF333333),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),
              labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
              labelPadding: EdgeInsets.symmetric(vertical: 5.0),
              indicatorPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: myTabs.map((Tab tab) {
                return Text(tab.text);
              }).toList(),
            ),
            Expanded(
              child:TabBarView(
                children: <Widget>[
                  Container(
                    height: 1000,
                    child: KStockOverview()
                  ),
                  Text("2"),
                  Text("3"),
                  Text("4"),
                  Text("5"),
                ],
              ) ,
            )

          ],
        )
      ) ,
    );
  }
}

