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

  // Save list of integers
  Future<bool> writeIntList(String key, List<int> value) async {
    final stringList = value.map((e) => e.toString()).toList();
    return await _prefs.setStringList(key, stringList);
  }

  // Read list of integers
  List<int>? readIntList(String key) {
    final stringList = _prefs.getStringList(key);
    if (stringList != null) {
      return stringList.map((e) => int.parse(e)).toList();
    }
    return null;
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

  // Save list of objects as JSON
  Future<bool> writeObjectList(String key, List<Map<String, dynamic>> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  // Read list of objects from JSON
  List<Map<String, dynamic>>? readObjectList(String key) {
    final data = _prefs.getString(key);
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((item) => item as Map<String, dynamic>).toList();
    }
    return null;
  }
}
