void chapaWebPost({
  required String publicKey,
  required String amount,
  required String currency,
  required String email,
  required String firstName,
  required String lastName,
  required String txRef,
  String? title,
  String? description,
}) {
  throw UnimplementedError('Web payments are not supported on this platform.');
}
