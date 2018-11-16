import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'dart:async';
import 'dart:convert';
import 'package:stock_k_chart_flutter/model/StockModel.dart';

List stockList;

class HotIndustryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  getStockList();
                },
                color: Colors.blue)
          ],
          title: Text(
            '热门行业',
            style: TextStyle(color: Colors.black, fontSize: 18),
          )),
      body: Container(
          child: Column(
        children: <Widget>[
          RowHeaderFrame(),
          Expanded(
            child: FutureBuilder(
                future: getStockList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    print('#############');
                    print(snapshot);
                    stockList = snapshot.data;
                    return StockListView();
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          )
        ],
      )),
    );
  }
}

class RowHeaderFrame extends StatelessWidget {
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
            child: Text('行业名称',
                style: TextStyle(color: Color(0xFF999999), fontSize: 13)),
          ),
          Expanded(
              child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('涨跌幅',
                    style: TextStyle(color: Color(0xFF1478F0), fontSize: 13)),
                Icon(Icons.add, size: 16)
              ],
            ),
          )),
          Expanded(
            child: Text('领涨股',
                style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                textAlign: TextAlign.right),
          )
        ],
      ),
    );
  }
}

//主页要展示的内容
class StockListView extends StatefulWidget {
  @override
  ListState createState() => new ListState();
}

//得到一个ListView
class ListState extends State<StockListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.separated(
            itemCount: stockList.length,
            itemBuilder: buildItem,
            separatorBuilder: separatorBuilder));
  }

  //ListView的Item
  Widget buildItem(BuildContext context, int index) {
    StockModel model = stockList[index];
    return _StockCell(stock: model);
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return Divider(color: Color(0xFFEAEAEA), height: 0);
  }

  Widget stockCell() {
    return Container(
      color: Colors.white,
      height: 54,
      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text('黄金',
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 17,
                      fontWeight: FontWeight.bold))),
          Expanded(
            child: Text(
              '+2.73%',
              style: TextStyle(color: Color(0xFFC13333), fontSize: 18),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
              child: Text(
            '刚泰控股',
            style: TextStyle(color: Color(0xFF333333), fontSize: 17),
            textAlign: TextAlign.right,
          ))
        ],
      ),
    );
  }
}

class _StockCell extends StatelessWidget {
  _StockCell({Key key, this.stock}) : super(key: key);
  final StockModel stock;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 54,
      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text(this.stock.name,
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 17,
                      fontWeight: FontWeight.bold))),
          Expanded(
            child: Text((double.parse(this.stock.changePercentLD) > 0 ? '+' : '') + this.stock.changePercentLD + '%',
              style: TextStyle(color: Color(0xFFC13333), fontSize: 18),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
              child: Text(this.stock.nameLD,
                style: TextStyle(color: Color(0xFF333333), fontSize: 17),
                textAlign: TextAlign.right,
              ))
        ],
      ),
    );
  }
}

Future<List> getStockList() async {
  final url = 'http://nujump.tigerobo.com/HB_Jumper/nu.ashx?cmd=C._BKHY&sty=S360SHYLU&st=c&sic=-1,1,10&flt=transhb&cb=';
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
