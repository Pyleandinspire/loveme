import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/models/game_save.dart';
import '../../../core/services/storage_service.dart';

class IdiomSolitaireScreen extends StatefulWidget {
  const IdiomSolitaireScreen({super.key});

  @override
  State<IdiomSolitaireScreen> createState() => _IdiomSolitaireScreenState();
}

class _IdiomSolitaireScreenState extends State<IdiomSolitaireScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _history = [];
  final List<String> _idioms = [];
  String _currentIdiom = '';
  int _score = 0;
  bool _gameOver = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadIdioms();
  }

  Future<void> _loadIdioms() async {
    final jsonString = await rootBundle.loadString('assets/idioms.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      _idioms.addAll((jsonData['idioms'] as List).cast<String>());
      _currentIdiom = _idioms[DateTime.now().millisecond % _idioms.length];
      _history.add(_currentIdiom);
      _loading = false;
    });
  }

  String _getLastChar(String idiom) {
    return String.fromCharCode(idiom.runes.last);
  }

  String _getFirstChar(String idiom) {
    return String.fromCharCode(idiom.runes.first);
  }

  Future<void> _submitIdiom() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    if (!_idioms.contains(input)) {
      _showMessage('这个不是成语哦~');
      return;
    }

    if (_history.contains(input)) {
      _showMessage('这个成语已经用过啦~');
      return;
    }

    if (_getFirstChar(input) != _getLastChar(_currentIdiom)) {
      _showMessage('不对哦，要以 "${_getLastChar(_currentIdiom)}" 开头~');
      return;
    }

    setState(() {
      _history.add(input);
      _currentIdiom = input;
      _score += 10;
    });
    _controller.clear();

    await Future.delayed(const Duration(milliseconds: 800));
    await _aiTurn();
  }

  Future<void> _aiTurn() async {
    final lastChar = _getLastChar(_currentIdiom);
    final validIdioms = _idioms.where((idiom) =>
        _getFirstChar(idiom) == lastChar && !_history.contains(idiom)).toList();

    if (validIdioms.isEmpty) {
      _endGame(true);
      return;
    }

    final nextIdiom = validIdioms[DateTime.now().millisecond % validIdioms.length];
    setState(() {
      _history.add(nextIdiom);
      _currentIdiom = nextIdiom;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _endGame(bool won) async {
    setState(() => _gameOver = true);

    final storage = Provider.of<StorageService>(context, listen: false);
    final save = storage.getCurrentSave();
    if (save != null) {
      save.lastGameContextTag = won ? 'Idiom_Win' : 'Idiom_Lose';
      if (won) {
        save.affection = (save.affection + 10).clamp(0, 1000);
      }
      storage.updateGameSave(save);
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(won ? '你赢了！🎉' : '你输了😢'),
          content: Text(won ? '得分: $_score，好感度 +10' : '得分: $_score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: const Text('再来一局'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('返回'),
            ),
          ],
        ),
      );
    }
  }

  void _resetGame() {
    setState(() {
      _history.clear();
      _currentIdiom = _idioms[DateTime.now().millisecond % _idioms.length];
      _history.add(_currentIdiom);
      _score = 0;
      _gameOver = false;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('成语接龙'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('得分: $_score', style: const TextStyle(fontSize: 18)),
                          Text('回合: ${_history.length}', style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final idiom = _history[index];
                        final isAi = index % 2 == 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment:
                                isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isAi ? Colors.pink[100] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  idiom,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (!_gameOver)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '请接以 "${_getLastChar(_currentIdiom)}" 开头的成语',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '输入成语...',
                                  ),
                                  onSubmitted: (_) => _submitIdiom(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _submitIdiom,
                                icon: const Icon(Icons.send),
                                color: Colors.pink,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (_gameOver)
                    ElevatedButton(
                      onPressed: _resetGame,
                      child: const Text('再来一局'),
                    ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
