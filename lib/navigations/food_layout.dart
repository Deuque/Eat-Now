import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../confirm_order.dart';
import 'cart.dart';
import 'fade_route.dart';

class FoodItemLayout extends StatefulWidget {
  final FoodItem item;
  final itemClick;

  const FoodItemLayout({Key key, this.item, this.itemClick}) : super(key: key);

  @override
  _FoodItemLayoutState createState() => _FoodItemLayoutState();
}

class _FoodItemLayoutState extends State<FoodItemLayout> {
  RxServices get service => GetIt.I<RxServices>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double iconsize = 105;

    void _bottomSheet() {
      double iconsize = 65;
      int qty = 1;
      showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          backgroundColor: aux1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: Material(
                color: aux1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: widget.item.imgUrl,
                        imageBuilder: (context, imageProvider) => SizedBox(
                          height: iconsize,
                          width: iconsize,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8),
                            child: Image(
                              image: imageProvider,
                              width: iconsize,
                              height: iconsize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Image.asset(
                          'assets/logo1.jpeg',
                          height: iconsize,
                          width: iconsize,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/logo1.jpeg',
                          height: iconsize,
                          width: iconsize,
                        ),
                      ),
                      title: Text(
                        widget.item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            color: aux6,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                            'QTY: ',
                            style: GoogleFonts.asap(
                                color: aux6,
                                fontWeight: FontWeight.w400,
                                fontSize: 13),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (qty > 1) qty--;
                              });
                            },
                            icon: Icon(
                              Icons.remove_circle,
                              color: aux3,
                            ),
                          ),
                          Text(
                            '${qty}',
                            style: GoogleFonts.asap(
                                color: aux6,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                qty++;
                              });
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: aux3,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        'NGN ${moneyResolver('${widget.item.price}')}',
                        style: GoogleFonts.sourceSansPro(
                            color: aux2,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          color: aux1,
                          elevation: 2.3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.5, horizontal: 8),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.roboto(
                                  color: aux2,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          color: aux2,
                          elevation: 2.3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.5, horizontal: 8),
                            child: Text(
                              'Buy',
                              style: GoogleFonts.roboto(
                                  color: aux1,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                FadeRoute(
                                    page: ConfirmOrder(
                                      items: [CartItem(widget.item, qty)],
                                    )));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          )
      );
    }
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: widget.itemClick??(){},
                  child: CachedNetworkImage(
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
                      'assets/logo1.jpeg',
                      height: iconsize,
                      width: double.maxFinite,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/logo1.jpeg',
                      height: iconsize,
                      width: double.maxFinite,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 7, bottom: 4,right: 8),
                  child: Flexible(
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
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Text(
                    'NGN ${moneyResolver(widget.item.price)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        color: aux6,
                        fontWeight: FontWeight.w300,
                        fontSize: 13),
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
                        onTap: _bottomSheet,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'BUY',
                            style: GoogleFonts.roboto(
                                color: aux3,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ),
                      ),
                      VerticalDivider(),
                      InkWell(
                        onTap: () {
                          service
                              .addToCart(CartItem(widget.item, 1))
                              .then((value) {
                            if (value) {
                              showToast(context, 'Food added to cart',
                                  snackaction: () {
                                    Scaffold.of(context).hideCurrentSnackBar;
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) => Cart()));
                                  });
                            } else {
                              Fluttertoast.showToast(msg: 'Item already added');
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'CART',
                            style: GoogleFonts.roboto(
                                color: aux3,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
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
