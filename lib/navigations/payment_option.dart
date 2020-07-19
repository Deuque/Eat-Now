import 'package:eat_now/models/card.dart';
import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
class PaymentOption extends StatefulWidget {
  final addCardClick, continueClick;

  const PaymentOption({Key key, this.addCardClick, this.continueClick}) : super(key: key);
  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  RxServices get service => GetIt.I<RxServices>();
  int _radioValue1 = 1;
  bool payNow = true;
  List<CardItem> cards = [];
  CardItem initCard;
  String credit;
  void valueChanged(value) {
    setState(() {
      payNow = value==1;
      if(value==2&&int.parse(credit)<1){
        Fluttertoast.showToast(msg: 'not enough credit');
      }else{
        _radioValue1 = value;
      }
    });
  }
  @override
  void initState() {
    cards.add(CardItem(card_type: 'mastercard', last_digits: '4509'));
    initCard = cards[0];

    credit = service.myUser.paymentInfo==null?'0':service.myUser.paymentInfo.creditLeft.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 25,top:15,left:5,right: 15),
      child: Column(
        children: <Widget>[
          Align(alignment:Alignment.centerRight,child: IconButton(onPressed:()=>Navigator.pop(context),icon: Icon(Icons.close,color: aux42,size: 18,))),
          SizedBox(height: 15,),
          Text(
            'Select a payment option:',
            style: GoogleFonts.roboto(
                color: aux6,
                fontWeight: FontWeight.w700,
                fontSize: 22),
          ),
          SizedBox(height: 34,),
          Row(
            children: <Widget>[
              new Radio(
                value: 1,
                groupValue: _radioValue1,
                onChanged: valueChanged,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pay with card',
                      style: GoogleFonts.roboto(
                          color: aux6,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    SizedBox(height: 5,),
                    RaisedButton(
                      onPressed: (){},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      elevation: 1.6,
                      color: aux1,
                      child: DropdownButton<CardItem>(
                        underline: Container(),
                        isExpanded: true,
                        items: cards.map((CardItem item) {
                          return DropdownMenuItem<CardItem>(
                            value: item,
                            child: CardLayout(card: item,),
                          );
                        }).toList(),
                        onChanged: (CardItem newitem) {
                          setState(() {
                            this.initCard = newitem;
                          });
                        },
                        value: initCard,
                      ),
                    ),
                    InkWell(
                      onTap: widget.addCardClick,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(mainAxisSize: MainAxisSize.min,children: <Widget>[
                          Icon(Icons.add_circle_outline,color: aux77,size: 15,),
                          SizedBox(width: 4,),
                          Text(
                            'New card',
                            style: GoogleFonts.roboto(
                                color: aux77,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ],),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: <Widget>[
              new Radio(
                value: 2,
                groupValue: _radioValue1,
                onChanged: valueChanged,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pay with credit',
                      style: GoogleFonts.roboto(
                          color: int.parse(credit)>0?aux6:aux42,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    RaisedButton(
                      onPressed: (){},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      elevation: 1.6,
                      color:int.parse(credit)>0?aux1:aux8,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Available: ',
                            style: GoogleFonts.roboto(
                                color: int.parse(credit)>0?aux6:aux42,
                                fontWeight: FontWeight.w300,
                                fontSize: 15),
                          ),
                          Text(
                            'NGN ${moneyResolver(credit)}',
                            style: GoogleFonts.roboto(
                                color: int.parse(credit)>0?aux6:aux42,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 23,),
          Container(
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.only(top: 6,left:17,bottom:6),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.5),
              ),
              color: aux2,
              onPressed: widget.addCardClick,
              child: Text(
                'Continue',
                textAlign: TextAlign.start,
                style: GoogleFonts.asap(
                    color: aux1,
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardLayout extends StatelessWidget {
  final CardItem card;

  const CardLayout({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Container(height:35,width: 35,padding:EdgeInsets.all(5),child: Image.asset('assets/${card.card_type}.png',)),
          SizedBox(width: 5,),
          Text(
            'XXXX XXXX XXXX ${card.last_digits}',
            style: GoogleFonts.roboto(
                color: aux6,
                fontWeight: FontWeight.w400,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}

