import 'package:flutter/material.dart';

class TYStockValueText extends StatelessWidget {
  final Color _redColor = Color(0xFFC13333);
  final Color _greenColor = Color(0xFF147A45);
  final Color _grayColor = Color(0xFF999999);

  final String data;
  final bool isPer;
  final TextStyle style;
  final TextAlign textAlign;

  TYStockValueText(this.data, this.isPer, {
    Key key,
    this.style,
    this.textAlign
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    Color displayColor;
    String displayString = '';
    if (data != null) {
      var value = double.parse(data);
      if (value > 0) {
        displayColor = this._redColor;
        displayString = '+' + data;
      }
      if (value < 0) {
        displayColor = this._greenColor;
        displayString = data;
      }
      if (value == 0) {
        displayColor = this._grayColor;
        displayString = data;
      }

      if (isPer) {
        displayString = data + '%';
      }

      return Text(displayString,
        style: defaultTextStyle.style.merge(style).merge(TextStyle(color: displayColor)),
        textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start
      );
    }
    return null;
  }
}
