import 'food_item.dart';

class CartItem {
  FoodItem foodItem;
  int qty;

  CartItem(this.foodItem, this.qty);

  Map<String, dynamic> toMap() {
    return {
      'foodItem': this.foodItem,
      'qty': this.qty,
    };
  }
}
