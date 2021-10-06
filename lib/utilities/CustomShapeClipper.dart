// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width * 0.4, size.height * 0.1);
    path.lineTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
