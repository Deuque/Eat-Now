import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/paystack_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/MyServices.dart';

class ConfirmOrder extends StatefulWidget {
  State<ConfirmOrder> createState() => MyState();
}

class MyState extends State<ConfirmOrder> {
  int _totalPrice = 0;
  int _totalPrice1=0;
  List cartitems = [];
  BasicInfo basicInfo;
  PersonalInfo personalInfo;
  String address='';
  String _foodDetails;
  int _radioValue1 = 1;

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    cartitems = appstate.getCartList();
    basicInfo = appstate.myUser.basicInfo;
    personalInfo = appstate.myUser.personalInfo;

    address ='${basicInfo.fname.toUpperCase()}\n${personalInfo.num}\n${personalInfo.address}, ${personalInfo.city}, ${personalInfo.state}, ${personalInfo.country}\n';

    _foodDetails = '';
    _totalPrice = 0;
    for (final item in appstate.getCartList()) {
      _totalPrice = _totalPrice + (int.parse(item.foodItem.price) * item.qty);
      _foodDetails =
          _foodDetails + '${item.qty} plate(s) of ' + item.foodItem.desc + '\n';
    }

    _totalPrice1 = _totalPrice+(_radioValue1==1?300:0);

    void setDelivery(value) {
      setState(() {
        _radioValue1 = value;
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appstate.aux1,
          iconTheme: IconThemeData(color: appstate.aux2),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'CONFIRM ORDER',
            style: GoogleFonts.roboto(
                color: appstate.aux2,
                fontWeight: FontWeight.w900,
                fontSize: 15),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  buildCard(
                    title: 'ADDRESS',
                    trailer: 'change',
                    subtitle: address,
                  ),
                  buildCard(
                    title: 'FOOD ITEMS',
                    subtitle: _foodDetails,
                  ),
                  buildCard(
                    title: 'DELIVERY METHOD',
                    isRadio: true,
                    radioItems: Column(
                      children: <Widget>[
                        radioButtons(
                          title: 'Delivery man +NGN300',
                          value: 1,
                          groupValue: _radioValue1,
                          valueChanged: setDelivery,
                        ),
                        radioButtons(
                          title: 'Pick up at our station',
                          value: 2,
                          groupValue: _radioValue1,
                          valueChanged: setDelivery,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                color: appstate.aux2,
                onPressed: () {
                  DeliveryItem ditem = new DeliveryItem(items: _foodDetails,type: _radioValue1==1?'Company Delivery':'Pick up at station',
                  amount: _totalPrice1, address: address, isDone: false);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>PaystackPayment(ditem: ditem,email: basicInfo.email,)));
                },
                child: Text(
                  'PAY NGN${appstate.moneyResolver('$_totalPrice1')}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color: appstate.aux1,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}

class buildCard extends StatelessWidget {
  final title, trailer, subtitle, trailerPressed, isRadio, radioItems;

  const buildCard(
      {Key key,
      this.title,
      this.trailer,
      this.subtitle,
      this.trailerPressed,
      this.isRadio = false,
      this.radioItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);

    return Card(
      elevation: 3,
      child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 5),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.sourceSansPro(
                        color: appstate.aux4,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 9),
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        trailer ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color: appstate.aux77,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                height: 1,
                color: appstate.aux4,
              ),
              isRadio
                  ? radioItems
                  : Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            subtitle ?? '',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.sourceSansPro(
                                color: appstate.aux6,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
            ],
          )),
    );
  }
}

class radioButtons extends StatelessWidget {
  final title, value, groupValue, valueChanged;

  const radioButtons(
      {Key key, this.title, this.value, this.groupValue, this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: value,
          groupValue: groupValue,
          onChanged: valueChanged,
        ),
        SizedBox(
          width: 7,
        ),
        Text(
          title,
          style: GoogleFonts.sourceSansPro(
              color: appstate.aux6, fontWeight: FontWeight.w500, fontSize: 16),
        )
      ],
    );
  }
}
