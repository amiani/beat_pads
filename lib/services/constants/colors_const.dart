import 'package:flutter/material.dart';

/// Custom Palette for this App
enum Palette {
  cadetBlue,
  yellowGreen,
  laserLemon,
  tan,
  lightPink,
  darkGrey,
  lightGrey,
  baseRed,
  whiteLike;

  Color get color {
    switch (this) {
      case Palette.cadetBlue:
        return const HSLColor.fromAHSL(1, 212, 0.31, 0.69).toColor();
      case Palette.yellowGreen:
        return const HSLColor.fromAHSL(1, 90, .90, .84).toColor();
      case Palette.laserLemon:
        return const HSLColor.fromAHSL(1, 61, 1, .71).toColor();
      case Palette.tan:
        return const HSLColor.fromAHSL(1, 28, .59, .63).toColor();
      case Palette.lightPink:
        return const HSLColor.fromAHSL(1, 351, .77, .85).toColor();
      case Palette.darkGrey:
        return Colors.grey[800]!;
      case Palette.lightGrey:
        return const HSLColor.fromAHSL(1, 0, .0, .33).toColor();
      case Palette.whiteLike:
        return Colors.white70;
      case Palette.baseRed:
        return const HSLColor.fromAHSL(1, 0, .95, .80).toColor();
    }
  }

  static Color intervalColor(int root, int note) {
    double hueShift = 0;
    double hue = (360 / 12 * ((note - root) % 12) + hueShift) % 360;
    return HSLColor.fromAHSL(1, hue, .95, .80).toColor();
  }
}

// Color _temp = HSLColor.fromAHSL(1, 351, .77, .82).toColor();

/* CSS HSL */
// --cadet-blue-crayola: hsla(212, 31%, 69%, 1); 
// --yellow-green-crayola: hsla(89, 100%, 84%, 1); 
// --laser-lemon: hsla(61, 100%, 71%, 1); 
// --tan-crayola: hsla(28, 59%, 63%, 1); 
// --light-pink: hsla(351, 77%, 82%, 1);


// RGB
// --cadet-blue-crayola: #96adc8ff;
// --yellow-green-crayola: #d7ffabff;
// --laser-lemon: #fcff6cff;
// --tan-crayola: #d89d6aff;
// --light-pink: #f4acb7ff;