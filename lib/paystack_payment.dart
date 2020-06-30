import 'dart:io';

import 'package:eat_now/order_Success.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'services/MyServices.dart';
import 'models/delivery_item.dart';

// To get started quickly, change this to your heroku deployment of
// https://github.com/PaystackHQ/sample-charge-card-backend
// Step 1. Visit https://github.com/PaystackHQ/sample-charge-card-backend
// Step 2. Click "Deploy to heroku"
// Step 3. Login with your heroku credentials or create a free heroku account
// Step 4. Provide your secret key and an email with which to start all test transactions
// Step 5. Replace {YOUR_BACKEND_URL} below with the url generated by heroku (format https://some-url.herokuapp.com)

// Set this to a public key that matches the secret key you supplied while creating the heroku instance

const String appName = 'Eat Now';

class PaystackPayment extends StatefulWidget {
  final DeliveryItem ditem;
  final email;

  const PaystackPayment({Key key, this.ditem, this.email}) : super(key: key);

  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<PaystackPayment> {
  RxServices get service => GetIt.I<RxServices>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController econtroller = new TextEditingController();
  TextEditingController ccontroller = new TextEditingController();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 20.0);

  bool _inProgress = false;
  String _cardNumber;
  String _cvv, payText;
  int oldExpiry = 0;
  int oldCard = 0;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  var appstate;
  ProgressDialog pr;

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appstate = Provider.of<MyService>(context);
    payText = 'Pay NGN ${moneyResolver('${widget.ditem.amount}')}';

    pr = getDialog(context);

    return SafeArea(
      child: new Scaffold(

        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: aux1,
          iconTheme: IconThemeData(color: aux6),
          elevation: 0,
        ),
        body: new Container(
          color: aux1,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        'assets/logo1.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        widget.email,
                        style: GoogleFonts.sourceSansPro(
                            color: aux4,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Pay ',
                            style: GoogleFonts.asap(
                                color: aux6,
                                fontWeight: FontWeight.w300,
                                fontSize: 14),
                          ),
                          TextSpan(
                            text: payText.substring(4),
                            style: GoogleFonts.sourceSansPro(
                                color: lightBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          )
                        ]),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Form(
                    key: _formKey,
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(vertical: 55.0, horizontal: 20),
                      children: <Widget>[
                        Center(
                            child: Text(
                          'Enter your card details to pay',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceSansPro(
                              color: aux6,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                        )),
                        _verticalSizeBox,
                        Theme(
                          data: ThemeData(primaryColor: green),
                          child: Column(
                            children: <Widget>[
                              new TextFormField(
                                validator: (value) =>
                                    value.isEmpty || value.length < 16
                                        ? 'Invalid card number'
                                        : null,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(
                                      RegExp("[0-9 ]")),
                                ],
                                keyboardType: TextInputType.number,
                                controller: ccontroller,
                                onChanged: (value) {
//                                  int newCard =
//                                      value.replaceAll(" ", '').length;
//                                  if (value.length > oldCard &&
//                                      newCard % 4 == 0 &&
//                                      value.length < 19) {
//                                    Fluttertoast.showToast(msg: '$newCard');
//                                    ccontroller.value = TextEditingValue(
//                                        text: ccontroller.text =
//                                            ccontroller.text + " ",
//                                        selection: TextSelection(
//                                            baseOffset: value.length,
//                                            extentOffset: value.length));
//                                  }
//                                  oldCard = value.length;
                                },
                                maxLength: 20,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: green)),
                                  counterText: '',
                                  suffixIcon: Icon(
                                    Icons.credit_card,
                                    size: 19,
                                  ),
                                  labelText: 'CARD NUMBER',
                                  hintText: '0000 0000 0000 0000',
                                ),
                                onSaved: (String value) => _cardNumber = value,
                              ),
                              _verticalSizeBox,
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                    child: new TextFormField(
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter(
                                              RegExp("[0-9/]")),
                                        ],
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                            value.isEmpty || value.length < 5
                                                ? 'Invalid expiry date'
                                                : null,
                                        controller: econtroller,
                                        onChanged: (value) {
                                          int newExpiry = value.length;
                                          if (newExpiry > oldExpiry &&
                                              newExpiry == 2) {
                                            econtroller.value =
                                                TextEditingValue(
                                                    text: econtroller.text =
                                                        econtroller.text + "/",
                                                    selection: TextSelection(
                                                        baseOffset:
                                                            value.length + 1,
                                                        extentOffset:
                                                            value.length + 1));
                                          }
                                          oldExpiry = value.length;
                                        },
                                        maxLength: 5,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          counterText: '',
                                          labelText: 'CARD EXPIRY',
                                          hintText: 'MM/YY',
                                        ),
                                        onSaved: (String value) {
                                          _expiryMonth = int.tryParse(
                                              value.substring(0, 2));
                                          _expiryYear =
                                              int.tryParse(value.substring(3));
                                        }),
                                  ),
                                  _horizontalSizeBox,
                                  new Expanded(
                                    child: new TextFormField(
                                      validator: (value) =>
                                          value.isEmpty || value.length < 3
                                              ? 'Invalid cvv number'
                                              : null,
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        counterText: '',
                                        labelText: 'CVV',
                                        hintText: '123',
                                      ),
                                      onSaved: (String value) => _cvv = value,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          color: green,
                          borderRadius: BorderRadius.circular(6),
                          child: FlatButton(
                              onPressed: (){

                                DeliveryItem ditem = widget.ditem;
                                ditem.orderDate = DateTime.now().toString();
                                appstate.addToDelivery(ditem);
    appstate.deleteAllCartItems();
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (_) => OrderSuccess()));
                              },
                              color: green,
                              child: Text(
                                _inProgress ? 'Processing...' : payText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              )),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.lock, color: aux6, size: 12),
                            Text(
                              'Secured By',
                              style: GoogleFonts.poppins(
                                  color: aux6,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/paystack.png',
                              height: 22,
                              width: 25,
                            ),
                            Text(
                              'paystack',
                              style: GoogleFonts.poppins(
                                  color: aux6,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkFields() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _startAfreshCharge() async {
    if (!checkFields()) return;
    pr.show();
    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);

    // Set transaction params directly in app (note that these params
    // are only used if an access_code is not set. In debug mode,
    // setting them after setting an access code would throw an exception

    charge
//      ..amount = int.parse('${widget.ditem.amount}00')
      ..amount = 2500
      ..email = widget.email
      ..reference = _getReference()
      ..putCustomField('Charged From', 'Flutter SDK');
    _chargeCard(charge);
  }

  _chargeCard(Charge charge) {
    // This is called only before requesting OTP
    // Save reference so you may send to server if error occurs with OTP
    handleBeforeValidate(Transaction transaction) {
      _updateStatus(transaction.reference, 'validating...');
    }

    handleOnError(Object e, Transaction transaction) {
      pr.hide();
      // If an access code has expired, simply ask your server for a new one
      // and restart the charge instead of displaying error
      if (e is ExpiredAccessCodeException) {
        _startAfreshCharge();
        _chargeCard(charge);
        return;
      }

      if (transaction.reference != null) {
        _verifyOnServer(transaction.reference);
      } else {
        setState(() => _inProgress = false);
        _updateStatus(transaction.reference, e.toString());
      }
    }

    // This is called only after transaction is successful
    handleOnSuccess(Transaction transaction) {
      DeliveryItem ditem = widget.ditem;
      ditem.orderDate = DateTime.now().toString();
      appstate.addToDelivery(ditem);
      appstate.deleteAllCartItems();

      _verifyOnServer(transaction.reference);
      pr.hide();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => OrderSuccess()));
    }

    PaystackPlugin.chargeCard(context,
        charge: charge,
        beforeValidate: (transaction) => handleBeforeValidate(transaction),
        onSuccess: (transaction) => handleOnSuccess(transaction),
        onError: (error, transaction) => handleOnError(error, transaction));
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );

    // Using Cascade notation (similar to Java's builder pattern)
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear)
//      ..name = 'Segun Chukwuma Adamu'
//      ..country = 'Nigeria'
//      ..addressLine1 = 'Ikeja, Lagos'
//      ..addressPostalCode = '100001';

    // Using optional parameters
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear,
//        name: 'Ismail Adebola Emeka',
//        addressCountry: 'Nigeria',
//        addressLine1: '90, Nnebisi Road, Asaba, Deleta State');
  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = new CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeBlue,
        child: new Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = new RaisedButton(
        onPressed: function,
        color: Colors.blueAccent,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        child: new Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
    return widget;
  }

  void _verifyOnServer(String reference) async {
    _updateStatus(reference, 'Verifying...');
    String url = '$backendUrl/verify/$reference';
    try {
      http.Response response = await http.get(url);
      var body = response.body;
      _updateStatus(reference, body);
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
    setState(() => _inProgress = false);
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }
}

const Color green = const Color(0xFF3db76d);
const Color lightBlue = const Color(0xFF34a5db);
const Color navyBlue = const Color(0xFF031b33);
