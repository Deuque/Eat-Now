import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/ApiResponse.dart';
import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_vendor_info.dart';
import 'package:eat_now/models/payment_vendor_info.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/models/personal_vendor_info.dart';
import 'package:eat_now/models/user_model.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/vendor_pages/edit_profile_forms.dart';
import 'package:eat_now/services/ApiService.dart';
import 'package:eat_now/services/Crud.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:eat_now/services/city_model.dart';
import 'package:eat_now/services/country_model.dart';
import 'package:eat_now/services/state_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  @override
  MyState createState() => MyState();
}

class MyState extends State<EditProfile> {
  RxServices get service => GetIt.I<RxServices>();
  List<CountryModel> countries = [];
  List<StateModel> states = [];
  List<CityModel> cities = [];
  var selCountry, selState;
  ApiService apiService = new ApiService();

  var _name,_num, _country, _state, _city, _address,_occp,_dob;
  File logo;
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
  void initState() {
    setLists();
    super.initState();
  }

  setLists() async{
    await apiService.getCountries().then((value) {
      if (!value.error) {
        setState(() {
          countries = value.data;
        });
      }
    });
    selCountry = countries.firstWhere(
            (element) => element.name == service.myUser.personalInfo.country);
    await apiService
        .getStates(selCountry.code)
        .then((value) {
      if (!value.error) {
        setState(() {
          states = value.data;
        });
      } else {
        Fluttertoast.showToast(msg: value.errMessage);
      }
    });
    selState = states.firstWhere(
            (element) => element.region == service.myUser.personalInfo.state);
   await apiService
        .getCities(selCountry.code, selState.region)
        .then((value) {
      if (!value.error) {
        setState(() {
          cities = value.data;
        });
      }else{
        Fluttertoast.showToast(msg: value.errMessage);
      }
    });
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

    double iconsize = 82;
    Padding padding = Padding(
      padding: const EdgeInsets.only(left: 110.0,right: 15),
      child: Divider(thickness: 1.2,color: aux41,),
    );
    EditProfile() async {
      if (checkFields()) {
        pr.show();
        User user = User(
            basicInfo:
            BasicInfo(email: service.myUser.basicInfo.email, fname: _name, password: service.myUser.basicInfo.password,
            imgUrl: service.myUser.basicInfo.imgUrl, imgKey: service.myUser.basicInfo.imgKey),
            personalInfo: PersonalInfo(
                dob: _dob,
                country: _country,
                state: _state,
                city: _city,
                address: _address,
                occupation: _occp,
                num: _num));

        if (logo != null) {
          var timekey = DateTime.now();
          ApiResponse<String> Logoresponse = await CrudOperations.uploadImage(
              file: logo,
              key: service.myUser.basicInfo.imgKey.isEmpty?'${timekey.millisecondsSinceEpoch}':service.myUser.basicInfo.imgKey,
              path: 'ProfileImages');
          if (Logoresponse.error) {
            pr.hide();
            Fluttertoast.showToast(
                msg: 'Image Upload Error: ' + Logoresponse.errorMessage,
                toastLength: Toast.LENGTH_LONG);
            return;
          }
          user.basicInfo.imgUrl = Logoresponse.data;
          user.basicInfo.imgKey = service.myUser.basicInfo.imgKey.isEmpty?'${timekey.millisecondsSinceEpoch}':service.myUser.basicInfo.imgKey;
          await CrudOperations.uploadData(
              service.firebaseUser.uid, 'user', user).then((value) {
            pr.hide();
            if (value.data) {
              Fluttertoast.showToast(
                  msg: 'Update Successful');
            } else {
              Fluttertoast.showToast(
                  msg: 'Upload Error: ' + value.errorMessage,
                  toastLength: Toast.LENGTH_LONG);
            }
            logo = null;
          });

        }else{
          await CrudOperations.uploadData(
              service.firebaseUser.uid, 'user', user).then((value) {
            pr.hide();
            if (value.data) {
              Fluttertoast.showToast(
                  msg: 'Update Successful');
            } else {
              Fluttertoast.showToast(
                  msg: 'Upload Error: ' + value.errorMessage,
                  toastLength: Toast.LENGTH_LONG);
            }
          });
        }
      }else{
        Fluttertoast.showToast(
            msg: 'Fill all fields');
      }

    }

    return Scaffold(
      backgroundColor: aux1,
      appBar: AppBar(
        backgroundColor: aux1,
        iconTheme: IconThemeData(color: aux2),
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.roboto(
              color: aux2,
              fontWeight: FontWeight.w700,
              fontSize: 18.7),
        ),
        actions: <Widget>[
          InkWell(
            onTap: EditProfile,
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Center(
                child: Text(
                  'Done',
                  style: GoogleFonts.roboto(
                      color: aux77,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: formkey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 15,),
            Container(
              height: 87,
              width: 87,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: service.myUser==null?'':service.myUser.basicInfo.imgUrl,
                    imageBuilder: (context, imageProvider) => SizedBox(
                      height: iconsize,
                      width: iconsize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(iconsize/2),
                        child: logo==null?Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ):Image.file(logo),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      'assets/logo.png',
                      height: iconsize,
                      width: iconsize,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/logo.png',
                      height: iconsize,
                      width: iconsize,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 10,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: aux1)
                      ),
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: getImage,
                        child: Icon(Icons.add_a_photo,color: aux4,size: 18,),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 23,),
            Divider(thickness: 1.2,color: aux41,),
            EditProfileForms(label: 'Name',resolvetext: (value)=>_name=value,initText: service.myUser.basicInfo.fname,),
            padding,
            EditProfileForms(label: 'Email',resolvetext: (value){},initText: service.myUser.basicInfo.email,readOnly: true,),
            Divider(thickness: 1.2,color: aux41,),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 14,bottom: 8),
              child: Text(
                'Other Information',
                style: GoogleFonts.asap(
                    color: aux2,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
            EditProfileDate(
              label: 'Date of birth',
              resolvetext: (value) => _dob = value,
              initText: service.myUser.personalInfo.dob,
            ),
            padding,
            EditProfileDropDown(
              label: 'Country/Region',
              initText: service.myUser.personalInfo.country,
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
            padding,
            EditProfileDropDown(
              label: 'State',
              initText: service.myUser.personalInfo.state,
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
            padding,
            EditProfileDropDown(
              label: 'City',
              initText: service.myUser.personalInfo.city,
              choices: cities,
              resolvetext: (value) => _city = value,
              setNextText: (value) {},
            ),
            padding,
            EditProfileForms(label: 'Address',resolvetext: (value)=>_address=value,initText: service.myUser.personalInfo.address,),
            padding,
            EditProfileForms(label: 'Occupation',resolvetext: (value)=>_occp=value,initText: service.myUser.personalInfo.occupation,),
            padding,
            EditProfileForms(label: 'Mobile Number',resolvetext: (value)=>_num=value,initText: service.myUser.personalInfo.num, isNum: true,),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
