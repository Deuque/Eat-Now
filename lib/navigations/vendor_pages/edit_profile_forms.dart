import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/services/MyServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

TextStyle mystyle = GoogleFonts.sourceSansPro(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: aux6);
class EditProfileForms extends StatelessWidget {
  final label, resolvetext,initText,isNum,readOnly;

  EditProfileForms({this.label,this.resolvetext,this.initText,this.isNum=false, this.readOnly=false});


  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController(text: initText);
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      alignment: Alignment.centerLeft,
      color: aux1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 67,
            child: Text(
              label,
              style: GoogleFonts.sourceSansPro(
                  color: aux4,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          SizedBox(width: 46,),
          Expanded(
            child: TextFormField(
              inputFormatters: !isNum?null:[
                WhitelistingTextInputFormatter(
                    RegExp("[0-9]")),
              ],
              readOnly: readOnly,
              keyboardType: !isNum?TextInputType.text:TextInputType.number,
              controller: controller,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
              style: mystyle,
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
    );
  }
}

class EditProfileDropDown extends StatefulWidget {
  final label;
  final initText;
  final resolvetext;
  final setNextText;
  final choices;

  EditProfileDropDown({this.label, this.initText,this.setNextText, this.resolvetext, this.choices});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}
class MyState extends State<EditProfileDropDown> {
  String text;
  var choices = <String>[];
  TextEditingController mController;

  @override
  void initState() {
    text = widget.initText;
    mController = new TextEditingController(text: text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    choices = [];
    for (final item in widget.choices) {
      if (!choices.contains(item.choice)) {
        choices.add(item.choice);
      } else {
        print(item.choice);
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      alignment: Alignment.centerLeft,
      color: aux1,
      child: Row(
        children: <Widget>[
          Container(
            width: 67,
            child: Text(
              widget.label,
              style: GoogleFonts.sourceSansPro(
                  color: aux4,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          SizedBox(width: 46,),
          Expanded(
            child: InkWell(
              onTap: _bottomSheet,
              child: TextFormField(
                onTap: _bottomSheet,
                controller: mController,
                readOnly: true,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
                style: mystyle,
                keyboardType: TextInputType.text,
                onSaved: widget.resolvetext,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Field required';
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      context: context,
      builder: (context) => Container(
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, top: 20, right: 8, bottom: 7),
              child: Text(
                'Select ${widget.label}',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18, fontWeight: FontWeight.w600, color: aux2),
              ),
            ),
            Divider(
              height: 1,
              color: aux4,
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 15),
                separatorBuilder: (_, i) => Divider(
                  color: aux8,
                  height: 1,
                ),
                itemBuilder: (_, i) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        mController.text = widget.choices[i].choice;
                      });
                      widget.setNextText(mController.text);
                      Navigator.pop(context);
                    },
                    title: Text(
                      '${widget.choices[i].choice}',
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    trailing: widget.choices[i].choice == mController.text
                        ? Icon(
                      Icons.check,
                      color: aux2,
                      size: 18,
                    )
                        : Text(''),
                  );
                },
                itemCount: widget.choices.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditProfileDate extends StatefulWidget {
  final label;
  final resolvetext;
  final initText;

  EditProfileDate({this.label, this.resolvetext, this.initText});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState1();
  }
}

class MyState1 extends State<EditProfileDate> {
  TextEditingController dateController;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != DateTime.now())
      dateController.text = picked.toLocal().toString().split(" ")[0];
  }

  @override
  void initState() {
    dateController  = new TextEditingController(text: widget.initText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      alignment: Alignment.centerLeft,
      color: aux1,
      child: Row(
        children: <Widget>[
          Container(
            width: 67,
            child: Text(
              widget.label,
              style: GoogleFonts.sourceSansPro(
                  color: aux4,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          SizedBox(width: 46,),
          Expanded(
            child: InkWell(
              child: TextFormField(
                onTap: () => _selectDate(context),
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
                style: mystyle,
                keyboardType: TextInputType.text,
                onSaved: widget.resolvetext,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Field required';
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegDropDown2 extends StatefulWidget {
  final resolvetext;
  List<String> choices;

  RegDropDown2({this.resolvetext, this.choices});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState2();
  }
}

class MyState2 extends State<RegDropDown2> {
  String dropdown;
  @override
  void initState() {
    dropdown = widget.choices[0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: DropdownButton<String>(
        underline: Container(),
        isExpanded: true,
        items: widget.choices.map((String ditem) {
          return DropdownMenuItem<String>(
            value: ditem,
            child: Text(ditem,style: mystyle,),
          );
        }).toList(),
        onChanged: (String newitem) {
          widget.resolvetext(newitem);
          setState(() {
            this.dropdown = newitem;
          });
        },
        value: dropdown,
      ),
    );
  }
}