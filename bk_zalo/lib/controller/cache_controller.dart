import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheController {
  static Future<void> saveData(Map<String, String> data, String key) async {
    var store = await SharedPreferences.getInstance();
    String userData = jsonEncode(data);
    await store.setString(key, userData);
  }

  static Future<Map<String, String>> loadData(String key) async {
    var store = await SharedPreferences.getInstance();
    String? rawData = store.getString(key);
    if (rawData != null) return jsonDecode(rawData);
    return {};
  }
}
