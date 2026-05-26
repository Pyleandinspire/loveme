import 'package:flutter/material.dart';
import '../../core/models/dialogue.dart';

class DialogueBubble extends StatelessWidget {
  final DialogueRecord dialogue;
  final bool isUser;
  final String? characterAvatar;

  const DialogueBubble({
    super.key,
    required this.dialogue,
    required this.isUser,
    this.characterAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser && characterAvatar != null) ...[
            CircleAvatar(
              backgroundImage: AssetImage(characterAvatar!),
              radius: 20,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isUser ? Colors.pink[400] : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                dialogue.content,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              child: Icon(Icons.person),
              radius: 20,
            ),
          ],
        ],
      ),
    );
  }
}
