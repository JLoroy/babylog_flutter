import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isChecking = false;
  bool _error = false;
  bool _isResending = false;
  bool _resendError = false;

  Future<void> _checkVerification() async {
    setState(() {
      _isChecking = true;
      _error = false;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If user is null, something is off – sign them out or go to /auth
      Navigator.pushReplacementNamed(context, '/auth');
      return;
    }

    // Reload user to ensure we get updated emailVerified status
    await user.reload();

    if (user.emailVerified) {
      Navigator.pushReplacementNamed(context, '/app');
    } else {
      setState(() {
        _isChecking = false;
        _error = true;
      });
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
      _resendError = false;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Possibly signed out behind the scenes
        Navigator.pushReplacementNamed(context, '/auth');
        return;
      }

      await user.sendEmailVerification();
    } catch (e) {
      setState(() {
        _resendError = true;
      });
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isChecking
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'We have sent a verification link to your email address. '
                      'Please click the link, then return here and press "Check Status".',
                      textAlign: TextAlign.center,
                    ),
                    if (_error)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Email not verified yet. Please try again or resend the link.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _checkVerification,
                      child: const Text('Check Status'),
                    ),
                    const SizedBox(height: 16),
                    _isResending
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _resendVerificationEmail,
                            child: const Text('Resend Verification Email'),
                          ),
                    if (_resendError)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Failed to resend email. Check your network connection.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _signOut,
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
