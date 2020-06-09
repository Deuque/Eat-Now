import 'package:eat_now/models/cart_item.dart';

class DeliveryItem{
  String items;
  String type;
  String address;
  int amount;
  String orderDate;
  bool isDone;

  DeliveryItem({this.items, this.type, this.address,this.amount, this.orderDate, this.isDone});

}