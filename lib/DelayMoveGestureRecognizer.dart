import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

//class LongPressMoveGestureRecognizer extends LongPressGestureRecognizer {
//  LongPressMoveGestureRecognizer({ Object debugOwner }) : super(debugOwner: debugOwner);
//
//  PointerDownEvent firstPointer;
//
//  @override
//  void addPointer(PointerDownEvent event) {
//    super.addPointer(event);
//
//    if (firstPointer == null) {
//      firstPointer = event;
//    }
//  }
//
//  @override
//  void handlePrimaryPointer(PointerEvent event) {
//    super.handlePrimaryPointer(event);
//  }
//}

typedef GestureLongPressCallback = void Function(PointerDownEvent);
typedef GestureMovePressMoveCallback = void Function(PointerMoveEvent);
typedef GestureLongPressUpCallback = void Function();

class DelayMoveGestureRecognizer extends PrimaryPointerGestureRecognizer {
  /// Creates a long-press gesture recognizer.
  ///
  /// Consider assigning the [onLongPress] callback after creating this object.
  DelayMoveGestureRecognizer({ Object debugOwner })
      : super(deadline: kDoubleTapTimeout, debugOwner: debugOwner);

  bool _longPressAccepted = false;

  /// Called when a long press gesture has been recognized.
  GestureLongPressCallback onLongPress;
  GestureMovePressMoveCallback onMove;
  /// Called when the pointer stops contacting the screen after the long-press gesture has been recognized.
  GestureLongPressUpCallback onLongPressUp;

  PointerDownEvent firstPointer;

  bool _pointerDown = false;

  @override
  void didExceedDeadline() {
    if (_pointerDown) {
      resolve(GestureDisposition.accepted);
      _longPressAccepted = true;
      if (onLongPress != null) {
        invokeCallback<void>('onLongPress', ()=> (
            onLongPress(firstPointer)
        ));
      }
    } else {
      print("didExceedDeadline rejected" );
      resolve(GestureDisposition.rejected);
      firstPointer = null;
    }
  }


  @override
  void handleEvent(PointerEvent event) {
    assert(state != GestureRecognizerState.ready);
    if (state == GestureRecognizerState.possible && event.pointer == primaryPointer) {
        handlePrimaryPointer(event);
    }
    stopTrackingIfPointerNoLongerDown(event);
  }

  @override
  void handlePrimaryPointer(PointerEvent event) {
    if (event is PointerUpEvent) {
      _pointerDown = false;
      firstPointer = null;
      if (_longPressAccepted == true && onLongPressUp != null) {
        _longPressAccepted = false;
        invokeCallback<void>('onLongPressUp', onLongPressUp);
      } else {
        resolve(GestureDisposition.rejected);
      }
    } else if (event is PointerDownEvent || event is PointerCancelEvent) {
      // the first touch, initialize the  flag with false
      _longPressAccepted = false;
      _pointerDown = true;
      if (firstPointer == null) {
        firstPointer = event;
      }
    } else if(event is PointerCancelEvent) {
      firstPointer = null;
      _longPressAccepted = false;
      _pointerDown = true;
    } else if (event is PointerMoveEvent) {
      if (_longPressAccepted) {
//        print("LongPressMoveGestureRecognizer moving point ${event.position.toString()}" );
        invokeCallback<void>('onLongPressUp', ()=>(
          onMove(event)
        ));
      }
    }
  }

  @override
  String get debugDescription => 'long press';

  double _getDistance(PointerEvent event) {
    print("_getDistance ----" );
    return -1.0;
  }
}
