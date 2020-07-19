class Driver{
  String name, number;

  Driver({this.name, this.number});

  factory Driver.fromJson(data) {
    return Driver(
        name: data['name'],
        number: data['number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'number': this.number,
    };
  }

}