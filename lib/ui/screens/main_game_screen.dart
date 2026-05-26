import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/affection_bar.dart';
import '../widgets/dialogue_bubble.dart';
import '../widgets/streaming_dialogue_bubble.dart';
import '../../core/managers/affection_manager.dart';
import '../../core/managers/character_manager.dart';
import '../../core/managers/memory_manager.dart';
import '../../core/models/dialogue.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/storage_service.dart';
import 'settings_screen.dart';
import 'mini_games/mini_game_menu.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  final CharacterManager _characterManager = CharacterManager();
  final AffectionManager _affectionManager = AffectionManager();
  final MemoryManager _memoryManager = MemoryManager();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _streamingContent = '';
  bool _isStreaming = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    await _characterManager.loadCharacters();
    setState(() => _isLoading = false);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final storage = Provider.of<StorageService>(context, listen: false);
    final save = storage.getCurrentSave();
    final character = _characterManager.getCharacterById(
        save?.currentCharacterId ?? '');

    if (save == null ||
        character == null ||
        _textController.text.isEmpty ||
        _isStreaming) return;

    final userInput = _textController.text.trim();
    _textController.clear();

    final userDialogue = DialogueRecord(
      speaker: 'user',
      content: userInput,
      timestamp: DateTime.now(),
    );

    setState(() {
      save.dialogueHistory.add(userDialogue);
      _memoryManager.addShortTermMemory(save, userDialogue);
      _isStreaming = true;
      _streamingContent = '';
    });

    storage.updateGameSave(save);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final aiConfig = storage.getAIConfig();
    final aiService = AIService(aiConfig);

    final contentBuffer = StringBuffer();
    await for (final chunk
        in aiService.streamResponse(userInput, save, character)) {
      contentBuffer.write(chunk);
      setState(() => _streamingContent = contentBuffer.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    final aiDialogue = DialogueRecord(
      speaker: character.name,
      content: contentBuffer.toString(),
      timestamp: DateTime.now(),
    );

    setState(() {
      save.dialogueHistory.add(aiDialogue);
      _memoryManager.addShortTermMemory(save, aiDialogue);
      _affectionManager.addAffection(save, 2);
      _isStreaming = false;
      _streamingContent = '';
    });

    storage.updateGameSave(save);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final save = storage.getCurrentSave();
    final character = _characterManager
        .getCharacterById(save?.currentCharacterId ?? '');

    if (_isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    if (save == null || character == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('请先选择一个角色'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.games),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MiniGameMenu()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemCount:
                      save.dialogueHistory.length + (_isStreaming ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == save.dialogueHistory.length &&
                        _isStreaming) {
                      return StreamingDialogueBubble(
                        content: _streamingContent,
                        isStreaming: _isStreaming,
                        characterAvatar: character.avatar,
                      );
                    }
                    final dialogue = save.dialogueHistory[index];
                    return DialogueBubble(
                      dialogue: dialogue,
                      isUser: dialogue.speaker == 'user',
                      characterAvatar:
                          dialogue.speaker != 'user' ? character.avatar : null,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: '输入要说的话...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 右侧好感度条
          Positioned(
            right: 16,
            top: 100,
            child: AffectionBar(
              currentAffection: save.affection,
              affectionManager: _affectionManager,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
