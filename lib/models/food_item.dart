class FoodItem {
  String img, desc, price, id;

  FoodItem(this.img, this.desc, this.price, {this.id});

  Map<String, dynamic> toMap() {
    return {
      'img': this.img,
      'desc': this.desc,
      'price': this.price,
    };
  }
}
