import 'package:eat_now/models/food_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'cart_item.dart';

import 'UserModel.dart';

class MyService with ChangeNotifier, DiagnosticableTreeMixin {
  //set Streams

  //user functions
  FirebaseUser _user;

  FirebaseUser get getUser => _user;

  void setFirebaseUser(FirebaseUser user) => _user = user;

  User _myUser;

  User get myUser => _myUser;

  void setMyUser(uid) {
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(uid)
        .onValue
        .map((event) => User.fromKey(event.snapshot.value))
        .listen((event) {
      _myUser = event;
    });
  }

  // my colors
  Color get aux1 => Color(0xFFFFFFFF);

  Color get aux2 => Color(0xFFE61111);

  Color get aux22 => Color(0xFFAF0D0D);

  Color get aux3 => Color(0xFFEEA3A3);

  Color get aux33 => Color(0xFFFCF4F4);

  Color get aux4 => Colors.grey[600];

  Color get aux5 => Color(0xFFFBFBFB);

  Color get aux6 => Colors.black87;

  Color get aux7 => Color(0xFFD4EBFE);

  Color get aux8 => Color(0xFFE5E5E5);

  // my progress dialog
  ProgressDialog getDialog(BuildContext context) {
    var pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.style(
        message: 'Please wait..',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        messageTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600));
    return pr;
  }

  //sample list
  List foodlist = [
    FoodItem('assets/ob2.jpeg',
        'Ofe nsala with fresh oporoko, saddled with kpomo', '600',
        id: '1'),
    FoodItem('assets/ob3.jpeg',
        'Coconot rice with red toppings with a pinch of bread crumbs', '1400',
        id: '2'),
    FoodItem('assets/ob4.jpeg',
        'Indomie noodles hungryman size with carrot and fish', '450',
        id: '3'),
    FoodItem('assets/ob1.jpeg',
        'Abacha and nkwobi with kpomo and lots of sauce', '900',
        id: '4'),
  ];

  List getList() => foodlist;

  //cart items
  List<CartItem> cart = [];

  List<CartItem> getCartList() => cart;

  Future<bool> addToCart(CartItem item) async {
    if (isThere(item)) return false;
    cart.add(item);
    return true;
  }

  void updateCart(CartItem item, int opType) async {
    int prevQty = item.qty;
    if (opType == 0) {
      getCartList()[getCartList().indexOf(item)].qty = prevQty + 1;
    } else {
      if (prevQty > 1) {
        getCartList()[getCartList().indexOf(item)].qty = prevQty - 1;
      }
    }
    notifyListeners();
  }

  void deleteCart(CartItem item) {
    getCartList().remove(item);
    notifyListeners();
  }

  bool isThere(CartItem newItem) {
    for (final item in cart) {
      if (item.foodItem.id == newItem.foodItem.id) {
        return true;
      }
    }
    return false;
  }

  //toast builder
  void showToast(BuildContext context, text, {snackaction}) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: aux6,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: aux1,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              text,
              textAlign: TextAlign.start,
              style: GoogleFonts.asap(
                  color: aux1, fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ],
        ),
        action: SnackBarAction(
            textColor: aux2, label: 'VIEW CART', onPressed: snackaction),
      ),
    );
  }

  //money resolver
  moneyResolver(String s){
    String newamount=s.substring(0,1);
    List sarray = s.split('');
    for(int a=1;a<sarray.length;a++){
      if((sarray.length-a)!=0 && (sarray.length-a)%3==0){
        newamount =newamount+","+sarray[a];
        continue;
      }
      newamount =newamount+sarray[a];
    }
    return  newamount;
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('aux1', aux1));
  }
}
