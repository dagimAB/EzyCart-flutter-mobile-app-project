import 'package:ezycart/features/ai/controllers/ai_chat_controller.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiChatController());
    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(ESizes.defaultSpace),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return Align(
                    alignment: msg.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: msg.isUser ? EColors.primary : EColors.light,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser ? EColors.white : EColors.dark,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? const LinearProgressIndicator()
                : const SizedBox(height: 0),
          ),
          Padding(
            padding: const EdgeInsets.all(ESizes.defaultSpace),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(hintText: 'Ask me...'),
                    onSubmitted: (v) async {
                      if (v.trim().isEmpty) return;
                      await controller.sendMessage(v.trim());
                      messageController.clear();
                    },
                  ),
                ),
                const SizedBox(width: ESizes.spaceBtwItems),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final text = messageController.text.trim();
                    if (text.isEmpty) return;
                    await controller.sendMessage(text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
