import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shortcut_model.dart';

class ShortcutService {
  static const String _shortcutsKey = 'shortcuts';

  /// Get all shortcuts from local storage
  Future<List<ShortcutModel>> getShortcuts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shortcutsJson = prefs.getString(_shortcutsKey);

      if (shortcutsJson == null || shortcutsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(shortcutsJson);
      return decoded.map((json) => ShortcutModel.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error getting shortcuts: $e', name: 'ShortcutService');
      return [];
    }
  }

  /// Add a shortcut to local storage
  Future<bool> addShortcut(ShortcutModel shortcut) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shortcuts = await getShortcuts();

      // Check if shortcut already exists (by slug)
      if (shortcuts.any((s) => s.slug == shortcut.slug)) {
        developer.log('Shortcut already exists: ${shortcut.slug}',
            name: 'ShortcutService');
        return false;
      }

      // Add to list
      shortcuts.add(shortcut);

      // Save to storage
      final encoded = jsonEncode(shortcuts.map((s) => s.toJson()).toList());
      await prefs.setString(_shortcutsKey, encoded);

      developer.log('Shortcut added: ${shortcut.menu}', name: 'ShortcutService');
      return true;
    } catch (e) {
      developer.log('Error adding shortcut: $e', name: 'ShortcutService');
      return false;
    }
  }

  /// Remove a shortcut from local storage
  Future<bool> removeShortcut(String slug) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shortcuts = await getShortcuts();

      // Remove by slug
      shortcuts.removeWhere((s) => s.slug == slug);

      // Save to storage
      final encoded = jsonEncode(shortcuts.map((s) => s.toJson()).toList());
      await prefs.setString(_shortcutsKey, encoded);

      developer.log('Shortcut removed: $slug', name: 'ShortcutService');
      return true;
    } catch (e) {
      developer.log('Error removing shortcut: $e', name: 'ShortcutService');
      return false;
    }
  }

  /// Check if a shortcut exists
  Future<bool> isShortcutExist(String slug) async {
    final shortcuts = await getShortcuts();
    return shortcuts.any((s) => s.slug == slug);
  }

  /// Clear all shortcuts
  Future<void> clearShortcuts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_shortcutsKey);
      developer.log('All shortcuts cleared', name: 'ShortcutService');
    } catch (e) {
      developer.log('Error clearing shortcuts: $e', name: 'ShortcutService');
    }
  }
}
