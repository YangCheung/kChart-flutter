
import  'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';

class SliverTickProvider implements TickerProvider {
  Ticker _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null)
        return true;
      throw FlutterError(
          '$runtimeType is a SingleTickerProviderStateMixin but multiple tickers were created.\n'
              'A SingleTickerProviderStateMixin can only be used as a TickerProvider once. If a '
              'State is used for multiple AnimationController objects, or if it is passed to other '
              'objects and those objects might use it more than one time in total, then instead of '
              'mixing in a SingleTickerProviderStateMixin, use a regular TickerProviderStateMixin.'
      );
    }());
    _ticker = Ticker(onTick, debugLabel: 'created by $this');
    // We assume that this is called from initState, build, or some sort of
    // event handler, and that thus TickerMode.of(context) would return true. We
    // can't actually check that here because if we're in initState then we're
    // not allowed to do inheritance checks yet.
    return _ticker;
  }
}