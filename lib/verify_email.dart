import 'package:eat_now/validation/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/MyServices.dart';

class VerifyEmail extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }

}

class MyState extends State<VerifyEmail>{
  var text = 'Verify Email Address';

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    var pr = appstate.getDialog(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: double.infinity,
              child: Image.asset('assets/verify_img.jpg')),
          Padding(
            padding: const EdgeInsets.only(top:25,bottom: 10.0),
            child: Text(
              'Before you eat!',
              style: GoogleFonts.dancingScript(
                  color: appstate.aux2,
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
                  color: appstate.aux2,
                  fontWeight: FontWeight.w200,
                  fontSize: 16),
            ),
          ),

//          Expanded(
//            child: Container(),
//          ),
          SizedBox(height: 35,),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: appstate.aux2,
                elevation: 3.0,
                child: Text(
                  text,
                  style: GoogleFonts.asap(
                      color: appstate.aux1,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                onPressed: () async{
                  if(text.contains('verified')){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> Login()));
                    return;
                  }
                  try {
                    pr.show();
                    await appstate.getUser.sendEmailVerification().then((value){
                      Fluttertoast.showToast(msg: 'Verification Link sent');
                      pr.hide();
                      setState(() {
                        text = 'I have verified my email';
                      });
                    });
                  } catch (e) {
                    pr.hide();
                    Fluttertoast.showToast(msg: 'An error occured');
                    print(e.message);
                  }
                }

            ),

          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  side: BorderSide(color: appstate.aux2, width: 1.0),
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: appstate.aux1,
                elevation: 3.0,
                child: Text(
                  'Use another email',
                  style: GoogleFonts.asap(
                      color: appstate.aux2,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                onPressed: () =>
                FirebaseAuth.instance.signOut()


            ),

          ),
        SizedBox(height: 15,)
        ],
      ),
    );
  }

}