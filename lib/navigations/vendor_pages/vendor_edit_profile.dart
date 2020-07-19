import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/ApiResponse.dart';
import 'package:eat_now/models/delivery_vendor_info.dart';
import 'package:eat_now/models/payment_vendor_info.dart';
import 'package:eat_now/models/personal_vendor_info.dart';
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

import '../../confirm_order.dart';
class VEditProfile extends StatefulWidget {
  @override
  _VEditProfileState createState() => _VEditProfileState();
}

class _VEditProfileState extends State<VEditProfile> {
  RxServices get service => GetIt.I<RxServices>();
  List<CountryModel> countries = [];
  List<StateModel> states = [];
  List<CityModel> cities = [];
  var selCountry, selState;
  String selectedCategory;
  ApiService apiService = new ApiService();

  var _name,_num;
  var _country, _state, _city, _address;
  bool _deliver;
  var _deliveryPrice;
  var _bank, _account_no;
  File logo,banner;
  final formkey = new GlobalKey<FormState>();
  int _radioValue1 ;



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
  _deliver = service.myVenor.delVInfo.deliver;
  _radioValue1 = _deliver?1:2;

  initializeRegions();
    super.initState();
  }

  initializeRegions() async{
    await apiService.getCountries().then((value) {
      if (!value.error) {
        setState(() {
          countries = value.data;
        });
      }
    });
    selCountry = countries.firstWhere(
            (element) => element.name == service.myVenor.persVInfo.country);
    await apiService
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
    selState = states.firstWhere(
            (element) => element.region == service.myVenor.persVInfo.state);
    apiService
        .getCities(selCountry.code, selState.region)
        .then((value) {
      if (!value.error) {
        setState(() {
          cities = value.data;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {



    var pr = getDialog(context);
    getImage(type) async {
      File file = await FilePicker.getFile(type: FileType.image);

      setState(() {
        if(type=='logo') {
          logo = file;
        }else{
          banner = file;
        }
      });
    }

    double iconsize = 82;
    Padding padding = Padding(
      padding: const EdgeInsets.only(left: 110.0,right: 15),
      child: Divider(thickness: 1.2,color: aux41,),
    );

    void setDelivery(value) {
      setState(() {
        _radioValue1 = value;
        _deliver = value == 1;
      });
    }

    EditProfile() async {
      if (checkFields()) {
        pr.show();
        Vendor vendor = Vendor(
            persVInfo: PersonalVendorInfo(
              cemail: service.myVenor.persVInfo.cemail,
              cname: _name,
              cpassword: service.myVenor.persVInfo.cpassword,
              country: _country,
              state: _state,
              city: _city,
              cnum: _num,
              address: _address,
              logoUrl: service.myVenor.persVInfo.logoUrl,
              bannerUrl: service.myVenor.persVInfo.bannerUrl,
              imgkey: service.myVenor.persVInfo.imgkey,
            ),
            payVInfo: PaymentVendorInfo(bank: _bank, account_no: _account_no),
            delVInfo:
            DeliveryVendorInfo(deliver: _deliver, price: _deliveryPrice));
        var timekey = DateTime.now();
        if (logo != null) {

          ApiResponse<String> Logoresponse = await CrudOperations.uploadImage(
              file: logo,
              key: service.myVenor.persVInfo.imgkey.isEmpty?'${timekey.millisecondsSinceEpoch}':service.myVenor.persVInfo.imgkey,
              path: 'ProfileImages');
          if (Logoresponse.error) {
            pr.hide();
            Fluttertoast.showToast(
                msg: 'Logo Upload Error: ' + Logoresponse.errorMessage,
                toastLength: Toast.LENGTH_LONG);
            return;
          }
          vendor.persVInfo.logoUrl = Logoresponse.data;
          vendor.persVInfo.imgkey = service.myVenor.persVInfo.imgkey.isEmpty?'${timekey.millisecondsSinceEpoch}':service.myVenor.persVInfo.imgkey;
//          await CrudOperations.uploadData(
//              service.firebaseUser.uid, 'vendor', vendor).then((value) {
//            pr.hide();
//            if (value.data) {
//              Fluttertoast.showToast(
//                  msg: 'Update Successful');
//            } else {
//              Fluttertoast.showToast(
//                  msg: 'Upload Error: ' + value.errorMessage,
//                  toastLength: Toast.LENGTH_LONG);
//            }
//            logo = null;
//          });

        }

        if (banner != null) {
          ApiResponse<String> bannerresponse = await CrudOperations.uploadImage(
              file: banner,
              key: service.myVenor.persVInfo.imgkey.isEmpty?'${timekey.millisecondsSinceEpoch}':service.myVenor.persVInfo.imgkey,
              path: 'BannerImages');
          if (bannerresponse.error) {
            pr.hide();
            Fluttertoast.showToast(
                msg: 'Banner Upload Error: ' + bannerresponse.errorMessage,
                toastLength: Toast.LENGTH_LONG);
            return;
          }
          vendor.persVInfo.bannerUrl = bannerresponse.data;
          vendor.persVInfo.imgkey = service.myVenor.persVInfo.imgkey.isEmpty?'${timekey.millisecondsSinceEpoch}':service.myVenor.persVInfo.imgkey;
        }
          await CrudOperations.uploadData(
              service.firebaseUser.uid, 'vendor', vendor).then((value) {
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
            banner = null;

          });

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
              color: aux6,
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
            Container(
              height: 120,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 90,
                    width: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: service.myVenor==null?'':service.myVenor.persVInfo.bannerUrl??'',
                          imageBuilder:
                              (context, imageProvider) =>
                              Container(
                                height: 90,
                                width: double.infinity,
                                child: banner==null?Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ):Image.file(banner,fit: BoxFit.cover,),
                              ),
                          placeholder: (context, url) =>
                              Container(
                                height: 90,
                                color: aux1,
                              ),
                          errorWidget: (context, url, error) =>
                              Container(
                                height: 90,
                                color: aux1,
                              ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
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
                              onTap: (){getImage('banner');},
                              child: Icon(Icons.add_a_photo,color: aux4,size: 18,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 87,
                      width: 87,
                      alignment: Alignment.center,

                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: service.myVenor==null?'':service.myVenor.persVInfo.logoUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              height: iconsize,
                              width: iconsize,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(iconsize/2),
                                  border: Border.all(color: aux1,width: 2)
                              ),
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
                                onTap: (){getImage('logo');},
                                child: Icon(Icons.add_a_photo,color: aux4,size: 18,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 23,),
            Divider(thickness: 1.2,color: aux41,),
            EditProfileForms(label: 'Category',resolvetext: (value)=>selectedCategory=value,initText: service.myVenor.persVInfo.category,),
            padding,
            EditProfileForms(label: 'Name',resolvetext: (value)=>_name=value,initText: service.myVenor.persVInfo.cname,),
            padding,
            EditProfileForms(label: 'Email',resolvetext: (value){},initText: service.myVenor.persVInfo.cemail,readOnly: true,),
            padding,
            EditProfileForms(label: 'Mobile Number',resolvetext: (value)=>_num=value,initText: service.myVenor.persVInfo.cnum, isNum: true,),
            padding,
            EditProfileDropDown(
              label: 'Country/Region',
              initText: service.myVenor.persVInfo.country,
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
              initText: service.myVenor.persVInfo.state,
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
              initText: service.myVenor.persVInfo.city,
              choices: cities,
              resolvetext: (value) => _city = value,
              setNextText: (value) {},
            ),
            padding,
            EditProfileForms(label: 'Address',resolvetext: (value)=>_address=value,initText: service.myVenor.persVInfo.address,),
            Divider(thickness: 1.2,color: aux41,),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 14,bottom: 8),
              child: Text(
                'Payment Information',
                style: GoogleFonts.asap(
                    color: aux2,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),

            ),
            EditProfileForms(label: 'Bank',resolvetext: (value)=>_bank=value,initText: service.myVenor.payVInfo.bank,),
            padding,
            EditProfileForms(label: 'Account No',resolvetext: (value)=>_account_no=value,initText: service.myVenor.payVInfo.account_no,isNum: true,),
            Divider(thickness: 1.2,color: aux41,),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 14,bottom: 8),
              child: Text(
                'Delivery Information',
                style: GoogleFonts.asap(
                    color: aux2,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),

            ),
            Row(
              children: <Widget>[
                SizedBox(width: 14,),
                Text(
                  'Do you deliver?',
                  style: GoogleFonts.sourceSansPro(
                      color: aux4,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                SizedBox(width: 3,),
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
            padding,
            Visibility(visible: _deliver,child: EditProfileForms(label: 'Delivery Price',resolvetext: (value)=>_deliveryPrice=value,initText: service.myVenor.delVInfo.price,isNum: true)),
          SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
