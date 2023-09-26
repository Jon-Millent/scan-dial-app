extension StringExtension on String {
  String removeSpace() {
    return replaceAll(RegExp(r'\s'), '');
  }
}