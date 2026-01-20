<#
PowerShell helper: android-setup.ps1
- Temporarily configures PATH for the current session (Android SDK & platform-tools)
- Verifies Flutter + Android SDK setup
- Lists AVDs and available system images
- (Optional) shows commands to create/start an emulator and run the app

Usage (PowerShell):
  ./scripts/android-setup.ps1

This script DOES NOT change system environment variables permanently.
#>

param(
    [string]$SdkPath = "$env:USERPROFILE\AppData\Local\Android\Sdk",
    [switch]$CreateAvd
)

Write-Host "Using Android SDK path: $SdkPath" -ForegroundColor Cyan

if (-Not (Test-Path $SdkPath)) {
    Write-Error "SDK path not found: $SdkPath`nPlease verify Android Studio SDK Manager -> SDK Location.";
    exit 1
}

# Add SDK tools to current session PATH
$platformTools = Join-Path $SdkPath 'platform-tools'
$toolsBin = Join-Path $SdkPath 'cmdline-tools\latest\bin'
if (-Not (Test-Path $toolsBin)) {
  # fallback location (cmdline-tools may be under 'bin' or 'latest')
  $toolsBin = Join-Path $SdkPath 'cmdline-tools\bin'
}

$env:PATH = "$platformTools;$toolsBin;${env:PATH}"
$env:ANDROID_SDK_ROOT = $SdkPath
$env:ANDROID_HOME = $SdkPath

Write-Host "Temporary PATH updated for this session." -ForegroundColor Green

# 1) Verify Flutter + Android
Write-Host "\n==> Running: flutter doctor -v" -ForegroundColor Yellow
flutter doctor -v

# 2) List adb devices (if phone is connected)
Write-Host "\n==> Running: adb devices" -ForegroundColor Yellow
adb devices || Write-Host "(adb not found in PATH)" -ForegroundColor DarkYellow

# 3) List installed SDK packages
Write-Host "\n==> Running: sdkmanager --list (may take a few seconds)" -ForegroundColor Yellow
if (Get-Command sdkmanager -ErrorAction SilentlyContinue) {
  sdkmanager --list
} else {
  Write-Host "sdkmanager not found in PATH. Ensure 'Android SDK Command-line Tools' is installed." -ForegroundColor DarkYellow
}

# 4) List available AVDs
Write-Host "\n==> Running: emulator -list-avds" -ForegroundColor Yellow
if (Get-Command emulator -ErrorAction SilentlyContinue) {
  emulator -list-avds
} else {
  Write-Host "Emulator not available (install Android Emulator in SDK Manager)." -ForegroundColor DarkYellow
}

# 5) Optional: create an AVD (commented by default)
if ($CreateAvd) {
  Write-Host "\n==> Creating AVD 'ezycart_pixel' (example)" -ForegroundColor Yellow
  Write-Host "This will attempt to install a system-image if missing (may require user approval)." -ForegroundColor DarkYellow
  # Example commands (uncomment to run interactively):
  # sdkmanager "system-images;android-31;google_apis;x86_64"
  # avdmanager create avd -n ezycart_pixel -k "system-images;android-31;google_apis;x86_64" --device "pixel"
  # emulator -avd ezycart_pixel &
}

# 6) Quick run instructions
Write-Host "\n==> Quick commands (copy/paste):" -ForegroundColor Cyan
Write-Host "adb devices                        # show attached phones" -ForegroundColor Gray
Write-Host "flutter devices                    # Flutter-detectable devices" -ForegroundColor Gray
Write-Host "flutter run -d <deviceId>          # run app on device" -ForegroundColor Gray
Write-Host "emulator -list-avds                # list AVDs" -ForegroundColor Gray
Write-Host "emulator -avd <name>               # start an AVD" -ForegroundColor Gray

Write-Host "\nIf you plug your phone in now (USB debugging enabled), re-run: adb devices  -> flutter run -d <deviceId>" -ForegroundColor Green
