import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LongPressMoveGestureRecognizer extends LongPressGestureRecognizer {
  LongPressMoveGestureRecognizer({ Object debugOwner }) : super(debugOwner: debugOwner);

  @override
  void handlePrimaryPointer(PointerEvent event) {
    super.handlePrimaryPointer(event);
  }
}