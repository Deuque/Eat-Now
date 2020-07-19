class DeliveryVendorInfo{
  bool deliver;
  String price;
  int rating;

  DeliveryVendorInfo({this.deliver, this.price, this.rating});


  factory DeliveryVendorInfo.fromKey(data) {
    return DeliveryVendorInfo(
      deliver: data['deliver'],
      price: data['price'],
      rating: data['rating']??0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deliver': this.deliver,
      'price': this.price,
    };
  }

}