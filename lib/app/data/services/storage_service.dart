import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Save string
  Future<bool> write(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Read string
  String? read(String key) {
    return _prefs.getString(key);
  }

  // Save object as JSON
  Future<bool> writeObject(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  // Read object from JSON
  Map<String, dynamic>? readObject(String key) {
    final data = _prefs.getString(key);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // Save boolean
  Future<bool> writeBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Read boolean
  bool? readBool(String key) {
    return _prefs.getBool(key);
  }

  // Save int
  Future<bool> writeInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  // Read int
  int? readInt(String key) {
    return _prefs.getInt(key);
  }

  // Remove single key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all data
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
