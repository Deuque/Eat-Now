import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'food_layout.dart';

class ViewVendor extends StatefulWidget {
  final uid;

  const ViewVendor({Key key, this.uid}) : super(key: key);

  @override
  _ViewVendorState createState() => _ViewVendorState();
}

class _ViewVendorState extends State<ViewVendor> {
  RxServices get service => GetIt.I<RxServices>();
  bool centerTitle = false;

  @override
  Widget build(BuildContext context) {
    double iconsize = 60;

    Widget itemsdisplay(String count, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            count,
            style: GoogleFonts.roboto(
                color: aux6, fontWeight: FontWeight.w600, fontSize: 16.5),
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            label,
            style: GoogleFonts.roboto(
                color: aux4, fontWeight: FontWeight.w400, fontSize: 15),
          ),
        ],
      );
    }

    Widget itemdisplay3(title, icon, click) {
      return InkWell(
        onTap: click,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.5),
            color: aux8,
          ),
          alignment: Alignment.center,
          child: InkWell(
            onTap: click,
            child: Icon(
              icon,
              size: 12,
            ),
          ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//
//                SizedBox(width: 4,),
////                    Flexible(
////                      child: Text(
////                        title,
////                        overflow: TextOverflow.ellipsis,
////                        maxLines: 1,
////                        style: GoogleFonts.roboto(
////                            color: aux4, fontWeight: FontWeight.w300, fontSize: 13),
////                      ),
////                    ),
//              ],
//            )
        ),
      );
    }

    return Scaffold(
      backgroundColor: aux1,
      body: FutureBuilder(
        future: service.vendorStream.first,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            Vendor vendor;
            for (final v in snapshot.data) {
              if (v.id == widget.uid) {
                vendor = v;
                break;
              }
            }
            return StreamBuilder<List<FoodItem>>(
                stream: service.foodStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    List myItems = [];
                    snapshot.data.forEach((element) {
                      if (element.vendor == widget.uid) myItems.add(element);
                    });
                    return NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            backgroundColor: aux1,
                            iconTheme: IconThemeData(color: aux6),
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  color: mytrans,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: aux1,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                            elevation: 0,
                            expandedHeight: 110 + iconsize / 2,
                            floating: false,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: //
                                  Stack(
                                children: <Widget>[
                                  Container(
                                    height: 110,
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: vendor == null
                                          ? ''
                                          : vendor.persVInfo.bannerUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      placeholder: (context, url) => Container(
                                        height: 110,
                                        color: aux2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 110,
                                        color: aux2,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 110,
                                    color: Colors.white30,
                                  ),
                                  Positioned(
                                    left: 16,
                                    top: 90,
                                    child: Container(
                                      height: iconsize,
                                      width: iconsize,
                                      child: CachedNetworkImage(
                                        imageUrl: vendor == null
                                            ? ''
                                            : vendor.persVInfo.logoUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: iconsize,
                                          width: iconsize,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      iconsize / 2),
                                              border: Border.all(
                                                  color: aux1, width: 2)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                iconsize / 2),
                                            child: Image(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/logo.png',
                                          height: iconsize,
                                          width: iconsize,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/logo.png',
                                          height: iconsize,
                                          width: iconsize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: _SliverTextDelegate(
                              Text(
                                vendor == null
                                    ? ''
                                    : '${vendor.persVInfo.cname} ',
                                style: GoogleFonts.roboto(
                                    color: aux22,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28),
                              ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 3,
                                            ),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                text: 'Address: ',
                                                style: GoogleFonts.roboto(
                                                    color: aux4,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13),
                                              ),
                                              TextSpan(
                                                text: vendor == null
                                                    ? ''
                                                    : '${vendor.persVInfo.address}, \n${vendor.persVInfo.city}, ${vendor.persVInfo.state}',
                                                style: GoogleFonts.roboto(
                                                    color: aux4,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 11.2),
                                              ),
                                            ])),
                                            SizedBox(height: 4,),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                text: 'Contact: ',
                                                style: GoogleFonts.roboto(
                                                    color: aux4,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13),
                                              ),
                                              TextSpan(
                                                text: vendor == null
                                                    ? ''
                                                    : '${vendor.persVInfo.cemail}, ${vendor.persVInfo.cnum}',
                                                style: GoogleFonts.roboto(
                                                    color: aux4,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 11.2),
                                              ),
                                            ])),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SmoothStarRating(
                                              allowHalfRating: false,
                                              onRated: (v) {},
                                              starCount: 5,
                                              rating: vendor == null
                                                  ? 0.0
                                                  : vendor.delVInfo.rating
                                                      .toDouble(),
                                              size: 10.5,
                                              isReadOnly: true,
                                              color: Colors.deepOrange,
                                              borderColor: Colors.deepOrange,
                                              spacing: 0.0),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            SingleChildScrollView(
                              child: GridView.count(
                                physics: ScrollPhysics(),
                                childAspectRatio: 0.75,
                                padding: EdgeInsets.all(10),
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 18,
                                shrinkWrap: true,
                                children: <Widget>[
                                  for (final item in myItems)
                                    if (item.vendor == widget.uid)
                                      FoodItemLayout(
                                        item: item,
                                      )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Text('Error Fetching Data'),
                  );
                });
          }

          return Text('Error Fetching Data');
        },
      ),
    );
  }
}

class _SliverTextDelegate extends SliverPersistentHeaderDelegate {
  _SliverTextDelegate(this._text);

  final Text _text;

  @override
  double get minExtent => 32;

  @override
  double get maxExtent => 32;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: aux1,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15.0,bottom: 6),
      child: _text,
    );
  }

  @override
  bool shouldRebuild(_SliverTextDelegate oldDelegate) {
    return false;
  }
}
