import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'dart:async';
import 'dart:convert';
import 'package:stock_k_chart_flutter/model/StockQuoteModel.dart';

class KStockOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
          future: getStockQuote(),
          builder:(BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return _StockQuoteView(snapshot.data);
            } else {
              return Text('Data is Null');
            }
          })
    );
  }
}

class _StockQuoteView extends StatelessWidget {
  final StockQuoteModel model;

  _StockQuoteView(this.model, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _SectionTitle(),
        _SectionPart(
            '今开', '最高', '昨收', '最低',
            model.open.toString(),
            model.high.toString(),
            model.settlement.toString(),
            model.low.toString()
        ),
        _SectionPart(
            '成交量', '52周最高', '成交额', '52周最低',
            _formatNumberToString(model.volume),
            model.max52.toString(),
            _formatNumberToString(model.amount),
            model.min52.toString()
        ),
        _SectionPart(
            '振幅', '换手率', '市盈率(动)', '市净率',
            model.changePercent.toString() + '%',
            model.turnOverRatio.toString(),
            model.pe_ttm.toString(),
            model.pb.toString()
        ),
        _SectionPart(
            '总市值', '流通市值', '总股本', '流通股本',
            _formatNumberToString(model.mktcap),
            _formatNumberToString(model.nmc),
            _formatNumberToString(model.totalCapital),
            _formatNumberToString(model.flowCapital)
        )
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 36,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text('行情数据',
            style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}

class _KeyText extends StatelessWidget {
  final String title;

  _KeyText(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text((title != null ? title : '-'),
      style: TextStyle(
          fontSize: 13,
          color: Color(0xFF666666)
      )
    );
  }
}

class _ValueText extends StatelessWidget {
  final String value;

  _ValueText(this.value, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text((value != null ? value : '-'),
      style: TextStyle(
          fontSize: 15,
          color: Color(0xFF333333),
          fontWeight: FontWeight.bold
      )
    );
  }
}

class _SectionPart extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;
  final String title4;
  final String value1;
  final String value2;
  final String value3;
  final String value4;

  _SectionPart(
      this.title1,
      this.title2,
      this.title3,
      this.title4,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      {Key key}
  ) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  height : 40.5,
                  padding: EdgeInsets.only(left: 15, top: 15, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _KeyText(title1),
                      _ValueText(value1)
                    ],
                  ),
                )
            ),
            Expanded(
                child: Container(
                  height : 40.5,
                  padding: EdgeInsets.only(left: 25, top: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _KeyText(title2),
                      _ValueText(value2)
                    ],
                  ),
                )
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  height : 40.5,
                  padding: EdgeInsets.only(left: 15, bottom: 15, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _KeyText(title3),
                      _ValueText(value3)
                    ],
                  ),
                )
            ),
            Expanded(
                child: Container(
                  height : 40.5,
                  padding: EdgeInsets.only(left: 25, bottom: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _KeyText(title4),
                      _ValueText(value4)
                    ],
                  ),
                )
            )
          ],
        ),
        Divider(
            height: 1,
            color: Color(0xFFE9E9E9)
        )
      ],
    );
  }
}

Future<StockQuoteModel> getStockQuote() async {
  final url = 'http://nujump.tigerobo.com/HB_Jumper/nu4o.ashx?type=ZCSFO&id=300059|sz&js=(x)';
  final response = await Http.get(url);

  StockQuoteModel model;

  if (response.statusCode == 200) {
    dynamic jsonObj = json.decode(response.body);
    model = StockQuoteModel.fromJson(jsonObj['quote']);
    return model;
  } else {
    throw Exception('========== >>>>> Failed to load post');
  }
}

String _formatNumberToString(double value) {
  if (value >= 100000000.0) {
    return (value / 100000000.0).toStringAsFixed(2) + '亿';
  } else if (value >= 10000.0) {
    return (value / 10000.0).toStringAsFixed(2) + '万';
  } else {
    return value.toString();
  }
}


