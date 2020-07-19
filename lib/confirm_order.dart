import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/navigations/payment_option.dart';
import 'package:eat_now/paystack_payment.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/vendor_model.dart';

class ConfirmOrder extends StatefulWidget {
  final List items;

  const ConfirmOrder({Key key, this.items}) : super(key: key);

  State<ConfirmOrder> createState() => MyState();
}

class MyState extends State<ConfirmOrder> {
  RxServices get service => GetIt.I<RxServices>();
  int _totalPrice = 0;
  int _totalPrice1 = 0;
  BasicInfo basicInfo;
  PersonalInfo personalInfo;
  String address = '';
  String _foodDetails;
  bool vendorDelivers = false;
  bool changeAddress = true;
  int _radioValue1 = 1;
  Vendor vendor;

  @override
  void initState() {
    getVendor();
    super.initState();
  }

  getVendor() async {
    List vendors = await service.vendorStream.first;
    for (final v in vendors) {
      if (v.id == widget.items[0].foodItem.vendor) {
        setState(() {
          vendor = v;
          vendorDelivers = vendor.delVInfo.deliver;

          _totalPrice1 = _totalPrice +
              (_radioValue1 == 1
                  ? vendorDelivers ? (int.parse(vendor.delVInfo.price)) : 300
                  : 0);
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    basicInfo = service.myUser.basicInfo;
    personalInfo = service.myUser.personalInfo;

    address =
        '${basicInfo.fname.toUpperCase()}\n${personalInfo.num}\n${personalInfo.address}, ${personalInfo.city}, ${personalInfo.state}, ${personalInfo.country}\n';

    _foodDetails = '';
    _totalPrice = 0;
    for (final item in widget.items) {
      _totalPrice = _totalPrice +
          (item == null ? 0 : (int.parse(item.foodItem.price) * item.qty));
      _foodDetails =
          _foodDetails + '${item.qty} plate(s) of ' + item.foodItem.desc + '\n';
    }

    void setDelivery(value) {
      setState(() {
        _radioValue1 = value;
        _totalPrice1 = _totalPrice +
            (_radioValue1 == 1
                ? vendorDelivers ? (int.parse(vendor.delVInfo.price)) : 300
                : 0);
      });
    }

    prepareOrder() {
      DeliveryItem ditem = new DeliveryItem(
          items: _foodDetails,
          type: _radioValue1 == 1 ? 'Company Delivery' : 'Pick up at station',
          amount: _totalPrice1,
          address: address,
          vendor: vendor.id,
          consumer: service.firebaseUser.uid,
          status: 'PROCESSING');
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PaystackPayment(
                    ditem: ditem,
                    email: basicInfo.email,
                  ))).then((value) {
        if (value != null && value) {
          for (final item in widget.items) {
            service.deleteCart(item);
          }

          Navigator.pop(context);
        }
      });
    }

    void _bottomSheet() {
      showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
          context: context,
          builder: (context) => StatefulBuilder(
                builder: (context, setState1) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: PaymentOption(
                        addCardClick: () {
                          prepareOrder();
                        },
                        continueClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: aux1,
          iconTheme: IconThemeData(color: aux2),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'CONFIRM ORDER',
            style: GoogleFonts.roboto(
                color: aux2, fontWeight: FontWeight.w900, fontSize: 15),
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
                    onChanged: (value) => address = value,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  buildCard(
                    title: 'FOOD ITEMS',
                    subtitle: _foodDetails,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  buildCard(
                    title: 'DELIVERY METHOD',
                    isRadio: true,
                    radioItems: Column(
                      children: <Widget>[
                        radioButtons(
                          title: 'Delivery man (+NGN' +
                              (vendorDelivers ? vendor.delVInfo.price : '300') +
                              ')',
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
                color: aux2,
                onPressed: () {
//
                  _bottomSheet();
                },
                child: Text(
                  'PAY NGN${moneyResolver('$_totalPrice1')}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color: aux1, fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}

class buildCard extends StatefulWidget {
  final title, trailer, subtitle, isRadio, radioItems, onChanged;

  const buildCard(
      {Key key,
      this.title,
      this.trailer,
      this.subtitle,
      this.isRadio = false,
      this.radioItems,
      this.onChanged})
      : super(key: key);

  @override
  _buildCardState createState() => _buildCardState();
}

class _buildCardState extends State<buildCard> {
  FocusNode myFocusNode;
  bool readOnly = true;

  @override
  void initState() {
    myFocusNode = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        new TextEditingController(text: widget.subtitle);

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
                    widget.title,
                    style: GoogleFonts.sourceSansPro(
                        color: aux4, fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 9),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          readOnly = false;
                          myFocusNode.requestFocus();
                        });
                      },
                      child: Text(
                        widget.trailer ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color: aux77,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                height: 1,
                color: aux42,
              ),
              widget.isRadio
                  ? widget.radioItems
                  : Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            minLines: 2,
                            maxLines: 6,
                            readOnly: readOnly,
                            focusNode: myFocusNode,
                            onChanged: widget.onChanged ?? (value) {},
                            controller: controller,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.sourceSansPro(
                                color: aux6,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: value,
          groupValue: groupValue,
          onChanged: valueChanged,
        ),
        Text(
          title,
          style: GoogleFonts.sourceSansPro(
              color: aux6, fontWeight: FontWeight.w500, fontSize: 16),
        )
      ],
    );
  }
}
