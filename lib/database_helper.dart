import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform, Directory;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    _database = await _initDB('spotlight.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String fullPath;
    if (kIsWeb) {
      final dbPath = await getDatabasesPath();
      fullPath = join(dbPath, filePath);
    } else {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        fullPath = join(Directory.current.path, filePath);
      } else {
        final dbPath = await getDatabasesPath();
        fullPath = join(dbPath, filePath);
      }
    }

    return await openDatabase(
      fullPath,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
CREATE TABLE IF NOT EXISTS follows (
  follower TEXT NOT NULL,
  following TEXT NOT NULL,
  PRIMARY KEY (follower, following)
)
''');

      await db.execute('''
CREATE TABLE IF NOT EXISTS friend_requests (
  sender TEXT NOT NULL,
  receiver TEXT NOT NULL,
  status TEXT NOT NULL,
  PRIMARY KEY (sender, receiver)
)
''');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  streakCount INTEGER,
  lastLoginDate TEXT,
  missionsCompletedToday INTEGER,
  extraData TEXT
)
''');

    await db.execute('''
CREATE TABLE reminders (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL,
  extraData TEXT
)
''');

    await db.execute('''
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL,
  title TEXT,
  body TEXT,
  time TEXT,
  read INTEGER
)
''');

    await db.execute('''
CREATE TABLE journals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  text TEXT,
  mood TEXT,
  imagePath TEXT,
  voiceNote TEXT,
  date TEXT
)
''');

    await db.execute('''
CREATE TABLE follows (
  follower TEXT NOT NULL,
  following TEXT NOT NULL,
  PRIMARY KEY (follower, following)
)
''');

    await db.execute('''
CREATE TABLE friend_requests (
  sender TEXT NOT NULL,
  receiver TEXT NOT NULL,
  status TEXT NOT NULL
)
''');
  }

  // ========================
  // USER MANAGEMENT
  // ========================

  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    final prefs = await SharedPreferences.getInstance();

    final username = user['username'] as String?;
    if (username == null) return -1;

    final existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (existing.isNotEmpty) {
      return -1; // Username already exists
    }

    // Add new user with streak data
    user['streakCount'] = 1;
    user['lastLoginDate'] = DateTime.now().toIso8601String().split('T')[0];
    user['missionsCompletedToday'] = false;

    // Separate extra columns
    Map<String, dynamic> extraData = {};
    user.forEach((key, value) {
      if (key != 'id' && 
          key != 'username' && 
          key != 'password' && 
          key != 'streakCount' && 
          key != 'lastLoginDate' && 
          key != 'missionsCompletedToday') {
        extraData[key] = value;
      }
    });

    Map<String, dynamic> userToInsert = {
      'username': username,
      'password': user['password'] ?? '',
      'streakCount': user['streakCount'],
      'lastLoginDate': user['lastLoginDate'],
      'missionsCompletedToday': user['missionsCompletedToday'] ? 1 : 0,
      'extraData': jsonEncode(extraData),
    };

    final id = await db.insert('users', userToInsert);
    user['id'] = id;

    // Set as current user
    await prefs.setString('current_user', jsonEncode(user));

    return id;
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await instance.database;
    final prefs = await SharedPreferences.getInstance();

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      Map<String, dynamic> userRow = Map<String, dynamic>.from(result.first);
      
      // Reconstruct base user map
      Map<String, dynamic> user = {};
      if (userRow['extraData'] != null) {
        user.addAll(jsonDecode(userRow['extraData'] as String));
      }
      user['id'] = userRow['id'];
      user['username'] = userRow['username'];
      user['password'] = userRow['password'];
      user['streakCount'] = userRow['streakCount'];
      user['lastLoginDate'] = userRow['lastLoginDate'];
      user['missionsCompletedToday'] = (userRow['missionsCompletedToday'] == 1);

      // Apply streak logic
      String today = DateTime.now().toIso8601String().split('T')[0];
      String? lastLogin = user['lastLoginDate'] as String?;
      
      if (lastLogin != null && lastLogin != today) {
        DateTime lastDate = DateTime.parse(lastLogin);
        DateTime todayDate = DateTime.parse(today);
        int diff = todayDate.difference(lastDate).inDays;
        
        if (diff == 1 && user['missionsCompletedToday'] == true) {
          user['streakCount'] = (user['streakCount'] ?? 0) + 1;
        } else if (diff > 1) {
          user['streakCount'] = 1;
        }
      }
      
      user['lastLoginDate'] = today;
      user['missionsCompletedToday'] = false;

      // Update user in the database
      await db.update(
        'users',
        {
          'streakCount': user['streakCount'],
          'lastLoginDate': user['lastLoginDate'],
          'missionsCompletedToday': user['missionsCompletedToday'] ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [user['id']],
      );

      // Set as current user
      await prefs.setString('current_user', jsonEncode(user));
      
      return user;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers([String? excludeUsername]) async {
    final db = await instance.database;
    final result = await db.query('users');
    
    List<Map<String, dynamic>> users = [];
    for (var row in result) {
      if (excludeUsername != null && row['username'] == excludeUsername) continue;
      Map<String, dynamic> user = Map<String, dynamic>.from(row);
      if (user['extraData'] != null) {
        user.addAll(jsonDecode(user['extraData'] as String));
      }
      users.add(user);
    }
    return users;
  }

  // ========================
  // STREAK MANAGEMENT
  // ========================

  Future<int> getStreak(String username) async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUserJson = prefs.getString('current_user');
    if (currentUserJson != null) {
      Map<String, dynamic> user = jsonDecode(currentUserJson);
      if (user['username'] == username) {
        return user['streakCount'] ?? 0;
      }
    }
    
    // Fallback to db
    final db = await instance.database;
    final result = await db.query(
      'users',
      columns: ['streakCount'],
      where: 'username = ?',
      whereArgs: [username],
    );
    
    if (result.isNotEmpty) {
      return result.first['streakCount'] as int? ?? 0;
    }
    return 0;
  }

  Future<void> completeMission(String username) async {
    final db = await instance.database;
    final prefs = await SharedPreferences.getInstance();
    
    await db.update(
      'users',
      {'missionsCompletedToday': 1},
      where: 'username = ?',
      whereArgs: [username],
    );

    String? currentUserJson = prefs.getString('current_user');
    if (currentUserJson != null) {
      Map<String, dynamic> user = jsonDecode(currentUserJson);
      if (user['username'] == username) {
        user['missionsCompletedToday'] = true;
        await prefs.setString('current_user', jsonEncode(user));
      }
    }
  }

  // ========================
  // REMINDER MANAGEMENT
  // ========================

  Future<List<Map<String, dynamic>>> getReminders(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'reminders',
      where: 'username = ?',
      whereArgs: [username],
    );

    List<Map<String, dynamic>> reminders = [];
    for (var row in result) {
      Map<String, dynamic> reminder = {};
      if (row['extraData'] != null) {
        reminder.addAll(jsonDecode(row['extraData'] as String));
      }
      reminder['id'] = row['id'];
      reminders.add(reminder);
    }
    return reminders;
  }

  Future<void> saveReminder(String username, Map<String, dynamic> reminder) async {
    final db = await instance.database;
    
    String id = reminder['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    reminder['id'] = id;

    Map<String, dynamic> extraData = {};
    reminder.forEach((key, value) {
      if (key != 'id' && key != 'username') {
        extraData[key] = value;
      }
    });

    await db.insert(
      'reminders',
      {
        'id': id,
        'username': username,
        'extraData': jsonEncode(extraData),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteReminder(String username, String reminderId) async {
    final db = await instance.database;
    await db.delete(
      'reminders',
      where: 'id = ? AND username = ?',
      whereArgs: [reminderId, username],
    );
  }

  // ========================
  // NOTIFICATION / ACTIVITY LOG
  // ========================

  Future<List<Map<String, dynamic>>> getNotifications(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'notifications',
      where: 'username = ?',
      orderBy: 'time DESC',
    );

    List<Map<String, dynamic>> notifications = [];
    for (var row in result) {
      notifications.add({
        'id': row['id'],
        'title': row['title'],
        'body': row['body'],
        'time': row['time'],
        'read': (row['read'] as int? ?? 0) == 1,
      });
    }
    return notifications;
  }

  Future<void> addNotification(String username, String title, String body) async {
    final db = await instance.database;
    
    await db.insert('notifications', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'username': username,
      'title': title,
      'body': body,
      'time': DateTime.now().toIso8601String(),
      'read': 0,
    });

    // Keep only last 50 notifications
    final excess = await db.query(
      'notifications',
      columns: ['id'],
      where: 'username = ?',
      orderBy: 'time DESC',
      offset: 50,
    );

    for (var row in excess) {
      await db.delete(
        'notifications',
        where: 'id = ?',
        whereArgs: [row['id']],
      );
    }
  }

  // ========================
  // JOURNALS
  // ========================

  Future<void> createJournal(Map<String, dynamic> journal) async {
    final db = await instance.database;
    await db.insert('journals', journal);
  }

  Future<List<Map<String, dynamic>>> readAllJournals() async {
    final db = await instance.database;
    final orderBy = 'date DESC';
    final result = await db.query('journals', orderBy: orderBy);
    return result;
  }

  // ========================
  // SOCIAL / CONNECTIONS
  // ========================

  Future<void> sendFriendRequest(String sender, String receiver) async {
    final db = await instance.database;
    await db.insert('friend_requests', {
      'sender': sender,
      'receiver': receiver,
      'status': 'pending'
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await addNotification(receiver, 'New Friend Request', '$sender sent you a friend request');
  }

  Future<void> acceptFriendRequest(String sender, String receiver) async {
    final db = await instance.database;
    await db.update(
      'friend_requests',
      {'status': 'accepted'},
      where: 'sender = ? AND receiver = ?',
      whereArgs: [sender, receiver],
    );
    await addNotification(sender, 'Friend Request Accepted', '$receiver accepted your friend request');
  }

  Future<void> declineFriendRequest(String sender, String receiver) async {
    final db = await instance.database;
    await db.update(
      'friend_requests',
      {'status': 'declined'},
      where: 'sender = ? AND receiver = ?',
      whereArgs: [sender, receiver],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingFriendRequests(String username) async {
    final db = await instance.database;
    return await db.query(
      'friend_requests',
      where: 'receiver = ? AND status = ?',
      whereArgs: [username, 'pending'],
    );
  }

  Future<void> followUser(String follower, String following) async {
    final db = await instance.database;
    await db.insert('follows', {
      'follower': follower,
      'following': following
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await addNotification(following, 'New Follower', '$follower started following you');
  }

  Future<void> unfollowUser(String follower, String following) async {
    final db = await instance.database;
    await db.delete(
      'follows',
      where: 'follower = ? AND following = ?',
      whereArgs: [follower, following],
    );
  }

  Future<Map<String, bool>> checkConnectionStatus(String me, String them) async {
    final db = await instance.database;
    
    final followResult = await db.query(
      'follows',
      where: 'follower = ? AND following = ?',
      whereArgs: [me, them],
    );
    bool isFollowing = followResult.isNotEmpty;

    final friendResult = await db.query(
      'friend_requests',
      where: '((sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)) AND status = ?',
      whereArgs: [me, them, them, me, 'accepted'],
    );
    bool isFriend = friendResult.isNotEmpty;

    final pendingResult = await db.query(
      'friend_requests',
      where: 'sender = ? AND receiver = ? AND status = ?',
      whereArgs: [me, them, 'pending'],
    );
    bool isPendingRequest = pendingResult.isNotEmpty;

    return {
      'isFollowing': isFollowing,
      'isFriend': isFriend,
      'isPendingRequest': isPendingRequest,
    };
  }

  Future<List<String>> getFollowers(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'follows',
      where: 'following = ?',
      whereArgs: [username],
    );
    return result.map((row) => row['follower'] as String).toList();
  }

  Future<List<String>> getFollowing(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'follows',
      where: 'follower = ?',
      whereArgs: [username],
    );
    return result.map((row) => row['following'] as String).toList();
  }
}
