class BasicInfo {
  String email, fname, password,imgUrl,imgKey;

  BasicInfo({this.email, this.fname, this.password, this.imgUrl, this.imgKey});

  factory BasicInfo.fromKey(data) {
    return BasicInfo(
      email: data['email'],
      fname: data['fname'],
      password: data['password'],
      imgUrl: data['imgUrl']??'',
      imgKey: data['imgKey']??''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'fname': this.fname,
      'password': this.password,
      'imgUrl': this.imgUrl??'',
      'imgKey': this.imgKey??''
    };
  }
}
