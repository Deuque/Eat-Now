
import 'package:eat_now/models/driver.dart';

class DeliveryItem{
  String id;
  String items;
  String type;
  String address;
  int amount;
  String orderDate;
  String status;
  String consumer;
  String vendor;
  Driver driver;

  DeliveryItem({this.id,this.items, this.type, this.address,this.amount, this.orderDate, this.status, this.consumer,this.vendor, this.driver});

  factory DeliveryItem.fromJson(data) {
    return DeliveryItem(
      items: data['items'],
      type: data['type'],
      address: data['address'],
      amount: data['amount'],
      orderDate: data['orderDate'],
      status: data['status'],
      consumer: data['consumer'],
      vendor: data['vendor'],
      driver: data['driver']==null?null:Driver.fromJson(data['driver']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': this.items,
      'type': this.type,
      'address': this.address,
      'amount': this.amount,
      'orderDate': this.orderDate,
      'status': this.status,
      'consumer': this.consumer,
      'vendor': this.vendor
    };
  }
}