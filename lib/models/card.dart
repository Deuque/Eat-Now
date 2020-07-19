import 'food_item.dart';

class CardItem {
  String card_type;
  String last_digits;

  CardItem({this.card_type, this.last_digits});

  Map<String, dynamic> toMap() {
    return {
      'card_type': this.card_type,
      'last_digits': this.last_digits,
    };
  }

  factory CardItem.fromJson(data) {
    return CardItem(
      card_type: data['card_type'],
      last_digits: data['last_digits'],
    );
  }
}
