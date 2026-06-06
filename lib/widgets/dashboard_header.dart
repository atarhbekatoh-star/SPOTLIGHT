import 'package:flutter/material.dart';
import '../database_helper.dart';

class DashboardHeader extends StatefulWidget {
  final VoidCallback onProfileTap;
  final String userName;
  final VoidCallback? onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.onProfileTap,
    required this.userName,
    this.onNotificationTap,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  int _streakCount = 0;
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    int streak = await DatabaseHelper.instance.getStreak(widget.userName);
    List<Map<String, dynamic>> notifications =
        await DatabaseHelper.instance.getNotifications(widget.userName);
    int unread = notifications.where((n) => n['read'] == false).length;

    if (mounted) {
      setState(() {
        _streakCount = streak;
        _unreadNotifications = unread;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hey ${widget.userName}! 👋",
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
            ),
            Row(
              children: [
                // Streak badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(30),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$_streakCount",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                // Notification bell with badge
                GestureDetector(
                  onTap: widget.onNotificationTap ?? () => _showNotificationsSheet(context),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.notifications_none, color: theme.iconTheme.color),
                      if (_unreadNotifications > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _unreadNotifications > 9 ? '9+' : '$_unreadNotifications',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                "Small steps.\nBig confidence.",
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 32),
              ),
            ),
            GestureDetector(
              onTap: widget.onProfileTap,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [const Color(0xFFBB86FC), const Color(0xFFBB86FC).withAlpha(150)],
                      ),
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFFBB86FC),
                    child: Icon(Icons.add, size: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showNotificationsSheet(BuildContext context) async {
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color cardBackground = Color(0xFF11162D);
    
    List<Map<String, dynamic>> notifications = 
        await DatabaseHelper.instance.getNotifications(widget.userName);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF060914),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '🔔 Notifications',
                style: TextStyle(
                  color: purpleGlow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              if (notifications.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.notifications_off_outlined, 
                          color: purpleGlow.withAlpha(80), size: 50),
                        const SizedBox(height: 10),
                        Text('No notifications yet',
                          style: TextStyle(color: Colors.white.withAlpha(100))),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: notif['read'] == false
                                ? purpleGlow.withAlpha(80)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: purpleGlow.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                notif['read'] == false
                                    ? Icons.notifications_active
                                    : Icons.notifications_none,
                                color: purpleGlow,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notif['title'] ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: notif['read'] == false
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notif['body'] ?? '',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(120),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
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
      },
    );
  }
}
