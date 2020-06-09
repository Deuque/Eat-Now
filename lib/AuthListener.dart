import 'package:eat_now/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/MyServices.dart';
import 'navigations/pageholder.dart';
import 'onboarding.dart';

class AuthListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    Widget state = Center(
      child: CircularProgressIndicator(
        backgroundColor: appstate.aux1,
      ),
    );
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return state;
          } else {
            if (snapshot.hasData) {
              FirebaseUser user = snapshot.data;
              appstate.setFirebaseUser(user);
              if (user.isEmailVerified) {
                appstate.setMyUser(user.uid);
                return PageHolder();
              }
              return VerifyEmail();
            }
            return Onboarding();
          }
        });
  }
}
