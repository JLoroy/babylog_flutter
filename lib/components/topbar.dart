import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    this.auth,
  });

  final FirebaseAuth? auth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50
        ),
        Container(
          decoration: BoxDecoration(
            color:Color(0xFFFCF7F3),
            boxShadow: [BoxShadow(blurRadius: 20, offset:Offset(0, 15) ,color: Color(0xFFFCF7F3))],
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Louisa",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24)
                      ),
                    Text("Babylog Assistant",style: TextStyle(letterSpacing: 1.5, fontSize: 12)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => signOutFromBabylog(context),
                      icon: Icon(Icons.logout)
                    ),
                    // CircleAvatar(
                    //   radius:20,
                    //   backgroundImage: Image.asset('assets/avatar.png').image,test4@gmail.com
                    // )
                  ]
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void signOutFromBabylog(BuildContext context) {
    FirebaseUIAuth.signOut(context: context,auth: auth);
    Navigator.pushReplacementNamed(context, '/auth');
  }  
}