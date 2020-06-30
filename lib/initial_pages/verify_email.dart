import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/services/Crud.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:eat_now/validation/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'AuthListener.dart';
import '../services/MyServices.dart';

class VerifyEmail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<VerifyEmail> {
  var text = 'Verify Email Address';
  RxServices get service => GetIt.I<RxServices>();
  @override
  Widget build(BuildContext context) {
    var pr = getDialog(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: double.infinity,
              child: Image.asset('assets/verify_img.jpg')),
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 10.0),
            child: Text(
              'Before you eat!',
              style: GoogleFonts.dancingScript(
                  color: aux2,
                  fontWeight: FontWeight.w700,
                  fontSize: 38),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'One last step, Click the button below and head over to your mail to verify your email address',
              textAlign: TextAlign.center,
              style: GoogleFonts.asap(
                  color: aux2,
                  fontWeight: FontWeight.w200,
                  fontSize: 16),
            ),
          ),

//          Expanded(
//            child: Container(),
//          ),
          SizedBox(
            height: 35,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: aux2,
                elevation: 3.0,
                child: Text(
                  text,
                  style: GoogleFonts.asap(
                      color: aux1,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                onPressed: () async {
                  if (text.contains('Continue')) {
                    pr.show();
                    String email = service.role=='user'?service.myUser.basicInfo.email:service.myVenor.persVInfo.cemail;
                    String pass = service.role=='user'?service.myUser.basicInfo.password:service.myVenor.persVInfo.cpassword;
                    CrudOperations.reAuthenticateUser(email: email, password: pass).then((value){
                      pr.hide();
                      if(!value.error){
                        if(value.data.user.isEmailVerified) {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (_) => AuthListener()));
                        }else{
                          Fluttertoast.showToast(
                              msg: 'Please verify your email', toastLength: Toast.LENGTH_LONG);
                        }
                      }else{
                        Fluttertoast.showToast(
                            msg: value.errorMessage, toastLength: Toast.LENGTH_LONG);
                      }
                    });

                    return;
                  }
                  try {
                    pr.show();
                    await service.firebaseUser
                        .sendEmailVerification()
                        .then((value) {
                      Fluttertoast.showToast(msg: 'Verification Link sent');
                      pr.hide();
                      setState(() {
                        text = 'Continue';
                      });
                    });
                  } catch (e) {
                    pr.hide();
                    Fluttertoast.showToast(msg: 'An error occured');
                    print(e.message);
                  }
                }),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  side: BorderSide(color: aux2, width: 1.0),
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: aux1,
                elevation: 3.0,
                child: Text(
                  'Use another email',
                  style: GoogleFonts.asap(
                      color: aux2,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                onPressed: () => FirebaseAuth.instance.signOut()),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
