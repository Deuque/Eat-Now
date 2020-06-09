import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/MyServices.dart';

class OrderSuccess extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context);
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: appstate.aux2,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Container(
            height: 350,
            decoration: BoxDecoration(
                color: appstate.aux8,
                borderRadius: BorderRadius.circular(8)
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 35),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                    radius: 40,
                    backgroundColor: appstate.aux12,
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: appstate.aux2,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Order Complete',
                    style: GoogleFonts.dancingScript(
                        color: appstate.aux2,
                        fontWeight: FontWeight.w700,
                        fontSize: 38),
                  ),
                ),
                Text(
                  'Your order has been completed and delivery is on the way. You will be notified as soon as possible',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color: appstate.aux2,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                SizedBox(height:40),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: appstate.aux6,

                  ),
                  iconSize: 20,
                  onPressed: ()=> Navigator.pop(context),
                )
              ],
            ),
          )
      ),
    );
  }

}