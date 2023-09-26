import 'package:camera/camera.dart';
import 'package:fast_call/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

class CameraControllerMax {

  late List<CameraDescription> _cameras;
  late CameraController controller;

  void init (ValueChanged<CameraController> onLoad) async {
    _cameras = await availableCameras();

    // 获取后置摄像头
    CameraDescription? backCamera = _cameras.firstWhereOrNull(
          (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    if (backCamera != null) {

      controller = CameraController(backCamera, ResolutionPreset.high);

      controller.initialize().then((_) {
        onLoad(controller);
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              CatToast.showToast("Please grant camera permission to use this feature");
              break;
            default:
              CatToast.showToast(e.toString());
              break;
          }
        }
      });

    }
  }


}