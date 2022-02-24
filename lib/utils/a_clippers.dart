import 'package:flutter/cupertino.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    path.lineTo(0, h * 0.6);
    path.quadraticBezierTo(w * 0.25, h * 0.70, w * 0.4, h * 0.5);
    path.quadraticBezierTo(w * 0.625, h * 0.20, w * 0.825, h * 0.4);
    path.quadraticBezierTo(w * 0.95, h * 0.5, w, h * 0.15);
    path.lineTo(w, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}