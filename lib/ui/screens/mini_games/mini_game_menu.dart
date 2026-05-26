import 'package:flutter/material.dart';

class MiniGameMenu extends StatelessWidget {
  const MiniGameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('休闲小游戏'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildGameCard(
            context,
            '21点',
            Icons.casino,
            Colors.red,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BlackjackGame()),
            ),
          ),
          _buildGameCard(
            context,
            '成语接龙',
            Icons.quiz,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IdiomGame()),
            ),
          ),
          _buildGameCard(
            context,
            '专注时钟',
            Icons.timer,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FocusTimerGame()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 21点游戏
class BlackjackGame extends StatefulWidget {
  const BlackjackGame({super.key});

  @override
  State<BlackjackGame> createState() => _BlackjackGameState();
}

class _BlackjackGameState extends State<BlackjackGame> {
  final List<String> _playerCards = [];
  final List<String> _dealerCards = [];
  bool _playerStand = false;
  bool _gameOver = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _playerCards.clear();
    _dealerCards.clear();
    _playerStand = false;
    _gameOver = false;
    _result = '';
    _hit();
    _hit();
    _dealerHit();
    _dealerHit();
  }

  int _getCardValue(String card) {
    if (card.contains('A')) return 11;
    if (card.contains('K') || card.contains('Q') || card.contains('J')) return 10;
    return int.parse(card.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  int _calculateScore(List<String> cards) {
    int score = 0;
    int aces = 0;
    for (final card in cards) {
      score += _getCardValue(card);
      if (card.contains('A')) aces++;
    }
    while (score > 21 && aces > 0) {
      score -= 10;
      aces--;
    }
    return score;
  }

  void _hit() {
    if (_gameOver) return;
    final suits = ['♠', '♥', '♦', '♣'];
    final ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
    final card = '${ranks[DateTime.now().microsecond % 13]}${suits[DateTime.now().millisecond % 4]}';
    setState(() => _playerCards.add(card));
    if (_calculateScore(_playerCards) > 21) {
      _endGame('你输了！');
    }
  }

  void _dealerHit() {
    while (_calculateScore(_dealerCards) < 17) {
      final suits = ['♠', '♥', '♦', '♣'];
      final ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
      final card = '${ranks[DateTime.now().microsecond % 13]}${suits[DateTime.now().millisecond % 4]}';
      _dealerCards.add(card);
    }
  }

  void _stand() {
    if (_gameOver) return;
    _playerStand = true;
    _dealerHit();
    final playerScore = _calculateScore(_playerCards);
    final dealerScore = _calculateScore(_dealerCards);
    if (dealerScore > 21) {
      _endGame('你赢了！');
    } else if (playerScore > dealerScore) {
      _endGame('你赢了！');
    } else if (playerScore < dealerScore) {
      _endGame('你输了！');
    } else {
      _endGame('平局！');
    }
  }

  void _endGame(String result) {
    setState(() {
      _gameOver = true;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('21点'), backgroundColor: Colors.red),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('庄家', style: TextStyle(fontSize: 20)),
          Text('${_calculateScore(_dealerCards)}', style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _dealerCards.map((c) => _buildCard(c)).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _playerCards.map((c) => _buildCard(c)).toList(),
          ),
          const SizedBox(height: 16),
          Text('${_calculateScore(_playerCards)}', style: const TextStyle(fontSize: 32)),
          const Text('你', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 32),
          if (_gameOver)
            Column(
              children: [
                Text(_result, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: _startGame, child: const Text('再玩一次')),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _hit, child: const Text('要牌')),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: _stand, child: const Text('停牌')),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCard(String card) {
    final isRed = card.contains('♥') || card.contains('♦');
    return Container(
      width: 50,
      height: 70,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(card, style: TextStyle(fontSize: 16, color: isRed ? Colors.red : Colors.black)),
      ),
    );
  }
}

// 成语接龙游戏
class IdiomGame extends StatefulWidget {
  const IdiomGame({super.key});

  @override
  State<IdiomGame> createState() => _IdiomGameState();
}

class _IdiomGameState extends State<IdiomGame> {
  final List<String> _idioms = ['一帆风顺', '顺其自然', '然荻读书', '书声琅琅'];
  final TextEditingController _controller = TextEditingController();
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('成语接龙'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                const Text('当前成语: ', style: TextStyle(fontSize: 18)),
                Text(
                  _idioms.last,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _idioms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_idioms[index], style: const TextStyle(fontSize: 18)),
                  leading: CircleAvatar(child: Text('${index + 1}')),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '输入下一个成语',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _checkIdiom,
                  child: const Text('确认'),
                ),
              ],
            ),
          ),
          Text('得分: $_score', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _checkIdiom() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final lastChar = _idioms.last[_idioms.last.length - 1];
    final firstChar = input[0];

    if (lastChar == firstChar) {
      setState(() {
        _idioms.add(input);
        _score += 10;
        _controller.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('错误！需要以"$lastChar"开头的成语')),
      );
    }
  }
}

// 专注时钟游戏
class FocusTimerGame extends StatefulWidget {
  const FocusTimerGame({super.key});

  @override
  State<FocusTimerGame> createState() => _FocusTimerGameState();
}

class _FocusTimerGameState extends State<FocusTimerGame> {
  int _seconds = 0;
  int _duration = 25 * 60;
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('专注时钟'), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 8),
              ),
              child: Center(
                child: Text(
                  '$minutes:$secs',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _isRunning ? '专注中...' : '点击开始专注',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _start,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('开始'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isRunning ? _pause : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('暂停'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('重置'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Slider(
              value: _duration.toDouble(),
              min: 5 * 60,
              max: 60 * 60,
              divisions: 11,
              label: '${_duration ~/ 60}分钟',
              onChanged: _isRunning ? null : (value) => setState(() => _duration = value.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  void _start() {
    _isRunning = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isRunning) return false;
      setState(() {
        if (_seconds < _duration) {
          _seconds++;
        } else {
          _isRunning = false;
          _showComplete();
        }
      });
      return _isRunning && _seconds < _duration;
    });
  }

  void _pause() => setState(() => _isRunning = false);

  void _reset() => setState(() {
        _isRunning = false;
        _seconds = 0;
      });

  void _showComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('太棒了！'),
        content: Text('你完成了${_duration ~/ 60}分钟的专注！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
