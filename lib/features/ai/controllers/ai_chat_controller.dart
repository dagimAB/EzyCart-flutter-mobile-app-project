import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ezycart/services/ai/ai_assistant_service.dart';

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AiMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };

  static AiMessage fromJson(Map<String, dynamic> j) => AiMessage(
    text: j['text'] ?? '',
    isUser: j['isUser'] ?? false,
    timestamp: DateTime.parse(
      j['timestamp'] ?? DateTime.now().toIso8601String(),
    ),
  );
}

class AiChatController extends GetxController {
  static AiChatController get instance => Get.find();

  final messages = <AiMessage>[].obs;
  final isLoading = false.obs;

  final _storage = GetStorage();
  final _storageKey = 'ai_chat_history';
  final _greetedKey = 'ai_has_greeted';

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
    // Persist whenever messages change
    messages.listen((_) => _saveHistory());

    // Add welcome message once per device/session if not already present
    final greeted = _storage.read(_greetedKey) as bool?;
    if (greeted != true) {
      addAssistantMessage('Welcome to EzyCart!');
      _storage.write(_greetedKey, true);
    }
  }

  void _loadHistory() {
    try {
      final raw = _storage.read(_storageKey) as List<dynamic>?;
      if (raw != null) {
        final list = raw
            .map((e) => AiMessage.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        messages.assignAll(list);
      }
    } catch (e) {
      debugPrint('Failed to load AI chat history: $e');
    }
  }

  void _saveHistory() {
    try {
      final raw = messages.map((m) => m.toJson()).toList();
      _storage.write(_storageKey, raw);
    } catch (e) {
      debugPrint('Failed to save AI chat history: $e');
    }
  }

  void addUserMessage(String text) {
    messages.add(AiMessage(text: text, isUser: true));
  }

  void addAssistantMessage(String text) {
    messages.add(AiMessage(text: text, isUser: false));
  }

  Future<void> sendMessage(String text) async {
    try {
      addUserMessage(text);
      isLoading.value = true;

      // Provide a short system prompt to guide assistant behavior per-session
      final systemPrompt = '''Welcome to EzyCart!\n
You are the EzyCart Assistant. Keep responses short and give clear navigation steps or product advice limited to EzyCart categories.''';

      // Send the user message to the AiAssistantService
      final reply = await AiAssistantService.instance.sendMessage(
        '$systemPrompt\nUser: $text',
      );

      addAssistantMessage(reply);
    } catch (e) {
      addAssistantMessage('Oops, something went wrong. Try again later.');
    } finally {
      isLoading.value = false;
    }
  }
}
