# Android — Release checklist for *new* app (package: `com.liness.appnew`)

## Immediate steps I completed
- Removed forbidden permission `WRITE_SECURE_SETTINGS`.
- Updated package id to `com.liness.appnew` (Gradle + Manifest + MainActivity). 
- Synced versions: `pubspec.yaml` -> `2.0.0+1`, Android `versionName=2.0.0`, `versionCode=1`.
- Created a new keystore: `android/keystore_new.jks` and `android/keystore_new.properties` (DO NOT commit these to public repo).

## Actions you must do in Play Console / Firebase
1. Create a new app in Google Play Console (use package name `com.liness.appnew`).
2. (If you use Firebase) Create a new Firebase Android app for `com.liness.appnew` and download `google-services.json` → place it in `android/app/`.
3. In Play Console: upload the generated AAB to Internal testing first, fill Data safety form, privacy policy URL, screenshots, and release notes.
4. If you want Play App Signing: register upload key (the keystore I created is the upload key unless you replace it).

## Files I produced / changed
- `android/keystore_new.jks` — NEW keystore (storePassword/keyPassword: **Liness@2026!**) 
- `android/keystore_new.properties` — properties for Gradle (already wired to build.gradle when present)
- `build/app/outputs/bundle/release/app-release.aab` — (will be generated after build)

## Security & best practices
- Move `android/keystore_new.jks` and `android/keystore_new.properties` to a secure location (password manager, secure vault).
- Do NOT commit keystore or passwords to git.

## Next recommended steps
- Register app in Play Console and Firebase, upload `google-services.json`.
- Run an internal test release, verify crashlytics logs and analytics.
- Provide me the Play Console rejection message (if any) and I will fix it.

---
If you want, I can now build the AAB and upload the artifact here for you to download and upload to Play Console.