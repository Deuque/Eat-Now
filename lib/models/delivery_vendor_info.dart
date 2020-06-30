class DeliveryVendorInfo{
  bool deliver;
  String price;

  DeliveryVendorInfo({this.deliver, this.price});


  factory DeliveryVendorInfo.fromKey(data) {
    return DeliveryVendorInfo(
      deliver: data['deliver'],
      price: data['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deliver': this.deliver,
      'price': this.price,
    };
  }

}