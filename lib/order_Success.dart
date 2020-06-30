import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'services/MyServices.dart';

class OrderSuccess extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: aux2,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Container(
            height: 350,
            decoration: BoxDecoration(
                color: aux8,
                borderRadius: BorderRadius.circular(8)
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 35),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                    radius: 40,
                    backgroundColor: aux12,
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: aux2,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Order Complete',
                    style: GoogleFonts.dancingScript(
                        color: aux2,
                        fontWeight: FontWeight.w700,
                        fontSize: 38),
                  ),
                ),
                Text(
                  'Your order has been completed and delivery is on the way. You will be notified as soon as possible',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color: aux2,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                SizedBox(height:40),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: aux6,

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