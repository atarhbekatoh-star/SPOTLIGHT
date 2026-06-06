import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    const Color bgDark = Color(0xFF0D0D0F);
    const Color cardDark = Color(0xFF16161A);
    const Color accentColor = Color(0xFFBB86FC);
    const Color highlightColor = Color(0xFFEFFF8A);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Spotlight Shop",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(40),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withAlpha(80)),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: highlightColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  "${appProvider.credits}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2B1842), cardDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentColor.withAlpha(50)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shopping_bag, color: accentColor, size: 40),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unlock Premium Items!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Spend your earned credits on exclusive avatars, themes, and stickers.",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildCategorySection("Avatars", [
              _ShopItem(id: "avatar_1", name: "Neon Fox", cost: 150, icon: Icons.face, color: Colors.orange),
              _ShopItem(id: "avatar_2", name: "Cyber Samurai", cost: 300, icon: Icons.sports_martial_arts, color: Colors.redAccent),
            ], appProvider, context),
            const SizedBox(height: 25),
            _buildCategorySection("Profile Themes", [
              _ShopItem(id: "theme_synth", name: "Synthwave", cost: 500, icon: Icons.color_lens, color: Colors.purpleAccent),
              _ShopItem(id: "theme_hacker", name: "Matrix Green", cost: 400, icon: Icons.terminal, color: Colors.greenAccent),
            ], appProvider, context),
            const SizedBox(height: 25),
            _buildCategorySection("Stickers", [
              _ShopItem(id: "sticker_gg", name: "GG Flame", cost: 50, icon: Icons.local_fire_department, color: Colors.deepOrange),
              _ShopItem(id: "sticker_star", name: "Super Star", cost: 50, icon: Icons.star, color: highlightColor),
            ], appProvider, context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<_ShopItem> items, AppProvider appProvider, BuildContext context) {
    const Color accentColor = Color(0xFFBB86FC);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.category, color: accentColor, size: 18),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: accentColor,
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final bool isUnlocked = appProvider.unlockedItems.contains(item.id);
            return _ShopItemCard(item: item, isUnlocked: isUnlocked, provider: appProvider);
          },
        ),
      ],
    );
  }
}

class _ShopItem {
  final String id;
  final String name;
  final int cost;
  final IconData icon;
  final Color color;

  _ShopItem({required this.id, required this.name, required this.cost, required this.icon, required this.color});
}

class _ShopItemCard extends StatelessWidget {
  final _ShopItem item;
  final bool isUnlocked;
  final AppProvider provider;

  const _ShopItemCard({required this.item, required this.isUnlocked, required this.provider});

  @override
  Widget build(BuildContext context) {
    const Color cardDark = Color(0xFF16161A);
    const Color accentColor = Color(0xFFBB86FC);
    const Color highlightColor = Color(0xFFEFFF8A);

    return Container(
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? accentColor.withAlpha(80) : Colors.white10,
        ),
        boxShadow: isUnlocked
            ? [BoxShadow(color: accentColor.withAlpha(20), blurRadius: 15, spreadRadius: 2)]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: item.color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 40, color: item.color),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (isUnlocked)
            const Text(
              "Owned",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            GestureDetector(
              onTap: () {
                bool success = provider.purchaseItem(item.id, item.cost);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Successfully purchased ${item.name}!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Not enough credits!"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: highlightColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: highlightColor.withAlpha(50)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, color: highlightColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "${item.cost}",
                      style: const TextStyle(
                        color: highlightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
