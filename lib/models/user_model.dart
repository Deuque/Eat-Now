import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/payment_info.dart';
import 'package:eat_now/models/personal_info.dart';

class User {
  String id;
  BasicInfo basicInfo;
  PersonalInfo personalInfo;
  PaymentInfo paymentInfo;

  User({this.id,this.basicInfo, this.personalInfo, this.paymentInfo});

  Map<String, dynamic> toMap() {
    return {
      'basicInfo': this.basicInfo.toMap(),
      'personalInfo': this.personalInfo.toMap(),
    };
  }

  factory User.fromJson(data) {
    return User(
        basicInfo: BasicInfo.fromKey(data['basicInfo']),
        personalInfo: PersonalInfo.fromKey(data['personalInfo']),
    paymentInfo: data['paymentInfo']==null?null:PaymentInfo.fromKey(data['paymentInfo']));
  }
}
