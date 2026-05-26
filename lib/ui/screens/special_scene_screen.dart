import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/dynamic_event_record.dart';

class SpecialSceneScreen extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String atmosphere;
  final List<DialogueOption> options;
  final Function(int affectionChange) onOptionSelected;
  final VoidCallback onClose;

  const SpecialSceneScreen({
    super.key,
    required this.title,
    this.imageUrl,
    required this.atmosphere,
    required this.options,
    required this.onOptionSelected,
    required this.onClose,
  });

  @override
  State<SpecialSceneScreen> createState() => _SpecialSceneScreenState();
}

class _SpecialSceneScreenState extends State<SpecialSceneScreen>
    with SingleTickerProviderStateMixin {
  String _displayedText = '';
  int _currentIndex = 0;
  bool _isTypingComplete = false;
  bool _showOptions = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    final fullText = widget.title;
    _timer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_currentIndex < fullText.length) {
        setState(() {
          _displayedText = fullText.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTypingComplete = true;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _showOptions = true;
            });
          }
        });
      }
    });
  }

  void _skipTyping() {
    _timer?.cancel();
    setState(() {
      _displayedText = widget.title;
      _isTypingComplete = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _getAtmosphereColor() {
    switch (widget.atmosphere.toLowerCase()) {
      case 'romantic':
        return Colors.pink.shade100;
      case 'warm':
        return Colors.orange.shade100;
      case 'sweet':
        return Colors.purple.shade100;
      case 'nervous':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _isTypingComplete ? null : _skipTyping,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片或渐变
            if (widget.imageUrl != null)
              Image.network(
                widget.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getAtmosphereColor(),
                          Colors.pink.shade200,
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getAtmosphereColor(),
                      Colors.pink.shade300,
                    ],
                  ),
                ),
              ),

            // 半透明遮罩
            Container(
              color: Colors.black.withAlpha(77),
            ),

            // 关闭按钮
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),

            // 标题文本
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Text(
                _displayedText,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // 互动选项
            if (_showOptions)
              Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: Column(
                  children: widget.options.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildOptionButton(entry.value, entry.key),
                    );
                  }).toList(),
                ),
              ),

            // 加载指示器
            if (!_isTypingComplete)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '点击跳过',
                    style: TextStyle(
                      color: Colors.white.withAlpha(179),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(DialogueOption option, int index) {
    final colors = [Colors.pink, Colors.blue, Colors.purple, Colors.orange];
    final buttonColor = colors[index % colors.length];

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onOptionSelected(option.affectionChange);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Text(
              option.text,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '好感度 ${option.affectionChange >= 0 ? '+' : ''}${option.affectionChange}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withAlpha(204),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
