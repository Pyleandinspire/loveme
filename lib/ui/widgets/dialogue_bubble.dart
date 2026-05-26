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
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.pinkAccent : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && characterAvatar != null) ...[
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(characterAvatar!),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      dialogue.speaker,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    dialogue.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 20, color: Colors.pinkAccent),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
