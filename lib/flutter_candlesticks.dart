import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'LongPressMoveGestureRecognizer.dart';

class OHLCVGraph extends StatefulWidget {
  OHLCVGraph({
    Key key,
    @required this.data,
    this.gridLineColor = Colors.grey,
    this.gridLineAmount = 5,
    this.gridLineWidth = 0.1,
    this.gridLineLabelColor = Colors.grey,
    @required this.enableGridLines,
    @required this.volumeProp,
    this.increaseColor = Colors.green,
    this.decreaseColor = Colors.red,
  })  : assert(data != null),
        super(key: key);

  /// OHLCV data to graph  /// List of Maps containing open, high, low, close and volumeto
  /// Example: [["open" : 40.0, "high" : 75.0, "low" : 25.0, "close" : 50.0, "volumeto" : 5000.0}, {...}]
  final List data;

  final bool enableGridLines;

  final Color gridLineColor;
  final Color gridLineLabelColor;

  /// Number of grid lines
  final int gridLineAmount;

  /// Width of grid lines
  final double gridLineWidth;

  /// Proportion of paint to be given to volume bar graph
  final double volumeProp;

  final Color increaseColor;
  final Color decreaseColor;

  @override
  StockGesture createState() => new StockGesture(
      data: data,
      enableGridLines: enableGridLines,
      gridLineColor: gridLineColor,
      gridLineLabelColor: gridLineLabelColor,
      gridLineAmount: gridLineAmount,
      gridLineWidth: gridLineWidth,
      volumeProp: volumeProp,
      increaseColor: increaseColor,
      decreaseColor: decreaseColor);
}

class StockGesture extends State<OHLCVGraph> {
  StockGesture(
      {this.data,
      this.enableGridLines,
      this.gridLineColor,
      this.gridLineLabelColor,
      this.gridLineAmount,
      this.gridLineWidth,
      this.volumeProp,
      this.increaseColor,
      this.decreaseColor});

  final List data;
  final bool enableGridLines;

  final Color gridLineColor;
  final Color gridLineLabelColor;

  /// Number of grid lines
  final int gridLineAmount;

  /// Width of grid lines
  final double gridLineWidth;

  /// Proportion of paint to be given to volume bar graph
  final double volumeProp;

  final Color increaseColor;
  final Color decreaseColor;

  bool hasLongPress = false;
  StateData stateData = new StateData();

  @override
  Widget build(BuildContext context) {
    final Map<Type, GestureRecognizerFactory> gestures = <Type, GestureRecognizerFactory>{};
    gestures[TapGestureRecognizer] = GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(debugOwner: this),
          (TapGestureRecognizer instance) {
        instance
          ..onTapDown = onTapDown
          ..onTapUp = onTapUp
          ..onTap = onTap
          ..onTapCancel = onTapCancel;
      },
    );

    gestures[LongPressMoveGestureRecognizer] = GestureRecognizerFactoryWithHandlers<LongPressMoveGestureRecognizer>(
          () => LongPressMoveGestureRecognizer(debugOwner: this),
          (LongPressGestureRecognizer instance) {
        instance
          ..onLongPress = onLongPress
          ..onLongPressUp = onLongPressUp;
      },
    );

    return new RawGestureDetector(
        gestures: gestures
//      onPointerDown: (event) {
//        RenderBox box = context.findRenderObject();
//
//        stateData.setLongPressed(true);
//        Offset offset = box.globalToLocal(event.position);
//        double x = stateData.computeCrossX(offset);
//        if (x > 0) {
//          setState(() {
//            stateData.offset = new Offset(x, offset.dy);
//          });
//        }
//      },
//      onPointerMove: (event) {
//        stateData.setLongPressed(true);
//        RenderBox box = context.findRenderObject();
//        Offset offset = box.globalToLocal(event.position);
//        double x = stateData.computeCrossX(offset);
//        if (x > 0) {
//          setState(() {
//            stateData.offset = new Offset(x, offset.dy);
//          });
//        }
//      },
      child:
//      LimitedBox(
//        maxHeight: 100,
//        maxWidth: 300,
//        child:
          new CustomPaint(
        size: Size.infinite,
        painter: new _OHLCVPainter(
//            data: data,
            lineWidth: 1.0,
            gridLineColor: gridLineColor,
            gridLineAmount: gridLineAmount,
            gridLineWidth: gridLineWidth,
            gridLineLabelColor: gridLineLabelColor,
            enableGridLines: enableGridLines,
            volumeProp: volumeProp,
            labelPrefix: "",
            increaseColor: increaseColor,
            decreaseColor: decreaseColor,
            stateData: stateData),
      ),
    );
  }
}

class StateData {
  bool needRepaint = false;
  bool _longPressed = false;

  Offset offset;
  int currentIndex = -1;
  List<Rect> kChartLineRects = [];

  clearRepaintState() {
    needRepaint = false;
  }

  setLongPressed(bool longPress) {
    this._longPressed = longPress;
    needRepaint = true;
  }

  bool getLongPressed() {
    return this._longPressed;
  }

  add(Rect rect) {
    kChartLineRects.add(rect);
  }

  clearKChartLineOffsets() {
    kChartLineRects.clear();
  }

  double computeCrossX(Offset pointer) {
    for (int i = 0; i < kChartLineRects.length; i++) {
      if (pointer.dx >= kChartLineRects[i].left &&
          pointer.dx <= kChartLineRects[i].right) {
        currentIndex = i;
        return kChartLineRects[i].left +
            (kChartLineRects[i].right - kChartLineRects[i].left) / 2.0;
      }
    }
    return -1.0;
  }
}

class _OHLCVPainter extends CustomPainter {
  Paint _textBackgroundPaint;

  _OHLCVPainter({
    @required this.data,
    @required this.lineWidth,
    @required this.enableGridLines,
    @required this.gridLineColor,
    @required this.gridLineAmount,
    @required this.gridLineWidth,
    @required this.gridLineLabelColor,
    @required this.volumeProp,
    @required this.labelPrefix,
    @required this.increaseColor,
    @required this.decreaseColor,
    @required this.stateData,
  }) {
    _textBackgroundPaint = new Paint()..color = Colors.white;
  }

  final List data;
  final double lineWidth;
  final bool enableGridLines;
  final Color gridLineColor;
  final int gridLineAmount;
  final double gridLineWidth;
  final Color gridLineLabelColor;
  final String labelPrefix;
  final double volumeProp;
  final Color increaseColor;
  final Color decreaseColor;

  StateData stateData;

  double _min;
  double _max;
  double _realMin;
  double _realMax;
  double _maxVolume;

  List<TextPainter> gridLineTextPainters = [];
  TextPainter maxVolumePainter;
  TextPainter maxPainter;
  TextPainter minPainter;

  Paint whiteLinePaint;
  TextStyle normalTextStyle;
  TextStyle crossHighLightTextStyle;

  int _renderStartIndex = -1;
  int _renderEndIndex = -1;

  numCommaParse(number) {
    return number.round().toString().replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  }

  String priceStr(double price) {
    String text;
    if (price < 1) {
      text = price.toStringAsPrecision(4);
    } else if (price < 999) {
      text = price.toStringAsFixed(2);
    } else {
      text = price.round().toString().replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
    }
    return text;
  }

  update() {
    whiteLinePaint = new Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = lineWidth;

    normalTextStyle = new TextStyle(
        color: Colors.black87, fontSize: 10.0, fontWeight: FontWeight.normal);

    crossHighLightTextStyle = new TextStyle(
        background: _textBackgroundPaint,
        color: Colors.blueAccent,
        fontSize: 10.0,
        fontWeight: FontWeight.normal);

//    if (_renderEndIndex == -1 || _renderStartIndex == -1) {
//
//    }

    _min = double.infinity;
    _max = -double.infinity;
    _maxVolume = -double.infinity;
    for (var i in data) {
      if (i["high"] > _max) {
        _max = i["high"].toDouble();
      }
      if (i["low"] < _min) {
        _min = i["low"].toDouble();
      }
      if (i["volumeto"] > _maxVolume) {
        _maxVolume = i["volumeto"].toDouble();
      }
    }

    _realMax = _max;
    _realMin = _min;

    if (enableGridLines) {
      double gridLineValue;
      double offset = _realMax - _realMin;
      _max = _realMax + offset * 0.1;
      _min = _realMin - offset * 0.1;

      for (int i = 0; i < gridLineAmount; i++) {
        // Label grid lines
        gridLineValue = _max - (((_max - _min) / (gridLineAmount - 1)) * i);

        String gridLineText;
        if (gridLineValue < 1) {
          gridLineText = gridLineValue.toStringAsPrecision(4);
        } else if (gridLineValue < 999) {
          gridLineText = gridLineValue.toStringAsFixed(2);
        } else {
          gridLineText = gridLineValue.round().toString().replaceAllMapped(
              new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => "${m[1]},");
        }

        gridLineTextPainters.add(new TextPainter(
            text: new TextSpan(
                text: labelPrefix + gridLineText, style: normalTextStyle),
            textDirection: TextDirection.ltr));
        gridLineTextPainters[i].layout();
      }

      maxPainter = new TextPainter(
          text: new TextSpan(text: _realMax.toString(), style: normalTextStyle),
          textDirection: TextDirection.ltr);
      maxPainter.layout();

      minPainter = new TextPainter(
          text: new TextSpan(text: _realMin.toString(), style: normalTextStyle),
          textDirection: TextDirection.ltr);
      minPainter.layout();

      // Label volume line
      maxVolumePainter = new TextPainter(
          text: new TextSpan(
              text: numCommaParse(_maxVolume), style: normalTextStyle),
          textDirection: TextDirection.ltr);
      maxVolumePainter.layout();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data == null) {
      return;
    }

    if (_min == null || _max == null || _maxVolume == null) {
      update();
    }
    print("volumeProp = " + volumeProp.toString());
    final double volumeHeight = size.height * volumeProp;
    final double volumeNormalizer = volumeHeight / _maxVolume;

    double width = size.width;
    final double height = size.height * (1 - volumeProp) - 10;

//    if (enableGridLines) {
    Paint gridPaint = new Paint()
      ..color = gridLineColor
      ..strokeWidth = gridLineWidth;

    double gridLineDist = height / (gridLineAmount - 1);
    double gridLineY;

    // Draw grid lines
    for (int i = 0; i < gridLineAmount; i++) {
      gridLineY = (gridLineDist * i).round().toDouble();
      canvas.drawLine(
          new Offset(0.0, gridLineY), new Offset(width, gridLineY), gridPaint);
    }

    // Label volume line
    maxVolumePainter.paint(canvas, new Offset(0.0, gridLineY + 2.0));
//    }

    final double heightNormalizer = height / (_max - _min);
    final double rectWidth = 7.0; //width / data.length;

    double rectLeft;
    double rectTop;
    double rectRight;
    double rectBottom;

    Paint rectPaint;

    // Loop through all data
    stateData.clearKChartLineOffsets();
    for (int i = 0; i < data.length; i++) {
      rectLeft = (i * rectWidth) + lineWidth / 2;
      rectRight = ((i + 1) * rectWidth) - lineWidth / 2;

      double volumeBarTop = (height + volumeHeight) -
          (data[i]["volumeto"] * volumeNormalizer - lineWidth / 2);
      double volumeBarBottom = height + volumeHeight + lineWidth / 2;

      if (data[i]["open"] > data[i]["close"]) {
        // Draw candlestick if decrease
        rectTop = height - (data[i]["open"] - _min) * heightNormalizer;
        rectBottom = height - (data[i]["close"] - _min) * heightNormalizer;
        rectPaint = new Paint()
          ..color = decreaseColor
          ..strokeWidth = lineWidth;

        Rect ocRect =
            new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
        canvas.drawRect(ocRect, rectPaint);
        stateData.add(ocRect);

        // Draw volume bars
        Rect volumeRect = new Rect.fromLTRB(
            rectLeft, volumeBarTop, rectRight, volumeBarBottom);
        canvas.drawRect(volumeRect, rectPaint);
      } else {
        // Draw candlestick if increase
        rectTop = (height - (data[i]["close"] - _min) * heightNormalizer) +
            lineWidth / 2;
        rectBottom = (height - (data[i]["open"] - _min) * heightNormalizer) -
            lineWidth / 2;
        rectPaint = new Paint()
          ..color = increaseColor
          ..strokeWidth = lineWidth;

        canvas.drawLine(new Offset(rectLeft, rectBottom - lineWidth / 2),
            new Offset(rectRight, rectBottom - lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft, rectTop + lineWidth / 2),
            new Offset(rectRight, rectTop + lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft + lineWidth / 2, rectBottom),
            new Offset(rectLeft + lineWidth / 2, rectTop), rectPaint);
        canvas.drawLine(new Offset(rectRight - lineWidth / 2, rectBottom),
            new Offset(rectRight - lineWidth / 2, rectTop), rectPaint);

        Rect ocRect =
            new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
        stateData.add(ocRect);

        // Draw volume bars
        canvas.drawLine(new Offset(rectLeft, volumeBarBottom - lineWidth / 2),
            new Offset(rectRight, volumeBarBottom - lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft, volumeBarTop + lineWidth / 2),
            new Offset(rectRight, volumeBarTop + lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft + lineWidth / 2, volumeBarBottom),
            new Offset(rectLeft + lineWidth / 2, volumeBarTop), rectPaint);
        canvas.drawLine(new Offset(rectRight - lineWidth / 2, volumeBarBottom),
            new Offset(rectRight - lineWidth / 2, volumeBarTop), rectPaint);
      }

      // Draw low/high candlestick wicks
      double low = height - (data[i]["low"] - _min) * heightNormalizer;
      double high = height - (data[i]["high"] - _min) * heightNormalizer;
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectBottom),
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, low),
          rectPaint);
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectTop),
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, high),
          rectPaint);

      if (_realMin == data[i]["low"]) {
        Offset offset =
            new Offset(rectLeft + rectWidth / 2 - lineWidth / 2 - 15, low + 2);
        canvas.drawLine(
            offset,
            new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, low + 2),
            whiteLinePaint);

        canvas.drawCircle(offset, 2, whiteLinePaint);
        minPainter.paint(
            canvas,
            new Offset(
                rectLeft +
                    rectWidth / 2 -
                    lineWidth / 2 -
                    15 -
                    minPainter.width -
                    2,
                low + 2 - minPainter.height / 2));
      }

      if (_realMax == data[i]["high"]) {
        Offset offset =
            new Offset(rectLeft + rectWidth / 2 - lineWidth / 2 - 15, high - 2);
        canvas.drawLine(
            offset,
            new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, high - 2),
            whiteLinePaint);
        canvas.drawCircle(offset, 2, whiteLinePaint);
        maxPainter.paint(
            canvas,
            new Offset(
                rectLeft +
                    rectWidth / 2 -
                    lineWidth / 2 -
                    15 -
                    maxPainter.width -
                    2,
                high - 2 - maxPainter.height / 2));
      }
    }

    for (int i = 0; i < gridLineAmount; i++) {
      gridLineY = (gridLineDist * i).round().toDouble();

      // Label grid lines
      if (i == 0) {
        gridLineTextPainters[i].paint(canvas, new Offset(2.0, gridLineY));
      } else {
        gridLineTextPainters[i].paint(canvas,
            new Offset(2.0, gridLineY - gridLineTextPainters[i].height));
      }
    }

    print("stateData.getLongPressed() = " +
        stateData.getLongPressed().toString());
    if (stateData.getLongPressed()) {
      if (stateData.currentIndex >= 0 && stateData.currentIndex < data.length) {
        DateTime dateD = new DateTime.fromMillisecondsSinceEpoch(
            data[stateData.currentIndex]["time"]);
        TextPainter datePainter = new TextPainter(
            text: new TextSpan(
                text: "${dateD.year}-${dateD.month}-${dateD.day}",
                style: crossHighLightTextStyle),
            textDirection: TextDirection.ltr);
        datePainter.layout();
        datePainter.paint(
            canvas,
            new Offset(stateData.offset.dx - datePainter.width / 2,
                height + volumeHeight + 5.0));
      }

      Paint crossPaint = new Paint()
        ..color = Colors.black
        ..strokeWidth = 1.0;
      //draw touch y line
      var crossY = stateData.offset.dy > height + volumeHeight
          ? height + volumeHeight
          : stateData.offset.dy;

      double currentPrice = _min + (_max - _min) * (height - crossY) / height;
      TextPainter vertical = new TextPainter(
          text: new TextSpan(
              text: priceStr(currentPrice), style: crossHighLightTextStyle),
          textDirection: TextDirection.ltr);
      vertical.layout();
      vertical.paint(canvas, new Offset(2.0, crossY - vertical.height / 2));

      canvas.drawLine(new Offset(vertical.width + 4.0, crossY),
          new Offset(width, crossY), crossPaint);

      //draw touch x line
      canvas.drawLine(new Offset(stateData.offset.dx, 0.0),
          new Offset(stateData.offset.dx, height + volumeHeight), crossPaint);
    }
//    stateData.clearRepaintState();
  }

  @override
  bool shouldRepaint(_OHLCVPainter old) {
    return data != old.data ||
        lineWidth != old.lineWidth ||
        enableGridLines != old.enableGridLines ||
        gridLineColor != old.gridLineColor ||
        gridLineAmount != old.gridLineAmount ||
        gridLineWidth != old.gridLineWidth ||
        volumeProp != old.volumeProp ||
        gridLineLabelColor != old.gridLineLabelColor ||
        stateData.needRepaint;
  }
}
