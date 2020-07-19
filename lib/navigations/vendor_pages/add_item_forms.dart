import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/services/MyServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

BoxDecoration adecor = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    color: aux1,
//  border: Border.all(width: 0),
//  boxShadow: [
//    BoxShadow(
//        color: aux8.withOpacity(.5),
//        offset: Offset(0.0, 1.1),
//        blurRadius: 8.0)
//  ],
);
class AddItemForms extends StatelessWidget {
  final resolvetext,controller,isdesc,isNum;

  AddItemForms({this.resolvetext,this.controller,this.isdesc=false,this.isNum=false});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: adecor,
        child: TextFormField(
          inputFormatters: !isNum?null:[
            WhitelistingTextInputFormatter(
                RegExp("[0-9]")),
          ],
          keyboardType: !isNum?TextInputType.text:TextInputType.number,
          controller: controller??TextEditingController(),
          maxLines: 3,
          minLines: isdesc?3:1,
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
    );
  }
}

class AddItemImage extends StatelessWidget {
  final label;
  final resolveFile;

  AddItemImage({this.label, this.resolveFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Container(
        height: 42,
        width: double.maxFinite,
        decoration: adecor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: aux4)
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: FlatButton(
                onPressed: resolveFile,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(5))),
                color: aux4,
                child: Text(
                  'Select Image',
                  style: GoogleFonts.sourceSansPro(
                      color: aux1,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}