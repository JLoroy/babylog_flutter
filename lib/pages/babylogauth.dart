import 'package:babylog/pages/assistantManager.dart';
import 'package:babylog/pages/verifyScreen.dart';
import 'package:babylog/theme/babylog_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

bool authProviderRequiresEmailVerification(Iterable<String> providerIds) {
  return providerIds.contains('password');
}

bool userRequiresEmailVerification(User user) {
  return !user.emailVerified &&
      authProviderRequiresEmailVerification(
        user.providerData.map((provider) => provider.providerId),
      );
}

class AuthGateApp extends StatelessWidget {
  const AuthGateApp({super.key});

  String get initialRoute {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      return '/auth';
    }
    if (userRequiresEmailVerification(user)) {
      return '/verify-email';
    }
    return '/app';
  }

  void backToAuth(context) {
    Navigator.pushReplacementNamed(context, '/auth');
  }

  void goToApp(context, user) async {
    if (user != null) {
      // Reload the user to ensure we have the most up-to-date info
      await user.reload();
      if (userRequiresEmailVerification(user)) {
        // Option: Send them a verification email again
        user.sendEmailVerification();
        Navigator.pushReplacementNamed(context, '/verify-email');
      } else {
        // If email is verified, allow them into the app
        Navigator.pushReplacementNamed(context, '/app');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: BabylogTheme.light(),
      initialRoute: initialRoute,
      routes: {
        '/auth': (context) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                goToApp(context, state.credential.user);
              }),
              AuthStateChangeAction<SignedIn>((context, state) async {
                goToApp(context, state.user);
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
        '/app': (context) =>
            AssistantManager(backToAuth: () => backToAuth(context)),
        '/forgot-password': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'],
            headerMaxExtent: 200,
          );
        },
        '/verify-email': (context) => const VerifyEmailScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Babylog',
    );
  }
}
