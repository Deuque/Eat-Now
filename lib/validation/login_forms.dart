import 'package:eat_now/models/MyServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginForms extends StatelessWidget {
  final label, hint;
  final resolvetext;
  bool isPassword;

  LoginForms({this.label, this.hint, this.resolvetext, this.isPassword});

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    return Container(
      color: appstate.aux1,
      width: double.maxFinite,
      child: TextFormField(
        style: GoogleFonts.sourceSansPro(
            fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87),
        keyboardType: TextInputType.text,
        onSaved: resolvetext,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field required';
          }
        },
        obscureText: isPassword,
        decoration: InputDecoration(
            labelText: label,
            fillColor: Colors.white,
            filled: true,
            border: UnderlineInputBorder(),
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
      ),
    );
  }
}
