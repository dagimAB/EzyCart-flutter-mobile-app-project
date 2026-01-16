import 'package:ezycart/features/ai_assistant/services/ai_service.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add a friendly usage prompt when the user opens the chat for the first time
    if (_messages.isEmpty) {
      _messages.add(
        _Message(
          "Hi! I'm the EzyCart Assistant. You can ask me where to find things (e.g., \"Where is Logout?\"), request product recommendations (e.g., \"Recommend clothes\"), or ask for help with the app. I only recommend products from these categories: Animals, Clothes, Cosmetics, Electronics, Furnitures, Jewelry, Sports.",
          false,
        ),
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, true));
      _isLoading = true;
      _controller.clear();
    });
    final aiService = AiService();

    // Build a small message history to provide context for the local fallback
    final history = _messages
        .map(
          (m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text},
        )
        .toList();
    history.add({'role': 'user', 'content': text});

    final response = await aiService.getChatResponse(text, history: history);
    setState(() {
      _messages.add(_Message(response, false));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: EColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? EColors.primary.withValues(alpha: 0.9)
                          : EColors.accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.text,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: msg.isUser ? Colors.white : EColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask EzyCart Assistant...',
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: EColors.primary),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  _Message(this.text, this.isUser);
}
