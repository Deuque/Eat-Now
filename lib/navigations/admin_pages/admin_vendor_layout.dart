
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/admin_pages/admin_vendor_profile.dart';
import 'package:eat_now/navigations/fade_route.dart';
import 'package:eat_now/navigations/view_vendor.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminVendorLayout extends StatelessWidget{
  const AdminVendorLayout({Key key, this.vendor}) : super(key: key);

  RxServices get service => GetIt.I<RxServices>();
  final Vendor vendor;
  @override
  Widget build(BuildContext context) {
    double iconsize = 40;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
      child: Card(
        elevation: 3,
        child: ListTile(
          leading:     CachedNetworkImage(
            imageUrl: vendor==null?'':vendor.persVInfo.logoUrl,
            imageBuilder: (context, imageProvider) => SizedBox(
              height: iconsize,
              width: iconsize,
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular( iconsize/2),
                child: Image(
                  image: imageProvider,
                  width: iconsize,
                  height: iconsize,
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
          title: Row(
            children: <Widget>[
              Text(
                vendor.persVInfo.cname,
                style: GoogleFonts.roboto(
                    color: aux6,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              SizedBox(width: 3,),
              vendor.isVerified?Icon(Icons.verified_user,color: Colors.green,size: 16,):Container()
            ],
          ),
          subtitle: Text(
            vendor.persVInfo.cemail,
            style: GoogleFonts.roboto(
                color: aux4,
                fontWeight: FontWeight.w300,
                fontSize: 14),
          ),
          trailing: InkWell(
            onTap:()=> Navigator.push(context, FadeRoute(page: AdminVendorProfile(vendor: vendor,))),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'View',
                style: GoogleFonts.roboto(
                    color: aux2,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
