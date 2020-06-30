import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/ApiResponse.dart';
import 'package:eat_now/models/delivery_vendor_info.dart';
import 'package:eat_now/models/payment_vendor_info.dart';
import 'package:eat_now/models/personal_vendor_info.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/vendor_pages/edit_profile_forms.dart';
import 'package:eat_now/services/Crud.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
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
  var _name, _email, _password,_num;
  var _country, _state, _city, _address;
  bool _deliver = true;
  var _deliveryPrice;
  var _bank, _account_no;
  File logo;

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
  Widget build(BuildContext context) {

    _deliver = service.myVenor.delVInfo.deliver;
    _radioValue1 = _deliver?1:2;

    var pr = getDialog(context);
    getImage() async {
      File file = await FilePicker.getFile(type: FileType.image);
      setState(() {
        logo = file;
      });
    }

    double iconsize = 78;
    Padding padding = Padding(
      padding: const EdgeInsets.only(left: 50.0,right: 15),
      child: Divider(thickness: 1.2,),
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
              cemail: _email,
              cname: _name,
              cpassword: service.myVenor.persVInfo.cpassword,
              country: service.myVenor.persVInfo.country,
              state: service.myVenor.persVInfo.state,
              city: service.myVenor.persVInfo.city,
              address: _address,
              logoUrl: service.myVenor.persVInfo.logoUrl,
              logokey: service.myVenor.persVInfo.logokey,
            ),
            payVInfo: PaymentVendorInfo(bank: _bank, account_no: _account_no),
            delVInfo:
            DeliveryVendorInfo(deliver: _deliver, price: _deliveryPrice));

        if (logo != null) {
          ApiResponse<String> Logoresponse = await CrudOperations.uploadImage(
              file: logo,
              key: service.myVenor.persVInfo.logokey,
              path: 'ProfileImages');
          if (Logoresponse.error) {
            pr.hide();
            Fluttertoast.showToast(
                msg: 'Image Upload Error: ' + Logoresponse.errorMessage,
                toastLength: Toast.LENGTH_LONG);
            return;
          }
          vendor.persVInfo.logoUrl = Logoresponse.data;
          vendor.persVInfo.logokey = service.myVenor.persVInfo.logokey;
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
          });

        }else{
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
          });
        }
      }else{
        Fluttertoast.showToast(
            msg: 'Fill all fields');
      }

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: aux1,
        iconTheme: IconThemeData(color: aux2),
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.roboto(
              color: aux2,
              fontWeight: FontWeight.w900,
              fontSize: 15),
        ),
        actions: <Widget>[
         InkWell(
           onTap: EditProfile,
           child:  Text(
             'Done',
             style: GoogleFonts.roboto(
                 color: aux77,
                 fontWeight: FontWeight.w400,
                 fontSize: 16),
           ),
         )
        ],
      ),
      body: Form(
        key: formkey,
        child: ListView(
          children: <Widget>[
            Container(
              height: 83,
              width: 83,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: service.myVenor==null?'':service.myVenor.persVInfo.logoUrl,
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
                    child: FlatButton(
                      onPressed: getImage,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(width: 1.2,color: aux1)
                      ),
                      color: Colors.white30,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.add_a_photo,color: aux4,),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 23,),
            Divider(thickness: 1.2,),
            EditProfileForms(label: 'Name',resolvetext: (value)=>_name=value,initText: service.myVenor.persVInfo.cname,),
            padding,
            EditProfileForms(label: 'Email',resolvetext: (value)=>_email=value,initText: service.myVenor.persVInfo.cemail,),
            padding,
            EditProfileForms(label: 'Number',resolvetext: (value)=>_name=value,initText: service.myVenor.persVInfo.cnum, isNum: true,),
            padding,
            EditProfileForms(label: 'Address',resolvetext: (value)=>_address=value,initText: service.myVenor.persVInfo.address,),
            Divider(thickness: 1.2,),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Payment Information',
                style: GoogleFonts.asap(
                    color: aux2,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),

            ),
            EditProfileForms(label: 'Bank',resolvetext: (value)=>_bank=value,initText: service.myVenor.payVInfo.bank,),
            padding,
            EditProfileForms(label: 'Account No',resolvetext: (value)=>_account_no=value,initText: service.myVenor.payVInfo.account_no,),
            Divider(thickness: 1.2,),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                SizedBox(width: 6.9,),
                Text(
                  'Do you deliver?',
                  style: GoogleFonts.sourceSansPro(
                      color: aux4,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
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
            Visibility(visible: _deliver,child: EditProfileForms(label: 'Delivery Price',resolvetext: (value)=>_deliveryPrice=value,initText: service.myVenor.delVInfo.price,)),
          ],
        ),
      ),
    );
  }
}
