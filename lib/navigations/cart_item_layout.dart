
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/fade_route.dart';
import 'package:eat_now/navigations/view_vendor.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/MyServices.dart';
import '../models/food_item.dart';

class CartItemLayout extends StatefulWidget {
  final CartItem cartItem;
  final pickedAction,isSelected;
//  RxServices get service => GetIt.I<RxServices>();

  CartItemLayout({this.cartItem,this.pickedAction,this.isSelected});

  @override
  _CartItemLayoutState createState() => _CartItemLayoutState();
}

class _CartItemLayoutState extends State<CartItemLayout> {
  RxServices get service => GetIt.I<RxServices>();
  Vendor vendor;

  getVendor() async {
    List vendors = await service.vendorStream.first;
    for (final v in vendors) {
      if (v.id == widget.cartItem.foodItem.vendor) {
        setState(() {
          vendor = v;
        });
        break;
      }
    }
  }

  @override
  void initState() {
    getVendor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    var service = Provider.of<MyService>(context);
    double iconsize = 20;
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 6, bottom: 5, top: 5,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: widget.pickedAction,
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: widget.isSelected?Icon(Icons.radio_button_checked,size: iconsize,color: aux2,):Icon(Icons.radio_button_unchecked,size:iconsize,color: aux42,),
            ),
          ),

          Expanded(
            child: Card(
              elevation: 3,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 7.0, right: 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                      child: Text(
                        widget.cartItem.foodItem.desc +
                            '\n' +
                            '‎NGN' +
                            widget.cartItem.foodItem.price,
                        style: GoogleFonts.asap(
                            color: aux6,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 5,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context,FadeRoute(page: ViewVendor(uid: widget.cartItem.foodItem.vendor,)));
                      },
                      child: Material(
                        color: aux5,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CachedNetworkImage(
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
                              SizedBox(width: 7,),
                              Text(
                                vendor==null?'':vendor.persVInfo.cname,
                                style: GoogleFonts.sourceSansPro(
                                    color: aux4,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Divider(
                      height: 1,
                      color: aux8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
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
                                    service.updateCart(widget.cartItem, 1);
                                  },
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: aux3,
                                  ),
                                ),
                                Text(
                                  widget.cartItem.qty.toString(),
                                  style: GoogleFonts.asap(
                                      color: aux6,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                IconButton(
                                  onPressed: () {
                                    service.updateCart(widget.cartItem, 0);
                                  },
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: aux3,
                                  ),
                                ),
                              ],
                            )),
                        IconButton(
                          iconSize: 20,
                          icon: Image.asset(
                            'assets/delete.png',
                            color: aux2,
                            height: 16,
                            width: 16,
                          ),
                          onPressed: () => service.deleteCart(widget.cartItem),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
