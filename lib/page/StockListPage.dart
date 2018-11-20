import 'package:flutter/material.dart';
import 'package:stock_k_chart_flutter/model/StockModel.dart';
import 'package:http/http.dart' as Http;
import 'dart:async';
import 'dart:convert';
import 'package:stock_k_chart_flutter/componets/TYStockValueText.dart';

List stockList = [];

class StockListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('涨幅榜',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StockRowHeaderFrame(),
            Expanded(
              child: FutureBuilder(
                  future: getStockList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                      stockList = snapshot.data;
                      return StockListView();
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            )
          ],
        ),
      ),
    );
  }
}

class StockRowHeaderFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 34,
      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text('股票名称',
                style: TextStyle(color: Color(0xFF999999), fontSize: 13)
            ),
          ),
          Expanded(
            child: Text('最新价',
              style: TextStyle(color: Color(0xFF999999), fontSize: 13),
              textAlign: TextAlign.right
            ),
          ),
          Expanded(
            child: Text('涨跌幅',
                style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                textAlign: TextAlign.right
            ),
          )
        ],
      ),
    );
  }
}


class StockListView extends StatefulWidget {
  @override
  ListState createState() => new ListState();
}

//得到一个ListView
class ListState extends State<StockListView> {
  @override
  Widget build(BuildContext context) {
    var length = stockList.length;
    return Container(
        child: ListView.separated(
            itemCount: length,
            itemBuilder: buildItem,
            separatorBuilder: separatorBuilder));
  }

  //ListView的Item
  Widget buildItem(BuildContext context, int index) {
    StockModel model = stockList[index];
    return StockCell(stock: model);
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return Divider(color: Color(0xFFEAEAEA), height: 0);
  }
}

class StockCell extends StatelessWidget {
  StockCell({Key key, this.stock}) : super(key: key);
  final StockModel stock;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 71,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(this.stock.name,
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TypeImage(
                          this.stock.mktType
                        ),
                        Text(this.stock.code,
                            style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 13,
                                fontWeight: FontWeight.normal
                            ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    )
                  ],
                ),
              )
          ),
          Expanded(
            child: Text(this.stock.close,
              style: TextStyle(color: Color(0xFF333333), fontSize: 18),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TYStockValueText(this.stock.changePercent,
                      true,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    TYStockValueText(this.stock.change,
                      false,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.right
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}

Future<List> getStockList() async {
  final url = 'http://nujump.tigerobo.com/HB_Jumper/nu.ashx?cmd=C.BK07321&sty=ACOSFDTA&st=c&sic=-1,1,10&flt=transhb&cb=';
  final response = await Http.get(url);

  List returnList = [];

  if (response.statusCode == 200) {
    List respList = json.decode(response.body);
    respList.forEach((m) {
      StockModel stockModel = StockModel.fromJson(m);
      returnList.add(stockModel);
      print(stockModel.name);
    });
    return returnList;
  } else {
    throw Exception('========== >>>>> Failed to load post');
  }
}

class TypeImage extends StatelessWidget {
  final String type;
  TypeImage(this.type, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    AssetImage assetImage;

    if (type == 'HK') {
      assetImage = AssetImage('images/general_US_logo@3x.png');
    } else if (type == 'SH') {
      assetImage = AssetImage('images/general_SH_logo@3x.png');
    } else if (type == 'SZ') {
      assetImage = AssetImage('images/general_SZ_logo@3x.png');
    } else if (type != null && type != '') {
      assetImage = AssetImage('images/general_US_logo@3x.png');
    }
    return Image(
      image: assetImage,
      width: 18,
    );
  }
}
