import 'package:flutter/material.dart';

// A widget that allows you to  restart the entire app.

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    final _RestartWidgetState? state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    state?.restartApp(); // Triggers app rebuild
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

/// The internal state of [RestartWidget] that manages the app restart logic.
class _RestartWidgetState extends State<RestartWidget> {
  // Unique key used to rebuild the widget subtree when changed
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key =
          UniqueKey(); // Changing the key causes Flutter to discard and recreate the widget subtree
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wraps the entire app in a KeyedSubtree so the subtree can be forcefully rebuilt
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
