import 'package:fast_call/plugins/link_getter/types/type.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CNNDisplayMode {
  RecognizedText recognizedText;
  Size imageSize;
  List<LinkGetterItemMode> better;

  CNNDisplayMode({
    required this.recognizedText,
    required this.imageSize,
    required this.better
  });
}