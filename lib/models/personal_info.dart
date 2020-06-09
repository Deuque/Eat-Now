class PersonalInfo {
  String dob, country, state, city, address, occupation, num;

  PersonalInfo(
      {this.dob,
      this.country,
      this.state,
      this.city,
      this.address,
      this.occupation,
      this.num});

  factory PersonalInfo.fromKey(data) {
    return PersonalInfo(
      dob: data['dob'],
      country: data['country'],
      state: data['state'],
      city: data['city'],
      address: data['address'],
      occupation: data['occupation'],
      num: data['num'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dob': this.dob,
      'country': this.country,
      'state': this.state,
      'city': this.city,
      'address': this.address,
      'occupation': this.occupation,
      'num': this.num,
    };
  }
}
