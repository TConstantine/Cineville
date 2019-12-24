import 'package:flutter/material.dart';

enum ClipDirection { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT }

class DiagonalView extends StatelessWidget {
  final double clipHeight;
  final ClipDirection clipDirection;
  final Widget child;

  const DiagonalView({
    Key key,
    this.clipHeight = 0.0,
    this.clipDirection = ClipDirection.BOTTOM_RIGHT,
    @required this.child,
  })  : assert(child != null),
        assert(clipHeight >= 0.0, 'clipHeight cannot be smaller than 0.0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _DiagonalClipper(clipHeight, clipDirection),
      child: child,
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  final double clipHeight;
  final ClipDirection clipDirection;

  _DiagonalClipper(this.clipHeight, this.clipDirection);

  @override
  Path getClip(Size size) {
    switch (clipDirection) {
      case ClipDirection.TOP_LEFT:
        return _getTopLeftPath(size);
      case ClipDirection.TOP_RIGHT:
        return _getTopRightPath(size);
      case ClipDirection.BOTTOM_LEFT:
        return _getBottomLeftPath(size);
      case ClipDirection.BOTTOM_RIGHT:
        return _getBottomRightPath(size);
      default:
        return _getBottomLeftPath(size);
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  Path _getTopLeftPath(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, clipHeight);
    path.close();
    return path;
  }

  Path _getTopRightPath(Size size) {
    final Path path = Path();
    path.moveTo(0.0, clipHeight);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  Path _getBottomLeftPath(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - clipHeight);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  Path _getBottomRightPath(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - clipHeight);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
}
