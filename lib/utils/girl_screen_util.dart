// 屏幕帮助类
import 'package:flutter/services.dart';

class GirlScreenUtil {
  // 锁定横屏
  static void lockHorizontalScreen () {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  // 取消锁定
  static void freeScreen () {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // 仅允许竖屏
    ]);
  }
}