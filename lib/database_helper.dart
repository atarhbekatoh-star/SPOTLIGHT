import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<int> createUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing users
    String? usersJson = prefs.getString('users_db');
    List<dynamic> users = [];
    if (usersJson != null) {
      users = jsonDecode(usersJson);
    }

    // Check if username exists
    for (var u in users) {
      if (u['username'] == user['username']) {
        return -1; // Username already exists
      }
    }

    // Add new user
    user['id'] = users.length + 1;
    users.add(user);

    // Save back to prefs
    await prefs.setString('users_db', jsonEncode(users));
    return user['id'];
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing users
    String? usersJson = prefs.getString('users_db');
    if (usersJson == null) return null;

    List<dynamic> users = jsonDecode(usersJson);

    // Find user
    for (var u in users) {
      if (u['username'] == username && u['password'] == password) {
        return u as Map<String, dynamic>;
      }
    }

    return null;
  }
}
