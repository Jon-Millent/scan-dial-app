import 'package:fast_call/plugins/time_tools/time.dart';
import 'package:fast_call/utils/string_util.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'cat_rules.dart';
import 'types/type.dart';

class LinkGetter {

  static String removeLeadingAndTrailingHyphen(String input) {
    final RegExp regex = RegExp(r'^-|-$');
    return input.replaceAll(regex, '');
  }

  static String removeParentheses(String input) {
    final RegExp regex = RegExp(r'[()]');
    return input.replaceAll(regex, '');
  }

  static bool containsParentheses(String input) {
    final RegExp regex = RegExp(r'[()]');
    return regex.hasMatch(input);
  }

  static bool areParenthesesBalanced(String input) {
    int balance = 0;

    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == '(') {
        balance++;
      } else if (char == ')') {
        balance--;
        if (balance < 0) {
          return false; // 如果出现不匹配的情况，直接返回 false
        }
      }
    }

    return balance == 0; // 如果 balance 为 0，则说明括号完全匹配
  }


  static List<LinkGetterItemMode> getLinksFormBlocks (RecognizedText recognizedText) {

    List<LinkGetterItemMode> result = [];
    List<LinkGetterItemMode> groupList = [];

    for (var element in recognizedText.blocks) {

      // print('===========================');
      // print(element.text);
      // print("\n\n\n\n");

      final elementLineTextList = element.text.split('\n');


      for (var elementLineTextItem in elementLineTextList) {

        final phoneNumber = CatRules.getPhoneNumbers(elementLineTextItem);
        final emails = CatRules.getEmail(elementLineTextItem);
        final urls = CatRules.getExtractUrls(elementLineTextItem);

        if (urls.isNotEmpty) {
          for (var urlItem in urls) {
            final myUrl = urlItem.removeSpace().toLowerCase();

            if (CatRules.isGoodUrl(myUrl)) {
              groupList.add(
                  LinkGetterItemMode(
                      textBlock: element,
                      link: myUrl,
                      type: LinkGetterItemTypeEnum.url,
                      createTime: TimeTools.getNowDate(),
                      realLink: myUrl
                  )
              );
            }
          }
        }

        if (emails.isNotEmpty) {
          for (var emailItem in emails) {
            groupList.add(
                LinkGetterItemMode(
                    textBlock: element,
                    link: emailItem.removeSpace().toLowerCase(),
                    type: LinkGetterItemTypeEnum.email,
                    createTime: TimeTools.getNowDate(),
                    realLink: emailItem.removeSpace().toLowerCase()
                )
            );
          }
        }

        if (phoneNumber.isNotEmpty) {
          for (var phoneNumberItem in phoneNumber) {

            groupList.add(
                LinkGetterItemMode(
                    textBlock: element,
                    link: phoneNumberItem.trim(),
                    type: LinkGetterItemTypeEnum.phoneNumber,
                    createTime: TimeTools.getNowDate(),
                    realLink: phoneNumberItem.removeSpace()
                )
            );
          }
        }


      }



    }

    // 去重
    List<String> repeatMap = [];

    for (var element in groupList) {


      if (!repeatMap.contains(element.link)) {

        // 筛选去留
        String beforePreLink = element.link;


        if (element.isPhoneNumber) {
          // 1、如果只有一个括号，则去除掉另外一个括号
          if (LinkGetter.containsParentheses(beforePreLink)) {
            if (!LinkGetter.areParenthesesBalanced(beforePreLink)) {
              // 没有成对出现，删除所有的括号
              beforePreLink = LinkGetter.removeParentheses(beforePreLink);
            }
          }

          // 2、如果去掉括号后，长度小于5的
          if (beforePreLink.replaceAll(RegExp(r'[()]'), '').length < 5) {
            beforePreLink = '';
          }

          // 3、如果去掉-后，长度小于5的
          if (beforePreLink.replaceAll(RegExp(r'-'), '').length < 5) {
            beforePreLink = '';
          }
        }

        // 如果结尾是 “-” 则去掉
        beforePreLink = removeLeadingAndTrailingHyphen(beforePreLink);

        element.link = beforePreLink;
        element.realLink = beforePreLink;

        // 长度要大于2
        if (beforePreLink.length > 2) {
          repeatMap.add(element.link);
          result.add(element);
        }

      }
    }

    // result.sort((a, b) => b.realLink.length.compareTo(a.realLink.length));

    return result;
  }


  // no used
  // 获取处理后的结果【优化】
  static List<LinkGetterItemMode> getLinksFormBlocksBetter (List<LinkGetterItemMode> needPreList) {
    final List<LinkGetterItemMode> better = [...needPreList];
    // 优化结果建议
    // 1、如果只有一个括号，则去除掉另外一个括号
    return better;
  }


  static List<String> getAllList (List<LinkGetterItemMode> better) {
    return better.map((e) => e.realLink).toList();
  }

  static String getAllListSpaces (List<LinkGetterItemMode> better) {
    return getAllList(better).join('\n');
  }
}