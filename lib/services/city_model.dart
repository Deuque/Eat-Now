class CityModel{
  String city,choice;

  CityModel(this.city);
  CityModel.fromMap(Map<String, dynamic> item) {
    this.city = item['city'];
    this.choice = item['city'];
  }

}