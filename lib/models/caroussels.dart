class Caroussel {
  String path, title, body;

  Caroussel({this.path, this.title, this.body});
}

var sampleCaroussels = [
  Caroussel(
    path: 'assets/ob1.jpeg',
    title: 'Variety of Dishes',
    body: 'We have different varieties of delicious food to choose from',
  ),
  Caroussel(
    path: 'assets/ob2.jpeg',
    title: 'No Interest Rate',
    body:
        'We require no interest rate from our credit facilities, as long as payment is made right on time',
  ),
  Caroussel(
    path: 'assets/ob3.jpeg',
    title: 'Delivery in 30mins',
    body:
        'Our delivery time is 30mins, you could literally countdown till your order gets to you',
  ),
  Caroussel(
    path: 'assets/ob4.jpeg',
    title: 'Instant Credit',
    body:
        'Once you login you will receive instant credit to purchase food immediately',
  ),
];
