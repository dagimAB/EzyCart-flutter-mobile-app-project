import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Simple AI Assistant service to interact with a Gemini-like API.
///
/// TODO: Replace the endpoint and headers with the actual Gemini API details.
/// TODO: Do NOT hardcode the API key here. Load it from secure storage or
/// environment variables (e.g., using `flutter_dotenv` or `flutter_secure_storage`).
class AiAssistantService {
  AiAssistantService._();
  static final instance = AiAssistantService._();

  // Placeholder endpoint for demo. Replace with the real endpoint in production.
  final _endpoint = Uri.parse('https://api.example.com/v1/generate');

  /// Send a user message and receive assistant response text.
  /// Returns the assistant's reply string on success or throws an error.
  Future<String> sendMessage(
    String message, {
    Map<String, dynamic>? context,
  }) async {
    try {
      // Example payload - adapt to your AI provider
      final payload = {
        'model': 'gemini-1.5',
        'prompt': message,
        'context': context ?? {},
      };

      // TODO: Replace with secure API key retrieval
      final apiKey = 'TODO_ADD_API_KEY';

      final resp = await http
          .post(
            _endpoint,
            headers: {
              'Content-Type': 'application/json',
              if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 20));

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        // This depends on provider response shape; adapt as needed.
        return (data['output'] as String?) ?? 'No response from assistant.';
      }

      throw 'AI service returned ${resp.statusCode}: ${resp.body}';
    } catch (e) {
      debugPrint('AiAssistantService.sendMessage error: $e');
      rethrow;
    }
  }
}
