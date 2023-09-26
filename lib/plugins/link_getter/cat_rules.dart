class CatRules {

  static List<String> urlSubFix = [
    "com", "net", "org", "edu", "gov",
    "io", "co", "biz", "info", "tv",
    "app", "store", "online", "website", "blog",
    "tech", "design", "shop", "club", "world",
    "space", "media", "life", "pro", "name",
    "dev", "xyz", "top", "work", "us", "io",
    "com.cn", "cn", "jp",
  ];

  static List<String> getEmail(String input) {
    RegExp emailRegExp = RegExp(
      r'(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))',
      caseSensitive:true,
      multiLine: true
    );

    Iterable<RegExpMatch> matches = emailRegExp.allMatches(input);
    List<String> emails = matches.map((match) => match.group(0)!).toList();
    return emails;
  }

  static List<String> getExtractUrls(String text) {
    final RegExp urlRegExp = RegExp(
      r'(((ht|f)tps?):\/\/)?([^!@#$%^&*?.\s-]([^!@#$%^&*?.\s]{0,63}[^!@#$%^&*?.\s])?\.)+[a-z]{2,6}\/?',
      caseSensitive:true,
      multiLine: true
    );
    final Iterable<Match> matches = urlRegExp.allMatches(text);

    return matches.map((Match match) => match.group(0)!).toList();
  }

  static List<String> getPhoneNumbers(String text) {
    RegExp phoneNumberRegExp = RegExp(
      r'[+]?[0-9()\-\s]{3,}',
      caseSensitive:true,
      multiLine: true
    );
    Iterable<RegExpMatch> matches = phoneNumberRegExp.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  static bool isGoodUrl (String url) {
    // 返回是否是一个好的后缀
    bool isAllGood = false;

    for (var element in urlSubFix) {
      if (url.endsWith(".$element")) {
        isAllGood = true;
      }
    }

    return isAllGood;
  }

}