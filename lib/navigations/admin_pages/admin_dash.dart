import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/initial_pages/validation_type.dart';
import 'package:eat_now/models/admin_model.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/user_model.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/fade_route.dart';
import 'package:eat_now/navigations/vendor_pages/catalogue.dart';
import 'package:eat_now/navigations/vendor_pages/vendor_edit_profile.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:eat_now/validation/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admins_vendors_list.dart';

class AdminDash extends StatefulWidget {
  @override
  _AdminDashState createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  RxServices get service => GetIt.I<RxServices>();
  @override
  Widget build(BuildContext context) {
    double iconsize = 74;

    Widget itemsdisplay(String count,String label){
      return   Padding(
        padding: const EdgeInsets.only(top:12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              count,
              style: GoogleFonts.roboto(
                  color: aux6,
                  fontWeight: FontWeight.w600,

                  fontSize: 16.5),
            ),
            SizedBox(height: 14,),
            Text(
              label,
              style: GoogleFonts.roboto(
                  color: aux4,
                  fontWeight: FontWeight.w300,
                  fontSize: 14.7),
            ),
          ],
        ),
      );
    }

    Widget itemdisplay2(title,body, click){
     return InkWell(
       onTap: click,
       child: Container(
         padding: EdgeInsets.symmetric(horizontal: 3,vertical: 7),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(6.5),
           color: aux41
         ),
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.roboto(
                  color: aux2,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
            subtitle: Text(
              body,
              style: GoogleFonts.roboto(
                  color: aux4,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.3),
            ),
            trailing:  CircleAvatar(
                radius: 15,
                backgroundColor: aux1,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: aux2,
                    size: 15,
                  ),
                )),
          ),
        ),
     );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: aux1,
        body: StreamBuilder(
          stream: service.adminStream,
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }

            if(snapshot.hasData && snapshot.data!=null){
              Admin admin = snapshot.data;
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: iconsize,
                        width: iconsize,
                        child: CachedNetworkImage(
                          imageUrl: admin==null?'':admin.imgUrl,
                          imageBuilder: (context, imageProvider) => SizedBox(
                            height: iconsize,
                            width: iconsize,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(iconsize/2),
                              child: Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
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
                      ),
                      Spacer(),
                      StreamBuilder<List<User>>(
                          stream: service.usersStream,
                          builder: (context, snapshot) {

                            if (snapshot.hasData && snapshot.data.isNotEmpty) {
                              List myItems = snapshot.data;
                              return itemsdisplay('${myItems.length}', 'Users');
                            }
                            return itemsdisplay('0', 'Users');
                          }),
                      SizedBox(width: 30,),
                      StreamBuilder<List<Vendor>>(
                          stream: service.vendorStream,
                          builder: (context, snapshot) {

                            if (snapshot.hasData && snapshot.data.isNotEmpty) {
                              List myItems = [];
                              snapshot.data.forEach((element) {if(element.isVerified)myItems.add(element);});
                              return itemsdisplay('${myItems.length}', 'Verified\nVendors');
                            }
                            return itemsdisplay('0', 'Verified\nVendors');
                          }),
                      SizedBox(width: 10,),
                    ],
                  ),
                  SizedBox(height: 14,),
                  Text('Admin',
                  style: GoogleFonts.roboto(
                  color: aux22,
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    admin==null?'': '${admin.email}',
                    style: GoogleFonts.roboto(
                        color: aux4,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  SizedBox(height: 22,),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    color: aux77,
                    onPressed: (){

                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20),
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.roboto(
                            color: aux1,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  itemdisplay2('Payment Requests', 'View payment requests by vendors', (){
//                    Navigator.push(context, FadeRoute(page: Catalogue()));
                  }),
                  SizedBox(height: 15,),
                  itemdisplay2('Vendors', 'View and verify vendors', (){
                    Navigator.push(context, FadeRoute(page: AdminVendorsList()));
                  }),
                  SizedBox(height: 15,),
                  itemdisplay2('Customers', 'View all customers', (){
//                    Navigator.push(context, FadeRoute(page: Orders()));
                  }),
                  SizedBox(height: 15,),
                  itemdisplay2('Logout', '', (){
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(context, FadeRoute(page: ValType()));
                    });
                  }),
                ],
              );
            }

            return Text('Error Fetching Data');
          },
        ),
      ),
    );
  }
}
