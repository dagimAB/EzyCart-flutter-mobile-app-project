import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// AI Assistant service with two modes:
/// 1) Remote mode: calls an external Gemini/OpenAI-like endpoint if an API key is configured.
/// 2) Fallback mode: deterministic local responder that understands navigation and product queries
///    so the assistant remains usable without external credentials.
///
/// Security:
/// - Do NOT hardcode the API key. The service checks `GEMINI_API_KEY` from .env and
///   then falls back to `flutter_secure_storage` if necessary.
class AiAssistantService {
  AiAssistantService._();
  static final instance = AiAssistantService._();

  final _secureStorage = const FlutterSecureStorage();

  /// Remote endpoint base for Google Generative Language (Gemini-like) APIs.
  /// Replace model name via GEMINI_MODEL env var if needed.
  final _googleGenerateBase =
      'https://generativelanguage.googleapis.com/v1beta2/models';

  /// Main entry. Tries remote call if API key configured, otherwise uses local fallback.
  Future<String> sendMessage(
    String message, {
    Map<String, dynamic>? context,
  }) async {
    try {
      final apiKey = await _getApiKey();

      if (apiKey != null && apiKey.isNotEmpty) {
        return await _sendToRemote(message, apiKey, context: context);
      } else {
        return _localFallbackResponder(message);
      }
    } catch (e) {
      debugPrint('AiAssistantService.sendMessage error: $e');
      // On unexpected error, return a friendly fallback message instead of throwing.
      return 'Oops, something went wrong while contacting the AI. Try again or ask a navigation question.';
    }
  }

  /// Attempt to read API key from .env first, then secure storage.
  Future<String?> _getApiKey() async {
    final envKey = dotenv.env['GEMINI_API_KEY'];
    if (envKey != null && envKey.isNotEmpty) return envKey;

    final secureKey = await _secureStorage.read(key: 'GEMINI_API_KEY');
    return secureKey;
  }

  Future<String> _sendToRemote(
    String message,
    String apiKey, {
    Map<String, dynamic>? context,
  }) async {
    // Use Google Generative API path for a default model. You can change the model name if needed.
    final model = dotenv.env['GEMINI_MODEL'] ?? 'gemini-1.5';
    final uri = Uri.parse(
      '$_googleGenerateBase/$model:generate${_maybeKeyQuery(apiKey)}',
    );

    // Google generative payload requires nested prompt object. We include a short system prompt.
    final promptText = (context != null && context['system'] != null)
        ? '${context['system']}\n\nUser: $message'
        : 'User: $message';

    final payload = {
      'prompt': {'text': promptText},
      'temperature': 0.2,
      'maxOutputTokens': 512,
    };

    final resp = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            // Prefer Bearer auth if apiKey looks like an OAuth token, otherwise the key param is used
            if (apiKey.startsWith('ya29.') ||
                dotenv.env['USE_BEARER'] == 'true')
              'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;

      // Google may return candidates with text in 'candidates[0].content' or similar.
      if (data.containsKey('candidates') &&
          (data['candidates'] as List).isNotEmpty) {
        final first =
            (data['candidates'] as List).first as Map<String, dynamic>;
        if (first.containsKey('content')) return first['content'] as String;
        if (first.containsKey('output')) return first['output'] as String;
      }

      // Generic provider shapes
      if (data.containsKey('output') && data['output'] is String)
        return data['output'] as String;
      if (data.containsKey('choices') && (data['choices'] as List).isNotEmpty) {
        final c0 = (data['choices'] as List).first;
        if (c0 is Map && c0.containsKey('text')) return c0['text'] as String;
      }

      return jsonEncode(data);
    }

    throw 'AI service returned ${resp.statusCode}: ${resp.body}';
  }

  /// Deterministic fallback responder.
  ///
  /// This covers navigation queries (where is X?), checkout/add-to-cart/wishlist paths,
  /// and limited product advice that asks about categories listed in the app.
  String _localFallbackResponder(String message) {
    final m = message.toLowerCase();

    // Greeting rule - ensure session greeting handled at controller level too
    if (m.contains('hello') || m.contains('hi') || m.contains('welcome')) {
      return 'Welcome to EzyCart! How can I help you today?';
    }

    // Navigation intents
    if (m.contains('where') && m.contains('wishlist')) {
      return 'To access your Wishlist: open the bottom navigation and tap the 3rd tab labeled "Wishlist" (heart icon).';
    }
    if (m.contains('where') && m.contains('cart')) {
      return 'To open your Cart: tap the Cart tab (4th tab with the shopping cart icon). From there you can review items and proceed to Checkout.';
    }
    if (m.contains('add to cart') || (m.contains('how') && m.contains('add'))) {
      return 'To add an item to cart: open a product, use the quantity selector, then tap "Add to Cart" at the bottom of the Product Details screen.';
    }
    if (m.contains('checkout')) {
      return 'To checkout: go to Cart → tap "Checkout" → select an address and payment method → confirm.';
    }
    if (m.contains('login') || m.contains('sign in')) {
      return 'To sign in: from the Login screen enter your email and password or use "Sign in with Google". If you need to Sign Up, tap "Sign Up" from the Login screen.';
    }
    if (m.contains('signup') ||
        m.contains('sign up') ||
        m.contains('create account')) {
      return 'To create an account: open Sign Up from the Login screen, fill the form, and submit. You will receive an email to verify your account.';
    }
    if (m.contains('logout') || m.contains('sign out')) {
      return 'To logout: open Settings (right-most tab) and tap the "Logout" button at the bottom.';
    }

    // Product advice intents - check for category keywords
    final categories = {
      'animals': ['animals', 'pets', 'pet'],
      'clothes': ['clothes', 'clothing', 'shirts', 'pants'],
      'cosmetics': ['cosmetics', 'makeup', 'skincare'],
      'electronics': ['electronics', 'phone', 'laptop', 'headphone'],
      'furnitures': ['furniture', 'sofa', 'table'],
      'jewelry': ['jewelry', 'necklace', 'ring'],
      'sports': ['sport', 'sports', 'fitness'],
    };

    final found = categories.entries.firstWhere(
      (e) => e.value.any((kw) => m.contains(kw)),
      orElse: () => MapEntry('', []),
    );

    if (found.key.isNotEmpty) {
      // Ask for a quick preference when not explicit
      return 'I specialize in ${found.key}. Do you have a preferred price range (budget, mid-range, premium) or a use case?';
    }

    // Fallback safe reply
    return 'I specialize in EzyCart\'s collections. I can help you with Clothes, Electronics, or our other 5 categories!';
  }
}
