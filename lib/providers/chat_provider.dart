import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_models.dart';

class ChatProvider with ChangeNotifier {
  List<Channel> _channels = [];
  List<Group> _groups = [];
  List<ChatMessage> _chats = [];
  List<CallSession> _calls = [];
  List<NotificationModel> _notifications = [];

  List<String> _pinnedChats = [];
  List<String> _mutedChats = [];
  List<String> _followedChannels = [];

  List<Channel> get channels => _channels;
  List<Group> get groups => _groups;
  List<ChatMessage> get chats => _chats;
  List<CallSession> get calls => _calls;
  List<NotificationModel> get notifications => _notifications;

  List<String> get pinnedChats => _pinnedChats;
  List<String> get mutedChats => _mutedChats;
  List<String> get followedChannels => _followedChannels;

  ChatProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _pinnedChats = prefs.getStringList('pinned_chats') ?? [];
    _mutedChats = prefs.getStringList('muted_chats') ?? [];
    _followedChannels = prefs.getStringList('followed_channels') ?? [];
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pinned_chats', _pinnedChats);
    await prefs.setStringList('muted_chats', _mutedChats);
    await prefs.setStringList('followed_channels', _followedChannels);
  }

  void togglePinChat(String chatId) {
    if (_pinnedChats.contains(chatId)) {
      _pinnedChats.remove(chatId);
    } else {
      _pinnedChats.add(chatId);
    }
    _savePreferences();
    notifyListeners();
  }

  void toggleMuteChat(String chatId) {
    if (_mutedChats.contains(chatId)) {
      _mutedChats.remove(chatId);
    } else {
      _mutedChats.add(chatId);
    }
    _savePreferences();
    notifyListeners();
  }

  void toggleFollowChannel(String channelId) {
    if (_followedChannels.contains(channelId)) {
      _followedChannels.remove(channelId);
    } else {
      _followedChannels.add(channelId);
    }
    _savePreferences();
    notifyListeners();
  }

  void sendMessage(ChatMessage message) {
    _chats.add(message);
    notifyListeners();
  }

  void reactToMessage(String messageId, String reaction, String userId) {
    final index = _chats.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      final message = _chats[index];
      final Map<String, List<String>> newReactions = Map.from(message.reactions);
      
      if (newReactions.containsKey(reaction)) {
        if (!newReactions[reaction]!.contains(userId)) {
          newReactions[reaction]!.add(userId);
        }
      } else {
        newReactions[reaction] = [userId];
      }

      _chats[index] = ChatMessage(
        id: message.id,
        senderId: message.senderId,
        text: message.text,
        timestamp: message.timestamp,
        isRead: message.isRead,
        isDelivered: message.isDelivered,
        type: message.type,
        replyToMessageId: message.replyToMessageId,
        reactions: newReactions,
        filePath: message.filePath,
      );
      notifyListeners();
    }
  }

  void setInitialData({
    List<Channel>? channels,
    List<Group>? groups,
    List<ChatMessage>? chats,
    List<CallSession>? calls,
    List<NotificationModel>? notifications,
  }) {
    if (channels != null) _channels = channels;
    if (groups != null) _groups = groups;
    if (chats != null) _chats = chats;
    if (calls != null) _calls = calls;
    if (notifications != null) _notifications = notifications;
    notifyListeners();
  }
}
