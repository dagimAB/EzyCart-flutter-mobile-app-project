# EzyCart

EzyCart is a modern, feature-rich e-commerce application built with Flutter. It provides a seamless shopping experience with a clean UI, robust state management, and a modular architecture.

## Features

- **Shop:**
  - Browse Products by Category and Brand.
  - Product Details with Image Slider and Reviews.
  - Cart and Checkout functionality.
  - Wishlist management.
- **Personalization:**
  - User Profile management.
  - Address management.
  - Order history.
  - Settings.
- **Authentication:**
  - Login, Signup, and Password Recovery screens (UI implemented).

## Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** GetX
- **Icons:** Iconsax

## Getting Started

1.  **Prerequisites:**

    - Flutter SDK installed.
    - Android Studio / VS Code set up.

2.  **Installation:**

    ```bash
    git clone https://github.com/yourusername/ezycart.git
    cd ezycart
    flutter pub get
    ```

3.  **Configuration:**

    - Copy `.env.example` to `.env` and fill in real, sensitive values (do NOT commit `.env`):
      - `GOOGLE_CLIENT_ID` — Required for Google Sign-In on Web.
      - `CHAPA_SECRET_KEY` and `CHAPA_PUBLIC_KEY` — Required for Chapa payments.
      - Any other keys used by your services (e.g., Cloudinary, etc.).
    - Ensure platform-specific files exist for Firebase:
      - `android/app/google-services.json` (Android)
      - `ios/Runner/GoogleService-Info.plist` (iOS)

4.  **Run the App:**
    ```bash
    flutter run
    ```

> Notes: If authentication or payments fail, check that `.env` has the required keys and that Firebase platform files are present. Read the `FIREBASE_SETUP.md` for help configuring Firebase.

## Folder Structure

The project follows a feature-first architecture:

- `lib/features/`: Contains feature-specific code (Shop, Personalization, Authentication).
- `lib/common/`: Reusable widgets and styles.
- `lib/utils/`: Helper functions, constants, and themes.
- `lib/data/`: Repositories and services.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.
