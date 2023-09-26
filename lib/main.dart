import 'dart:io';

import 'package:fast_call/utils/girl_screen_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'cnn/view.dart';


void main() {

  if (kReleaseMode) {
    // 在发布模式下禁用所有日志
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark
        )
    );
  }

  WidgetsFlutterBinding.ensureInitialized();
  GirlScreenUtil.freeScreen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp(
        title: 'Fast Call',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CnnHomePage(),
        navigatorObservers: [
          FlutterSmartDialog.observer,
        ],
        builder: FlutterSmartDialog.init(),
      )
    );
  }
}
