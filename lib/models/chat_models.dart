class UserModel {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final bool isOnline;
  final DateTime lastSeen;
  final String bio;
  final int level;
  final int streak;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.isOnline,
    required this.lastSeen,
    required this.bio,
    required this.level,
    required this.streak,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final bool isDelivered;
  final String type; // text, image, voice, file
  final String? replyToMessageId;
  final Map<String, List<String>> reactions;
  final String? filePath;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isRead,
    required this.isDelivered,
    required this.type,
    this.replyToMessageId,
    required this.reactions,
    this.filePath,
  });
}

class Channel {
  final String id;
  final String name;
  final String description;
  final String avatarUrl;
  final int followersCount;
  final bool isFollowing;
  final String bannerUrl;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.followersCount,
    required this.isFollowing,
    required this.bannerUrl,
  });
}

class Group {
  final String id;
  final String name;
  final String description;
  final String avatarUrl;
  final List<String> members;
  final List<String> admins;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.members,
    required this.admins,
  });
}

class CallSession {
  final String id;
  final String hostName;
  final String title;
  final String type; // voice/video
  final String status; // ongoing, upcoming, missed, completed
  final DateTime timestamp;
  final Duration duration;

  CallSession({
    required this.id,
    required this.hostName,
    required this.title,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.duration,
  });
}

class FriendRequest {
  final String id;
  final String senderName;
  final String receiverId;
  final String status;

  FriendRequest({
    required this.id,
    required this.senderName,
    required this.receiverId,
    required this.status,
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}
