import 'dart:io';

import 'package:eat_now/models/ApiResponse.dart';
import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_vendor_info.dart';
import 'package:eat_now/models/payment_vendor_info.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/models/personal_vendor_info.dart';
import 'package:eat_now/models/user_model.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:eat_now/validation/register_forms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../confirm_order.dart';
import '../initial_pages/AuthListener.dart';
import '../services/ApiService.dart';
import '../services/Crud.dart';
import '../services/MyServices.dart';
import '../services/city_model.dart';
import '../services/country_model.dart';
import '../services/state_model.dart';

class RegisterVendor extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<RegisterVendor> {
  var _name, _email, _password;
  var _country, _state, _city, _address;
  bool _deliver = true;
  var _deliveryPrice;
  var _bank, _account_no;
  File logo;

  List<CountryModel> countries = [];
  List<StateModel> states = [];
  List<CityModel> cities = [];
  var selCountry, selState;
  final formkey = new GlobalKey<FormState>();
  ApiService apiService = new ApiService();
  int _radioValue1 = 1;

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

    getImage() async {
      File file = await FilePicker.getFile(type: FileType.image);

      setState(() {
        logo = file;
      });
    }

    void setDelivery(value) {
      setState(() {
        _radioValue1 = value;
        _deliver = value == 1;
      });
    }

    createVendor() async {
      if (checkFields() && logo!=null) {
        pr.show();
        Vendor vendor = Vendor(
            persVInfo: PersonalVendorInfo(
              cemail: _email,
              cname: _name,
              cpassword: _password,
              country: _country,
              state: _state,
              city: _city,
              address: _address,
            ),
            payVInfo: PaymentVendorInfo(bank: _bank, account_no: _account_no),
            delVInfo:
            DeliveryVendorInfo(deliver: _deliver, price: _deliveryPrice));

        await CrudOperations.createUser(vendor.persVInfo.cemail, vendor.persVInfo.cpassword).then((result) async{
          if (result.error) {
            pr.hide();
            Fluttertoast.showToast(
                msg: 'Register Error: ' + result.errorMessage,
                toastLength: Toast.LENGTH_LONG);
          } else {
            var timekey = DateTime.now();
            ApiResponse<String> Logoresponse= await CrudOperations.uploadImage(file: logo, key: '${timekey.millisecondsSinceEpoch}', path: 'ProfileImages');
            if(Logoresponse.error){
              pr.hide();
              Fluttertoast.showToast(
                  msg: 'Image Upload Error: ' + Logoresponse.errorMessage,
                  toastLength: Toast.LENGTH_LONG);
              return;
            }
            vendor.persVInfo.logoUrl = Logoresponse.data;
            vendor.persVInfo.logokey = timekey.millisecondsSinceEpoch.toString();
            await CrudOperations.uploadData(result.data.user.uid, 'vendor', vendor).then((value) {
              pr.hide();
              if (value.data) {
                CrudOperations.setRole('vendor');
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    AuthListener()), (Route<dynamic> route) => false);
              } else {
                Fluttertoast.showToast(
                    msg: 'Upload Error: ' + value.errorMessage,
                    toastLength: Toast.LENGTH_LONG);
              }
            });

          }
        });
      }
    }

    EdgeInsetsGeometry myPadding = EdgeInsets.symmetric(horizontal: 18,vertical: 20);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: aux2,
        elevation: 0,
      ),


          body:
          ListView(
              children: <Widget>[
                Container(
                  color: aux2,
                  height: 110,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Register as Vendor',
                        style: GoogleFonts.dancingScript(
                            color: aux1,
                            fontWeight: FontWeight.w700,
                            fontSize: 38),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Enter your information correctly, so we get to know your company better',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.asap(
                            color: aux1,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
            Form(
                key: formkey,
                child: Container(
                  color: aux41,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: aux1,
                        padding: myPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 15,),
                            Text(
                              'Company Details',
                              style: GoogleFonts.asap(
                                  color: aux2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8,),
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
                            RegDropDown(
                              label: 'Country/Region',
                              choices: countries,
                              resolvetext: (value) => _country = value,
                              setNextText: (value) {
                                selCountry = countries
                                    .firstWhere((element) =>
                                element.name == value);
                                apiService.getStates(selCountry.code).then((
                                    value) {
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
                                selState = states
                                    .firstWhere((element) =>
                                element.region == value);
                                apiService
                                    .getCities(
                                    selCountry.code, selState.region)
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
                            RegImage(
                              label: logo==null?'':'Image Selected',
                              resolveFile: getImage,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 12,),
                      Container(
                        color: aux1,
                        padding: myPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Payment Information',
                              style: GoogleFonts.asap(
                                  color: aux2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8,),
                            RegForms(
                              label: 'Bank Name',
                              resolvetext: (value) => _bank = value,
                              isPassword: false,
                            ),
                            RegForms(
                              label: 'Account No',
                              resolvetext: (value) => _account_no = value,
                              isPassword: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12,),
                      Container(
                        color: aux1,

                        padding: myPadding,
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Delivery Information',
                              style: GoogleFonts.asap(
                                  color: aux2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8,),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 6.9,),
                                Text(
                                  'Do you deliver?',
                                  style: GoogleFonts.asap(
                                      color: aux6,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                SizedBox(width: 18,),
                                radioButtons(
                                  title: 'Yes',
                                  value: 1,
                                  groupValue: _radioValue1,
                                  valueChanged: setDelivery,
                                ),
                                SizedBox(width: 7,),
                                radioButtons(
                                  title: 'No',
                                  value: 2,
                                  groupValue: _radioValue1,
                                  valueChanged: setDelivery,
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _deliver,
                              child: RegForms(
                                label: 'Delivery Price',
                                resolvetext: (value) => _deliveryPrice = value,
                                isPassword: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12,),
                      Container(
                        width: double.infinity,
                        height: 87,
                        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                        color: aux1,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
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
                          onPressed: createVendor,
                        ),
                      )
                    ],
                  ),
                ))
          ]),
    );
  }
}
