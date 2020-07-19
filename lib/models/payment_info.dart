class PaymentInfo{
  bool freeCreditAssigned;
  int credit;
  int creditUsed;
  int creditLeft;

  PaymentInfo({this.credit, this.creditUsed, this.creditLeft,this.freeCreditAssigned});

  factory PaymentInfo.fromKey(data) {
    return PaymentInfo(
      credit: data['credit']??0,
      creditUsed: data['creditLeft']??0,
      creditLeft: data['credit']??0 - data['creditLeft']??0,
      freeCreditAssigned: data['fca']??false
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'credit': this.credit,
      'creditUsed': this.creditUsed,
      'creditLeft': this.creditLeft
    };
  }
}