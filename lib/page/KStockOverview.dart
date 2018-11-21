import 'package:flutter/material.dart';

class KStockOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _SectionTitle(),
          _SectionPart()
        ],
      ),
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
    return Text(title,
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
    return Text(value,
      style: TextStyle(
          fontSize: 15,
          color: Color(0xFF333333),
          fontWeight: FontWeight.bold
      )
    );
  }
}

class _SectionPart extends StatelessWidget {

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
                  padding: EdgeInsets.only(left: 15,top: 15, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _KeyText('今开'),
                      _ValueText('222.3')
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
                      _KeyText('最高'),
                      _ValueText('222.3')
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
                      _KeyText('昨收'),
                      _ValueText('222.3')
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
                      _KeyText('最低'),
                      _ValueText('222.3')
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


