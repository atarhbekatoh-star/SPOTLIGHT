import 'package:flutter/material.dart';

class CoStar {
  final String name;
  final int level;
  final String lastMessage;
  final int streak;
  final String avatarUrl;

  CoStar({
    required this.name,
    required this.level,
    required this.lastMessage,
    required this.streak,
    required this.avatarUrl,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}

class AppStateManager {
  static final ValueNotifier<List<CoStar>> activeChats = ValueNotifier([
    CoStar(
      name: 'Avery',
      level: 3,
      lastMessage: 'Well, we were rooming together...',
      streak: 5,
      avatarUrl: '',
    ),

    CoStar(
      name: 'Jordan',
      level: 5,
      lastMessage: 'Haha you here?',
      streak: 3,
      avatarUrl: '',
    ),

    CoStar(
      name: 'Malrin',
      level: 3,
      lastMessage: 'We\'ll go to try out your new...',
      streak: 4,
      avatarUrl: '',
    ),
  ]);

  static final ValueNotifier<List<ChatMessage>> messageHistory =
      ValueNotifier([
        ChatMessage(
          text:
              'Hi shonn! Start a conversation with someone new. Make eye contact, smile, and say hello. You\'ve got this!',
          isMe: false,
          timestamp: DateTime.now(),
        ),
      ]);

  static final ValueNotifier<bool> hasPendingRequest =
      ValueNotifier(true);

  static void addMessage(String text, bool isMe) {
    messageHistory.value = [
      ...messageHistory.value,
      ChatMessage(
        text: text,
        isMe: isMe,
        timestamp: DateTime.now(),
      ),
    ];
  }
}

// =======================================================
// MAIN CHAT PAGE
// =======================================================

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF000000),
      body: MainNavigationHub(),
    );
  }
}

// =======================================================
// NEW TOP TAB NAVIGATION
// =======================================================

class MainNavigationHub extends StatelessWidget {
  const MainNavigationHub({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,

      child: Scaffold(
        backgroundColor: const Color(0xFF000000),

        appBar: AppBar(
          backgroundColor: const Color(0xFF0F0F11),
          elevation: 0,

          title: const Text(
            "Co-Star Hub",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          actions: [
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),

              color: const Color(0xFF1A1A1D),

              onSelected: (value) {
                if (value == "settings") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Settings coming soon"),
                    ),
                  );
                }

                if (value == "logout") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Logout coming soon"),
                    ),
                  );
                }
              },

              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "settings",
                  child: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const PopupMenuItem(
                  value: "logout",
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],

          bottom: const TabBar(
            indicatorColor: Color(0xFFA855F7),

            labelColor: Colors.white,

            unselectedLabelColor: Colors.grey,

            tabs: [
              Tab(
                icon: Icon(Icons.people),
                text: "Connections",
              ),

              Tab(
                icon: Icon(Icons.chat_bubble),
                text: "Chat",
              ),

              Tab(
                icon: Icon(Icons.person),
                text: "Profile",
              ),

              Tab(
                icon: Icon(Icons.person_add_alt_1),
                text: "Requests",
              ),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            ConnectionsDashboardPage(),
            ActivechatPage(),
            CoStarProfilePage(),
            ConnectionRequestPage(),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// REQUESTS PAGE
// =======================================================

class ConnectionRequestPage extends StatelessWidget {
  const ConnectionRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            'Connection Requests',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 12),

          Text(
            'Review incoming connection requests here.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// CONNECTIONS PAGE
// =======================================================

class ConnectionsDashboardPage extends StatelessWidget {
  const ConnectionsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Connections',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFF121214),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    child: const Text(
                      'Hey Sam! 👋',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFFA855F7),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Expanded(
            child: ValueListenableBuilder<List<CoStar>>(
              valueListenable:
                  AppStateManager.activeChats,

              builder: (context, chats, child) {
                return ListView.separated(
                  itemCount: chats.length,

                  separatorBuilder:
                      (_, __) =>
                          const SizedBox(height: 12),

                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    return Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: const Color(0xFF121214),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                const Color(0xFF2E2E38),

                            child: Text(
                              chat.name[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                Text(
                                  '${chat.name} (Lv. ${chat.level})',

                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  chat.lastMessage,

                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),

                                  maxLines: 1,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,
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
}

// =======================================================
// ACTIVE CHAT PAGE
// =======================================================

class ActivechatPage extends StatefulWidget {
  const ActivechatPage({super.key});

  @override
  State<ActivechatPage> createState() =>
      _ActivechatPageState();
}

class _ActivechatPageState
    extends State<ActivechatPage> {
  final TextEditingController _messageController =
      TextEditingController();

  final List<String> sparks = [
    "Ask about their recent skill unlock",
    "Share a challenge you faced",
    "Suggest a weekend meet-up"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder<List<ChatMessage>>(
            valueListenable:
                AppStateManager.messageHistory,

            builder: (context, messages, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: messages.length,

                itemBuilder: (context, index) {
                  final msg = messages[index];

                  return Align(
                    alignment:
                        msg.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(
                            vertical: 4,
                          ),

                      padding:
                          const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color:
                            msg.isMe
                                ? const Color(
                                  0xFF5B21B6,
                                )
                                : const Color(
                                  0xFF1E1B4B,
                                ),

                        borderRadius:
                            BorderRadius.circular(16),
                      ),

                      child: Text(
                        msg.text,

                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Type a message...',

                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),

                    fillColor:
                        const Color(0xFF121214),

                    filled: true,

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(24),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              CircleAvatar(
                backgroundColor:
                    const Color(0xFF7C3AED),

                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),

                  onPressed: () {
                    if (_messageController.text
                        .trim()
                        .isNotEmpty) {
                      AppStateManager.addMessage(
                        _messageController.text.trim(),
                        true,
                      );

                      _messageController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =======================================================
// PROFILE PAGE
// =======================================================

class CoStarProfilePage extends StatelessWidget {
  const CoStarProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Co-Star Profile",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }
}