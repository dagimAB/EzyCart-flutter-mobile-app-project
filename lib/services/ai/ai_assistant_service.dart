import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ezycart/features/shop/controllers/product_controller.dart';
import 'package:ezycart/features/shop/controllers/category_controller.dart';
import 'package:ezycart/features/shop/models/category_model.dart';
import 'package:ezycart/features/shop/models/product_model.dart';

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

  // Controllers used by the local responder when remote chat is unavailable
  // These are lazily resolved so the service can be used in early app lifecycle.
  // (Avoid importing UI packages here.)
  // -- Deferred imports

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
      // If the developer/owner set local-only mode, skip remote calls entirely
      final forceLocalEnv = dotenv.env['AI_FORCE_LOCAL'] == 'true';
      if (forceLocalEnv) {
        final local = await _localFallbackResponder(message);
        return 'Local Assistant: $local';
      }

      final apiKey = await _getApiKey();

      if (apiKey != null && apiKey.isNotEmpty) {
        return await _sendToRemote(message, apiKey, context: context);
      } else {
        final local = await _localFallbackResponder(message);
        return 'Local Assistant: $local';
      }
    } catch (e) {
      debugPrint('AiAssistantService.sendMessage error: $e');
      // Return a helpful error message including the underlying exception to aid debugging
      return 'Error contacting AI service: ${e.toString()}';
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
    // Use Google Generative API path for a default model. If a model was
    // explicitly selected in the diagnostics UI, prefer that.
    var selectedModel = await _secureStorage.read(key: 'GEMINI_SELECTED_MODEL');
    var model = (selectedModel != null && selectedModel.isNotEmpty)
        ? selectedModel
        : (dotenv.env['GEMINI_MODEL'] ?? 'gemini-1.5-flash');
    var switchedModel = false;

    try {
      final available = await listModels(apiKey);
      debugPrint('Available models: $available');

      // Find chat-capable models only (do not pick embedding-only models)
      final chatCandidates = available.where((m) {
        final lower = m.toLowerCase();
        return lower.contains('chat') ||
            lower.contains('bison') ||
            lower.contains('gemini') ||
            lower.contains('gpt');
      }).toList();

      if (chatCandidates.isNotEmpty) {
        // If configured model isn't among the chat candidates, switch to the first chat model
        if (!chatCandidates.any(
          (m) => m.toLowerCase().contains(model.toLowerCase()),
        )) {
          final preferred = chatCandidates.first;
          debugPrint(
            'Configured model $model not available among chat models, switching to $preferred',
          );
          model = preferred;
          switchedModel = true;
        }
      } else {
        // No chat-capable models available — use local fallback only
        debugPrint(
          'No chat-capable models available; using local fallback responder.',
        );
        final avail = available.isEmpty ? 'none' : available.join(', ');
        final local = await _localFallbackResponder(message);
        return 'No chat-capable models available for this API key (found: $avail). Using local assistant: $local';
      }
    } catch (e) {
      debugPrint('Error while listing models: $e');
      // If model listing fails, continue with configured model — API will return a clear error.
    }

    final uri = Uri.parse(
      '$_googleGenerateBase/$model:generate${_maybeKeyQuery(apiKey)}',
    );

    // Use the v1beta2 chat-style prompt messages which Gemini expects for chat-capable models.
    final payload = {
      'prompt': {
        'messages': [
          {
            'author': 'system',
            'content': [
              {
                'type': 'text',
                'text': context != null && context['system'] != null
                    ? context['system']
                    : '',
              },
            ],
          },
          {
            'author': 'user',
            'content': [
              {'type': 'text', 'text': message},
            ],
          },
        ],
      },
      'temperature': 0.2,
      'maxOutputTokens': 512,
    };

    final resp = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            if (apiKey.startsWith('ya29.') ||
                dotenv.env['USE_BEARER'] == 'true')
              'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 20));

    // Debug logging for easier diagnosis
    debugPrint('AiAssistantService._sendToRemote status: ${resp.statusCode}');
    debugPrint('AiAssistantService._sendToRemote body: ${resp.body}');

    // If Google returns a clear

    // Handle successful response and normalize shapes
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;

      // If Google returns 'candidates' with 'content' as a list of parts, collect texts
      if (data.containsKey('candidates') &&
          (data['candidates'] as List).isNotEmpty) {
        final first = (data['candidates'] as List).first;
        if (first is Map && first.containsKey('content')) {
          final content = first['content'];
          if (content is String) {
            final out = content;
            return switchedModel ? 'Note: using model $model.\n\n$out' : out;
          }
          if (content is List) {
            final buffer = StringBuffer();
            for (final part in content) {
              if (part is Map && part.containsKey('text')) {
                buffer.writeln(part['text']);
              } else if (part is String) {
                buffer.writeln(part);
              }
            }
            final out = buffer.toString().trim();
            if (out.isNotEmpty) {
              return switchedModel ? 'Note: using model $model.\n\n$out' : out;
            }
          }
        }
      }

      // Some responses may contain an 'output' string or nested 'output[0].content'.
      if (data.containsKey('output')) {
        final out = data['output'];
        if (out is String) {
          return switchedModel ? 'Note: using model $model.\n\n$out' : out;
        }
        if (out is List && out.isNotEmpty) {
          final first = out.first;
          if (first is Map) {
            if (first.containsKey('content')) {
              final text = jsonEncode(first['content']);
              return switchedModel
                  ? 'Note: using model $model.\n\n$text'
                  : text;
            }
            if (first.containsKey('text')) {
              final text = first['text'] as String;
              return switchedModel
                  ? 'Note: using model $model.\n\n$text'
                  : text;
            }
          }
        }
      }

      // Older shapes: choices[0].text
      if (data.containsKey('choices') && (data['choices'] as List).isNotEmpty) {
        final c0 = (data['choices'] as List).first;
        if (c0 is Map && c0.containsKey('text')) {
          final text = c0['text'] as String;
          return switchedModel ? 'Note: using model $model.\n\n$text' : text;
        }
      }

      // If nothing matched, return the raw body to aid debugging
      return switchedModel
          ? 'Note: using model $model.\n\n${resp.body}'
          : resp.body;
    }

    // Non-successful status — return informative error
    throw 'AI service returned ${resp.statusCode}: ${resp.body}';
  }

  // Helper to add the key as a query param when not using Bearer
  String _maybeKeyQuery(String apiKey) {
    if (apiKey.startsWith('ya29.') || dotenv.env['USE_BEARER'] == 'true') {
      return '';
    }
    return '?key=${Uri.encodeComponent(apiKey)}';
  }

  /// Diagnostic helper: list available models from the Google Generative API.
  Future<List<String>> listModels(String apiKey) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta2/models${_maybeKeyQuery(apiKey)}',
    );
    final resp = await http
        .get(
          uri,
          headers: {
            if (apiKey.startsWith('ya29.') ||
                dotenv.env['USE_BEARER'] == 'true')
              'Authorization': 'Bearer $apiKey',
          },
        )
        .timeout(const Duration(seconds: 20));

    debugPrint('AiAssistantService.listModels status: ${resp.statusCode}');
    debugPrint('AiAssistantService.listModels body: ${resp.body}');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final models = <String>[];
      if (data.containsKey('models') && data['models'] is List) {
        for (final m in data['models']) {
          if (m is Map && m.containsKey('name')) {
            models.add(m['name'] as String);
          }
        }
      }
      return models;
    }

    throw 'Model list fetch failed ${resp.statusCode}: ${resp.body}';
  }

  // OpenAI fallback removed. All remote fallbacks are disabled to enforce local-only chat per project settings.
  // If you later choose to add another remote provider, reintroduce it here behind a feature flag.

  /// Deterministic fallback responder.
  ///
  /// This covers navigation queries (where is X?), checkout/add-to-cart/wishlist paths,
  /// and limited product advice that asks about categories listed in the app.
  Future<String> _localFallbackResponder(
    String message, {
    List<Map<String, String>>? history,
  }) async {
    final m = message.toLowerCase();

    // Incorporate a tiny context-aware reply if the last user message is present
    if (history != null && history.isNotEmpty) {
      final last = history.last;
      if (last['role'] == 'user' && last['content'] != null) {
        // If the user asked a follow-up question and it's a generic one, reply concisely
        final lastText = (last['content'] ?? '').toLowerCase();
        if (m.contains('also') ||
            m.contains('and') ||
            m.startsWith('what') ||
            m.startsWith('how')) {
          // Keep it short and reference last topic when possible
          return 'Following up on your previous question: ${lastText.split('.').first}. Can you clarify what you mean?';
        }
      }
    }

    // Greeting & help rule - ensure session greeting handled at controller level too
    if (m.contains('hello') || m.contains('hi') || m.contains('welcome')) {
      return 'Welcome to EzyCart! How can I help you today?';
    }

    // Help / usage guidance
    if (m.contains('help') ||
        m.contains('how') && m.contains('use') ||
        m.contains('how to')) {
      return 'You can ask me things like:\n• "Where is Logout?" — I will tell you which screen contains the action.\n• "Recommend clothes" — I will suggest products from our Clothes category.\n• "Add to Cart" — I will explain where to add items (Product Details screen).\nPlease ask about only these categories: Animals, Clothes, Cosmetics, Electronics, Furnitures, Jewelry, Sports.';
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
      // If the message looks like a product request, try to fetch sample products from the store
      final productRequestKeywords = [
        'recommend',
        'suggest',
        'looking for',
        'show me',
        'i want',
        'find',
        'what should i buy',
      ];
      final isProductRequest = productRequestKeywords.any(
        (kw) => m.contains(kw),
      );

      // Also consider that short queries like "clothes" could be a browse intent
      final isShortBrowse =
          m.split(' ').length <= 2 && m.trim().length <= 30 && !m.contains('?');

      if (isProductRequest || isShortBrowse) {
        try {
          // Lazy-load controllers if needed
          final productController = Get.isRegistered<ProductController>()
              ? ProductController.instance
              : Get.put(ProductController());

          final categoryController = Get.isRegistered<CategoryController>()
              ? CategoryController.instance
              : Get.put(CategoryController());

          // If categories were just created/put, ensure they are loaded before using
          if (categoryController.allCategories.isEmpty) {
            await categoryController.fetchCategories();
          }

          // Find a category that matches our keyword set
          final matchedCategory = categoryController.allCategories.firstWhere(
            (c) =>
                c.name.toLowerCase() == found.key ||
                c.name.toLowerCase().contains(found.key),
            orElse: () => CategoryModel.empty(),
          );

          List<ProductModel> products = [];
          if (matchedCategory.id.isNotEmpty) {
            products = await productController.fetchProductsByCategoryId(
              matchedCategory.id,
            );
          } else {
            // Fallback: use featured products in that category if category id not found
            products = await productController.fetchAllFeaturedProducts();
            products = products
                .where(
                  (p) => (p.categoryId ?? '').toLowerCase().contains(found.key),
                )
                .take(3)
                .toList();
          }

          if (products.isEmpty) {
            return 'I specialize in ${found.key}. I couldn\'t find live products right now, but you can browse ${found.key} under the Store > ${found.key} category.';
          }

          final buffer = StringBuffer();
          buffer.writeln(
            'I specialize in ${found.key}. Here are some suggestions:',
          );
          for (
            var i = 0;
            i < (products.length < 3 ? products.length : 3);
            i++
          ) {
            final p = products[i];
            buffer.writeln(
              '${i + 1}. ${p.title} — ${p.price.toStringAsFixed(2)}',
            );
          }
          buffer.writeln(
            '\nOpen a product to see the "Add to Cart" button on the Product Details screen.',
          );
          return buffer.toString();
        } catch (e) {
          // If any of the fetches fail, fallback to a friendly prompt
          return 'I specialize in ${found.key}. Do you have a preferred price range (budget, mid-range, premium) or a use case?';
        }
      }

      // Ask for a quick preference when not explicit
      return 'I specialize in ${found.key}. Do you have a preferred price range (budget, mid-range, premium) or a use case?';
    }

    // Fallback safe reply
    return 'I specialize in EzyCart\'s collections. I can help you with Clothes, Electronics, or our other 5 categories!';
  }
}
