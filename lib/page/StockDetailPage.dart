import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'KChartPage.dart';
import 'KChartForDetailPage.dart';
import 'KDetailBottomView.dart';

class StockDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            const Text(
              "腾讯控股",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.black),
            ),
            const Text("00700.HK",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 11.0,
                    color: Color(0xFF999999))),
          ],
        ),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            StockValueFrame(),
            KChartDetailPageWidget(),
            KDetailBottomView()
          ],
        ),
      ),
    );
  }
}

class StockValueFrame extends StatelessWidget {
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
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: const Text("HK\$",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Color(0xffC13333))),
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
                      child: const Text("254.34",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36.0,
                              color: Color(0xffC13333))),
                    ),
                    Column(
                      verticalDirection: VerticalDirection.up,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Text("+10%",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                color: Color(0xffC13333))),
                        const Text("+43.0",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                color: Color(0xffC13333))),
                      ],
                    ),
                  ],
                ),
                const Text("已收盘，09-18 08:00 HKT",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 11.0,
                        color: Color(0xff999999))),
              ],
            )));
  }
}
