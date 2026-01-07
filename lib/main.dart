import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ezycart/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

/// -------------Entry point of Flutter App---------
Future<void> main() async {
  try {
    // Todo: Add Widgets Binding
    WidgetsFlutterBinding.ensureInitialized();

    // Load Environment Variables
    await dotenv.load(fileName: ".env");

    // Todo: Init Local Storage
    await GetStorage.init();

    // Todo: Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

    // Todo: Initialize Authentication
    runApp(const App());
  } catch (e) {
    debugPrint('Error in main: $e');
  }
}
