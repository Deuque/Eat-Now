import 'dart:ui';

import 'package:eat_now/navigations/fade_route.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:eat_now/validation/register.dart';
import 'package:eat_now/validation/register_vendor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../validation/login.dart';

class ValType extends StatefulWidget {
  @override
  _ValTypeState createState() => _ValTypeState();
}

class _ValTypeState extends State<ValType> {
  String valtype, valrole;

  @override
  Widget build(BuildContext context) {
    void _bottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: aux1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Material(
            color: aux1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 259,
                  width: 259,
                  child: Image.asset(
                    'assets/valtype.png',
                    height: 259,
                    width: 259,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("How would you like to $valtype",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: aux6,
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: aux2,
                  elevation: 2.3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 22),
                    child: Text(
                      'Customer',
                      style: GoogleFonts.roboto(
                          color: aux1,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  onPressed: () {
                    Widget widget =
                        valtype == 'Login' ? Login(type: 'user') : Register();
                    Navigator.push(context, FadeRoute(page: widget));
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: aux1,
                  elevation: 2.3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 22),
                    child: Text(
                      'Vendor',
                      style: GoogleFonts.roboto(
                          color: aux2,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  onPressed: () {
                    Widget widget = valtype == 'Login'
                        ? Login(type: 'vendor')
                        : RegisterVendor();
                    Navigator.push(context, FadeRoute(page: widget));
                  },
                ),
                SizedBox(
                  height: 13,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: aux1,
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
                            color: aux1,
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
                      color: aux2, fontWeight: FontWeight.w300, fontSize: 16),
                ),
                onPressed: () {
                  _bottomSheet();
                  setState(() {
                    valtype = 'Login';
                  });
                },
              ),
              Container(
                  width: double.infinity,
                  height: 68,
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                    ),
                    color: aux2,
                    elevation: 3.0,
                    child: Text(
                      'LET\'S START',
                      style: GoogleFonts.asap(
                          color: aux1,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                    onPressed: () {
                      _bottomSheet();
                      setState(() {
                        valtype = 'Register';
                      });
                    },
                  ))
            ],
          )
        ],
      ),
    );
  }
}
