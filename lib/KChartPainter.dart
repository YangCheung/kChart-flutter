import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'KChartGraphWidget.dart';

class KChartPainter extends CustomPainter {
  Paint _textBackgroundPaint;

  KChartPainter({
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
    @required this.rectWidth
  }) {
    _textBackgroundPaint = new Paint()..color = Colors.white;
    init();
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

  final StateData stateData;

  List<TextPainter> gridLineTextPainters = [];
  TextPainter maxVolumePainter;
  TextPainter maxPainter;
  TextPainter minPainter;

  Paint whiteLinePaint;
  TextStyle normalTextStyle;
  TextStyle crossHighLightTextStyle;

  double rectWidth;
  int offsetIndex = 0;

  init() {
    rectWidth = stateData.kRectWidth;

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
  }

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

  update(Size size) {
    print("size = ${size.toString()}");

    print("stateData.renderStartIndex =  ${stateData.renderStartIndex}; drawCount = ${stateData.drawCount}");
    print("stateData.renderStartIndex =  ${stateData.max}; drawCount = ${stateData.min}");
    double gridLineValue;
    for (int i = 0; i < gridLineAmount; i++) {
      gridLineValue = stateData.max - (((stateData.max - stateData.min) / (gridLineAmount - 1)) * i);

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
        text: new TextSpan(text: stateData.realMax.toString(), style: normalTextStyle),
        textDirection: TextDirection.ltr);
    maxPainter.layout();

    minPainter = new TextPainter(
        text: new TextSpan(text: stateData.realMin.toString(), style: normalTextStyle),
        textDirection: TextDirection.ltr);
    minPainter.layout();

    // Label volume line
    maxVolumePainter = new TextPainter(
        text: new TextSpan(
            text: numCommaParse(stateData.maxVolume), style: normalTextStyle),
        textDirection: TextDirection.ltr);
    maxVolumePainter.layout();
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("paint size ${size.toString()}");
    if (data == null || size.width.toInt() == 0 || size.height.toInt() == 0) {
      return;
    }
    stateData.computeIndexWithSize(size);

    if (stateData.requestOffsetData ||
        maxVolumePainter == null ||
        stateData.max == null ||
        stateData.maxVolume == null) {
      update(size);
    }

    stateData.requestOffsetData = false;

    print("volumeProp = " + volumeProp.toString());
    final double volumeHeight = size.height * volumeProp;
    final double volumeNormalizer = volumeHeight / stateData.maxVolume;

    double width = size.width;
    final double height = size.height * (1 - volumeProp) - 10;

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

    maxVolumePainter.paint(canvas, new Offset(0.0, gridLineY + 2.0));

    final double heightNormalizer = height / (stateData.max - stateData.min);

    double rectLeft;
    double rectTop;
    double rectRight;
    double rectBottom;

    Paint rectPaint;

    // Loop through all data
    stateData.clearKChartLineOffsets();
    print("paint_renderStartIndex = $stateData.renderStartIndex");
    print("drawCount = ${stateData.drawCount}");

    Path avg5path;
    Path avg10path;
    Path avg20path;
    Path avg60path;

    for (int i = 0; i < stateData.drawCount; i++) {
      int dataIndex = stateData.renderStartIndex + i;

      rectLeft = (i * rectWidth) + lineWidth / 2;
      rectRight = ((i + 1) * rectWidth) - lineWidth / 2;

      Map currentData = data[dataIndex];
      var x = (i * rectWidth) + rectWidth / 2;
      if (currentData["average5"] != null) {
        print("currentData average5 = ${currentData["average5"]}");
        var y = height - (currentData["average5"] - stateData.min) * heightNormalizer;
        if (avg5path == null) {
          avg5path = new Path();
          avg5path.moveTo(x, y );
          avg5path.lineTo(x, y );
        } else {
          avg5path.lineTo(x, y );
        }
      }

      if (currentData["average10"] != null) {
        var y = height - (currentData["average10"] - stateData.min) * heightNormalizer;
        if (avg10path == null) {
          avg10path = new Path();
          avg10path.moveTo(x, y );
          avg10path.lineTo(x, y );
        } else {
          avg10path.lineTo(x, y );
        }
      }

      if (currentData["average20"] != null) {
        var y = height - (currentData["average20"] - stateData.min) * heightNormalizer;
        if (avg20path == null) {
          avg20path = new Path();
          avg20path.moveTo(x, y );
          avg20path.lineTo(x, y );
        } else {
          avg20path.lineTo(x, y );
        }
      }

      if (currentData["average60"] != null) {
        var y = height - (currentData["average60"] - stateData.min) * heightNormalizer;
        if (avg60path == null) {
          avg60path = new Path();
          avg60path.moveTo(x, y );
          avg60path.lineTo(x, y );
        } else {
          avg60path.lineTo(x, y );
        }
      }


      double volumeBarTop = (height + volumeHeight) -
          (data[dataIndex]["volumeto"] * volumeNormalizer - lineWidth / 2);
      double volumeBarBottom = height + volumeHeight + lineWidth / 2;

      if (data[dataIndex]["open"] > data[dataIndex]["close"]) {
        // Draw candlestick if decrease
        rectTop = height - (data[dataIndex]["open"] - stateData.min) * heightNormalizer;
        rectBottom = height - (data[dataIndex]["close"] - stateData.min) * heightNormalizer;
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
        rectTop =
            (height - (data[dataIndex]["close"] - stateData.min) * heightNormalizer) + lineWidth / 2;
        rectBottom =
            (height - (data[dataIndex]["open"] - stateData.min) * heightNormalizer) - lineWidth / 2;
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
      double low = height - (data[dataIndex]["low"] - stateData.min) * heightNormalizer;
      double high =
          height - (data[dataIndex]["high"] - stateData.min) * heightNormalizer;
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectBottom),
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, low),
          rectPaint);
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectTop),
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, high),
          rectPaint);

      if (stateData.realMin == data[dataIndex]["low"]) {
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

      if (stateData.realMax == data[dataIndex]["high"]) {
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

    Paint avgPaint = new Paint()
      ..color = Colors.black;
    avgPaint.strokeJoin = StrokeJoin.round;
    avgPaint.style = PaintingStyle.stroke;
    canvas.drawPath(avg5path, avgPaint);

    Paint avg10Paint = new Paint()
      ..color = Colors.amber;
    avg10Paint.strokeJoin = StrokeJoin.round;
    avg10Paint.style = PaintingStyle.stroke;
    canvas.drawPath(avg10path, avg10Paint);

    Paint avg20Paint = new Paint()
      ..color = Colors.pinkAccent;
    avg20Paint.strokeJoin = StrokeJoin.round;
    avg20Paint.style = PaintingStyle.stroke;
    canvas.drawPath(avg20path, avg20Paint);

    Paint avg60Paint = new Paint()
      ..color = Colors.blueAccent;
    avg60Paint.strokeJoin = StrokeJoin.round;
    avg60Paint.style = PaintingStyle.stroke;
    canvas.drawPath(avg60path, avg60Paint);

    if (stateData.getLongPressed()) {
      var pressedIndex = stateData.currentIndex + stateData.renderStartIndex;
      if (pressedIndex >= 0 && pressedIndex < data.length) {
        DateTime dateD = new DateTime.fromMillisecondsSinceEpoch(data[pressedIndex]["time"]);
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
        ..color = Colors.black;
      //draw touch y line
      var crossY = stateData.offset.dy > height + volumeHeight
          ? height + volumeHeight
          : stateData.offset.dy;

      double currentPrice = stateData.min + (stateData.max - stateData.min) * (height - crossY) / height;
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
  }

  @override
  bool shouldRepaint(KChartPainter old) {
    return true;
//    return data != old.data ||
//        lineWidth != old.lineWidth ||
//        enableGridLines != old.enableGridLines ||
//        gridLineColor != old.gridLineColor ||
//        gridLineAmount != old.gridLineAmount ||
//        gridLineWidth != old.gridLineWidth ||
//        volumeProp != old.volumeProp ||
//        gridLineLabelColor != old.gridLineLabelColor ||
//        stateData.requestOffsetData ||
//        stateData.getLongPressed();
  }
}
