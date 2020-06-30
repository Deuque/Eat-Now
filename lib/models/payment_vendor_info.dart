class PaymentVendorInfo{
  String bank, account_no;

  PaymentVendorInfo({this.bank, this.account_no});

  factory PaymentVendorInfo.fromKey(data) {
    return PaymentVendorInfo(
      bank: data['bank'],
      account_no: data['account_no'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bank': this.bank,
      'account_no': this.account_no,
    };
  }

}