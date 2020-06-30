class FoodItem {
  String imgUrl, name, desc, price, id, vendor;

  FoodItem({this.imgUrl, this.name, this.desc, this.price, this.vendor, this.id});

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': this.imgUrl,
      'name': this.name,
      'desc': this.desc,
      'price': this.price,
      'vendor': this.vendor,
      'id':id
    };
  }

  factory FoodItem.fromJson(data) {
    return FoodItem(
        imgUrl: data['imgUrl'],
        name: data['name'],
        desc: data['desc'],
        price: data['price'],
      vendor: data['vendor'],
      id: data['id']
    );
  }
}
