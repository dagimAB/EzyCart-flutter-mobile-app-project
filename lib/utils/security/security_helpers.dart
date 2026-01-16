import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Generates a SHA-256 hash so we never send the raw password to Firebase.
/// Firebase will hash the already hashed value again, adding a small extra safety layer.
String hashPassword(String plainText) {
  final normalized = plainText.trim();
  final bytes = utf8.encode(normalized);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
