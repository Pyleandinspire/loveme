import 'package:flutter/material.dart';

class StreamingDialogueBubble extends StatelessWidget {
  final String content;
  final bool isStreaming;
  final String? characterAvatar;

  const StreamingDialogueBubble({
    super.key,
    required this.content,
    required this.isStreaming,
    this.characterAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
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
            if (characterAvatar != null) ...[
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'AI',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isStreaming) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey[400]!,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content.isEmpty ? '正在输入...' : content,
                    style: TextStyle(
                      fontSize: 16,
                      color: content.isEmpty ? Colors.grey : Colors.black87,
                    ),
                  ),
                  if (isStreaming)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '正在输入...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
