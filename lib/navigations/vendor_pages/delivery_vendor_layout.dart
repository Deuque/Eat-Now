
import 'package:eat_now/models/ApiResponse.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/driver.dart';
import 'package:eat_now/services/Alert.dart';
import 'package:eat_now/services/Crud.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_item_forms.dart';

class DeliveryVendorLayout extends StatefulWidget {
  DeliveryItem delItem;
  DeliveryVendorLayout(this.delItem);
  State<DeliveryVendorLayout> createState() => MyState2();


}
class MyState2 extends State<DeliveryVendorLayout>{
  bool _showDetails = false;
  var dname,dnum;
  final formkey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var pr = getDialog(context);
    checkFields() {
      final form = formkey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }
    cancelOrder() async{
      pr.show();
      final result = await showDialog(
          context: context,
          builder: (BuildContext context) => MyAlert(title: 'Cancel Order',message: 'Are you sure you want to cancel this order',)
      );

      if(result) {
        CrudOperations.changeDeliveryStatus(
            widget.delItem.id, 'CANCELLED').then((
            value) {

          if (value.error) {
            Fluttertoast.showToast(
                msg: 'Cancel Order Error: ' +
                    value.errorMessage,
                toastLength: Toast.LENGTH_LONG);
          }
        });
      }
      pr.hide();
    }
    dispatchItem() async {
      if (!checkFields()) {
        return;
      }
      Driver driver = Driver(name: dname, number: dnum);
      pr.show();
      ApiResponse data_response = await CrudOperations.dispatchDelivery(widget.delItem.id,driver);
      pr.hide();
      if (data_response.error) {
        Fluttertoast.showToast(
            msg: 'Dispatch Error: ' + data_response.errorMessage,
            toastLength: Toast.LENGTH_LONG);
        return;
      }

      Fluttertoast.showToast(msg: 'Item added successfully');
      Navigator.pop(context);
    }
    void _bottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: aux41,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
        ),
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left:20,right:20,top: 15, bottom:MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Driver Name',
                      style: GoogleFonts.roboto(
                          color: aux2, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    AddItemForms(
                      resolvetext: (value) {
                        dname = value;
                      },
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Driver Number',
                      style: GoogleFonts.roboto(
                          color: aux2, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    AddItemForms(
                      resolvetext: (value) {
                        dnum = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.5),
                        ),
                        color: aux2,
                        onPressed: dispatchItem,
                        child: Text(
                          'Dispatch',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.asap(
                              color: aux1,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
      child: Card(
        elevation: 3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical:5.0),
              child: ListTile(
                title: Text(
                  '${widget.delItem.items}',
                  style: GoogleFonts.sourceSansPro(
                      color: aux6,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                subtitle: Text(
                  '${dateFormatter(widget.delItem.orderDate)}',
                  style: GoogleFonts.sourceSansPro(
                      color: aux6,
                      fontWeight: FontWeight.w300,
                      fontSize: 14),
                ),
                trailing: Column(
                  children: <Widget>[
                    Text(
                      'NGN${moneyResolver('${widget.delItem.amount}')}',
                      style: GoogleFonts.sourceSansPro(
                          color: aux2,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    SizedBox(height: 6,),
                Visibility(visible: widget.delItem.status=='DELIVERED',child: Icon(Icons.check,color: Colors.green,size: 16.8,))
                  ],
                ),
              ),
            ),
            Divider(height: 1,color: aux8,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'More Details',
                    style: GoogleFonts.sourceSansPro(
                        color: aux4,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        setState(()=> _showDetails = !_showDetails);
                      },
                      icon: Icon(_showDetails?Icons.chevron_left:Icons.chevron_right,color: aux4,),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: _showDetails,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Status',
                          style: GoogleFonts.sourceSansPro(
                              color: aux42,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        SizedBox(width: 17,),
                        Text(
                          widget.delItem.status,
                          style: GoogleFonts.sourceSansPro(
                              color: aux77,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: <Widget>[
                        Text(
                          'Driver Name',
                          style: GoogleFonts.sourceSansPro(
                              color: aux42,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          widget.delItem.driver==null?'':widget.delItem.driver.number,
                          style: GoogleFonts.sourceSansPro(
                              color: aux4,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: <Widget>[
                        Text(
                          'Driver Number',
                          style: GoogleFonts.sourceSansPro(
                              color: aux42,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        SizedBox(width: 22,),
                        Text(
                          widget.delItem.driver==null?'':widget.delItem.driver.number,
                          style: GoogleFonts.sourceSansPro(
                              color: aux4,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Visibility(
                      visible: widget.delItem.status=='PROCESSING',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              onPressed: _bottomSheet,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: aux4, width: 0.9),
                                  borderRadius: BorderRadius.circular(6)),
                              color: aux1,
                              child: Text(
                                'Dispatch',
                                style: GoogleFonts.roboto(
                                    color: aux4,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: cancelOrder,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: aux4, width: 0.9),
                                  borderRadius: BorderRadius.circular(6)),
                              color: aux4,
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.roboto(
                                    color: aux1,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
