import 'package:eat_now/models/MyServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegForms extends StatelessWidget{
  final label;
  final resolvetext;
  bool isPassword;
  RegForms({this.label,this.resolvetext,this.isPassword});

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: appstate.aux7, width: 1),
            color: appstate.aux1

        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none
                ),
                style: GoogleFonts.sourceSansPro(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                keyboardType: TextInputType.text,
                obscureText: isPassword,
                onSaved: resolvetext,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Field required';
                  }
                },
              ),
            ),
            Text(
              label,
              style: GoogleFonts.sourceSansPro(
                  color: appstate.aux4,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

}