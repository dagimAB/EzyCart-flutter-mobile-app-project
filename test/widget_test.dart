// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ezycart/app.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // No Firebase initialization in tests; use no-op bindings to avoid external services.
  });

  testWidgets('App builds smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame with a no-op binding to avoid external dependencies.
    await tester.pumpWidget(App(initialBinding: BindingsBuilder(() {})));

    // Advance timers so SplashScreen's timer completes and no timers remain pending.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
