# Online Car Wash APP

A cross-platform Flutter app for booking and managing car and bike wash services. The app provides user authentication, profile management, booking creation and editing, subscription handling, and in-app payments.

Project name: `Online Car Wash App`

## Key features
- User authentication and complete profile flow
- Create, view, edit and cancel bookings
- Booking status tracking (confirmed, cancelled, completed)
- Subscription management and in-app payments (Stripe)
- Image/video upload for profiles and listings
- Map and location support (Google Maps, geocoding, geolocator)
- Offline caching with Hive and secure storage
- Responsive UI using assets in `assets/` and `images/`

## Tech stack
- Flutter (Dart)
- State management: GetX (`get`)
- HTTP & networking: Dio
- Local storage: Hive, flutter_secure_storage
- Maps & location: google_maps_flutter, geolocator, geocoding
- Payment: flutter_stripe

## Getting started
Prerequisites
- Flutter SDK (compatible with Dart SDK >= 3.9.2)
- Android Studio / Xcode (for platform builds)

Quick start
1. Clone the repository
   git clone <repo-url>
2. From the project root run:
   flutter pub get
3. Run on a device or simulator:
   flutter run

Building
- Android (APK):
  flutter build apk --release
- iOS (device):
  flutter build ios --release

## Configuration
- App entry: `lib/main.dart`
- Dependencies and assets are declared in `pubspec.yaml`.
- Stripe and any API keys should be stored securely (do not commit keys). Use `flutter_dotenv` or native config.
- Keystore and signing files are excluded by `.gitignore`; follow Flutter docs to add your keys for release builds.

## Project structure (important folders)
- `lib/` — application source code
- `assets/icons/`, `assets/images/` — UI assets
- `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/` — platform folders

## Contributing
1. Fork the repo
2. Create a feature branch
3. Add clear commit messages and tests when possible
4. Open a pull request with a description of changes

## License
Add a `LICENSE` file (MIT or other) if you plan to open-source the project.

If you want, I can add a short Getting Started section tailored to macOS (Xcode) or create a GitHub workflow for CI. 
