import 'package:eat_now/navigations/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/MyServices.dart';
import 'cart.dart';

class NavItems extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context,listen: true);

    Route _createRoute(Widget w) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => w,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    }

    _navigateToWidget(Widget w){
      Navigator.pop(context);
      Navigator.of(context).push(_createRoute(w));
    }

    return Container(
      color: appstate.aux2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(15.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: appstate.aux5,
                size: 20.0,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo1.jpeg',
                  height: 180,
                  width: 200,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 15),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      'Explore',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.asap(
                          color: appstate.aux1,
                          fontWeight: FontWeight.w300,
                          fontSize: 19),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      'Track meal',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.asap(
                          color: appstate.aux1,
                          fontWeight: FontWeight.w300,
                          fontSize: 19),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      _navigateToWidget(Profile());
                    },
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.asap(
                          color: appstate.aux1,
                          fontWeight: FontWeight.w300,
                          fontSize: 19),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: InkWell(
                    splashColor: appstate.aux22,
                    onTap: () {
                      _navigateToWidget(Cart());

                    },
                    child: Text(
                      'Cart',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.asap(
                          color: appstate.aux1,
                          fontWeight: FontWeight.w300,
                          fontSize: 19),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 50,
            child: FlatButton(
              color: appstate.aux3,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Logout',
                textAlign: TextAlign.center,
                style: GoogleFonts.asap(
                    color: appstate.aux2,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }

}