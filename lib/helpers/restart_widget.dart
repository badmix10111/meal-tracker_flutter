// lib/widgets/restart_widget.dart

import 'package:flutter/material.dart';

/// Wrap your entire app in this widget to enable a full “restart.”
class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  /// Call this to rebuild the entire app.
  static void restartApp(BuildContext context) {
    final _RestartWidgetState? state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    state?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
