import 'package:eat_now/models/delivery_vendor_info.dart';
import 'package:eat_now/models/payment_vendor_info.dart';
import 'package:eat_now/models/personal_vendor_info.dart';

class Vendor {
  String id;
  bool isVerified;
  PersonalVendorInfo persVInfo;
  PaymentVendorInfo payVInfo;
  DeliveryVendorInfo delVInfo;

  Vendor({this.id,this.isVerified,this.persVInfo, this.payVInfo, this.delVInfo});

  Map<String, dynamic> toMap() {
    return {
      'isVerified': this.isVerified??false,
      'persVInfo': this.persVInfo.toMap(),
      'payVInfo': this.payVInfo.toMap(),
      'delVInfo': this.delVInfo.toMap(),
    };
  }

  factory Vendor.fromJson(data) {
    return Vendor(
        isVerified: data['isVerified']??false,
        persVInfo: PersonalVendorInfo.fromKey(data['persVInfo']),
        payVInfo: PaymentVendorInfo.fromKey(data['payVInfo']),
        delVInfo: DeliveryVendorInfo.fromKey(data['delVInfo']));
  }

}
