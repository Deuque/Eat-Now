import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/cart.dart';
import 'package:eat_now/services/MyServices.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'fade_route.dart';

RxServices get service => GetIt.I<RxServices>();

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  TextEditingController scontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget restaurants_layout(Vendor v) {
      double iconsize = 55;
      return Padding(
        padding: const EdgeInsets.only(right:7.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: v.persVInfo.logoUrl,
              imageBuilder: (context, imageProvider) => SizedBox(
                height: iconsize,
                width: iconsize,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Image(
                    image: imageProvider,
                    height: iconsize,
                    width: iconsize,
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
            SizedBox(
              height: 5,
            ),
            Text(
              v.persVInfo.cname,
              style: GoogleFonts.roboto(
                  color: aux6, fontWeight: FontWeight.w400, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: aux1,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 11.0, right: 11, top: 11),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder(
                            stream: service.userStream,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasData && snapshot.data != null) {
                                return Text(
                                  'Hello ${service.myUser.basicInfo.fname.split(' ')[0]},',
                                  style: GoogleFonts.roboto(
                                      color: aux22,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25),
                                );
                              }

                              return Text('Error Fetching Data');
                            },
                          ),
                          Text(
                            'What do you want to eat?',
                            style: GoogleFonts.roboto(
                                color: aux4,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, FadeRoute(page: Cart()));
                      },
                      icon: Image.asset(
                        'assets/cart.png',
                        color: aux22,
                        height: 17,
                        width: 17,
                      ),
                      iconSize: 14,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 65,
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: TextFormField(
                    maxLines: 1,
                    minLines: 1,
                    controller: scontroller,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: aux6,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        fillColor: aux41,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: aux5, width: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: aux5, width: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintText: 'Find food or restaurant',
                        prefixIcon: IconButton(
                          iconSize: 13,
                          icon: Image.asset(
                            'assets/search.png',
                            height: 16,
                            width: 16,
                            color: aux6,
                          ),
                        ),
                        hintStyle: TextStyle(
                          height: 1.3,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: aux42,
                        )),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Explore Restaurants',
                      style: GoogleFonts.roboto(
                          color: aux4,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.5),
                    ),
                    Text(
                      'see more',
                      style: GoogleFonts.roboto(
                          color: aux77,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                StreamBuilder<List<Vendor>>(
                    stream: service.vendorStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 60,
                          width: 60,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasData && snapshot.data.isNotEmpty) {
                        List vendors = snapshot.data;
                        return SizedBox(
                          height: 106,
                          child: ListView(
                            padding: EdgeInsets.only(top: 7),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (final item in vendors)
                                restaurants_layout(item)
                            ],
                          ),
                        );
                      }
                      return Container(
                        height: 80,
                        width: 80,
                        child: Center(
                          child: Text(
                            'No vendors yet',
                            style: TextStyle(color: aux42),
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Popular Food',
                      style: GoogleFonts.roboto(
                          color: aux4,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.5),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          StreamBuilder<List<FoodItem>>(
              stream: service.foodStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 80,
                    width: 80,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  List myItems = snapshot.data;
                  return SingleChildScrollView(
                    child: GridView.count(
                      physics: ScrollPhysics(),
                      childAspectRatio: 0.65,
                      padding: EdgeInsets.all(10),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 18,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (final item in myItems)
                          FoodItemLayout(
                            item: item,
                          )
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Image.asset('assets/nofood.png',
                        color: aux41, height: 65, width: 65),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class FoodItemLayout extends StatefulWidget {
  final FoodItem item;

  const FoodItemLayout({Key key, this.item}) : super(key: key);

  @override
  _FoodItemLayoutState createState() => _FoodItemLayoutState();
}

class _FoodItemLayoutState extends State<FoodItemLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context,listen:true);
    double iconsize = 112.7;
    return FutureBuilder(
      future: service.vendorStream.first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          Vendor vendor;
          for (final v in snapshot.data) {
            if (v.id == widget.item.vendor) {
              vendor = v;
              break;
            }
          }
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
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: widget.item.imgUrl,
                  imageBuilder: (context, imageProvider) => SizedBox(
                    height: iconsize,
                    width: double.maxFinite,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(9)),
                      child: Image(
                        image: imageProvider,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Image.asset(
                    'assets/logo1.png',
                    height: iconsize,
                    width: iconsize,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/logo1.png',
                    height: iconsize,
                    width: iconsize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 7, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          widget.item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              color: aux6,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),

//                IconButton(iconSize: 15,icon: Image.asset('assets/cart.png',height: 15,width: 15,color: aux2,),color: aux1,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 8, bottom: 2),
                  child: Text(
                    vendor.persVInfo.cname,
                    style: GoogleFonts.roboto(
                        color: aux42,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {},
                          starCount: 5,
                          rating: 3,
                          size: 12.0,
                          isReadOnly: true,
                          color: aux2,
                          borderColor: aux2,
                          spacing: 0.0),
                      Text(
                        widget.item.price,
                        style: GoogleFonts.roboto(
                            color: aux6,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Divider(),
                Container(
                  padding: EdgeInsets.only(bottom: 2),
                  width: double.maxFinite,
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: (){

                },
                        child: Text(
                          'BUY',
                          style: GoogleFonts.roboto(
                              color: aux3,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                      VerticalDivider(),
                      InkWell(
                        onTap: (){
                          appstate
                              .addToCart(CartItem(widget.item, 1))
                              .then((value) {
                            if (value) {
                              service
                                  .showToast(context, 'Food added to cart',
                                  snackaction: () {
                                    Scaffold.of(context).hideCurrentSnackBar;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Cart()));
                                  });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Item already added');
                            }
                          });
                        },
                        child: Text(
                          'CART',
                          style: GoogleFonts.roboto(
                              color: aux3,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
