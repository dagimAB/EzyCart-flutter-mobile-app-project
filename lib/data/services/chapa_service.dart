import 'dart:convert';
import 'package:ezycart/data/services/chapa_web_stub.dart'
    if (dart.library.html) 'package:ezycart/data/services/chapa_web_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Fix: Ensure library is loaded correctly
class ChapaService {
  // Replace with your actual Secret Key from Chapa Dashboard
  // For testing, use the test key provided by Chapa documentation
  static String get secretKey => dotenv.env['CHAPA_SECRET_KEY'] ?? '';
  // Public Key is required for Form POST on Web
  static String get publicKey => dotenv.env['CHAPA_PUBLIC_KEY'] ?? '';
  static const String baseUrl = 'https://api.chapa.co/v1';

  // Optional: Backend proxy endpoint for Web to avoid CORS and keep secrets safe.
  // Example: 'https://your-cloud-function-url/initChapa'
  static const String proxyInitializeUrl = '';

  /// Initializes a payment transaction
  static Future<String?> initializeTransaction({
    required String amount,
    required String currency,
    required String email,
    required String firstName,
    required String lastName,
    required String txRef, // Unique transaction reference
    String? phoneNumber,
    String? title,
    String? description,
  }) async {
    debugPrint('InitializeTransaction called. kIsWeb: $kIsWeb');

    // On mobile/desktop, ensure secret key is available
    if (!kIsWeb && secretKey.isEmpty && proxyInitializeUrl.isEmpty) {
      throw Exception(
        'Chapa secret key (CHAPA_SECRET_KEY) is missing in .env for mobile/desktop payments.',
      );
    }

    Uri url;
    Map<String, String> headers;

    // On Web with Proxy
    if (kIsWeb && proxyInitializeUrl.isNotEmpty) {
      // Use configured backend proxy
      url = Uri.parse(proxyInitializeUrl);
      headers = {'Content-Type': 'application/json'};
    } else if (kIsWeb) {
      // Web: Use HTML Form Post to bypass CORS
      if (publicKey.isEmpty) {
        throw Exception('Chapa PUBLIC KEY is missing for Web payments.');
      }
      chapaWebPost(
        publicKey: publicKey,
        amount: amount,
        currency: currency,
        email: email,
        firstName: firstName,
        lastName: lastName,
        txRef: txRef,
        title: title,
        description: description,
      );
      return null;
    } else {
      // Mobile/Desktop: Direct call
      url = Uri.parse('$baseUrl/transaction/initialize');
      headers = {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/json',
      };
    }

    final body = {
      'amount': amount,
      'currency': currency,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'tx_ref': txRef,
      'return_url':
          'https://yoursite.com/payment-success', // Redirect after success
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (title != null) 'customization[title]': title,
      if (description != null) 'customization[description]': description,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Handle both direct Chapa response and potential Proxy response structures
        if (jsonResponse['status'] == 'success' ||
            jsonResponse.containsKey('checkout_url')) {
          return jsonResponse['data']?['checkout_url'] ??
              jsonResponse['checkout_url'];
        } else {
          throw Exception(
            'Failed to initialize payment: ${jsonResponse['message']}',
          );
        }
      } else {
        throw Exception(
          'Failed to connect: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error initializing payment: $e');
    }
  }

  // static void _webFormPost({
  //   required String amount,
  //   required String currency,
  //   required String email,
  //   required String firstName,
  //   required String lastName,
  //   required String txRef,
  //   String? title,
  //   String? description,
  // }) {
  //   final form = html.FormElement()
  //     ..method = 'POST'
  //     ..action = 'https://api.chapa.co/v1/hosted/pay'
  //     ..style.display = 'none';

  //   void addInput(String name, String value) {
  //     final input = html.InputElement()
  //       ..type = 'hidden'
  //       ..name = name
  //       ..value = value;
  //     form.append(input);
  //   }

  //   addInput('public_key', publicKey);
  //   addInput('tx_ref', txRef);
  //   addInput('amount', amount);
  //   addInput('currency', currency);
  //   addInput('email', email);
  //   addInput('first_name', firstName);
  //   addInput('last_name', lastName);
  //   addInput('return_url', 'https://yoursite.com/payment-success');

  //   if (title != null) addInput('title', title);
  //   if (description != null) addInput('description', description);

  //   html.document.body!.append(form);
  //   form.submit();
  //   form.remove();
  // }

  static Future<void> launchPaymentUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    // Launch in external browser for best security/compatibility
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  /// Verify a transaction status by reference
  static Future<bool> verifyTransaction(String txRef) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transaction/verify/$txRef'),
        headers: {'Authorization': 'Bearer $secretKey'},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['status'] == 'success';
      }
      debugPrint('Chapa verify failed: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('Chapa verify error: $e');
      return false;
    }
  }

  /// Helper to generate a unique transaction reference
  static String generateTxRef() {
    return 'TX-${DateTime.now().millisecondsSinceEpoch}';
  }
}
