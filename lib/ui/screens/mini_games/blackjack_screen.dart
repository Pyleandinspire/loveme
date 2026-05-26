import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/game_save.dart';
import '../../../core/services/storage_service.dart';

class BlackjackScreen extends StatefulWidget {
  const BlackjackScreen({super.key});

  @override
  State<BlackjackScreen> createState() => _BlackjackScreenState();
}

class _BlackjackScreenState extends State<BlackjackScreen> {
  final List<String> _deck = [];
  List<String> _playerHand = [];
  List<String> _dealerHand = [];
  bool _gameOver = false;
  bool _playerWon = false;
  bool _isDealerTurn = false;

  @override
  void initState() {
    super.initState();
    _initDeck();
    _dealCards();
  }

  void _initDeck() {
    const suits = ['♠', '♣', '♥', '♦'];
    const ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];
    for (final suit in suits) {
      for (final rank in ranks) {
        _deck.add('$rank$suit');
      }
    }
    _deck.shuffle();
  }

  String _drawCard() {
    return _deck.removeAt(0);
  }

  void _dealCards() {
    _playerHand = [_drawCard(), _drawCard()];
    _dealerHand = [_drawCard(), _drawCard()];
  }

  int _calculateScore(List<String> hand) {
    int score = 0;
    int aces = 0;

    for (final card in hand) {
      final rank = card.substring(0, card.length - 1);
      if (rank == 'A') {
        aces++;
        score += 11;
      } else if (['K', 'Q', 'J'].contains(rank)) {
        score += 10;
      } else {
        score += int.parse(rank);
      }
    }

    while (score > 21 && aces > 0) {
      score -= 10;
      aces--;
    }

    return score;
  }

  void _hit() {
    if (_gameOver) return;
    setState(() => _playerHand.add(_drawCard()));

    if (_calculateScore(_playerHand) > 21) {
      _endGame(false);
    }
  }

  Future<void> _stand() async {
    if (_gameOver) return;
    setState(() => _isDealerTurn = true);

    while (_calculateScore(_dealerHand) < 17) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _dealerHand.add(_drawCard()));
    }

    final playerScore = _calculateScore(_playerHand);
    final dealerScore = _calculateScore(_dealerHand);

    bool won;
    if (dealerScore > 21) {
      won = true;
    } else if (playerScore > dealerScore) {
      won = true;
    } else if (playerScore < dealerScore) {
      won = false;
    } else {
      won = false;
    }

    _endGame(won);
  }

  Future<void> _endGame(bool won) async {
    setState(() {
      _gameOver = true;
      _playerWon = won;
    });

    final storage = Provider.of<StorageService>(context, listen: false);
    final save = storage.getCurrentSave();
    if (save != null) {
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
          content: Text(won ? '好感度 +10' : '下次再努力吧！'),
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
      _deck.clear();
      _playerHand.clear();
      _dealerHand.clear();
      _gameOver = false;
      _playerWon = false;
      _isDealerTurn = false;
    });
    _initDeck();
    _dealCards();
  }

  Widget _buildCard(String card, bool hidden) {
    return Container(
      width: 60,
      height: 84,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: hidden ? Colors.blue[800] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: hidden
          ? const Center(
              child: Icon(Icons.question_mark, color: Colors.white, size: 32),
            )
          : Center(
              child: Text(
                card,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ['♥', '♦'].contains(card.substring(card.length - 1))
                      ? Colors.red
                      : Colors.black,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('21点'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('AI 的牌', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _dealerHand.asMap().entries.map((entry) {
                      final index = entry.key;
                      final card = entry.value;
                      return _buildCard(card, !_gameOver && !_isDealerTurn && index > 0);
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  if (_gameOver || _isDealerTurn)
                    Text('点数: ${_calculateScore(_dealerHand)}'),
                ],
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('你的牌', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _playerHand.map((card) => _buildCard(card, false)).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text('点数: ${_calculateScore(_playerHand)}'),
                ],
              ),
            ),
            if (!_gameOver) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _hit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('要牌', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _stand,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('停牌', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
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
}
