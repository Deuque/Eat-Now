import 'dart:io';

import 'package:eat_now/models/admin_model.dart';
import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ApiResponse.dart';

//
class CrudOperations {
  static Future<ApiResponse<AuthResult>> createUser(email, pass) async {
    ApiResponse<AuthResult> response;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((result) {
      response = new ApiResponse(data: result, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: null, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> uploadData(String uid, role, data) async {
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child(role == 'user' ? "Users" : 'Vendors')
        .child(uid)
        .set(data.toMap())
        .then((value) {
      response = new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<String>> uploadImage({File file, key, path}) async {
    ApiResponse<String> response;

    final StorageReference sref = FirebaseStorage.instance.ref().child(path);
    final StorageUploadTask uploadTask = sref.child(key).putFile(file);
    await (await uploadTask.onComplete).ref.getDownloadURL().then((value) {
      response = new ApiResponse(data: value, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: '', error: true, errorMessage: e.toString());
    });

    return response;
  }

  static Future<ApiResponse<bool>> uploadFoodItem(FoodItem item) async {
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child('Food_Items')
        .child(item.id)
        .set(item.toMap())
        .then((value) {
      response = new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> deleteFoodItem(FoodItem item) async {
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child('Food_Items')
        .child(item.id)
        .remove()
        .then((value) async {
      await FirebaseStorage.instance
          .ref()
          .child('Food_Images')
          .child(item.id)
          .delete()
          .then((value) {
        response = new ApiResponse(data: true, error: false, errorMessage: '');
      }).catchError((e) {
        new ApiResponse(data: false, error: true, errorMessage: e.toString());
      });
    }).catchError((e) {
      response =
          new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> loginUser(BasicInfo basicInfo) async {
    ApiResponse<bool> response;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: basicInfo.email, password: basicInfo.password)
        .then((result) {
      response = new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<String>> getUserRole(String email) async {
    ApiResponse<String> response;
    await FirebaseDatabase.instance
        .reference()
        .child('Admins')
        .once()
        .then((value) async {
      DataSnapshot snapshot = value;
      Map<dynamic, dynamic> DATA = snapshot.value;
      if (DATA != null) {
        List<Admin> admins = [];
        DATA.forEach((key, value) {
          Admin a = Admin.fromJson(DATA[key]);
          a.id = key;
          admins.insert(0, a);
        });

        for (final a in admins) {
          if (a.email == email) {
            response =
                new ApiResponse(data: 'admin', error: false, errorMessage: '');
            break;
          }
        }
      }
      if (response != null) {
        return;
      }

      await FirebaseDatabase.instance
          .reference()
          .child('Vendors')
          .once()
          .then((value) {
        DataSnapshot snapshot = value;
        Map<dynamic, dynamic> DATA = snapshot.value;
        if (DATA != null) {
          List<Vendor> vendors = [];
          DATA.forEach((key, value) {
            Vendor v = Vendor.fromJson(DATA[key]);
            v.id = key;
            vendors.insert(0, v);
          });

          for (final v in vendors) {
            if (v.persVInfo.cemail == email) {
              response = new ApiResponse(
                  data: 'vendor', error: false, errorMessage: '');
              break;
            }
          }
        }
      }).catchError((e) {
        response =
            new ApiResponse(data: '', error: true, errorMessage: e.toString());
      });

      if (response != null) {
        return;
      } else {
        response =
            new ApiResponse(data: 'user', error: false, errorMessage: '');
      }
    }).catchError((e) {
      response =
          new ApiResponse(data: '', error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<AuthResult>> reAuthenticateUser(
      {String email, String password}) async {
    ApiResponse<AuthResult> response;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      response = new ApiResponse(data: result, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: null, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> uploadDelivery(DeliveryItem item) async {
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child("Deliveries")
        .child('${DateTime.now().millisecondsSinceEpoch}')
        .set(item.toMap())
        .then((value) {
      response = new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> verifyVendor(uid, status) async {
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child("Vendors")
        .child(uid)
        .child('isVerified')
        .set(status)
        .then((value) {
      response = new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> dispatchDelivery(id, dmodel) async {
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child("Deliveries")
        .child(id)
        .child('driver')
        .set(dmodel)
        .then((value) {
      response = new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response =
      new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> changeDeliveryStatus(id, status) async {
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child("Deliveries")
        .child(id)
        .child('status')
        .set(status)
        .then((value) {
      response = new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response =
      new ApiResponse(data: false, error: true, errorMessage: e.toString());
    });
    return response;
  }

  //shared preferences
  static Future<void> setRole(String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("role", role);
  }

  static Future<String> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("role") ?? '';
  }
}
