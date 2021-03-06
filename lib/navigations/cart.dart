
import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/navigations/dash.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../confirm_order.dart';
import '../services/MyServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_item_layout.dart';

class Cart extends StatefulWidget {
  State<Cart> createState() => MyState();
}

class MyState extends State<Cart> {
//  RxServices get service => GetIt.I<RxServices>();
  int _totalPrice = 0;
  bool checkedValue = true;
  List<String> itemspicked=[];
  List cartitems = [];

  @override
  Widget build(BuildContext context) {
//    var appstate = Provider.of<MyService>(context,listen: false);
//    cartitems = appstate.getCartList();


    return Scaffold(
        appBar: AppBar(
          backgroundColor: aux1,
          iconTheme: IconThemeData(color: aux2),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'CART',
            style: GoogleFonts.roboto(
                color: aux2,
                fontWeight: FontWeight.w900,
                fontSize: 15),
          ),
        ),
        body: StreamBuilder<List<CartItem>>(
          stream: service.cartStream,
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data.isNotEmpty){
              cartitems = snapshot.data;
              _totalPrice = 0;
              for (final item in itemspicked) {
                for(final citem in cartitems){
                  if(citem.foodItem.id == item){
                    _totalPrice = _totalPrice + (int.parse(citem.foodItem.price) * citem.qty);
                  }
                }

              }
            }
            return Column(
              children: <Widget>[
                Expanded(
                  child: CustomScrollView(slivers: <Widget>[
                    SliverAppBar(
                      snap: true,
                      floating: true,
                      backgroundColor: Colors.white,
                      title: Text(''),
                      expandedHeight: 112,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          width: double.infinity,
                          color: aux33,
                          padding: EdgeInsets.all(28),
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Total',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.asap(
                                    color: aux6,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child:
//                            Text(
//                              'NGN${moneyResolver('$_totalPrice')}',
//                              textAlign: TextAlign.center,
//                              style: GoogleFonts.asap(
//                                  color: aux2,
//                                  fontWeight: FontWeight.w700,
//                                  fontSize: 29),
//                            )
                                    RichText(
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                        child: Transform.translate(
                                      offset: Offset(-3, -8),
                                      child: Text(
                                        'NGN',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.asap(
                                            color: aux2,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                    )),
                                    TextSpan(
                                      text:
                                          '${moneyResolver('$_totalPrice')}',
                                      style: GoogleFonts.asap(
                                          color: aux2,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 29),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      for (CartItem item in cartitems) CartItemLayout(cartItem: item,isSelected: itemspicked.isNotEmpty && itemspicked.contains(item.foodItem.id),pickedAction:
                      (){
                        setState(() {
                          if(itemspicked.isNotEmpty&& itemspicked.contains(item.foodItem.id)){
                            itemspicked.remove(item.foodItem.id);
                            return;
                          }
                          bool sameVendor=true;
                          for(final id in itemspicked){
                            for(final citem in cartitems){
                              if(id==citem.foodItem.id){
                                if(citem.foodItem.vendor!=item.foodItem.vendor){
                                  sameVendor = false;
                                  break;
                                }
                              }
                            }
                          }
                          if(!sameVendor){itemspicked.clear(); Fluttertoast.showToast(msg: 'Different vendors');}
                          itemspicked.add(item.foodItem.id);
                        });
                      },),
                    ]))
                  ]),
                ),
//                Divider(
//                  height: 1,
//                  color: aux4,
//                ),
//            Padding(
//              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 25),
//              child: Text(
//                'If you want to come to the office for delivery, kindly uncheck the option below',
//                textAlign: TextAlign.center,
//                style: GoogleFonts.asap(
//                    color: aux2,
//                    fontWeight: FontWeight.w400,
//                    fontSize: 14),
//              ),
//            ),
//            Divider(
//              height: 1,
//              color: aux4,
//            ),
//            Padding(
//              padding: EdgeInsets.only(top: 10, bottom: 13.0, right: 20.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Expanded(
//                      child: CheckboxListTile(
//                    title: Text(
//                      'Delivery',
//                      textAlign: TextAlign.start,
//                      style: GoogleFonts.asap(
//                          color: aux6,
//                          fontWeight: FontWeight.w500,
//                          fontSize: 16),
//                    ),
//                    value: checkedValue,
//                    selected: true,
//                    onChanged: (newValue) {
//                      setState(() {
//                        checkedValue = newValue;
//                      });
//                    },
//                    controlAffinity: ListTileControlAffinity
//                        .leading, //  <-- leading Checkbox
//                  )),
//                  Text(
//                    'NGN300',
//                    textAlign: TextAlign.center,
//                    style: GoogleFonts.asap(
//                        color: aux2,
//                        fontWeight: FontWeight.w400,
//                        fontSize: 16),
//                  )
//                ],
//              ),
//            ),
                Visibility(
                  visible: itemspicked.isNotEmpty,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: aux2,
                      onPressed: () {
                        if(!cartitems.isEmpty){
                          List myitems = [];
                          for(final id in itemspicked){
                            for(final item in cartitems){
                              if(id==item.foodItem.id){
                                myitems.add(item);
                              }
                            }
                          }
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) =>
                                    ConfirmOrder(
                                      items: myitems,)));

                        }
                      },
                      child: Text(
                        'ORDER',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.asap(
                            color: aux1,
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        )

        );
  }
}
