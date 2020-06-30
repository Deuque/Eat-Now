
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../services/MyServices.dart';
import '../models/food_item.dart';

class CartItemLayout extends StatelessWidget {
  CartItem cartItem;
//  RxServices get appstate => GetIt.I<RxServices>();

  CartItemLayout(this.cartItem);

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context,listen:true);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
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
                  cartItem.foodItem.desc +
                      '\n' +
                      '‎NGN' +
                      cartItem.foodItem.price,
                  style: GoogleFonts.asap(
                      color: aux6,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ),
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
                              appstate.updateCart(cartItem, 1);
                            },
                            icon: Icon(
                              Icons.remove_circle,
                              color: aux3,
                            ),
                          ),
                          Text(
                            cartItem.qty.toString(),
                            style: GoogleFonts.asap(
                                color: aux6,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          IconButton(
                            onPressed: () {
                              appstate.updateCart(cartItem, 0);
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
                    onPressed: () => appstate.deleteCart(cartItem),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
