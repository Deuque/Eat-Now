import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/personal_info.dart';

class User {
  BasicInfo basicInfo;
  PersonalInfo personalInfo;

  User({this.basicInfo, this.personalInfo});

  Map<String, dynamic> toMap() {
    return {
      'basicInfo': this.basicInfo.toMap(),
      'personalInfo': this.personalInfo.toMap(),
    };
  }

  factory User.fromKey(data) {
    return User(
        basicInfo: BasicInfo.fromKey(data['basicInfo']),
        personalInfo: PersonalInfo.fromKey(data['personalInfo']));
  }
}
