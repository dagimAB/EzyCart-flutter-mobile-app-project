


class EValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ); 


    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    String cleanedValue = value.replaceAll(RegExp(r'[()\s\-\+]'), '');

    final ethiopianPhoneRegExp = RegExp(r'^(09|07)\d{8}$|^251\d{9}$');

    if (!ethiopianPhoneRegExp.hasMatch(cleanedValue)) {

      return 'Invalid Ethiopian phone number format (e.g., 09xxxxxxxx or +2519xxxxxxxx).';
    }

    return null;
  }



}
