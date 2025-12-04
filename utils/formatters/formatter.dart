import 'package:intl/intl.dart';

class EFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat(
      'dd-MMM-yyyy',
    ).format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    ).format(amount); 
  }

static String formatPhoneNumber(String phoneNumber) {
    // 1. Clean the number: remove non-digit characters (+, spaces, hyphens)
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // 2. Handle International Format (+251...)
    // Total 12 digits: 251 + 9XXXXXXXX
    if (digitsOnly.length == 12 && digitsOnly.startsWith('251')) {
      // Format: +251 9XX XXX XXX
      // Substring(3) starts after '251'
      String localNumber = digitsOnly.substring(3);
      return '+251 ${localNumber.substring(0, 3)} ${localNumber.substring(3, 6)} ${localNumber.substring(6)}';
    }
    // 3. Handle Local Format (09...)
    // Total 10 digits: 09XX XXX XXX
    else if (digitsOnly.length == 10 && digitsOnly.startsWith('0')) {
      // Format: 09X XXX XXXX
      return '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6)}';
    }
    // 4. Fallback (e.g., US formats or unhandled lengths)
    else if (digitsOnly.length == 10) {
      // Retain original 10-digit US logic as a general fallback
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11) {
      // Retain original 11-digit logic
      return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4, 7)} ${digitsOnly.substring(7)}';
    }

    // 5. Return original if no formatting matches
    return phoneNumber;
  }
}
