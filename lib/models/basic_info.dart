class BasicInfo {
  String email, fname, password;

  BasicInfo({this.email, this.fname, this.password});

  factory BasicInfo.fromKey(data) {
    return BasicInfo(
      email: data['email'],
      fname: data['fname'],
      password: data['password']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'fname': this.fname,
      'password': this.password
    };
  }
}
