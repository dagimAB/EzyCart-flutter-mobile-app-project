import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key});

  Widget _statusTile({
    required String title,
    required bool ok,
    String? message,
  }) {
    return ListTile(
      leading: Icon(
        ok ? Icons.check_circle : Icons.error,
        color: ok ? Colors.green : Colors.red,
      ),
      title: Text(title),
      subtitle: message == null ? null : Text(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseInitialized = Firebase.apps.isNotEmpty;

    final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    final chapaSecret = dotenv.env['CHAPA_SECRET_KEY'] ?? '';
    final chapaPublic = dotenv.env['CHAPA_PUBLIC_KEY'] ?? '';
    final firebaseApiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';
    final firebaseProjectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
    final firebaseAppId = dotenv.env['FIREBASE_APP_ID'] ?? '';

    final androidGoogleServicesExists = File(
      'android/app/google-services.json',
    ).existsSync();
    final iosPlistExists = File(
      'ios/Runner/GoogleService-Info.plist',
    ).existsSync();

    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Environment checks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _statusTile(
              title: 'Firebase initialized',
              ok: firebaseInitialized,
              message: firebaseInitialized
                  ? 'Firebase apps: ${Firebase.apps.length}'
                  : 'Call Firebase.initializeApp() in main.dart',
            ),
            _statusTile(
              title: 'GOOGLE_CLIENT_ID',
              ok: googleClientId.isNotEmpty,
              message: googleClientId.isNotEmpty
                  ? 'Present (masked): ${googleClientId.length} chars'
                  : 'Missing: add GOOGLE_CLIENT_ID to .env',
            ),
            _statusTile(
              title: 'CHAPA_SECRET_KEY',
              ok: chapaSecret.isNotEmpty,
              message: chapaSecret.isNotEmpty
                  ? 'Present (masked)'
                  : 'Missing: add CHAPA_SECRET_KEY to .env',
            ),
            _statusTile(
              title: 'CHAPA_PUBLIC_KEY',
              ok: chapaPublic.isNotEmpty,
              message: chapaPublic.isNotEmpty
                  ? 'Present (masked)'
                  : 'Missing: add CHAPA_PUBLIC_KEY to .env',
            ),
            _statusTile(
              title: 'Firebase API key',
              ok: firebaseApiKey.isNotEmpty,
              message: firebaseApiKey.isNotEmpty
                  ? 'Present (masked)'
                  : 'Missing: add FIREBASE_API_KEY to .env',
            ),
            _statusTile(
              title: 'Firebase Project ID',
              ok: firebaseProjectId.isNotEmpty,
              message: firebaseProjectId.isNotEmpty
                  ? 'Present: $firebaseProjectId'
                  : 'Missing: add FIREBASE_PROJECT_ID to .env',
            ),
            _statusTile(
              title: 'Firebase App ID',
              ok: firebaseAppId.isNotEmpty,
              message: firebaseAppId.isNotEmpty
                  ? 'Present (masked)'
                  : 'Missing: add FIREBASE_APP_ID to .env',
            ),
            const Divider(),
            const Text(
              'Platform files',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _statusTile(
              title: 'android/app/google-services.json',
              ok: androidGoogleServicesExists,
              message: androidGoogleServicesExists
                  ? 'Found'
                  : 'Missing: add google-services.json from Firebase for Android',
            ),
            _statusTile(
              title: 'ios/Runner/GoogleService-Info.plist',
              ok: iosPlistExists,
              message: iosPlistExists
                  ? 'Found'
                  : 'Missing: add GoogleService-Info.plist for iOS (if building on iOS)',
            ),
            const Divider(),
            const Text(
              'Tips / Next steps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '- If Google sign-in fails on Android, add your app SHA-1 to Firebase console (Project Settings).',
            ),
            const SizedBox(height: 6),
            const Text(
              '- For Web Google sign-in: create an OAuth Client ID (Web) in Google Cloud Console and set GOOGLE_CLIENT_ID in .env and add the origin to authorized JS origins.',
            ),
            const SizedBox(height: 12),
            if (kDebugMode)
              ElevatedButton.icon(
                onPressed: () => Get.snackbar(
                  'Diagnostics',
                  'Copy instructions from README or follow tips above',
                ),
                icon: const Icon(Icons.copy),
                label: const Text('Show quick help'),
              ),
          ],
        ),
      ),
    );
  }
}
