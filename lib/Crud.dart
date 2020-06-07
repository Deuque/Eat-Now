import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/validation/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'models/ApiResponse.dart';
import 'models/MyServices.dart';
import 'models/UserModel.dart';

//import 'package:flutter_renew2/models/UserModel.dart';
//import 'models/carModel.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

//
class CrudOperations {

  static Future<ApiResponse<AuthResult>> createUser(User userModel) async {
    ApiResponse<AuthResult> response;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userModel.basicInfo.email, password: userModel.basicInfo.password)
        .then((result) {
      response = new ApiResponse(data: result, error: false, errorMessage: '');
    }).catchError((e) {
      response =
          new ApiResponse(data: null, error: true, errorMessage: e.toString());
    });
    return response;
  }

  static Future<ApiResponse<bool>> uploadData(String uid, User user) async{
    ApiResponse<bool> response;
    await FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(uid)
        .set(user.toMap())
        .then((value) {
      response =
      new ApiResponse(data: true, error: false, errorMessage: '');
    }).catchError((e) {
      response = new ApiResponse(
          data: false, error: true, errorMessage: e.toString());
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





//  static Future<ApiResponse<bool>> uploadStory(StoryModel data) async {
//    ApiResponse<bool> response;
//    await FirebaseDatabase.instance
//        .reference()
//        .child("STstories")
//        .push()
//        .set(data.toMap())
//        .then((value) {
//      response = new ApiResponse(data: true, error: false, errorMessage: '');
//    }).catchError((e) {
//      response =
//          new ApiResponse(data: false, error: true, errorMessage: e.toString());
//    });
//    return response;
//  }


}
