import 'package:flutter/material.dart';

class NoGlowList extends StatelessWidget {
  final Widget child;

  NoGlowList({this.child});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (os) {
          os.disallowGlow();
          return;
        },
        child: child);
  }
}
