import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  StorageService._();

  static const String _tokenKey = 'auth_access_token';
  static const String _userKey = 'auth_user_json';
  static const String _favoritesKey = 'local_favorite_photo_ids';

  static Future<void> saveSession({
    required String token,
    UserModel? user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    if (user != null) {
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return UserModel.fromJson(decoded);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<Set<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey) ?? const [];
    return list.toSet();
  }

  static Future<void> saveFavoriteIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, ids.toList());
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
