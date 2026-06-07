import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'database_helper.dart';
import 'pages/chat/calls_page.dart';
import 'pages/chat/channels_page.dart';
import 'pages/chat/groups_page.dart';
import 'pages/chat/notifications_page.dart';
import 'pages/other_user_profile_page.dart';
import 'pages/chat/call_screen.dart';

// Expanded Message Types to handle all requesting interaction modules
enum MessageType { text, voice, sticker, image, poll }

class CoStar {
  final String name;
  final int level;
  final String lastMessage;
  final int streak;
  final String avatarUrl;
  final String time;
  final int unreadCount;

  CoStar({
    required this.name,
    required this.level,
    required this.lastMessage,
    required this.streak,
    required this.avatarUrl,
    required this.time,
    this.unreadCount = 0,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageType type;
  final String? duration; // For voice notes
  final String? filePath; // For picked local image assets/stickers
  
  final String? pollQuestion;
  final List<String>? pollOptions;
  final List<int>? pollVotes;
  final bool isRead;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.type = MessageType.text,
    this.duration,
    this.filePath,
    this.pollQuestion,
    this.pollOptions,
    this.pollVotes,
    this.isRead = false,
  });
}

class AppStateManager {
  static List<CoStar> _allChats = [];
  static final ValueNotifier<List<CoStar>> activeChats = ValueNotifier([]);

  static Future<void> loadChatsFromSupabase() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserJson = prefs.getString('current_user');
    String? currentUsername;
    if (currentUserJson != null) {
      final userMap = jsonDecode(currentUserJson);
      currentUsername = userMap['username'];
    }

    final users = await DatabaseHelper.instance.getAllUsers(currentUsername);
    _allChats = users.map((u) {
      return CoStar(
        name: u['username'] ?? 'Unknown',
        level: u['level'] ?? 1,
        lastMessage: 'Tap to chat...',
        streak: u['streakCount'] ?? 0,
        avatarUrl: '',
        time: '',
      );
    }).toList();
    activeChats.value = List.from(_allChats);
  }



  
  static void filterChats(String query) {
    if (query.isEmpty) {
      activeChats.value = List.from(_allChats);
    } else {
      activeChats.value = _allChats
          .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  static final ValueNotifier<List<ChatMessage>> messageHistory = ValueNotifier([
    ChatMessage(
      text: 'How does it sound for you?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatMessage(
      text: 'Yes, that sounds good!',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: '', 
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      type: MessageType.voice,
      duration: '3:15',
    ),
  ]);

  static final ValueNotifier<bool> hasPendingRequest = ValueNotifier(true);

  static void addMessage(
    String text, 
    bool isMe, {
    MessageType type = MessageType.text, 
    String? duration,
    String? filePath,
    String? pollQuestion,
    List<String>? pollOptions,
  }) {
    messageHistory.value = [
      ...messageHistory.value,
      ChatMessage(
        text: text,
        isMe: isMe,
        timestamp: DateTime.now(),
        type: type,
        duration: duration,
        filePath: filePath,
        pollQuestion: pollQuestion,
        pollOptions: pollOptions,
        pollVotes: pollOptions != null ? List.filled(pollOptions.length, 0) : null,
      ),
    ];
  }

  static void voteInPoll(int messageIndex, int optionIndex) {
    final updatedList = List<ChatMessage>.from(messageHistory.value);
    final msg = updatedList[messageIndex];
    if (msg.pollVotes != null) {
      final updatedVotes = List<int>.from(msg.pollVotes!);
      updatedVotes[optionIndex] = updatedVotes[optionIndex] + 1;
      
      updatedList[messageIndex] = ChatMessage(
        text: msg.text,
        isMe: msg.isMe,
        timestamp: msg.timestamp,
        type: msg.type,
        pollQuestion: msg.pollQuestion,
        pollOptions: msg.pollOptions,
        pollVotes: updatedVotes,
      );
      messageHistory.value = updatedList;
    }
  }
}

// =======================================================
// MAIN CHAT PAGE CONTAINER
// =======================================================
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF16161A),
          title: const Text('Chats', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Color(0xFFBB86FC)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Color(0xFFEFFF8A)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFFEFFF8A),
            labelColor: Color(0xFFEFFF8A),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Messages'),
              Tab(text: 'Channels'),
              Tab(text: 'Groups'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ConnectionsDashboardPage(),
            ChannelsPage(),
            GroupsPage(),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// CONNECTIONS DASHBOARD (Main Screen)
// =======================================================
class ConnectionsDashboardPage extends StatefulWidget {
  const ConnectionsDashboardPage({super.key});

  @override
  State<ConnectionsDashboardPage> createState() => _ConnectionsDashboardPageState();
}

class _ConnectionsDashboardPageState extends State<ConnectionsDashboardPage> {
  String selectedFilter = "All";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppStateManager.loadChatsFromSupabase();
  }

  void _showRequestsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16161A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ConnectionRequestPage(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: AppStateManager.filterChats,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search matching co-stars...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ValueListenableBuilder<List<CoStar>>(
                    valueListenable: AppStateManager.activeChats,
                    builder: (context, chats, _) {
                      return _buildFilterChip("All", count: chats.length);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip("Live Chat", count: 2),
                  const SizedBox(width: 8),
                  _buildFilterChip("Live Channels"),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: AppStateManager.hasPendingRequest,
            builder: (context, hasRequest, child) {
              if (!hasRequest) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () => _showRequestsBottomSheet(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1B4B), 
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBB86FC).withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_add_alt_1, color: Color(0xFFBB86FC), size: 22),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Review Incoming Requests',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBB86FC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'New',
                          style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Unread Messages',
              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<CoStar>>(
              valueListenable: AppStateManager.activeChats,
              builder: (context, chats, child) {
                if (chats.isEmpty) {
                  return const Center(
                    child: Text("No co-stars match your filter search.", style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivechatPage(starName: chat.name),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              final userJson = prefs.getString('current_user');
                              String? currentUsername;
                              if (userJson != null) {
                                currentUsername = jsonDecode(userJson)['username'];
                              }
                              
                              final users = await DatabaseHelper.instance.getAllUsers();
                              final targetUser = users.firstWhere((u) => u['username'] == chat.name, orElse: () => {});
                              
                              if (context.mounted && targetUser.isNotEmpty && currentUsername != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtherUserProfilePage(
                                      user: targetUser,
                                      currentUsername: currentUsername!,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: const Color(0xFF2E2E38),
                                  child: Text(
                                    chat.name[0],
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (chat.unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFBB86FC),
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                      child: Text(
                                        '${chat.unreadCount}',
                                        style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                                    ),
                                    Text(chat.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  chat.lastMessage,
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {int? count}) {
    final bool isActive = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEFFF8A) : const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 16,
              color: isActive ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black.withOpacity(0.1) : const Color(0xFFBB86FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// =======================================================
// DEDICATED ACTIVE CHAT PAGE
// =======================================================
class ActivechatPage extends StatefulWidget {
  final String starName;
  const ActivechatPage({super.key, required this.starName});

  @override
  State<ActivechatPage> createState() => _ActivechatPageState();
}

class _ActivechatPageState extends State<ActivechatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _showEmoji = false;
  final FocusNode _focusNode = FocusNode();

  bool _isOnline = false;
  String? _currentUser;
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoadingMessages = true;
  StreamSubscription<List<Map<String, dynamic>>>? _messagesSubscription;
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _checkOnlineStatus();
    _initCurrentUser();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showEmoji = false;
        });
      }
    });
  }

  Future<void> _initCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      if (userJson != null) {
        final map = jsonDecode(userJson);
        _currentUser = map['username'];
        
        _messagesSubscription = DatabaseHelper.instance.getMessagesStream(_currentUser!, widget.starName).listen((data) {
          if (mounted) {
            setState(() {
              _messages = data;
              _isLoadingMessages = false;
            });
            if (_messages.length > _previousMessageCount) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }
            _previousMessageCount = _messages.length;
          }
        }, onError: (err) {
          if (mounted) {
            setState(() {
              _isLoadingMessages = false;
            });
          }
        });

        // Mark received messages as read
        DatabaseHelper.instance.markMessagesAsRead(widget.starName, _currentUser!);
      } else {
        setState(() {
          _isLoadingMessages = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingMessages = false;
      });
    }
  }

  Future<void> _checkOnlineStatus() async {
    try {
      final users = await DatabaseHelper.instance.getAllUsers();
      final otherUser = users.firstWhere((u) => u['username'] == widget.starName, orElse: () => {});
      bool isOnline = false;
      if (otherUser.isNotEmpty) {
        String today = DateTime.now().toIso8601String().split('T')[0];
        if (otherUser['lastLoginDate'] == today) {
          isOnline = true;
        }
      }
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
        });
      }
    } catch (e) {
      // ignore
    }
  }

  void _sendMessage(String text, String type, {String? extra}) {
    if (_currentUser != null) {
      final newMsg = {
        'sender': _currentUser!,
        'receiver': widget.starName,
        'text': text,
        'type': type,
        'extra': extra,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      setState(() {
        _messages.add(newMsg);
      });
      _previousMessageCount = _messages.length;
      
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
      
      DatabaseHelper.instance.sendMessage(_currentUser!, widget.starName, text, type, extra: extra);
    }
  }

  void _showDeleteDialog(Map<String, dynamic> data, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16161A),
        title: const Text('Delete Message?', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this message for everyone? This action cannot be undone.', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (_currentUser != null) {
                await DatabaseHelper.instance.deleteMessage(_currentUser!, widget.starName, data['created_at']);
                if (mounted) {
                  setState(() {
                    _messages.removeAt(index);
                  });
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Native Platform Action sheet logic handling Gallery Picker, Realtime Cam, and Interactive Polling Modules
  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16161A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFBB86FC)),
                title: const Text('Upload Image from Phone', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    _sendMessage('', 'image', extra: image.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFBB86FC)),
                title: const Text('Take Active Picture', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    _sendMessage('', 'image', extra: photo.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart, color: Color(0xFFEFFF8A)),
                title: const Text('Create Dynamic Poll', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showCreatePollDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.auto_awesome, color: Colors.amberAccent),
                title: const Text('Create Custom Sticker from Gallery', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? stickerImage = await _picker.pickImage(source: ImageSource.gallery);
                  if (stickerImage != null) {
                    AppStateManager.addMessage('Custom Photo', true, type: MessageType.sticker, filePath: stickerImage.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Interactive Poll Generator Overlay Dialog Blueprint
  void _showCreatePollDialog(BuildContext context) {
    final TextEditingController questionCtrl = TextEditingController();
    final TextEditingController opt1Ctrl = TextEditingController();
    final TextEditingController opt2Ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16161A),
          title: const Text('New Star Poll', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Enter question...', hintStyle: TextStyle(color: Colors.grey)),
              ),
              TextField(
                controller: opt1Ctrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Option 1', hintStyle: TextStyle(color: Colors.grey)),
              ),
              TextField(
                controller: opt2Ctrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Option 2', hintStyle: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (questionCtrl.text.isNotEmpty && opt1Ctrl.text.isNotEmpty && opt2Ctrl.text.isNotEmpty) {
                  AppStateManager.addMessage(
                    '', 
                    true, 
                    type: MessageType.poll,
                    pollQuestion: questionCtrl.text,
                    pollOptions: [opt1Ctrl.text, opt2Ctrl.text],
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Launch', style: TextStyle(color: Color(0xFFEFFF8A))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16161A),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF2E2E38),
              child: Text(
                widget.starName[0], 
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.starName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(_isOnline ? 'Online' : 'Offline', style: TextStyle(color: _isOnline ? const Color(0xFFEFFF8A) : Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Color(0xFFBB86FC)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallScreen(userName: widget.starName, isVideoCall: false),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color(0xFF16161A),
            onSelected: (value) async {
              if (value == 'profile') {
                final prefs = await SharedPreferences.getInstance();
                final userJson = prefs.getString('current_user');
                String? currentUsername;
                if (userJson != null) currentUsername = jsonDecode(userJson)['username'];
                
                final users = await DatabaseHelper.instance.getAllUsers();
                final targetUser = users.firstWhere((u) => u['username'] == widget.starName, orElse: () => {});
                
                if (context.mounted && targetUser.isNotEmpty && currentUsername != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherUserProfilePage(
                        user: targetUser,
                        currentUsername: currentUsername!,
                      ),
                    ),
                  );
                }
              } else if (value == 'mute') {
                final prefs = await SharedPreferences.getInstance();
                final currentUserJson = prefs.getString('current_user');
                if (currentUserJson != null) {
                  final userMap = jsonDecode(currentUserJson);
                  List<dynamic> muted = userMap['muted_users'] ?? [];
                  if (!muted.contains(widget.starName)) muted.add(widget.starName);
                  userMap['muted_users'] = muted;
                  
                  await DatabaseHelper.instance.supabase.from('users').update({
                    'extraData': jsonEncode(userMap),
                  }).eq('username', userMap['username']);
                  
                  await prefs.setString('current_user', jsonEncode(userMap));
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Muted notifications for ${widget.starName}')));
                }
              } else if (value == 'block') {
                final prefs = await SharedPreferences.getInstance();
                final currentUserJson = prefs.getString('current_user');
                if (currentUserJson != null) {
                  final userMap = jsonDecode(currentUserJson);
                  List<dynamic> blocked = userMap['blocked_users'] ?? [];
                  if (!blocked.contains(widget.starName)) blocked.add(widget.starName);
                  userMap['blocked_users'] = blocked;
                  
                  await DatabaseHelper.instance.supabase.from('users').update({
                    'extraData': jsonEncode(userMap),
                  }).eq('username', userMap['username']);
                  
                  await prefs.setString('current_user', jsonEncode(userMap));
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Blocked ${widget.starName}')));
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'profile', child: Text('View Star Profile', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: 'mute', child: Text('Mute Notifications', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: 'block', child: Text('Block User', style: TextStyle(color: Colors.redAccent))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final data = _messages[index];
                      final isMe = data['sender'] == _currentUser;
                      final msgTypeStr = data['type'] ?? 'text';
                      MessageType type = MessageType.text;
                      if (msgTypeStr == 'image') type = MessageType.image;
                      if (msgTypeStr == 'voice') type = MessageType.voice;
                      if (msgTypeStr == 'sticker') type = MessageType.sticker;
                      if (msgTypeStr == 'poll') type = MessageType.poll;

                      final msg = ChatMessage(
                        text: data['text'] ?? '',
                        isMe: isMe,
                        timestamp: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
                        type: type,
                        filePath: (type == MessageType.image || type == MessageType.sticker) ? data['extra'] : null,
                        duration: type == MessageType.voice ? data['extra'] : null,
                        pollQuestion: type == MessageType.poll ? jsonDecode(data['extra'] ?? '{}')['question'] : null,
                        pollOptions: type == MessageType.poll ? List<String>.from(jsonDecode(data['extra'] ?? '{}')['options'] ?? []) : null,
                        isRead: data['is_read'] == true || data['is_read'] == 1,
                      );

                      Widget messageWidget;
                      if (msg.type == MessageType.voice) {
                        messageWidget = _buildVoiceMessage(msg);
                      } else if (msg.type == MessageType.sticker) {
                        messageWidget = _buildStickerMessage(msg);
                      } else if (msg.type == MessageType.image) {
                        messageWidget = _buildImageMessage(msg);
                      } else if (msg.type == MessageType.poll) {
                        messageWidget = _buildPollMessage(msg, index);
                      } else {
                        messageWidget = Align(
                          alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: msg.isMe ? const Color(0xFFBB86FC) : const Color(0xFF16161A),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.text,
                                  style: TextStyle(color: msg.isMe ? Colors.black : Colors.white, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _formatTime(msg.timestamp),
                                      style: TextStyle(
                                        color: msg.isMe ? Colors.black54 : Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    if (msg.isMe) ...[
                                      const SizedBox(width: 4),
                                      _buildTicks(msg),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onLongPress: msg.isMe ? () => _showDeleteDialog(data, index) : null,
                        child: messageWidget,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16161A),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(_showEmoji ? Icons.keyboard : Icons.sentiment_satisfied_alt, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _showEmoji = !_showEmoji;
                              if (_showEmoji) {
                                _focusNode.unfocus();
                              } else {
                                _focusNode.requestFocus();
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            focusNode: _focusNode,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file, color: Colors.grey),
                          onPressed: () => _showAttachmentMenu(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _sendMessage(_messageController.text.trim(), 'text');
                      _messageController.clear();
                    }
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFFF8A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.send, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
          if (_showEmoji)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: _messageController,
                config: const Config(),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    int hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    String minute = time.minute.toString().padLeft(2, '0');
    String ampm = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $ampm";
  }

  Widget _buildTicks(ChatMessage msg) {
    if (!msg.isMe) return const SizedBox.shrink();
    if (msg.isRead) {
      return const Icon(Icons.done_all, color: Colors.blue, size: 14);
    } else if (_isOnline) {
      return const Icon(Icons.done_all, color: Colors.black54, size: 14);
    } else {
      return const Icon(Icons.check, color: Colors.black54, size: 14);
    }
  }

  Widget _buildVoiceMessage(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        width: 250,
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFFBB86FC) : const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: msg.isMe ? Colors.white.withOpacity(0.3) : const Color(0xFF232329),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow, color: msg.isMe ? Colors.black : Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(15, (index) {
                  return Container(
                    width: 2,
                    height: (index % 3 == 0) ? 16 : (index % 2 == 0) ? 10 : 6,
                    color: msg.isMe ? Colors.black87 : Colors.grey,
                  );
                }),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  msg.duration ?? "0:00",
                  style: TextStyle(color: msg.isMe ? Colors.black87 : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(msg.timestamp),
                      style: TextStyle(color: msg.isMe ? Colors.black54 : Colors.grey, fontSize: 11),
                    ),
                    if (msg.isMe) ...[
                      const SizedBox(width: 4),
                      _buildTicks(msg),
                    ]
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStickerMessage(ChatMessage msg) {
    final hasFile = msg.filePath != null;
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFFBB86FC).withOpacity(0.8) : const Color(0xFF4B429F),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: hasFile 
                ? Image.file(File(msg.filePath!), fit: BoxFit.cover)
                : Center(
                    child: Text(
                      "${msg.text}\nSticker", 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: msg.isMe ? Colors.white : Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageMessage(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF16161A), width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: msg.filePath != null 
            ? Image.file(File(msg.filePath!))
            : const Padding(
                padding: EdgeInsets.all(16),
                child: Text("Missing Image Metadata File Source", style: TextStyle(color: Colors.red)),
              ),
      ),
    );
  }

  Widget _buildPollMessage(ChatMessage msg, int msgIndex) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        width: 260,
        decoration: BoxDecoration(
          color: const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBB86FC).withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Color(0xFFEFFF8A), size: 18),
                const SizedBox(width: 6),
                Text('CO-STAR POLL', style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(msg.pollQuestion ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            ...?msg.pollOptions?.asMap().entries.map((entry) {
              int idx = entry.key;
              String optionText = entry.value;
              int votes = msg.pollVotes?[idx] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () => AppStateManager.voteInPoll(msgIndex, idx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2E38),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(optionText, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFEFFF8A), borderRadius: BorderRadius.circular(6)),
                          child: Text('$votes v', style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// REQUESTS BOTTOM SHEET VIEW
// =======================================================
class ConnectionRequestPage extends StatefulWidget {
  const ConnectionRequestPage({super.key});

  @override
  State<ConnectionRequestPage> createState() => _ConnectionRequestPageState();
}

class _ConnectionRequestPageState extends State<ConnectionRequestPage> {
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;
  String? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _currentUser = jsonDecode(userJson)['username'];
      if (_currentUser != null) {
        final reqs = await DatabaseHelper.instance.getPendingFriendRequests(_currentUser!);
        if (mounted) {
          setState(() {
            _requests = reqs;
            _isLoading = false;
          });
        }
        return;
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _acceptRequest(String sender) async {
    if (_currentUser != null) {
      await DatabaseHelper.instance.acceptFriendRequest(sender, _currentUser!);
      _loadRequests();
    }
  }

  Future<void> _declineRequest(String sender) async {
    if (_currentUser != null) {
      await DatabaseHelper.instance.declineFriendRequest(sender, _currentUser!);
      _loadRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Connection Requests',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Review incoming connection requests here.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)))
          else if (_requests.isEmpty)
            Center(
              child: Text(
                'No new requests right now!',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  final sender = _requests[index]['sender'];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFBB86FC),
                      child: Text(sender[0].toUpperCase(), style: const TextStyle(color: Colors.black)),
                    ),
                    title: Text(sender, style: const TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Color(0xFFEFFF8A)),
                          onPressed: () => _acceptRequest(sender),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.redAccent),
                          onPressed: () => _declineRequest(sender),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}