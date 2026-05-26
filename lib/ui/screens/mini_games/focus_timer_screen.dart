import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/game_save.dart';
import '../../../core/services/storage_service.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  Timer? _timer;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  bool _isPaused = false;
  final List<int> _durations = [25, 30, 45];
  int _selectedDurationIndex = 0;
  final TextEditingController _taskController = TextEditingController();

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _onComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = _durations[_selectedDurationIndex] * 60;
    });
  }

  Future<void> _onComplete() async {
    setState(() => _isRunning = false);

    final storage = Provider.of<StorageService>(context, listen: false);
    final save = storage.getCurrentSave();
    if (save != null) {
      save.lastGameContextTag = 'Focus_Success';
      save.affection = (save.affection + 15).clamp(0, 1000);
      storage.updateGameSave(save);
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('太棒了！🎉'),
          content: const Text('你成功完成了专注！好感度 +15'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetTimer();
              },
              child: const Text('再来一次'),
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

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('专注时钟'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      '专注时长',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _durations.asMap().entries.map((entry) {
                        final index = entry.key;
                        final duration = entry.value;
                        final isSelected = index == _selectedDurationIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ChoiceChip(
                            label: Text('${duration}分钟'),
                            selected: isSelected,
                            onSelected: _isRunning
                                ? null
                                : (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedDurationIndex = index;
                                        _remainingSeconds = duration * 60;
                                      });
                                    }
                                  },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    labelText: '本次专注任务（可选）',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isRunning,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: _remainingSeconds /
                                (_durations[_selectedDurationIndex] * 60),
                            strokeWidth: 12,
                            backgroundColor: Colors.pink[100],
                            valueColor: const AlwaysStoppedAnimation(Colors.pink),
                          ),
                        ),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isRunning && !_isPaused)
                          ElevatedButton(
                            onPressed: _startTimer,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text('开始专注'),
                          ),
                        if (_isRunning) ...[
                          ElevatedButton(
                            onPressed: _pauseTimer,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            child: const Icon(Icons.pause),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: _resetTimer,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            child: const Icon(Icons.refresh),
                          ),
                        ],
                        if (_isPaused) ...[
                          ElevatedButton(
                            onPressed: _resumeTimer,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Icon(Icons.play_arrow),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: _resetTimer,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            child: const Icon(Icons.refresh),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
