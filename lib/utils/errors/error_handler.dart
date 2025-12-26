import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ezycart/utils/popups/loaders.dart';

class ErrorHandler {
  /// Returns a user-friendly message based on the exception type.
  static String getFriendlyMessage(dynamic error) {
    try {
      if (error == null) return 'Something went wrong. Please try again.';

      // If an explicit string was thrown
      if (error is String) return error;

      // Socket exceptions -> no internet
      if (error is SocketException) {
        return 'No internet connection. Please check your network and try again.';
      }

      // Timeout
      if (error is TimeoutException) {
        return 'Request timed out. Please check your connection and try again.';
      }

      // Platform specific exceptions
      if (error is PlatformException) {
        return error.message ?? 'An unexpected platform error occurred.';
      }

      // Firebase exceptions
      if (error is FirebaseException) {
        return error.message ?? 'A network error occurred while accessing the server.';
      }

      // HTTP/other generic errors
      final message = error.toString();
      if (message.contains('Http') || message.contains('http')) {
        return 'Network error. Please try again.';
      }

      // Default fallback
      return message;
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Convenience method to show a consistent error snackbar.
  static void showError({dynamic error, String title = 'Error', String? fallbackMessage}) {
    final msg = getFriendlyMessage(error);
    ELoaders.errorSnackBar(title: title, message: fallbackMessage ?? msg);
  }

  /// Convenience method to show a warning snackbar.
  static void showWarning({dynamic error, String title = 'Warning', String? fallbackMessage}) {
    final msg = getFriendlyMessage(error);
    ELoaders.warningSnackBar(title: title, message: fallbackMessage ?? msg);
  }
}
