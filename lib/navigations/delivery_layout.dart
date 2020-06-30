import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/services/MyServices.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../navigations/cart.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryLayout extends StatefulWidget {
  DeliveryItem delItem;
  DeliveryLayout(this.delItem);
  State<DeliveryLayout> createState() => MyState();


}
class MyState extends State<DeliveryLayout>{
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
      child: Card(
        elevation: 3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical:5.0),
              child: ListTile(
                title: Text(
                  '${widget.delItem.items}',
                  style: GoogleFonts.sourceSansPro(
                      color: aux6,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                subtitle: Text(
                  '${dateFormatter(widget.delItem.orderDate)}',
                  style: GoogleFonts.sourceSansPro(
                      color: aux6,
                      fontWeight: FontWeight.w300,
                      fontSize: 14),
                ),
                trailing: Text(
                  'NGN${moneyResolver('${widget.delItem.amount}')}',
                  style: GoogleFonts.sourceSansPro(
                      color: aux2,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
            Divider(height: 1,color: aux8,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'More Details',
                    style: GoogleFonts.sourceSansPro(
                        color: aux4,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        setState(()=> _showDetails = !_showDetails);
                      },
                      icon: Icon(_showDetails?Icons.chevron_left:Icons.chevron_right,color: aux4,),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}