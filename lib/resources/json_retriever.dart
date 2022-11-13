import 'dart:convert';

import 'package:flutter/services.dart';

Map<String, dynamic> _jsonData = {};

String? getStringBy(String key) => _jsonData[key] as String;

class JsonDataRetriever {
  const JsonDataRetriever();

  loadJson() async {
    String jsonString = await rootBundle.loadString("assets/local_texts.json");
    _jsonData = await json.decode(jsonString) as Map<String, dynamic>;
  }

  List<dynamic> fetchAplhabets() {
    return _jsonData['alphabets'] as List<dynamic>;
  }

  List<dynamic> fetchNumbers() {
    return _jsonData['numbers'] as List<dynamic>;
  }
}
