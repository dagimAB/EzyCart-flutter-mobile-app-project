# Firebase Integration Guide for EzyCart

This guide will walk you through the steps to integrate Firebase into your Flutter project.

## Prerequisites

1.  **Node.js**: Ensure you have Node.js installed.
2.  **Firebase CLI**: Install the Firebase CLI globally:
    ```bash
    npm install -g firebase-tools
    ```
3.  **FlutterFire CLI**: Install the FlutterFire CLI:
    ```bash
    dart pub global activate flutterfire_cli
    ```

## Step 1: Create a Firebase Project

1.  Go to the [Firebase Console](https://console.firebase.google.com/).
2.  Click **Add project**.
3.  Enter a project name (e.g., `ezycart-app`).
4.  Disable Google Analytics for now (optional).
5.  Click **Create project**.

## Step 2: Configure FlutterFire

1.  Open your terminal in the root of your Flutter project (`ezycart/`).
2.  Login to Firebase:
    ```bash
    firebase login
    ```
3.  Configure the app:
    ```bash
    flutterfire configure
    ```
4.  Select your newly created project from the list.
5.  Select the platforms you want to support (Android, iOS, Web, etc.).
6.  The CLI will automatically generate a `firebase_options.dart` file in `lib/`.

## Step 3: Add Dependencies

Add the necessary Firebase packages to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  # Add other packages as needed (firebase_storage, etc.)
```

Run `flutter pub get` to install them.

## Step 4: Initialize Firebase

Open `lib/main.dart` and initialize Firebase before running the app.

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
```

## Step 5: Authentication Setup (Example)

1.  In Firebase Console, go to **Authentication** > **Get started**.
2.  Enable **Email/Password** provider.
3.  In your code, use `FirebaseAuth` to sign in/up users.

```dart
// Example Sign Up
Future<void> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    print(e);
  }
}
```

## Step 6: Firestore Setup (Example)

1.  In Firebase Console, go to **Firestore Database** > **Create database**.
2.  Start in **Test mode** for development.
3.  In your code, use `FirebaseFirestore` to read/write data.

```dart
// Example Read
final db = FirebaseFirestore.instance;
final docRef = db.collection("users").doc("user_id");
docRef.get().then(
  (DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // ...
  },
  onError: (e) => print("Error getting document: $e"),
);
```

## Next Steps

- Implement Authentication logic in your Login/Signup screens.
- Replace dummy product data with data fetched from Firestore.
- Implement Cart and Wishlist logic using Firestore or Local Storage synced with Firestore.
