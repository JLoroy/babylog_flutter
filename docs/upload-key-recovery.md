# Babylog Upload Key Recovery

Last updated: 2026-05-06

Purpose:
Resolve the current Android release-signing blocker without exposing signing
secrets in the repo.

Official references:

- Use Play App Signing:
  https://support.google.com/googleplay/android-developer/answer/9842756
- Prepare and roll out a release:
  https://support.google.com/googleplay/android-developer/answer/9859348

## Update
the password has been recovered and is stored in the android/key.properties

## Current Evidence

- Upload key archive is present in `~/Documents`.
- `~/Documents/AndroidReleaseKeys/eranova_upload.jks` is present.
- `~/Documents/AndroidReleaseKeys/private_key.pepk` is present.
- The zip archive contains the same two files.
- The ignored `android/key.properties` points to the local JKS file and alias
  `upload`.
- The correct password has been recovered and configured in ignored
  `android/key.properties`.
- `keytool -list` opens the configured keystore and alias with Java 17.
- `flutter build appbundle --release` produced
  `build/app/outputs/bundle/release/app-release.aab` on 2026-05-06.

Do not commit `android/key.properties`, keystore files, PEPK files, passwords,
or generated certificates containing private-key material.

## Path 1: Correct password found

Use this path when rebuilding with the recovered keystore and key password.

1. Update the ignored `android/key.properties` locally.
2. Confirm the keystore opens:

```bash
JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH" \
keytool -list -v \
  -keystore ~/Documents/AndroidReleaseKeys/eranova_upload.jks \
  -alias upload
```

3. Build the signed release bundle:

```bash
JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH" \
flutter build appbundle --release
```

4. Continue with `docs/play-release-runbook.md`.

## Path 2: Password cannot be recovered

Use this path if the password is actually lost and the app is already enrolled
in Play App Signing.

Google's Play App Signing documentation says the account owner can initiate an
upload key reset in Play Console when the private upload key is lost or
compromised. Resetting the upload key does not affect the app signing key that
Google Play uses to sign APKs delivered to users.

1. Confirm in Play Console whether Babylog is enrolled in Play App Signing.
2. Go to `Test and release > Setup > App signing`.
3. Create a new local upload key:

```bash
keytool -genkeypair \
  -v \
  -keystore ~/Documents/AndroidReleaseKeys/babylog_upload_20260505.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

4. Store the new passwords in the team password manager, not in git.
5. Export the upload certificate:

```bash
keytool -export -rfc \
  -keystore ~/Documents/AndroidReleaseKeys/babylog_upload_20260505.jks \
  -alias upload \
  -file ~/Documents/AndroidReleaseKeys/upload_certificate.pem
```

6. In Play Console, request or continue the upload key reset and provide
   `upload_certificate.pem` when prompted.
7. Wait for Google Play confirmation that the new upload key is registered.
8. Update ignored `android/key.properties` to point at the new keystore.
9. Re-run `flutter build appbundle --release`.
10. Continue with internal testing in `docs/play-release-runbook.md`.

## If Play App Signing Is Not Enabled

If this app is not enrolled in Play App Signing and the app signing key is lost,
Google Play may not be able to accept updates for the existing package. Do not
create a new package name until the Play Console signing state has been checked
and recorded in `STATUS.md`.

## Evidence To Capture

- Whether Babylog is enrolled in Play App Signing.
- The Play Console app signing page status.
- If password recovery succeeds: `keytool -list -v` fingerprint output, without
  passwords.
- If reset is used: reset request date, confirmation date, and the new upload
  certificate fingerprint.
- The successful signed AAB path:
  `build/app/outputs/bundle/release/app-release.aab`.
