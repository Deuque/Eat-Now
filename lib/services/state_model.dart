class StateModel{
String region,country,choice;

StateModel(this.region, this.country);

StateModel.fromMap(Map<String, dynamic> item) {
  this.region = item['region'];
  this.country = item['country'];
  this.choice = item['region'];
}
}