import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/models/user_model.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:eat_now/validation/register_forms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../initial_pages/AuthListener.dart';
import '../services/ApiService.dart';
import '../services/Crud.dart';
import '../services/city_model.dart';
import '../services/country_model.dart';
import '../services/state_model.dart';

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
  List<CountryModel> countries = [];
  List<StateModel> states = [];
  List<CityModel> cities = [];
  var selCountry, selState;
  final formkey = new GlobalKey<FormState>();
  ApiService apiService = new ApiService();

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    apiService.getCountries().then((value) {
      if (!value.error) {
        setState(() {
          countries = value.data;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pr = getDialog(context);

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

        CrudOperations.createUser(user.basicInfo.email, user.basicInfo.password)
            .then((result) {
          if (result.error) {
            pr.hide();
            Fluttertoast.showToast(
                msg: 'Register Error: ' + result.errorMessage,
                toastLength: Toast.LENGTH_LONG);
          } else {
            CrudOperations.uploadData(result.data.user.uid, 'user', user)
                .then((value) {
              pr.hide();
              if (value.data) {
                CrudOperations.setRole('user');
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    AuthListener()), (Route<dynamic> route) => false);
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

    EdgeInsetsGeometry myPadding =
        EdgeInsets.symmetric(horizontal: 18, vertical: 20);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: aux2,
          elevation: 0,
        ),
        body: ListView(children: <Widget>[
          Container(
            color: aux2,
            height: 110,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                Text(
                  'Register',
                  style: GoogleFonts.dancingScript(
                      color: aux1, fontWeight: FontWeight.w700, fontSize: 38),
                ),
                SizedBox(height: 5),
                Text(
                  'Enter your information correctly, so we get to know you better',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.asap(
                      color: aux1, fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ],
            ),
          ),
          Form(
              key: formkey,
              child: Container(
                color: aux41,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: aux1,
                      padding: myPadding,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Basic Details',
                              style: GoogleFonts.asap(
                                  color: aux2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            SizedBox(
                              height: 7,
                            ),
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
                          ]),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      color: aux1,
                      padding: myPadding,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Other Details',
                              style: GoogleFonts.asap(
                                  color: aux2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            RegDate(
                              label: 'Date of birth',
                              resolvetext: (value) => _dob = value,
                            ),
                            RegDropDown(
                              label: 'Country/Region',
                              choices: countries,
                              resolvetext: (value) => _country = value,
                              setNextText: (value) {
                                selCountry = countries.firstWhere(
                                    (element) => element.name == value);
                                apiService
                                    .getStates(selCountry.code)
                                    .then((value) {
                                  if (!value.error) {
                                    setState(() {
                                      states = value.data;
                                    });
                                  } else {
                                    print(value.errMessage);
                                  }
                                });
                              },
                            ),
                            RegDropDown(
                              label: 'State',
                              choices: states,
                              resolvetext: (value) => _state = value,
                              setNextText: (value) {
                                selState = states.firstWhere(
                                    (element) => element.region == value);
                                apiService
                                    .getCities(selCountry.code, selState.region)
                                    .then((value) {
                                  if (!value.error) {
                                    setState(() {
                                      cities = value.data;
                                    });
                                  }
                                });
                              },
                            ),
                            RegDropDown(
                              label: 'City',
                              choices: cities,
                              resolvetext: (value) => _city = value,
                              setNextText: (value) {},
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
                          ]),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      height: 81,
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      color: aux1,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(9),
                        ),
                        color: aux2,
                        elevation: 3.0,
                        child: Text(
                          'SUBMIT',
                          style: GoogleFonts.asap(
                              color: aux1,
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
