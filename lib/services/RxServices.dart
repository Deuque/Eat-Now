import 'package:eat_now/models/admin_model.dart';
import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/user_model.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/state_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import 'ApiService.dart';
import 'auxilliary.dart';
import 'city_model.dart';
import 'country_model.dart';

class RxServices {
  FirebaseDatabase database;

  List<CountryModel> countries = [];
  List<CountryModel> get mcountries => countries;
  setCountry(c){
    countries = c;
  }
  List<StateModel> states = [];
  List<StateModel> get mstates => states;
  setStates(s){
    states = s;
  }
  List<CityModel> cities = [];
  List<CityModel> get mcities => cities;
  setCities(ct){
    cities = ct;
  }

  RxServices() {
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

  }

  bool _shownFilter = false;
  bool get shownFilter => _shownFilter;
  setShownFilter(){
    _shownFilter = true;
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

  BehaviorSubject<Admin> adminObservable = BehaviorSubject.seeded(null);

  Stream<Admin> get adminStream => adminObservable.stream;
  Admin _myAdmin;

  Admin get myAdmin => _myAdmin;

  void setMyAdmin(uid) {
    Stream s = database
        .reference()
        .child("Admins")
        .child(uid)
        .onValue
        .map((event) =>Admin.fromJson(event.snapshot.value));
    s.listen((event) {
      _myAdmin = event;
    });
    s.listen((event) {
      adminObservable.sink.add(event);
    });
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
        .map((event) =>User.fromJson(event.snapshot.value));
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

  BehaviorSubject<List<User>> usersObservable = BehaviorSubject.seeded([]);

  Stream<List<User>> get usersStream => usersObservable.stream;

  void getUsers() {
    database.reference().child("Users").onValue.map((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> DATA = snapshot.value;

      if (DATA != null) {
        List<User> users = [];
        DATA.forEach((key, value) {
          User u = User.fromJson(DATA[key]);
          u.id = key;
          users.insert(0, u);
        });
        return users;
      }

      return [];
    }).listen((event) {
      usersObservable.sink.add(event);
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

  BehaviorSubject<List<DeliveryItem>> deliveryObservable = BehaviorSubject.seeded([]);

  Stream<List<DeliveryItem>> get deliveryStream => deliveryObservable.stream;

  void getDeliveries() {
    database.reference().child("Deliveries").onValue.map((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> DATA = snapshot.value;

      if (DATA != null) {
        List<DeliveryItem> deliveries = [];
        DATA.forEach((key, value) {
          DeliveryItem d = DeliveryItem.fromJson(DATA[key]);
          if(d.consumer == _user.uid || d.vendor == _user.uid){
            d.id = key;
            deliveries.insert(0, d);
          }
        });
        return deliveries;
      }

      return [];
    }).listen((event) {
      deliveryObservable.sink.add(event);
    });
  }

  BehaviorSubject<List<String>> categoryObservable = BehaviorSubject.seeded([]);

  Stream<List<String>> get categoryStream => categoryObservable.stream;

  void getCategories() {
    database.reference().child("Categories").onValue.map((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> DATA = snapshot.value;

      if (DATA != null) {
        List<String> categories = [];
        DATA.forEach((key, value) {
          categories.add(DATA[key].toString());
        });
        categories.insert(0, '--Select Restaurant Category--');
        return categories;
      }

      return ['--Select Restaurant Category--'];
    }).listen((event) {
      categoryObservable.sink.add(event);
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
    cartObservable.sink.add(cart);
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


}
