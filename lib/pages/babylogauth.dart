import 'package:babylog/pages/babylogapp.dart';
import 'package:babylog/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class AuthGateApp extends StatelessWidget {
 const AuthGateApp({super.key});

 String get initialRoute {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return '/auth';
    }
    return '/app';
  }

 @override
 Widget build(BuildContext context) {
   //final providers = [EmailAuthProvider()];
   return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/auth': (context) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/app');
              }),
              ForgotPasswordAction((context, email) {
                Navigator.pushNamed(
                  context,
                  '/forgot-password',
                  arguments: {'email': email},
                );
              }),
            ],
          );
        },
        '/app': (context) {
          return BabylogApp();
        },
        '/forgot-password': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'],
            headerMaxExtent: 200,
          );
        },
        '/settings': (context) => SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Babylog',
   );
  }
}