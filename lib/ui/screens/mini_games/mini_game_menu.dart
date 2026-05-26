import 'package:flutter/material.dart';
import 'blackjack_screen.dart';
import 'idiom_solitaire_screen.dart';
import 'focus_timer_screen.dart';

class MiniGameMenu extends StatelessWidget {
  const MiniGameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('小游戏'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGameCard(
            context,
            icon: Icons.casino,
            title: '21点',
            description: '与 AI 一起来玩经典的21点纸牌游戏',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BlackjackScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildGameCard(
            context,
            icon: Icons.book,
            title: '成语接龙',
            description: '来一场有趣的成语接龙比赛',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IdiomSolitaireScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildGameCard(
            context,
            icon: Icons.timer,
            title: '专注时钟',
            description: '让 AI 陪你一起专注学习',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FocusTimerScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: Colors.pink),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
