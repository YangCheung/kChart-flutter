import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../kchart/KChartGraphWidget.dart';

class KChartDetailPageWidget extends StatefulWidget {
  @override
  State createState() => KChartDetailPageWidgetState();
}

class KChartDetailPageWidgetState extends State<KChartDetailPageWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorColor: Color(0xff1478F0),
            indicatorWeight: 3,
            unselectedLabelColor: Color(0xFF999999),
            labelColor: Color(0xFF333333),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),
            labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
            labelPadding: EdgeInsets.symmetric(vertical: 5.0),
            indicatorPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              const Text("分时"),
              const Text("五日"),
              const Text("日K"),
              const Text("周K"),
              const Text("月K"),
            ],
          ),
//
//            Container(
//              height: 200,
//              child:
//            )
          KCharMainFrameWidget(),
        ],
      ),
    );
  }
}

class KCharMainFrameWidget extends StatefulWidget {
  const KCharMainFrameWidget({
    Key key,
    this.controller,
  });

  final TabController controller;

  @override
  _KCharMainFrameWidgetState createState() => _KCharMainFrameWidgetState();
}

class _KCharMainFrameWidgetState extends State<KCharMainFrameWidget> {
  TabController _controller;
  int _currentIndex;

  void _updateTabController() {
    final TabController newController =
        widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError('No TabController for ${widget.runtimeType}.\n'
            'When creating a ${widget.runtimeType}, you must either provide an explicit '
            'TabController using the "controller" property, or you must ensure that there '
            'is a DefaultTabController above the ${widget.runtimeType}.\n'
            'In this case, there was neither an explicit controller nor a default controller.');
      }
      return true;
    }());
    if (newController == _controller) return;

    if (_controller != null) {
      _controller.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller.addListener(_handleTabControllerTick);
      _currentIndex = _controller.index;
    }
  }

  void _handleTabControllerTick() {
    if (_controller.index != _currentIndex) {
      _currentIndex = _controller.index;
      print("_currentIndex = $_currentIndex");

      setState(() {
        // Rebuild the tabs after a (potentially animated) index change
        // has completed.
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
  }

  @override
  void didUpdateWidget(KCharMainFrameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey,
        child: new Text("_currentIndex = $_currentIndex"));
  }
}
