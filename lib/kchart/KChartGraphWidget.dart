import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:stock_k_chart_flutter/kchart/KChartPainter.dart';
import '../DelayMoveGestureRecognizer.dart';

class KChartGraphWidget extends StatefulWidget {
  KChartGraphWidget(
      {Key key,
      @required this.data,
      this.gridLineColor = Colors.grey,
      this.gridLineAmount = 5,
      this.gridLineWidth = 0.1,
      this.gridLineLabelColor = Colors.grey,
      @required this.enableGridLines,
      @required this.volumeProp,
      this.increaseColor = Colors.green,
      this.decreaseColor = Colors.red,
      this.ma5dColor = Colors.amber})
      : assert(data != null),
        super(key: key);

  /// Example: [["open" : 40.0, "high" : 75.0, "low" : 25.0, "close" : 50.0, "volumeto" : 5000.0}, {...}]
  final List data;

  final bool enableGridLines;

  final Color gridLineColor;
  final Color gridLineLabelColor;

  final Color ma5dColor;

  /// Number of grid lines
  final int gridLineAmount;

  /// Width of grid lines
  final double gridLineWidth;

  /// Proportion of paint to be given to volume bar graph
  final double volumeProp;

  final Color increaseColor;
  final Color decreaseColor;

  @override
  KChartState createState() => new KChartState(
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

class KChartState extends State<KChartGraphWidget> {
  KChartState({
    this.data,
    this.enableGridLines,
    this.gridLineColor,
    this.gridLineLabelColor,
    this.gridLineAmount,
    this.gridLineWidth,
    this.volumeProp,
    this.increaseColor,
    this.decreaseColor,
  }) {
    stateData = StateData(data);
    init();
  }

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
  StateData stateData;

  KChartPainter kCharPainter;

  double touchSlap = 7.0;
  final Map<Type, GestureRecognizerFactory> gestures = <Type, GestureRecognizerFactory>{};

  init() {
    gestures[TapGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(debugOwner: this),
              (TapGestureRecognizer instance) {
            instance
              ..onTapDown = onTapDown
              ..onTapUp = onTapUp;
//          ..onTap = onTap
//          ..onTapCancel = onTapCancel;
          },
        );

    gestures[DelayMoveGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<DelayMoveGestureRecognizer>(
              () => DelayMoveGestureRecognizer(debugOwner: this),
              (DelayMoveGestureRecognizer instance) {
            instance
              ..onLongPress = onLongPress
              ..onMove = onLongPressMove
              ..onLongPressUp = onLongPressUp;
          },
        );

    gestures[HorizontalDragGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(debugOwner: this),
              (HorizontalDragGestureRecognizer instance) {
            instance
              ..onDown = onHorizontalDragDown
              ..onStart = onHorizontalDragStart
              ..onUpdate = onHorizontalDragUpdate
              ..onEnd = onHorizontalDragEnd
              ..onCancel = onHorizontalDragCancel;
          },
        );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context) {
    print("afterFirstLayout ${context.size.toString()}");

//    stateData = StateData(data);
//    stateData.computeIndexWithSize(context.size);
  }

  onTapDown(TapDownDetails details) {
    print("onTapDown");
  }

  onTapUp(TapUpDetails details) {
    print("onTapUp");
  }

  onLongPress(PointerEvent event) {
    RenderBox box = context.findRenderObject();

    stateData.setLongPressed(true);
    Offset offset = box.globalToLocal(event.position);
    print("onLongPress = ${offset.toString()}");

    double x = stateData.computeCrossX(offset);
    setState(() {
      stateData.offset = new Offset(x, offset.dy);
    });
  }

  onLongPressMove(PointerMoveEvent event) {
    print("onLongPressMove");
    stateData.setLongPressed(true);
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(event.position);
    double x = stateData.computeCrossX(offset);
    if (x > 0) {
      setState(() {
        stateData.offset = new Offset(x, offset.dy);
      });
    }
  }

  onLongPressUp() {
    stateData.setLongPressed(true);
  }

  onHorizontalDragDown(DragDownDetails details) {
    print("onHorizontalDragDown");
  }

  onHorizontalDragStart(DragStartDetails details) {
    print("onHorizontalDragStart");
    horizontalDragOffset = 0;
  }

  double horizontalDragOffset = 0;

  onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dx * horizontalDragOffset < 0) {
      horizontalDragOffset = 0;
    }
    horizontalDragOffset = horizontalDragOffset + details.delta.dx;

    if (kCharPainter != null) {
      if (horizontalDragOffset.abs() >= touchSlap) {
        print("horizontalDragOffset = $horizontalDragOffset");
        if (stateData.move(horizontalDragOffset)) {
          print("horizontalDragOffset = setState");
          setState(() {});
        }
        horizontalDragOffset = 0;
      }
    }
  }

  onHorizontalDragEnd(DragEndDetails details) {
    horizontalDragOffset = 0;
  }

  onHorizontalDragCancel() {
    horizontalDragOffset = 0;
  }

  @override
  Widget build(BuildContext context) {
    kCharPainter = new KChartPainter(
        data: data,
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
        stateData: stateData);
    return new RawGestureDetector(
        gestures: gestures,
        child: new CustomPaint(size: Size.infinite, painter: kCharPainter));
  }
}

class StateData {
  StateData(this.data);

  final double kRectWidth = 7.0;
  int drawCount = 0;

  bool needRepaint = false;
  bool _longPressed = false;

  Offset offset;
  int currentIndex = -1;
  List<Rect> kChartLineRects = [];

  int renderStartIndex = -1;
  bool requestOffsetData = false;

  List data;

  double min;
  double max;
  double realMin;
  double realMax;
  double maxVolume;

  Size paintSize;

  computeIndexWithSize(Size size) {
    print("computeIndexWithSize = $size");
    print("computeIndexWithSize paintSize = $paintSize");
    if (paintSize == null || !(paintSize == size) && size.width > 0 && size.height > 0) {
      paintSize = size;

      int targetDrawCount = (size.width / kRectWidth).floor();
      print("computeIndexWithSize = $drawCount");
      if (targetDrawCount > data.length) {
        targetDrawCount = data.length;
      }

      if (renderStartIndex == -1 || renderStartIndex > data.length - drawCount || drawCount != targetDrawCount) {
        drawCount = targetDrawCount;
        renderStartIndex = data.length - targetDrawCount;
        computeMaxAndMin();
      }

      drawCount = targetDrawCount;
    }
  }

  computeMaxAndMin() {
    print("computeMaxAndMin = $drawCount");
    min = double.infinity;
    max = -double.infinity;
    maxVolume = -double.infinity;

    realMax = max;
    realMin = min;

    for (int index = renderStartIndex; index < renderStartIndex + drawCount; index++) {
      var i = data[index];
      if (i["high"] > realMax) {
        realMax = i["high"].toDouble();
      }

      if (i["average5"] != null && i["average5"] > max) {
        max = i["average5"].toDouble();
      }
      if (i["average10"] != null && i["average10"] > max) {
        max = i["average10"].toDouble();
      }
      if (i["average20"] != null && i["average20"] > max) {
        max = i["average20"].toDouble();
      }
      if (i["average60"] != null && i["average60"] > max) {
        max = i["average60"].toDouble();
      }

      if (i["average5"] != null && i["average5"] < min) {
        min = i["average5"].toDouble();
      }
      if (i["average10"] != null && i["average10"] < min) {
        min = i["average10"].toDouble();
      }
      if (i["average20"] != null && i["average20"] < min) {
        min = i["average20"].toDouble();
      }
      if (i["average60"] != null && i["average60"] < min) {
        min = i["average60"].toDouble();
      }

      if (i["low"] < realMin) {
        realMin = i["low"].toDouble();
      }
      if (i["volumeto"] > maxVolume) {
        maxVolume = i["volumeto"].toDouble();
      }
    }

    if (max < realMax) {
      max = realMax;
    }
    if (realMin < min) {
      min = realMin;
    }

    double offset = max - min;
    max = max + offset * 0.1;
    min = min - offset * 0.1;
  }

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
      if (pointer.dx >= kChartLineRects[i].left - 0.2 &&
          pointer.dx <= kChartLineRects[i].right + 0.2) {
        currentIndex = i;
        return kChartLineRects[i].left +
            (kChartLineRects[i].right - kChartLineRects[i].left) / 2.0;
      }
    }
    return -1.0;
  }

  bool move(double offset) {
    if (data == null || drawCount == 0) {
      print("${this.hashCode.toString()}");
      print("drawCount = $drawCount");
      print("move = $renderStartIndex");
      return false;
    }

    int oldStartIndex = renderStartIndex;
    int offsetIndex = (offset / kRectWidth).round();
    print("offsetIndex = $offsetIndex");
    int targetStartIndex = renderStartIndex - offsetIndex;
    print("targetStartIndex = $targetStartIndex");
    if (targetStartIndex >= 0 && targetStartIndex <= data.length - drawCount) {
      renderStartIndex = targetStartIndex;
    }
    requestOffsetData = oldStartIndex != renderStartIndex;

    if (requestOffsetData) {
      computeMaxAndMin();
    }
    return requestOffsetData;
  }
}
