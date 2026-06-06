import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  // ========================
  // USER MANAGEMENT
  // ========================

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

    // Add new user with streak data
    user['id'] = users.length + 1;
    user['streakCount'] = 1;
    user['lastLoginDate'] = DateTime.now().toIso8601String().split('T')[0];
    user['missionsCompletedToday'] = false;
    users.add(user);

    // Save back to prefs
    await prefs.setString('users_db', jsonEncode(users));
    
    // Set as current user
    await prefs.setString('current_user', jsonEncode(user));
    
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
        Map<String, dynamic> user = Map<String, dynamic>.from(u);
        
        // Update streak on login
        String today = DateTime.now().toIso8601String().split('T')[0];
        String? lastLogin = user['lastLoginDate'];
        
        if (lastLogin != null && lastLogin != today) {
          // Check if yesterday
          DateTime lastDate = DateTime.parse(lastLogin);
          DateTime todayDate = DateTime.parse(today);
          int diff = todayDate.difference(lastDate).inDays;
          
          if (diff == 1 && user['missionsCompletedToday'] == true) {
            // Consecutive day with completed missions - increase streak
            user['streakCount'] = (user['streakCount'] ?? 0) + 1;
          } else if (diff > 1) {
            // Missed a day - reset streak
            user['streakCount'] = 1;
          }
          // Same day - keep streak as is
        }
        
        user['lastLoginDate'] = today;
        user['missionsCompletedToday'] = false;
        
        // Update user in the database
        await _updateUser(user);
        
        // Set as current user
        await prefs.setString('current_user', jsonEncode(user));
        
        return user;
      }
    }

    return null;
  }

  // ========================
  // STREAK MANAGEMENT
  // ========================

  Future<int> getStreak(String username) async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUserJson = prefs.getString('current_user');
    if (currentUserJson != null) {
      Map<String, dynamic> user = jsonDecode(currentUserJson);
      return user['streakCount'] ?? 0;
    }
    return 0;
  }

  Future<void> completeMission(String username) async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUserJson = prefs.getString('current_user');
    if (currentUserJson != null) {
      Map<String, dynamic> user = jsonDecode(currentUserJson);
      user['missionsCompletedToday'] = true;
      await prefs.setString('current_user', jsonEncode(user));
      await _updateUser(user);
    }
  }

  // ========================
  // REMINDER MANAGEMENT
  // ========================

  Future<List<Map<String, dynamic>>> getReminders(String username) async {
    final prefs = await SharedPreferences.getInstance();
    String? remindersJson = prefs.getString('reminders_$username');
    if (remindersJson != null) {
      List<dynamic> list = jsonDecode(remindersJson);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<void> saveReminder(String username, Map<String, dynamic> reminder) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> reminders = await getReminders(username);
    reminders.add(reminder);
    await prefs.setString('reminders_$username', jsonEncode(reminders));
  }

  Future<void> deleteReminder(String username, String reminderId) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> reminders = await getReminders(username);
    reminders.removeWhere((r) => r['id'] == reminderId);
    await prefs.setString('reminders_$username', jsonEncode(reminders));
  }

  // ========================
  // NOTIFICATION / ACTIVITY LOG
  // ========================

  Future<List<Map<String, dynamic>>> getNotifications(String username) async {
    final prefs = await SharedPreferences.getInstance();
    String? notifJson = prefs.getString('notifications_$username');
    if (notifJson != null) {
      List<dynamic> list = jsonDecode(notifJson);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<void> addNotification(String username, String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> notifications = await getNotifications(username);
    notifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'body': body,
      'time': DateTime.now().toIso8601String(),
      'read': false,
    });
    // Keep only last 50 notifications
    if (notifications.length > 50) {
      notifications = notifications.sublist(0, 50);
    }
    await prefs.setString('notifications_$username', jsonEncode(notifications));
  }

  // ========================
  // INTERNAL HELPERS
  // ========================

  Future<void> _updateUser(Map<String, dynamic> updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users_db');
    if (usersJson == null) return;

    List<dynamic> users = jsonDecode(usersJson);
    for (int i = 0; i < users.length; i++) {
      if (users[i]['username'] == updatedUser['username']) {
        users[i] = updatedUser;
        break;
      }
    }
    await prefs.setString('users_db', jsonEncode(users));
  }
}
