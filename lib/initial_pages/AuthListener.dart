
import 'package:eat_now/initial_pages/verify_email.dart';
import 'package:eat_now/navigations/vendor_pages/vendor_dash.dart';
import 'package:eat_now/services/Crud.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../services/MyServices.dart';
import '../navigations/pageholder.dart';
import 'onboarding.dart';

class AuthListener extends StatelessWidget {
  RxServices get service => GetIt.I<RxServices>();

  @override
  Widget build(BuildContext context) {

    Widget state = Center(
      child: CircularProgressIndicator(
        backgroundColor: aux1,
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
              service.setFirebaseUser(user);
              service.getFoodItems();



                return FutureBuilder(
                  future: CrudOperations.getRole(),
                  builder: (_, snapshot) {

                    if (snapshot.hasData) {
                      service.setRole(snapshot.data);
                      if (snapshot.data == 'user') {
                        service.setMyUser(user.uid);
                        service.getVendors();
                      }else{
                        service.setMyVendor(user.uid);
                      }


                      if (!user.isEmailVerified) {
                        return VerifyEmail();
                      }


                      if (snapshot.data == 'user') {
                        return PageHolder();
                      }

                      return VendorDash();
                    } else {
                      return state;
                    }
                  },
                );

            }
            return Onboarding();
          }
        });
  }
}
