import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'character_select_screen.dart';
import 'main_game_screen.dart';
import '../../core/services/storage_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context, listen: false);
    final hasExistingSave = storage.getCurrentSave() != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 主要内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'LoveMe',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'AI驱动的恋爱模拟游戏',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CharacterSelectScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('开始恋爱'),
                ),
                if (hasExistingSave) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MainGameScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      textStyle: const TextStyle(fontSize: 20),
                      side: const BorderSide(color: Colors.pinkAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('继续游戏', style: TextStyle(color: Colors.pinkAccent)),
                  ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    _showHistoryDialog(context);
                  },
                  child: const Text(
                    '历史回顾',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          // 底部角色图片
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/lin_xiaoyu.png',
              height: 280,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('历史回顾'),
        content: const SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Center(
            child: Text('暂无历史记录'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
