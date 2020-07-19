class PersonalVendorInfo {
  String cname, cemail, cpassword, cnum, country, state, city, address, logoUrl,imgkey,bannerUrl,category;

  PersonalVendorInfo(
      {this.cname,
        this.cemail,
        this.cpassword,
        this.cnum,
        this.country,
        this.state,
        this.city,
        this.address,
      this.logoUrl,
      this.imgkey,
        this.bannerUrl,
      this.category});

  factory PersonalVendorInfo.fromKey(data) {
    if(data==null||data.toString().isEmpty){
      return null;
    }
    return PersonalVendorInfo(
      cname: data['cname'],
      country: data['country'],
      state: data['state'],
      city: data['city'],
      cnum: data['cnum']??'',
      address: data['address'],
      cemail: data['cemail'],
      cpassword: data['cpassword'],
        logoUrl: data['logoUrl'],
      imgkey: data['imgkey']??'',
      bannerUrl: data['bannerUrl']??'',
      category: data['category']??''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cname': this.cname,
      'country': this.country,
      'state': this.state,
      'city': this.city,
      'cnum': this.cnum??'',
      'address': this.address,
      'cemail': this.cemail,
      'cpassword': this.cpassword,
      'logoUrl': this.logoUrl,
      'imgkey': this.imgkey,
      'bannerUrl': this.bannerUrl,
      'category':this.category
    };
  }
}
