import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/personal_info.dart';

class User {
  String id;
  BasicInfo basicInfo;
  PersonalInfo personalInfo;

  User({this.id,this.basicInfo, this.personalInfo});

  Map<String, dynamic> toMap() {
    return {
      'basicInfo': this.basicInfo.toMap(),
      'personalInfo': this.personalInfo.toMap(),
    };
  }

  factory User.fromJson(jsondata) {
    var data = jsondata.value;
    return User(
      id: jsondata.key,
        basicInfo: BasicInfo.fromKey(data['basicInfo']),
        personalInfo: PersonalInfo.fromKey(data['personalInfo']));
  }
}
