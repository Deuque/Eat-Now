import 'dart:ui';

import 'package:eat_now/validation/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/MyServices.dart';
import 'validation/login.dart';

class ValType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 420,
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/ob1.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              // make sure we apply clip it properly
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(30.0),
                    child: Text(
                        "We believe everyone deserves a meal when hungry, so go ahead and order a meal...",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.asap(
                            color: appstate.aux1,
                            fontWeight: FontWeight.w200,
                            fontSize: 16)),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Have an account? Login",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.asap(
                      color: appstate.aux2,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Login())),
              ),
              Container(
                width: double.infinity,
                height: 68,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                    ),
                    color: appstate.aux2,
                    elevation: 3.0,
                    child: Text(
                      'LET\'S START',
                      style: GoogleFonts.asap(
                          color: appstate.aux1,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Register()))),
              )
            ],
          )
        ],
      ),
    );
  }
}
