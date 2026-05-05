# Babylog

Babylog is every parent's dearest comapnion. It is a mobile app that allows you to record your baby events onto a shared timeline, using GenAI to transcribe the audio into events.

## Installation

Before you can run Babylog, you need to make sure Flutter is installed and set up on your local machine. For help with this, refer to Flutter's [official documentation](https://flutter.dev/docs/get-started/install).

## Project Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/jloroy/babylog_flutter.git
   ```

2. Navigate to the project directory:

   ```bash
   cd babylog
   ```

3. Get Flutter packages:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

## Usage

1. Press the 'REC' button to start recording. Press it again to stop.

2. Press the 'Send' button to send the audio file to OpenAI for transcription. The transcribed text will be displayed in the text area.

## Android release signing (AAB)

Release signing is configured to be **portable** and to avoid committing secrets.

### Option A — `android/key.properties` (recommended)

1. Copy the example file:

   ```bash
   cp android/key.properties.example android/key.properties
   ```

2. Edit `android/key.properties` to point to your keystore and credentials.

Notes:
- `android/key.properties` is gitignored.
- The `storeFile` can be an absolute path, or a path relative to the `android/` folder.

### Option B — CI via env vars

Set these environment variables in CI:
- `ERA_NOVA_ANDROID_STORE_FILE`
- `ERA_NOVA_ANDROID_STORE_PASSWORD`
- `ERA_NOVA_ANDROID_KEY_ALIAS`
- `ERA_NOVA_ANDROID_KEY_PASSWORD`

Then build a signed release:

```bash
flutter build appbundle --release
```

## License

Babylog is licensed under the [MIT License](LICENSE.md).

## Acknowledgements

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* [OpenAI](https://openai.com/)