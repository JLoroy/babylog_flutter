import 'package:babylog/pages/babylogapp.dart';
import 'package:babylog/pages/assistantManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AuthGateApp extends StatelessWidget {
  const AuthGateApp({super.key});

  String get initialRoute {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return '/auth';
    }
    return '/app';
  }

  void backToAuth(context) {
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
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
        '/app': (context) => MaterialApp(
          home: AssistantManager(backToAuth: () => backToAuth(context)),
        ),
        '/forgot-password': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'],
            headerMaxExtent: 200,
          );
        },
      },
      debugShowCheckedModeBanner: false,
      title: 'Babylog',
    );
  }
}