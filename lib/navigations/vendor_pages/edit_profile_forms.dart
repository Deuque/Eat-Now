import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/services/MyServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class EditProfileForms extends StatelessWidget {
  final label, resolvetext,initText,isNum;

  EditProfileForms({this.label,this.resolvetext,this.initText,this.isNum=false});


  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController(text: initText);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        color: aux1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.sourceSansPro(
                  color: aux4,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            Expanded(
              child: TextFormField(
                inputFormatters: !isNum?null:[
                  WhitelistingTextInputFormatter(
                      RegExp("[0-9]")),
                ],
                keyboardType: !isNum?TextInputType.text:TextInputType.number,
                controller: controller,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
                style: GoogleFonts.sourceSansPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: aux4),
                onSaved: resolvetext,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Field required';
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}