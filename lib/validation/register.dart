import 'package:eat_now/AuthListener.dart';
import 'package:eat_now/models/UserModel.dart';
import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/validation/register_forms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Crud.dart';
import '../models/MyServices.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<Register> {
  var _name, _email, _password;
  var _dob, _country, _state, _city, _address, _occupation, _num;
  final formkey = new GlobalKey<FormState>();

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);

    var pr = appstate.getDialog(context);

    createUser() async {
      if (checkFields()) {
        pr.show();
        User user = User(
            basicInfo:
                BasicInfo(email: _email, fname: _name, password: _password),
            personalInfo: PersonalInfo(
                dob: _dob,
                country: _country,
                state: _state,
                city: _city,
                address: _address,
                occupation: _occupation,
                num: _num));

        CrudOperations.createUser(user).then((result) {
          if (result.error) {
            pr.hide();
            Fluttertoast.showToast(
                msg: 'Register Error: ' + result.errorMessage,
                toastLength: Toast.LENGTH_LONG);
          } else {
            CrudOperations.uploadData(result.data.user.uid, user).then((value) {
              pr.hide();
              if (value.data) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => AuthListener()));
              } else {
                Fluttertoast.showToast(
                    msg: 'Upload Error: ' + result.errorMessage,
                    toastLength: Toast.LENGTH_LONG);
              }
            });
          }
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appstate.aux2,
          elevation: 0,
        ),
        body: ListView(children: <Widget>[
          Container(
            color: appstate.aux2,
            height: 110,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                Text(
                  'Register',
                  style: GoogleFonts.dancingScript(
                      color: appstate.aux1,
                      fontWeight: FontWeight.w700,
                      fontSize: 38),
                ),
                SizedBox(height: 5),
                Text(
                  'Enter your information correctly, so we get to know you better',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.asap(
                      color: appstate.aux1,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ],
            ),
          ),
          Form(
              key: formkey,
              child: Container(
                padding: EdgeInsets.all(15.0),
                color: appstate.aux5,
                child: Column(
                  children: <Widget>[
                    RegForms(
                      label: 'Full Name',
                      resolvetext: (value) => _name = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'Email',
                      resolvetext: (value) => _email = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'Password',
                      resolvetext: (value) => _password = value,
                      isPassword: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 10),
                      child: Text(
                        'Personal Information',
                        style: GoogleFonts.asap(
                            color: appstate.aux3,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                    ),
                    RegForms(
                      label: 'Date of birth',
                      resolvetext: (value) => _dob = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'Country/Region',
                      resolvetext: (value) => _country = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'State',
                      resolvetext: (value) => _state = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'City',
                      resolvetext: (value) => _city = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'Address',
                      resolvetext: (value) => _address = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'Occupation',
                      resolvetext: (value) => _occupation = value,
                      isPassword: false,
                    ),
                    RegForms(
                      label: 'Mobile number',
                      resolvetext: (value) => _num = value,
                      isPassword: false,
                    ),
                    Container(
                      width: double.infinity,
                      height: 67,
                      padding: EdgeInsets.all(15),
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: appstate.aux2,
                        elevation: 3.0,
                        child: Text(
                          'SUBMIT',
                          style: GoogleFonts.asap(
                              color: appstate.aux1,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                        onPressed: createUser,
                      ),
                    )
                  ],
                ),
              ))
        ]));
  }
}
