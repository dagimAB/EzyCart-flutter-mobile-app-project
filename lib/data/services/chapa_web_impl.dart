// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
  final form = html.FormElement()
    ..method = 'POST'
    ..action = 'https://api.chapa.co/v1/hosted/pay'
    ..style.display = 'none';

  void addInput(String name, String value) {
    final input = html.InputElement()
      ..type = 'hidden'
      ..name = name
      ..value = value;
    form.append(input);
  }

  addInput('public_key', publicKey);
  addInput('tx_ref', txRef);
  addInput('amount', amount);
  addInput('currency', currency);
  addInput('email', email);
  addInput('first_name', firstName);
  addInput('last_name', lastName);
  // Using a dummy return URL or one configured in environment would be better
  // But for now keeping it generic as per previous implementation
  addInput('return_url', 'https://www.google.com');

  if (title != null) addInput('title', title);
  if (description != null) addInput('description', description);

  html.document.body!.append(form);
  form.submit();
  form.remove();
}
