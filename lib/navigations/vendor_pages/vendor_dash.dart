import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/initial_pages/validation_type.dart';
import 'package:eat_now/models/food_item.dart';
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

import 'orders.dart';
class VendorDash extends StatefulWidget {
  @override
  _VendorDashState createState() => _VendorDashState();
}

class _VendorDashState extends State<VendorDash> {
  RxServices get service => GetIt.I<RxServices>();
  @override
  Widget build(BuildContext context) {
    double iconsize = 70;

    Widget itemsdisplay(String count,String label){
      return   Padding(
        padding: const EdgeInsets.only(top:30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              count,
              style: GoogleFonts.roboto(
                  color: aux6,
                  fontWeight: FontWeight.w500,

                  fontSize: 16),
            ),
            SizedBox(height: 14,),
            Text(
              label,
              style: GoogleFonts.roboto(
                  color: aux4,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
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




    return Scaffold(
      backgroundColor: aux1,
      body: StreamBuilder(
        stream: service.myVendStream,
        builder: (_,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          if(snapshot.hasData && snapshot.data!=null){
            Vendor vendor = snapshot.data;
            return ListView(
              children: <Widget>[
                Container(
                  height: 100+iconsize,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: service.myVenor.persVInfo.bannerUrl,
                              imageBuilder:
                                  (context, imageProvider) =>
                                  Container(
                                    height: 100,
                                    width: double.infinity,
                                    child: Image(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              placeholder: (context, url) =>
                                  Container(
                                    height: 100,
                                    color: aux1,
                                  ),
                              errorWidget: (context, url, error) =>
                                  Container(
                                    height: 100,
                                    color: aux1,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: iconsize,
                              width: iconsize,
                              child: CachedNetworkImage(
                                imageUrl: vendor==null?'':vendor.persVInfo.logoUrl,
                                imageBuilder: (context, imageProvider) => Container(
                                  height: iconsize,
                                  width: iconsize,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(iconsize/2),
                                      border: Border.all(color: aux1,width: 2)
                                  ),
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
                            StreamBuilder<List<FoodItem>>(
                                stream: service.foodStream,
                                builder: (context, snapshot) {

                                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                                    List myItems = snapshot.data;
                                    myItems.removeWhere(
                                            (element) => element.vendor != service.firebaseUser.uid);
                                    return itemsdisplay('${myItems.length}', 'Food Items');
                                  }
                                  return itemsdisplay('0', 'Food Items');
                                }),

                            SizedBox(width: 20,),
                            itemsdisplay('0', 'Orders Completed'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 6,),
                      Row(
                        children: <Widget>[
                          Text(
                            vendor==null?'':'${vendor.persVInfo.cname}',
                            style: GoogleFonts.roboto(
                                color: aux22,
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                          ),
                          vendor.isVerified?Icon(Icons.verified_user,color: Colors.green,size: 16,):
                          Text(
                            '',
                            style: GoogleFonts.roboto(
                                color: aux77,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Text(
                        vendor==null?'': '${vendor.persVInfo.cemail}',
                        style: GoogleFonts.roboto(
                            color: aux4,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        vendor==null?'':'${vendor.persVInfo.address},\n${vendor.persVInfo.city}, ${vendor.persVInfo.state}',
                        style: GoogleFonts.roboto(
                            color: aux4,
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                      ),

                      SizedBox(height: 22,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(6))
                            ),
                            color: aux77,
                            onPressed: (){
                              Navigator.push(context, FadeRoute(page: VEditProfile()));
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
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(6))
                            ),
                            color: aux4,
                            onPressed: (){},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20),
                              child: Text(
                                'Request Payments',
                                style: GoogleFonts.roboto(
                                    color: aux1,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      itemdisplay2('Catalogue', 'View, add or delete Food items', (){
                        Navigator.push(context, FadeRoute(page: Catalogue()));
                      }),
                      SizedBox(height: 15,),
                      itemdisplay2('Orders', 'View, dispatch or cancel orders', (){
                        Navigator.push(context, FadeRoute(page: Orders()));
                      }),
                      SizedBox(height: 15,),
                      itemdisplay2('Logout', '', (){
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.pushReplacement(context, FadeRoute(page: ValType()));
                        });
                      }),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              ],
            );
          }

          return Text('Error Fetching Data');
        },
      ),
    );
  }
}
