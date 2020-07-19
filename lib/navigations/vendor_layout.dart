import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class VendorLayout extends StatefulWidget {
  final Vendor item;
  final itemClick;

  const VendorLayout({Key key, this.item, this.itemClick}) : super(key: key);

  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<VendorLayout> {
  RxServices get service => GetIt.I<RxServices>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double iconsize = 105;

    return Container(
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
            padding: const EdgeInsets.only(left: 8.0, top: 7, bottom: 1),
            child: Text(
              widget.item.persVInfo.cname,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                  color: aux6, fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8, bottom: 2),
            child: Text(
              widget.item.delVInfo.deliver
                  ? 'Delivery - NGN ${widget.item.delVInfo.price}'
                  : 'No Delivery',
              style: GoogleFonts.roboto(
                  color: aux42, fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              children: <Widget>[
                SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {},
                    starCount: 5,
                    rating: widget.item.delVInfo.rating.toDouble(),
                    size: 12.0,
                    isReadOnly: true,
                    color: aux2,
                    borderColor: aux2,
                    spacing: 0.0),
                Spacer(),
                Container(
                  height: 20,
                  width: 20,
                  padding: EdgeInsets.all(4.7),
                  decoration: BoxDecoration(
                    color: aux1,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: aux42.withOpacity(.5),
                          offset: Offset(0.0, 3.5),
                          blurRadius: 8.0)
                    ],
                  ),
                  child: InkWell(
                    child: Image.asset('assets/locate.png'),
                  ),
                ),
                SizedBox(width: 5)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
