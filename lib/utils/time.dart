class CatTime {
  static Future<void> sleep (int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}