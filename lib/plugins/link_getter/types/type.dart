import 'package:fast_call/plugins/utils/link_type_getter.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class LinkGetterItemTypeEnum {
  static String email = 'email';
  static String phoneNumber = 'phoneNumber';
  static String url = 'url';
}

class LinkGetterItemMode {

  String type;

  String link;

  String createTime;

  TextBlock textBlock;

  String realLink;

  bool get isEmail => LinkTypeGetter.isEmail(type);
  bool get isPhoneNumber => LinkTypeGetter.isPhoneNumber(type);
  bool get isUrl => LinkTypeGetter.isUrl(type);

  IconData get getIcon => LinkTypeGetter.getLinkIconByType(type);
  Color get getColor => LinkTypeGetter.getLinkColorByType(type);
  String get getTitle => LinkTypeGetter.getTitleByType(type);

  LinkGetterItemMode({
    required this.textBlock,
    required this.type,
    required this.link,
    required this.createTime,
    required this.realLink
  });

}