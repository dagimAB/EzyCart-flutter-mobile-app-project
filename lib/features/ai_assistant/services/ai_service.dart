import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ezycart/services/ai/ai_assistant_service.dart';

class AiService {
  // System instruction for EzyCart context
  static const String _systemInstruction = '''
You are EzyCart's AI Assistant. Guide users about the app's screens and navigation. 
- If asked about features or where to find something, use this structure:
  - Logout: Settings screen
  - Add to Cart: Product Details screen
  - Order History: Profile > Orders
  - Wishlist: Wishlist screen
  - Cart: Cart screen
  - Home: Home screen
  - Categories: Store screen
- Only recommend products from these categories: Animals, Clothes, Cosmetics, Electronics, Furnitures, Jewelry, Sports.
- If asked about a product, only mention those categories. If asked about a non-existent category, politely say it's not available.
- Be concise and friendly, and always refer to the EzyCart app structure.
''';

  /// Uses the internal HTTP-based AiAssistantService which calls the v1beta2
  /// Google Generative endpoint (this supports Gemini 1.5 Flash). We pass the
  /// system instruction via `context['system']` so the remote prompt includes it.
  Future<String> getChatResponse(
    String userPrompt, {
    List<Map<String, String>>? history,
  }) async {
    try {
      final response = await AiAssistantService.instance.sendMessage(
        userPrompt,
        context: {'system': _systemInstruction, 'history': history},
      );

      // If the response was produced by the local assistant prefix, return its bare content
      if (response.startsWith('Local Assistant:')) {
        return response.replaceFirst('Local Assistant:', '').trim();
      }

      // If the service already returned a clear fallback message, just show it.
      if (response.startsWith('Remote model unavailable')) return response;

      // Handle our 'no chat-capable models' message and extract local assistant reply
      if (response.startsWith('No chat-capable models available')) {
        final parts = response.split('Using local assistant:');
        final local = parts.length > 1 ? parts[1].trim() : '';
        if (local.isNotEmpty) {
          return 'Note: remote chat not available for this API key. $local';
        }
        return 'Note: remote chat not available for this API key.';
      }

      // Normalize common remote errors (model-not-found / not supported / is not available)
      if (response.toLowerCase().contains('not found') ||
          response.toLowerCase().contains('not supported') ||
          response.toLowerCase().contains('is not available')) {
        // Try to fetch available models to give a helpful message
        try {
          final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
          if (apiKey.isEmpty) {
            return 'The configured model appears unavailable. Also, GEMINI_API_KEY is not set.';
          }

          final models = await AiAssistantService.instance.listModels(apiKey);
          final top = models.take(5).toList();
          final suggestion = top.isEmpty
              ? 'No models returned by ListModels.'
              : 'Available models (top results): ${top.join(', ')}';
          return 'Model "${dotenv.env['GEMINI_MODEL'] ?? 'gemini-1.5-flash'}" is not available. $suggestion';
        } catch (e) {
          return 'Model "${dotenv.env['GEMINI_MODEL'] ?? 'gemini-1.5-flash'}" is not available. Additionally, failed to list models: ${e.toString()}';
        }
      }

      return response;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
