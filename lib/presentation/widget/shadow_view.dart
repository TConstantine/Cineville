import 'package:flutter/material.dart';

class ShadowView extends StatelessWidget {
  final Widget child;

  ShadowView({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey.withOpacity(0.85),
            offset: Offset(6.0, 6.0),
          )
        ],
      ),
      child: child,
    );
  }
}
