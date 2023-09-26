import 'dart:math';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemHelp {
  static double maxWidth = 750;
  static double maxScaleWidth = 1024;
  static double realWidth = ScreenUtil().screenWidth * (ScreenUtil().pixelRatio ?? 1);
  static double rem = realWidth / maxWidth;

  static double getRealPx (double size) {
    double screenWidth = min(ScreenUtil().screenWidth, RemHelp.maxScaleWidth);
    double rem = screenWidth / maxWidth;
    return size * rem;
  }

  static double getSize (double size) {
    return RemHelp.getRealPx(size);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

extension IntFit on int {
  double get px {
    return RemHelp.getSize(toDouble());
  }
}

extension DoubleFit on double {
  double get px {
    return RemHelp.getSize(this);
  }
}

extension StringFit on String {
  HexColor get color {
    return HexColor(this);
  }
}