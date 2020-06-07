class PersonalInfo{
  String dob,country,state,city,address,occupation,income;

  PersonalInfo({this.dob, this.country, this.state, this.city, this.address,
      this.occupation, this.income});

  factory PersonalInfo.fromKey(data) {
    return PersonalInfo(
      dob: data['dob'],
      country: data['country'],
      state: data['state'],
      city: data['city'],
      address: data['address'],
      occupation: data['occupation'],
      income: data['income'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'dob': this.dob,
      'country': this.country,
      'state': this.state,
      'city': this.city,
      'address': this.address,
      'occupation': this.occupation,
      'income': this.income,
    };
  }
}