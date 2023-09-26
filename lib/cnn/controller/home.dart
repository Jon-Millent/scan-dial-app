import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:fast_call/plugins/link_getter/link.dart';
import 'package:fast_call/plugins/link_getter/types/type.dart';
import 'package:fast_call/reasoning/view.dart';
import 'package:fast_call/utils/call_link.dart';
import 'package:fast_call/utils/rem_help.dart';
import 'package:fast_call/utils/time.dart';
import 'package:fast_call/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../types/type.dart';
import 'camera.dart';

class HomeController extends ChangeNotifier {

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  CameraControllerMax cameraControllerMax = CameraControllerMax();

  CNNDisplayMode? cnnDisplayMode;

  bool onLoad = false;

  bool canPick = false;
  int pickTime = 0;

  bool lightIsOpen = false;

  int scanNumbers = 0;

  // 每秒识别几次
  double pickTargetEverySeconds = 1;

  late BuildContext pageContext;

  Timer? _debounce;

  bool isImageStream = true;


  void init (BuildContext context) async {
    pageContext = context;

    cameraControllerMax.init((value) {
      onLoad = true;

      notifyListeners();

      startImageSteam();
    });
  }

  void toggleLight () {
    if (lightIsOpen) {
      cameraControllerMax.controller.setFlashMode(FlashMode.off);
      lightIsOpen = false;
    } else {
      cameraControllerMax.controller.setFlashMode(FlashMode.torch);
      lightIsOpen = true;
    }

    notifyListeners();
  }

  Future<void> closeReady ({bool isPaused = true}) async {
    closeLight();
    disableImageStream();

    if (isPaused) {
      try {
        await cameraControllerMax.controller.pausePreview();
      } catch (e) {
        await CatTime.sleep(300);
        await cameraControllerMax.controller.pausePreview();
      }
    }
  }

  Future<void> openReady ({bool isPaused = true}) async {
    enableImageStream();

    if (isPaused) {
      try {
        await cameraControllerMax.controller.resumePreview();
      } catch (e) {
        await CatTime.sleep(300);
        await cameraControllerMax.controller.resumePreview();
      }
    }
  }


  void openQuickJump (LinkGetterItemMode info) async {

    closeReady(isPaused: false);
    await showDialog(
      context: pageContext,
      builder: (BuildContext context) {

        final phoneMenu = [
          TextButton.icon(
            onPressed: () {
              CallLinkAction.callPhoneNumber(info.realLink);
            },
            icon: const Icon(Icons.call),
            label: const Text('Dial'),
          ),
          TextButton.icon(
            onPressed: () {
              CallLinkAction.copy(info.realLink);
              CatToast.showToast('Copied');
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
          TextButton.icon(
            onPressed: () {
              CallLinkAction.sendSMS(info.realLink);
            },
            icon: const Icon(Icons.sms_outlined),
            label: const Text('SMS'),
          ),
        ];
        final mailMenu = [
          TextButton.icon(
            onPressed: () {
              CallLinkAction.sendEmail(info.realLink);
            },
            icon: const Icon(Icons.email),
            label: const Text('Send Email'),
          ),
          TextButton.icon(
            onPressed: () {
              CallLinkAction.copy(info.realLink);
              CatToast.showToast('Copied');
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ];
        final urlMenu = [
          TextButton.icon(
            onPressed: () {
              CallLinkAction.openUrl(info.realLink);
            },
            icon: Icon(info.getIcon),
            label: const Text('Open Url'),
          ),
          TextButton.icon(
            onPressed: () {
              CallLinkAction.copy(info.realLink);
              CatToast.showToast('Copied');
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ];

        List<Widget> finalMenu = [];

        if (info.isPhoneNumber) {
          finalMenu = phoneMenu;
        } else if (info.isEmail) {
          finalMenu = mailMenu;
        } else if (info.isUrl) {
          finalMenu = urlMenu;
        }

        return AlertDialog(
          title: Row(
            children: [
              Text(
                  info.getTitle
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 20.px
                ),
                width: 400,
                child: Text(
                  info.link,
                  style: TextStyle(
                    fontSize: 40.px,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20.px
                ),
                child: Row(
                  children: finalMenu
                ),
              )
            ],
          ),
          actions: info.isPhoneNumber ? [
            TextButton.icon(
              onPressed: () {
                CallLinkAction.addConcat(info.realLink);
              },
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Add Contacts'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: const Text('Close'),
            ),
          ] : [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: const Text('Close'),
            ),

          ],
        );
      },
    );
    openReady(isPaused: false);
  }

  Future<void> closeLight () async {
    await cameraControllerMax.controller.setFlashMode(FlashMode.off);
    lightIsOpen = false;

    notifyListeners();
  }

  void viewAllResult () async {
    if (cnnDisplayMode != null) {
      closeReady();
      await showModalBottomSheet(
        context: pageContext,
        builder: (BuildContext context) {
          return ReasoningPage(
            cnnDisplayMode: cnnDisplayMode!
          );
        },
        isScrollControlled: true,
      );
      openReady();
    }
  }

  focusTap (TapDownDetails details) {
    // 计算点击点在预览视图中的位置

    final cameraController = cameraControllerMax.controller;

    if (cameraController.value.previewSize != null) {

      final previewSize = cameraController.value.previewSize!;

      final previewSizeTarget = Size(min(previewSize.width, previewSize.height), max(previewSize.width, previewSize.height));

      double relativeX = details.localPosition.dx / previewSizeTarget.width;
      double relativeY = details.localPosition.dy / previewSizeTarget.height;

      // 设置对焦区域
      cameraController.setFocusPoint(
        Offset(relativeX, relativeY)
      );

      if (_debounce != null && _debounce!.isActive) {
        _debounce!.cancel();
      }

      _debounce = Timer(const Duration(milliseconds: 1000), () {
        if (cameraController != null) {
          cameraController.setFocusMode(FocusMode.auto);
        }
      });

    }

  }

  startImageSteam () {
    pickTime = DateTime.now().millisecondsSinceEpoch;

    cameraControllerMax.controller.startImageStream((image) {

      if (isImageStream) {

        int now = DateTime.now().millisecondsSinceEpoch;

        if ((now - pickTime) >= (60 / pickTargetEverySeconds / 60) * 1000) {
          pickTime = now;
          toCNN(image);
        }
      }

    });
  }

  toCNN (CameraImage image) async {
    // image to camera image

    // 获取图像的大小
    Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final inputImage = InputImage.fromBytes(
      bytes: convertPlanesToBytes(image.planes),
      metadata: InputImageMetadata(
        rotation: InputImageRotation.rotation90deg,
        format: InputImageFormat.nv21,
        size: imageSize,
        bytesPerRow: 0
      )
    );

    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    cnnDisplayMode = CNNDisplayMode(
      recognizedText: recognizedText,
      imageSize: imageSize,
      better: LinkGetter.getLinksFormBlocks(recognizedText)
    );

    if (cnnDisplayMode != null) {
      scanNumbers = cnnDisplayMode!.better.length;
    }

    textRecognizer.close();

    notifyListeners();
  }

  Uint8List convertPlanesToBytes(List<Plane> planes) {
    // 获取每个平面的字节数组
    Uint8List yPlane = planes[0].bytes;
    Uint8List uPlane = planes[1].bytes;
    Uint8List vPlane = planes[2].bytes;

    // 计算图像的总大小
    int totalSize = yPlane.length + uPlane.length + vPlane.length;

    // 创建一个新的Uint8List用于存储合并后的字节数组
    Uint8List mergedBytes = Uint8List(totalSize);

    // 将每个平面的数据复制到合并后的字节数组中
    int offset = 0;
    mergedBytes.setRange(offset, offset + yPlane.length, yPlane);
    offset += yPlane.length;
    mergedBytes.setRange(offset, offset + uPlane.length, uPlane);
    offset += uPlane.length;
    mergedBytes.setRange(offset, offset + vPlane.length, vPlane);

    return mergedBytes;
  }

  disableImageStream () {
    isImageStream = false;
  }
  enableImageStream () {
    isImageStream = true;
  }


  void unload () {
    cameraControllerMax.controller.pausePreview();
    cameraControllerMax.controller.dispose();
  }

}