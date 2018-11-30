import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'KChartPage.dart';
import 'KChartForDetailPage.dart';
import 'KDetailBottomView.dart';

import 'package:flutter/rendering.dart';
import 'KStockOverview.dart';
import 'SliverTickProvider.dart';
import 'package:stock_k_chart_flutter/model/StockQuoteModel.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

//class StockDetail {
//  StockDetail(this.stockCode, this.mkt, this.stockName, {this.currentPrice});
//
//  final String stockCode;
//  final String stockName;
//  final String mkt;
//
//  double currentPrice;
//}

class StockDetailPageWidget extends StatefulWidget {
  StockDetailPageWidget(
      this.stockCode, this.mkt, this.stockName, {this.currentPrice}
  ) : super() {
    {
      this.stockModel = StockQuoteModel(
          stockCode: stockCode,
          stockName: stockName,
          exchange: mkt,
          trade: currentPrice
      );
    }
  }

  final String stockCode;
  final String stockName;
  final String mkt;

  double currentPrice;

//  final StockDetail stockDetail;

  StockQuoteModel stockModel;

  @override
  StockDetailPage createState() => StockDetailPage();
}

class StockDetailPage extends State<StockDetailPageWidget> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: '总览'),
    Tab(text: '资讯'),
    Tab(text: '公告'),
    Tab(text: '财务'),
    Tab(text: '简况')
  ];

  @override
  void initState() {
    super.initState();
    getStockQuote(widget.stockCode, widget.mkt);
  }

  void getStockQuote(String code, String mkt) {
    final url =
        'http://nujump.tigerobo.com/HB_Jumper/nu4o.ashx?type=ZCSFO&id=$code|$mkt&js=(x)';
    Http.get(url).then((response) {
      dynamic jsonObj = json.decode(response.body);
      StockQuoteModel model = StockQuoteModel.fromJson(jsonObj['quote']);
      setState(() {
        widget.stockModel = model;
        print(model.trade.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.stockModel.stockName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.black),
            ),
            Text("${widget.stockModel.stockCode}.${widget.stockModel.exchange}",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 11.0,
                    color: Color(0xFF999999))),
          ],
        ),
      ),
      body: DefaultTabController(
          length: myTabs.length, // This is the number of tabs.
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
//                  SliverOverlapAbsorber(
//                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                        context),
//                    child:
                  SliverPersistentHeader(
                    delegate: _SliverTopDelegate(Column(
                      children: <Widget>[
                        StockValueFrame(widget.stockModel),
                        Container(
                          child: KChartDetailPageWidget(),
                          width: screenW,
                        ),
                      ],
                    )),
                    pinned: true,
                  ),
//                  ),
//                  SliverOverlapAbsorber(
//                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                          context),
//                      child:
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(TabBar(
                      indicatorColor: Color(0xff1478F0),
                      indicatorWeight: 3,
                      unselectedLabelColor: Color(0xFF999999),
                      labelColor: Color(0xFF333333),
                      unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15.0),
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                      labelPadding: EdgeInsets.symmetric(vertical: 5.0),
                      indicatorPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(text: '总览'),
                        Tab(text: '资讯'),
                        Tab(text: '公告'),
                        Tab(text: '财务'),
                        Tab(text: '简况')
                      ],
                    )),
                    pinned: true,
//                      )
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  KStockOverview(widget.stockModel),
//            Text("999992"),
//            Text("3"),
//            Text("4"),
//            Text("5"),
                ],
              ))),
    );
  }

  Widget _buildBottomView(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      Tab(text: '总览'),
      Tab(text: '资讯'),
      Tab(text: '公告'),
      Tab(text: '财务'),
      Tab(text: '简况')
    ];

    TabController _controller = TabController(
        vsync: SliverTickProvider(), length: myTabs.length, initialIndex: 0);
    Widget tabBar = TabBar(
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
    );

    Widget tabBarView = TabBarView(
      controller: _controller,
      children: <Widget>[
//        Container(height: 1000, child: KStockOverview()),
        Text("2"),
        Text("3"),
        Text("4"),
        Text("5"),
      ],
    );

//    return SliverStickyHeader(
//        header: tabBar,
//        sliver: SliverToBoxAdapter(
//            child: Container(
//          child: tabBarView,
//          height: 1000,
//        )));
  }
}

class StockValueFrame extends StatelessWidget {
  StockValueFrame(this.model) : super();

  final StockQuoteModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KChartPage()),
          );
        },
        child: new Padding(
            padding: new EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Text(model.exchange,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Color(0xffC13333))),
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
                      child: Text(
                          model != null && model.trade != null
                              ? model.trade.toString()
                              : "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36.0,
                              color: Color(0xffC13333))),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.up,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("${model.changePercent}%",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                color: Color(0xffC13333))),
                        Text(
                            model != null &&
                                    model.trade != null &&
                                    model.settlement != null
                                ? (model.trade - model.settlement)
                                    .toStringAsFixed(2)
                                : "",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                color: Color(0xffC13333))),
                      ],
                    ),
                  ],
                ),
                Text(
                    model != null
                        ? "${model.tradeStatus()}，${model.updateTime}"
                        : "",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 11.0,
                        color: Color(0xff999999))),
              ],
            )));
  }
}

class _SliverTopDelegate extends SliverPersistentHeaderDelegate {
  _SliverTopDelegate(this._widget);

  final Widget _widget;

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 300;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (maxExtent - shrinkOffset > 0) {
      return ClipRect(
          child: Stack(children: <Widget>[
        Positioned(
          top: -shrinkOffset,
          child: _widget,
        )
      ]));
    } else {
      return ClipRect();
    }
  }

  @override
  bool shouldRebuild(_SliverTopDelegate oldDelegate) {
    return true;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
