import 'package:flutter/material.dart';
import '../../core/managers/affection_manager.dart';

class AffectionBar extends StatelessWidget {
  final int currentAffection;
  final AffectionManager affectionManager;

  const AffectionBar({
    super.key,
    required this.currentAffection,
    required this.affectionManager,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentAffection / 1000;
    final levelName = affectionManager.getAffectionLevelName(currentAffection);

    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            levelName,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: RotatedBox(
              quarterTurns: -1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.pink[100],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
                  minHeight: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$currentAffection/1000',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
