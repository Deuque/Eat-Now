
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/view_vendor.dart';
import 'package:eat_now/services/Alert.dart';
import 'package:eat_now/services/Crud.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fade_route.dart';

class DeliveryLayout extends StatefulWidget {
  DeliveryItem delItem;
  DeliveryLayout(this.delItem);
  State<DeliveryLayout> createState() => MyState2();


}
class MyState2 extends State<DeliveryLayout>{
  RxServices get service => GetIt.I<RxServices>();
  bool _showDetails = false;
  Vendor vendor;



  getVendor() async {
    List vendors = await service.vendorStream.first;
    for (final v in vendors) {
      if (v.id == widget.delItem.vendor) {
        setState(() {
          vendor = v;
        });
        break;
      }
    }
  }

  @override
  void initState() {
    getVendor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pr = getDialog(context);
    double iconsize = 20;
    confirmDelivery() async{
      pr.show();
      final result = await showDialog(
          context: context,
          builder: (BuildContext context) => MyAlert(title: 'Confirm Delivery',message: 'Are you sure you have received this order?',)
      );
      if(result) {
        CrudOperations.changeDeliveryStatus(
            widget.delItem.id, 'DELIVERED').then((
            value) {
          pr.hide();
          if (value.error) {
            Fluttertoast.showToast(
                msg: 'Confirm Delivery Error: ' +
                    value.errorMessage,
                toastLength: Toast.LENGTH_LONG);
          }
        });
      }
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        Navigator.push(context,FadeRoute(page: ViewVendor(uid: widget.delItem.vendor,)));
                      },
                      child: Material(
                        color: aux5,
                      borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: vendor==null?'':vendor.persVInfo.logoUrl,
                                imageBuilder: (context, imageProvider) => SizedBox(
                                  height: iconsize,
                                  width: iconsize,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular( iconsize/2),
                                    child: Image(
                                      image: imageProvider,
                                      width: iconsize,
                                      height: iconsize,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Image.asset(
                                  'assets/logo.png',
                                  height: iconsize,
                                  width: iconsize,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/logo.png',
                                  height: iconsize,
                                  width: iconsize,
                                ),
                              ),
                              SizedBox(width: 7,),
                              Text(
                                vendor==null?'':vendor.persVInfo.cname,
                                style: GoogleFonts.sourceSansPro(
                                    color: aux4,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      '${dateFormatter(widget.delItem.orderDate)}',
                      style: GoogleFonts.sourceSansPro(
                          color: aux6,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                  ],
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
                    SizedBox(height: 9,),
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
                    SizedBox(height: 15,),
                    Visibility(
                      visible: widget.delItem.status == 'PROCESSING',
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: FlatButton(
                          onPressed: confirmDelivery,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.green,
                          child: Text(
                            'Confirm Delivery',
                            style: GoogleFonts.roboto(
                                color: aux1,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
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
