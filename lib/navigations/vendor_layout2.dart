import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class VendorLayout2 extends StatefulWidget {
  final Vendor item;
  final itemClick;

  const VendorLayout2({Key key, this.item, this.itemClick}) : super(key: key);

  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<VendorLayout2> {
  RxServices get service => GetIt.I<RxServices>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double iconsize = 85;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left:11,top: 8,bottom: 12),
      child: Container(
        width: width/2 + (width / 6),
        decoration: BoxDecoration(
          color: aux1,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
                color: aux42.withOpacity(.5),
                offset: Offset(0.0, 3.5),
                blurRadius: 8.0)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: widget.itemClick ?? () {},
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
                child: CachedNetworkImage(
                  imageUrl: widget.item.persVInfo.bannerUrl,
                  imageBuilder: (context, imageProvider) => SizedBox(
                    height: iconsize,
                    width: double.maxFinite,
                    child: Image(
                      image: imageProvider,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                  placeholder: (context, url) => Image.asset(
                    'assets/logo1.jpeg',
                    height: iconsize,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/logo1.jpeg',
                    height: iconsize,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9.0, top: 9, bottom: 1),
              child: Text(
                widget.item.persVInfo.cname,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                    color: aux6, fontWeight: FontWeight.w400, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 9,right: 9, bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Expanded(
                    child: Text(
                      widget.item.persVInfo.city+', '+widget.item.persVInfo.state,
                      style: GoogleFonts.roboto(
                          color: aux4, fontWeight: FontWeight.w300, fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 10,),
                  SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {},
                      starCount: 5,
                      rating: widget.item.delVInfo.rating.toDouble(),
                      size: 10.5,
                      isReadOnly: true,
                      color: aux2,
                      borderColor: aux2,
                      spacing: 0.0),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
