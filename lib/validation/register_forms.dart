import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/services/MyServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

BoxDecoration bdecor = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(color: aux4, width: 0.8),
    color: aux1);
class RegForms extends StatelessWidget {
  final label;
  final resolvetext;
  bool isPassword;

  RegForms({this.label, this.resolvetext, this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: bdecor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
                style: GoogleFonts.sourceSansPro(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
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
                  color: aux4,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}

class RegImage extends StatelessWidget {
  final label;
  final resolveFile;

  RegImage({this.label, this.resolveFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.maxFinite,
        decoration: bdecor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)
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
                  'Select Logo',
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
class RegDate extends StatefulWidget{
  final label;
  final resolvetext;
  RegDate({this.label, this.resolvetext});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState1();
  }

}
class MyState1 extends State<RegDate> {

  TextEditingController dateController = new TextEditingController();


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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: bdecor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: TextFormField(
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
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
            Text(
              widget.label,
              style: GoogleFonts.sourceSansPro(
                  color: aux4,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}

class RegDropDown extends StatefulWidget {
  final label;
  final resolvetext;
  final setNextText;
  final choices;

  RegDropDown({this.label, this.setNextText, this.resolvetext, this.choices});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<RegDropDown> {
  String text = 'Afghanistan';
  var choices =<String>[];
  TextEditingController mController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    choices=[];
    for(final item in widget.choices) {
      if(!choices.contains(item.choice)){
        choices.add(item.choice);
      }else{
        print(item.choice);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration:bdecor,
        child: Row(
          children: <Widget>[
            Expanded(
                child:
                InkWell(
                  onTap: _bottomSheet,
                  child: TextFormField(
                    onTap: _bottomSheet,
                    controller: mController,
                    readOnly: true,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                    keyboardType: TextInputType.text,
                    onSaved: widget.resolvetext,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Field required';
                      }
                    },
                  ),
                ),

//              child:Container(
//                width: 100,
//                child: DropdownButton<String>(
//                      items: choices.map((String ditem) {
//                        return DropdownMenuItem<String>(
//                          value: ditem??null,
//                          child: Text(ditem),
//                        );
//                      }).toList(),
//                      onChanged: (String newitem) {
//                        setState(() {
//                          text = newitem;
//                        });
//                        widget.setNextText(newitem);
//                      },
//                      isExpanded: false,
//                      value: text,
//                    ),
//              ),
            ),
            Text(
              widget.label,
              style: GoogleFonts.sourceSansPro(
                  color: aux4,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            )
          ],
        ),
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
              padding: EdgeInsets.symmetric(
                  vertical: 20),


                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:5.0,top:20,right: 8,bottom: 7),
                    child: Text(
                        'Select ${widget.label}',
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: aux2),
                      ),
                  ),
                    Divider(height: 1,color: aux4,),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        separatorBuilder: (_,i)=>Divider(color: aux8,height: 1,),
                        itemBuilder: (_,i){
                          return ListTile(
                            onTap: (){
                              setState(() {
                                mController.text = widget.choices[i].choice;
                              });
                              widget.setNextText(mController.text);
                              Navigator.pop(context);
                            },
                            title:  Text(
                              '${widget.choices[i].choice}',
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                            trailing: widget.choices[i].choice== mController.text?Icon(Icons.check,color: aux2,size: 18,):Text(''),
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
