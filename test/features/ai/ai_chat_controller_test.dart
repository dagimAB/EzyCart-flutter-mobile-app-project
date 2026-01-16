import 'package:flutter_test/flutter_test.dart';
import 'package:ezycart/features/ai/controllers/ai_chat_controller.dart';

void main() {
  group('AiChatController', () {
    test('adds user and assistant messages locally', () {
      final c = AiChatController();
      expect(c.messages.length, 0);

      c.addUserMessage('hello');
      expect(c.messages.length, 1);
      expect(c.messages.first.text, 'hello');
      expect(c.messages.first.isUser, true);

      c.addAssistantMessage('hi');
      expect(c.messages.length, 2);
      expect(c.messages[1].text, 'hi');
      expect(c.messages[1].isUser, false);
    });
  });
}
