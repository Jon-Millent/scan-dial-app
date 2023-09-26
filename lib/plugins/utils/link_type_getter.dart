import 'package:fast_call/plugins/link_getter/types/type.dart';
import 'package:fast_call/utils/rem.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LinkTypeGetter {

  static Color getLinkColorByType (String type) {
    if (LinkTypeGetter.isPhoneNumber(type)) {
      return Colors.green;
    } else if (LinkTypeGetter.isEmail(type)) {
      return Colors.blue;
    } else if (LinkTypeGetter.isUrl(type)) {
      return '#1E91ED'.color;
    }
    return Colors.green;
  }


  static IconData getLinkIconByType (String type) {
    if (LinkTypeGetter.isPhoneNumber(type)) {
      return Icons.call;
    } else if (LinkTypeGetter.isEmail(type)) {
      return Icons.email;
    } else if (LinkTypeGetter.isUrl(type)) {
      return MdiIcons.web;
    }
    return Icons.call;
  }

  static String getTitleByType (String type) {
    if (LinkTypeGetter.isPhoneNumber(type)) {
      return "Phone Number";
    } else if (LinkTypeGetter.isEmail(type)) {
      return "Email";
    } else if (LinkTypeGetter.isUrl(type)) {
      return "Link";
    }
    return "Unknown";
  }

  static isEmail(String type) {
    return LinkGetterItemTypeEnum.email == type;
  }

  static isPhoneNumber(String type) {
    return LinkGetterItemTypeEnum.phoneNumber == type;
  }

  static isUrl(String type) {
    return LinkGetterItemTypeEnum.url == type;
  }

}