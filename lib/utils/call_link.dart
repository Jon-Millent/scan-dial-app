import 'dart:io';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CallLinkAction {

  static const MethodChannel androidMainChannel  = MethodChannel('top.totoro.fast_call/mainChannel');

  static void copy (String realLink) {
    Clipboard.setData(ClipboardData(text: realLink));
  }

  static void callPhoneNumber (String realLink) {
    final Uri uri = Uri(
      scheme: 'tel',
      path: realLink,
    );
    launchUrl(uri);
  }

  static void sendSMS (String realLink) {
    final Uri uri = Uri(
      scheme: 'sms',
      path: realLink,
    );
    launchUrl(uri);
  }

  static void openUrl (String realLink) {

    String preLink = realLink;

    if (!RegExp(r'^(http|https)://').hasMatch(preLink)) {
      preLink = 'https://$preLink';
    }

    launchUrl(Uri.parse(preLink), mode: LaunchMode.externalApplication);
  }

  static void sendEmail (String realLink) {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: realLink,
    );
    launchUrl(uri);
  }

  static void addConcat (String tel) async {
    if (Platform.isAndroid) {
      await androidMainChannel.invokeMethod('openContacts', {
        'name': '',
        'mobile': tel
      });
    }
  }

  static shareEmail (String realLink) {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: realLink,
    );
    Share.shareUri(uri);
  }

  static sharePhoneNumber (String realLink) {
    final Uri uri = Uri(
      scheme: 'tel',
      path: realLink,
    );
    Share.shareUri(uri);
  }

  static shareText (String text) {
    Share.share(text);
  }

}