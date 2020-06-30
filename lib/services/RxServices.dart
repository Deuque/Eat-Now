import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/user_model.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import 'auxilliary.dart';

class RxServices {
  FirebaseDatabase database;

  RxServices() {
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  //user functions
  FirebaseUser _user;

  FirebaseUser get firebaseUser => _user;

  void setFirebaseUser(FirebaseUser user) => _user = user;

  String _role = '';

  String get role => _role;

  void setRole(String role) {
    _role = role;
  }

  BehaviorSubject<User> userObservable = BehaviorSubject.seeded(null);

  Stream<User> get userStream => userObservable.stream;
  User _myUser;

  User get myUser => _myUser;

  void setMyUser(uid) {
    Stream s = database
        .reference()
        .child("Users")
        .child(uid)
        .onValue
        .map((event) => User.fromJson(event.snapshot));
    s.listen((event) {
      _myUser = event;
    });
    s.listen((event) {
      userObservable.sink.add(event);
    });
  }

  BehaviorSubject<Vendor> myVendObservable = BehaviorSubject.seeded(null);

  Stream<Vendor> get myVendStream => myVendObservable.stream;
  Vendor _myVenor;

  Vendor get myVenor => _myVenor;

  void setMyVendor(uid) {
    Stream s = database
        .reference()
        .child("Vendors")
        .child(uid)
        .onValue
        .map((event) => Vendor.fromJson(event.snapshot.value));
    s.listen((event) {
      _myVenor = event;
    });
    s.listen((event) {
      myVendObservable.sink.add(event);
    });
  }

  BehaviorSubject<List<FoodItem>> foodObservable = BehaviorSubject.seeded([]);

  Stream<List<FoodItem>> get foodStream => foodObservable.stream;

  void getFoodItems() {
    database.reference().child("Food_Items").onValue.map((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> DATA = snapshot.value;

      if (DATA != null) {
        List<FoodItem> items = [];
        DATA.forEach((key, value) {
          FoodItem f = FoodItem.fromJson(DATA[key]);
          items.insert(0, f);
        });
        return items;
      }

      return [];
    }).listen((event) {
      foodObservable.sink.add(event);
    });
  }

  BehaviorSubject<List<Vendor>> vendorObservable = BehaviorSubject.seeded([]);

  Stream<List<Vendor>> get vendorStream => vendorObservable.stream;

  void getVendors() {
    database.reference().child("Vendors").onValue.map((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> DATA = snapshot.value;

      if (DATA != null) {
        List<Vendor> vendors = [];
        DATA.forEach((key, value) {
          Vendor v = Vendor.fromJson(DATA[key]);
          v.id = key;
          vendors.insert(0, v);
        });
        return vendors;
      }

      return [];
    }).listen((event) {
      vendorObservable.sink.add(event);
    });
  }

  //restaurants items
//  BehaviorSubject<List<Vendor>> vendorObservable = BehaviorSubject.seeded([]);
//  Stream<List<Vendor>> get vendorStream => vendorObservable.stream;
//  List <List<String>> sampleVendors() {
//    return [
//      ['assets/rl1.jpg','Bonafile'],['assets/rl2.jpg','Tag Eats'],['assets/rl3.jpg','Starbucks']
//    ];
//  }
//  List <List<String>> sampleFood() {
//    return [
//      ['assets/ob2.jpeg',
//        'Ofe nsala with fresh oporoko, saddled with kpomo', 'Starbucks','\$600',],
//      [
//        'assets/ob3.jpeg',
//        'Coconot rice with red toppings with a pinch of bread crumbs','The Forks', '\$120',
//      ],
//      [
//        'assets/ob4.jpeg',
//        'Indomie noodles hungryman size with carrot and fish','Merry Eats', '\$450',
//      ],
//      ['assets/ob2.jpeg',
//        'Ofe nsala with fresh oporoko, saddled with kpomo', 'Starbucks','\$600',],
//      [
//        'assets/ob3.jpeg',
//        'Coconot rice with red toppings with a pinch of bread crumbs','The Forks', '\$120',
//      ],
//      [
//        'assets/ob4.jpeg',
//        'Indomie noodles hungryman size with carrot and fish','Merry Eats', '\$450',
//      ]
//    ];
//  }

  //cart items
  BehaviorSubject<List<CartItem>> cartObservable = BehaviorSubject.seeded([]);

  Stream<List<CartItem>> get cartStream => cartObservable.stream;
  List<CartItem> cart = [];

  List<CartItem> getCartList() => cart;

  Future<bool> addToCart(CartItem item) async {
    if (isThere(item)) return false;
    cart.add(item);
    cartObservable.sink.add(cart);
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
    cartObservable.sink.add(cart);
  }

  void deleteCart(CartItem item) {
    getCartList().remove(item);
  }

  bool isThere(CartItem newItem) {
    for (final item in cart) {
      if (item.foodItem.id == newItem.foodItem.id) {
        return true;
      }
    }
    return false;
  }

  void deleteAllCartItems() {
    getCartList().clear();
    cartObservable.sink.add(cart);
  }

  //delivery items
  List<DeliveryItem> deliveries = [];

  List<DeliveryItem> getDeliveryList() => deliveries;

  addToDelivery(DeliveryItem item) async {
    deliveries.add(item);
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
}
