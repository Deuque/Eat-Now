import 'package:eat_now/models/delivery_vendor_info.dart';
import 'package:eat_now/models/payment_vendor_info.dart';
import 'package:eat_now/models/personal_vendor_info.dart';

class Admin {
  String id,imgUrl,email,password;

  Admin({this.id,this.imgUrl, this.email,this.password});

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': this.imgUrl??'',
      'email': this.email,
      'password': this.password,
    };
  }

  factory Admin.fromJson(data) {
    return Admin(
        imgUrl: data['imgUrl']??'',
        email: data['email'],
      password: data['password'],);
  }

}
