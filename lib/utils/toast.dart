import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CatToast {

  static void showToast(String msg) {
    SmartDialog.showToast(msg, alignment: const Alignment(0.0, 0.8));
  }

  static void showLoading({String title = 'Loading'}) {
    SmartDialog.showLoading(
      builder: (cancelFunc) {
        return PhysicalModel(
          borderRadius: BorderRadius.circular(10),
          elevation: 5,
          color: Colors.white.withOpacity(0),
          shadowColor: Colors.black.withOpacity(0.2),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      displayTime: const Duration(
        seconds: 20,
      ),
      backDismiss: true,
      clickMaskDismiss: true,
      maskColor: Colors.black.withOpacity(.1)
    );
  }

  static void hideLoading () {
    SmartDialog.dismiss();
  }
}