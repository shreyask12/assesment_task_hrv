import 'json_retriever.dart';

extension ResourceResolver on String {
  String resolveResource() {
    if (getStringBy(this) == null) {
      return this;
    }
    return getStringBy(this)!; // Added null check added before this statement.
  }

  String resolveResourceWithArgs(Map<String, String> args) {
    String str = resolveResource();
    args.forEach((key, value) {
      // ignore: prefer_interpolation_to_compose_strings
      str = str.replaceAll(RegExp(r'\@{' + key + '}'), value);
    });
    return str;
  }
}
