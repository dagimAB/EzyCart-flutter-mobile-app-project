import 'package:get/get.dart';
import 'package:ezycart/services/ai/ai_assistant_service.dart';

class AiMessage {
  final String text;
  final bool isUser;
  AiMessage({required this.text, required this.isUser});
}

class AiChatController extends GetxController {
  static AiChatController get instance => Get.find();

  final messages = <AiMessage>[].obs;
  final isLoading = false.obs;

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
