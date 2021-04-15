import 'package:flutter/material.dart';

import 'colors.dart';

// Title
TextStyle largeTitle =
    TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.white);

TextStyle title =
    TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.white);

TextStyle smallTitle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white);

// Colored title
TextStyle coloredLargeTitle =
    TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500, color: mainColor);

TextStyle coloredTitle =
    TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: mainColor);

TextStyle coloredSmallTitle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: mainColor);

TextStyle colorCustomTitle(double size) =>
    TextStyle(fontSize: size, fontWeight: FontWeight.w500, color: mainColor);

TextStyle colorTinyTitle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: mainColor);

// Hint
TextStyle largeHint = TextStyle(
    fontSize: 28.0, fontWeight: FontWeight.w500, color: Colors.grey[400]);

TextStyle hint = TextStyle(
    fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.grey[400]);

TextStyle smallHint = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.grey[400]);

TextStyle tinyHint =
    TextStyle(fontSize: 14, color: Colors.grey[400], letterSpacing: 1);

// Text
TextStyle largeText = TextStyle(
    fontSize: 28.0, fontWeight: FontWeight.w500, color: Colors.grey[600]);

TextStyle text = TextStyle(
    fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.grey[600]);

TextStyle smallText = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.grey[600]);

TextStyle tinyText = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.grey[600]);
