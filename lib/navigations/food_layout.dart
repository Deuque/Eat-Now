import 'package:eat_now/models/MyServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../navigations/cart.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodLayout extends StatelessWidget {
  FoodItem foodItem;

  FoodLayout(this.foodItem);

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(11.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.asset(
                        foodItem.img,
                        fit: BoxFit.cover,
                      ))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 11.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                        child: Text(
                          foodItem.desc + '\n' + 'NGN' + foodItem.price,
                          style: GoogleFonts.asap(
                              color: appstate.aux6,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                            onTap: () {
                              appstate
                                  .addToCart(CartItem(foodItem, 1))
                                  .then((value) {
                                if (value) {
                                  appstate
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
                              'ADD TO CART',
                              style: GoogleFonts.asap(
                                  color: appstate.aux2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
