# Android SDK & Device setup — quick reference

This document collects the steps required to run the app on Android devices (physical or emulator).

Prerequisites

- Android Studio installed (SDK Manager used to install SDK components).
- Flutter SDK already installed (you already have this).

Required SDK components (Android Studio → SDK Manager → SDK Tools)

- Android SDK Platform-Tools (adb)
- Android SDK Command-line Tools (latest)
- Android SDK Build-Tools (matching target)
- At least one SDK Platform (e.g. Android 13 / API 33 or Android 16 / API 36)
- Android Emulator (if you want to run an AVD)
- (Optional) Google USB Driver on Windows for Pixel devices or OEM USB driver for other vendors

One-time configuration (Windows)

1. Ensure Android SDK path is configured in Android Studio (File → Settings → Appearance & Behavior → System Settings → Android SDK).
2. (Optional) Make platform-tools available in your shell PATH for convenience:
   - Temporary (PowerShell):
     $env:PATH = "C:\Users\<you>\AppData\Local\Android\Sdk\platform-tools;${env:PATH}"
   - Permanent: update System Environment Variables → PATH (not done by this project).

Helpful scripts (project)

- `scripts/android-setup.ps1` — configures PATH for the session, runs `flutter doctor`, lists AVDs and sdk packages, and prints quick commands.
  - Run: `.\	emplates\scripts\android-setup.ps1` (PowerShell)

Quick verification commands

- flutter doctor -v
- flutter devices
- adb devices
- flutter doctor --android-licenses (accept licenses)

How to run the app

- Physical device:
  1. Enable Developer options and USB debugging on the phone.
  2. Connect via USB (use a data cable; choose File transfer / MTP mode).
  3. Confirm the RSA fingerprint prompt on the phone.
  4. flutter devices → find device id
  5. flutter run -d <deviceId>

- Emulator (AVD):
  1. Create an AVD via Android Studio AVD Manager or using `avdmanager`.
  2. emulator -avd <name>
  3. flutter devices → flutter run -d <emulatorId>

Troubleshooting

- adb not found: ensure `platform-tools` is installed and in PATH.
- Device shown as "unauthorized": accept RSA prompt on phone and/or revoke USB debugging authorizations and reconnect.
- Device not listed: try different USB cable/port; install OEM driver; reboot phone/PC.

If you want, I can create an AVD for you or provide the exact OEM USB driver link if you tell me your phone model.
