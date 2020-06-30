import 'package:eat_now/models/ApiResponse.dart';
import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../initial_pages/AuthListener.dart';
import '../services/Crud.dart';
import '../services/MyServices.dart';
import 'login_forms.dart';

class Login extends StatefulWidget {
  final type;

  const Login({Key key, this.type}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<Login> {
  TextEditingController econtrol = new TextEditingController();
  TextEditingController pcontrol = new TextEditingController();
  final formkey = new GlobalKey<FormState>();
  var _email, _password;

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

    var pr = getDialog(context);

    LoginUser() {
      if (checkFields()) {
        pr.show();
        CrudOperations.loginUser(
                BasicInfo(email: _email.toString().trim(), password: _password))
            .then((result) async {

          if (!result.data) {
            pr.hide();
            Fluttertoast.showToast(
                msg: result.errorMessage, toastLength: Toast.LENGTH_LONG);
          } else {
            ApiResponse response = await CrudOperations.checkUserRole(_email);
            if (response.error) {
              Fluttertoast.showToast(
                  msg: result.errorMessage, toastLength: Toast.LENGTH_LONG);
              return;
            }
            pr.hide();
            CrudOperations.setRole(response.data?'vendor':'user');
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                AuthListener()), (Route<dynamic> route) => false);
//            Navigator.pushReplacement(
//                context, MaterialPageRoute(builder: (_) => AuthListener()));

          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: aux2,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: aux2,
            height: 90,
            width: double.infinity,
            child: Center(
              child: Text(
                'Login',
                style: GoogleFonts.dancingScript(
                    color: aux1,
                    fontWeight: FontWeight.w700,
                    fontSize: 38),
              ),
            ),
          ),
          Form(
              key: formkey,
              child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LoginForms(
                        label: 'Email Address',
                        hint: 'johndoe@gmail.com',
                        resolvetext: (value) => _email = value,
                        isPassword: false,
                      ),
                      SizedBox(height: 15.0),
                      LoginForms(
                        label: 'Password',
                        hint: 'johndoepass123',
                        resolvetext: (value) => _password = value,
                        isPassword: true,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.asap(
                              color: aux2,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: aux2,
                          elevation: 3.0,
                          child: Text(
                            'LOGIN',
                            style: GoogleFonts.asap(
                                color: aux1,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          onPressed: LoginUser,
                        ),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}
