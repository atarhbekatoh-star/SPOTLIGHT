import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  final supabase = Supabase.instance.client;

  // ========================
  // USER MANAGEMENT
  // ========================

  Future<int> createUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();

    final username = user['username'] as String?;
    if (username == null) return -1;

    final existing = await supabase
        .from('users')
        .select()
        .eq('username', username);

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

    final response = await supabase
        .from('users')
        .insert(userToInsert)
        .select();

    final id = response.first['id'] as int;
    user['id'] = id;

    // Set as current user
    await prefs.setString('current_user', jsonEncode(user));

    return id;
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final result = await supabase
        .from('users')
        .select()
        .eq('username', username)
        .eq('password', password);

    if (result.isNotEmpty) {
      Map<String, dynamic> userRow = Map<String, dynamic>.from(result.first);
      
      // Reconstruct base user map
      Map<String, dynamic> user = {};
      if (userRow['extraData'] != null && userRow['extraData'].toString().isNotEmpty) {
        user.addAll(jsonDecode(userRow['extraData'] as String));
      }
      user['id'] = userRow['id'];
      user['username'] = userRow['username'];
      user['password'] = userRow['password'];
      user['streakCount'] = userRow['streakCount'];
      user['lastLoginDate'] = userRow['lastLoginDate'];
      user['missionsCompletedToday'] = (userRow['missionsCompletedToday'] == 1 || userRow['missionsCompletedToday'] == true);

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
      await supabase
          .from('users')
          .update({
            'streakCount': user['streakCount'],
            'lastLoginDate': user['lastLoginDate'],
            'missionsCompletedToday': user['missionsCompletedToday'] ? 1 : 0,
          })
          .eq('id', user['id']);

      // Set as current user
      await prefs.setString('current_user', jsonEncode(user));
      
      return user;
    }

    return null;
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.remove('xp');
    await prefs.remove('credits');
    await prefs.remove('unlockedItems');
    await prefs.remove('practice_step');
    await prefs.remove('last_practice_date');
    await prefs.remove('rewardStreak');
    await prefs.remove('lastClaimDate');
  }

  Future<List<Map<String, dynamic>>> getAllUsers([String? excludeUsername]) async {
    final result = await supabase.from('users').select();
    
    List<Map<String, dynamic>> users = [];
    for (var row in result) {
      if (excludeUsername != null && row['username'] == excludeUsername) continue;
      Map<String, dynamic> user = Map<String, dynamic>.from(row);
      if (user['extraData'] != null && user['extraData'].toString().isNotEmpty) {
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
    final result = await supabase
        .from('users')
        .select('streakCount')
        .eq('username', username);
    
    if (result.isNotEmpty) {
      return result.first['streakCount'] as int? ?? 0;
    }
    return 0;
  }

  Future<void> completeMission(String username) async {
    final prefs = await SharedPreferences.getInstance();
    
    await supabase
        .from('users')
        .update({'missionsCompletedToday': 1})
        .eq('username', username);

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
    final result = await supabase
        .from('reminders')
        .select()
        .eq('username', username);

    List<Map<String, dynamic>> reminders = [];
    for (var row in result) {
      Map<String, dynamic> reminder = {};
      if (row['extraData'] != null && row['extraData'].toString().isNotEmpty) {
        reminder.addAll(jsonDecode(row['extraData'] as String));
      }
      reminder['id'] = row['id'];
      reminders.add(reminder);
    }
    return reminders;
  }

  Future<void> saveReminder(String username, Map<String, dynamic> reminder) async {
    String id = reminder['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    reminder['id'] = id;

    Map<String, dynamic> extraData = {};
    reminder.forEach((key, value) {
      if (key != 'id' && key != 'username') {
        extraData[key] = value;
      }
    });

    await supabase.from('reminders').upsert(
      {
        'id': id,
        'username': username,
        'extraData': jsonEncode(extraData),
      },
    );
  }

  Future<void> deleteReminder(String username, String reminderId) async {
    await supabase
        .from('reminders')
        .delete()
        .eq('id', reminderId)
        .eq('username', username);
  }

  // ========================
  // NOTIFICATION / ACTIVITY LOG
  // ========================

  Future<List<Map<String, dynamic>>> getNotifications(String username) async {
    final result = await supabase
        .from('notifications')
        .select()
        .eq('username', username)
        .order('time', ascending: false);

    List<Map<String, dynamic>> notifications = [];
    for (var row in result) {
      notifications.add({
        'id': row['id'],
        'title': row['title'],
        'body': row['body'],
        'time': row['time'],
        'read': (row['read'] == 1 || row['read'] == true),
      });
    }
    return notifications;
  }

  Future<void> addNotification(String username, String title, String body) async {
    await supabase.from('notifications').insert({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'username': username,
      'title': title,
      'body': body,
      'time': DateTime.now().toIso8601String(),
      'read': 0,
    });

    // Keep only last 50 notifications
    final excess = await supabase
        .from('notifications')
        .select('id')
        .eq('username', username)
        .order('time', ascending: false)
        .range(50, 1000);

    for (var row in excess) {
      await supabase
          .from('notifications')
          .delete()
          .eq('id', row['id']);
    }
  }

  // ========================
  // JOURNALS
  // ========================

  Future<void> createJournal(Map<String, dynamic> journal) async {
    Map<String, dynamic> journalData = Map.from(journal);
    if (journalData.containsKey('id') && journalData['id'] == null) {
      journalData.remove('id');
    }
    await supabase.from('journals').insert(journalData);
  }

  Future<List<Map<String, dynamic>>> readAllJournals() async {
    final result = await supabase
        .from('journals')
        .select()
        .order('date', ascending: false);
    return result;
  }

  // ========================
  // SOCIAL / CONNECTIONS
  // ========================

  Future<void> sendFriendRequest(String sender, String receiver) async {
    if (sender == receiver) return;
    await supabase.from('friend_requests').upsert({
      'sender': sender,
      'receiver': receiver,
      'status': 'pending'
    });
    await addNotification(receiver, 'New Friend Request', '${sender} sent you a friend request');
  }

  Future<void> acceptFriendRequest(String sender, String receiver) async {
    await supabase
        .from('friend_requests')
        .update({'status': 'accepted'})
        .eq('sender', sender)
        .eq('receiver', receiver);
    await addNotification(sender, 'Friend Request Accepted', '${receiver} accepted your friend request');
  }

  Future<void> cancelFriendRequest(String sender, String receiver) async {
    await supabase
        .from('friend_requests')
        .delete()
        .eq('sender', sender)
        .eq('receiver', receiver)
        .eq('status', 'pending');
  }

  Future<void> declineFriendRequest(String sender, String receiver) async {
    await supabase
        .from('friend_requests')
        .update({'status': 'declined'})
        .eq('sender', sender)
        .eq('receiver', receiver);
  }

  Future<List<Map<String, dynamic>>> getPendingFriendRequests(String username) async {
    return await supabase
        .from('friend_requests')
        .select()
        .eq('receiver', username)
        .eq('status', 'pending');
  }

  Future<void> followUser(String follower, String following) async {
    if (follower == following) return;
    try {
      await supabase.from('follows').insert({
        'follower': follower,
        'following': following
      });
      await addNotification(following, 'New Follower', '${follower} started following you');
    } catch (e) {
      // Ignore if exists
    }
  }

  Future<void> unfollowUser(String follower, String following) async {
    await supabase
        .from('follows')
        .delete()
        .eq('follower', follower)
        .eq('following', following);
  }

  Future<Map<String, bool>> checkConnectionStatus(String me, String them) async {
    final followResult = await supabase
        .from('follows')
        .select()
        .eq('follower', me)
        .eq('following', them);
    bool isFollowing = followResult.isNotEmpty;

    final friendResult1 = await supabase
        .from('friend_requests')
        .select()
        .eq('sender', me)
        .eq('receiver', them)
        .eq('status', 'accepted');
        
    final friendResult2 = await supabase
        .from('friend_requests')
        .select()
        .eq('sender', them)
        .eq('receiver', me)
        .eq('status', 'accepted');
        
    bool isFriend = friendResult1.isNotEmpty || friendResult2.isNotEmpty;

    final pendingResult = await supabase
        .from('friend_requests')
        .select()
        .eq('sender', me)
        .eq('receiver', them)
        .eq('status', 'pending');
    bool isPendingRequest = pendingResult.isNotEmpty;

    return {
      'isFollowing': isFollowing,
      'isFriend': isFriend,
      'isPendingRequest': isPendingRequest,
    };
  }

  Future<List<String>> getFollowers(String username) async {
    final result = await supabase
        .from('follows')
        .select('follower')
        .eq('following', username);
    return result.map((row) => row['follower'] as String).toList();
  }

  Future<List<String>> getFollowing(String username) async {
    final result = await supabase
        .from('follows')
        .select('following')
        .eq('follower', username);
    return result.map((row) => row['following'] as String).toList();
  }
}
