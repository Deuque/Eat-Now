class CountryModel{
  String name,code,choice;

  CountryModel(this.name, this.code);

  CountryModel.fromMap(Map<String, dynamic> item) {
    this.name = item['name'];
    this.code = item['code'];
    this.choice = item['name'];
  }
}