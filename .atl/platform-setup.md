# Platform Setup for Google Sign-In

## Android

Google Sign-In requires the app's SHA-1 fingerprint registered in the Firebase Console.

**Steps:**
1. Generate the SHA-1 fingerprint:
   ```
   cd android && ./gradlew signingReport
   ```
   Copy the **debug** SHA-1 for development; use the release SHA-1 for production builds.

2. Go to **Firebase Console → Project Settings → Your Android App**.
3. Under "SHA certificate fingerprints", click **Add fingerprint** and paste the SHA-1.
4. Download the updated `google-services.json` and replace `android/app/google-services.json`.

> Skipping this step will cause a `PlatformException` at runtime when Google Sign-In is attempted on Android.

---

## iOS

Google Sign-In requires the reversed client ID added as a URL scheme in `Info.plist`.

**Steps:**
1. Open `ios/Runner/Info.plist`.
2. Find `REVERSED_CLIENT_ID` in `ios/Runner/GoogleService-Info.plist`.
3. Add the following block to `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from `GoogleService-Info.plist`.

---

## macOS

Same URL scheme setup as iOS, but in `macos/Runner/Info.plist`.

Additionally, add network entitlements to `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`:

```xml
<key>com.apple.security.network.client</key>
<true/>
```

> macOS Google Sign-In support is best-effort. It may not function correctly in all macOS environments.

---

## Windows

Google Sign-In is **not supported** on Windows via the `google_sign_in` Flutter plugin. The "Continuar con Google" button should be hidden or disabled on Windows builds.

> Windows behavior is best-effort — the app must not crash if Google Sign-In is unavailable.

---

## Web

Add the Google Sign-In OAuth client ID meta tag to `web/index.html`:

```html
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
```

Find the client ID in **Firebase Console → Project Settings → Web App → OAuth 2.0 client ID**.

---

## Manual Commands (must be run after dependency/code changes)

After modifying `pubspec.yaml` (adding `google_sign_in`):
```
flutter pub get
```

After modifying `RecipeEntity` (adding `id` field) and `RecipeModel` (adding `id`, `toJson`, `fromEntity`):
```
dart run build_runner build --delete-conflicting-outputs
```

This regenerates:
- `lib/features/recipe/domain/entities/recipe_entity.freezed.dart`
- `lib/features/recipe/data/models/recipe_model.g.dart`

Verify there are no compile errors before proceeding to Phase 2.

---

## Firestore Security Rules Deployment

MANDATORY before going to production.

### Deploy via Firebase CLI
```bash
# Install Firebase CLI if not installed
npm install -g firebase-tools

# Login
firebase login

# Deploy only Firestore rules (safe — does not affect other Firebase services)
firebase deploy --only firestore:rules

# Verify deployment
firebase firestore:rules:list
```

### Important
- Rules are NOT automatically deployed when you push code
- Test rules in Firebase Console → Firestore → Rules → Rules Playground
- Current rules enforce: deny-all by default, UID-matching on users/{uid}/recipes subcollection
- `firestore.rules` is at the project root; `firebase.json` points to it via the `firestore.rules` key
