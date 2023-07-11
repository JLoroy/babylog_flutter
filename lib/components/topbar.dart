import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    Key? key,
    this.auth,
    required this.settings,
  }) : super(key: key);

  final FirebaseAuth? auth;
  final Function() settings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFCF7F3),
            boxShadow: [BoxShadow(blurRadius: 20, offset: Offset(0, 15), color: Color(0xFFFCF7F3))],
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Louisa",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24),
                    ),
                    Text("Babylog Assistant", style: TextStyle(letterSpacing: 1.5, fontSize: 12)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PopupMenuButton<int>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text("Settings"),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text("Sign Out"),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 1) {
                          // Navigate to Settings page
                          settings();
                        } else if (value == 2) {
                          // Sign out
                          signOutFromBabylog(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void signOutFromBabylog(BuildContext context) {
    FirebaseUIAuth.signOut(context: context, auth: auth);
  }
}
