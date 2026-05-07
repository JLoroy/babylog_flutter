import 'package:babylog/pages/babylogauth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'scripts/firebase_options.dart';

const googleOAuthClientId =
    '328975985379-pr8mkiluvddcjhk1m6tcj3rqn0ld2059.apps.googleusercontent.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: googleOAuthClientId),
  ]);

  runApp(const AuthGateApp());
}
