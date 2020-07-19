import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/Crud.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminVendorProfile extends StatefulWidget {
  final Vendor vendor;

  const AdminVendorProfile({Key key, this.vendor}) : super(key: key);

  @override
  _AdminVendorProfileState createState() => _AdminVendorProfileState();
}

class _AdminVendorProfileState extends State<AdminVendorProfile> {
  RxServices get service => GetIt.I<RxServices>();
  bool isVerified;

  @override
  void initState() {
    isVerified = widget.vendor.isVerified;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pr = getDialog(context);
    var choices = ['Payment record'];
    double iconsize = 52;
    Widget div({thick}) => Padding(
          padding: EdgeInsets.symmetric(horizontal: thick == null ? 18.0 : 0),
          child: Divider(
            thickness: thick == null ? 1.2 : thick,
            color: aux41,
          ),
        );
    Widget hdiv = Container(
      height: 40,
      width: 1.2,
      color: aux41,
    );
    Widget itemsdisplay(String count, String label) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            count,
            style: GoogleFonts.roboto(
                color: aux6, fontWeight: FontWeight.w500, fontSize: 16.5),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                color: aux4, fontWeight: FontWeight.w300, fontSize: 15),
          ),
        ],
      );
    }

    Widget details({title, subtitle, trailer, trailerClick}) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 8, top: 8, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        color: aux77,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        color: aux6, fontWeight: FontWeight.w300, fontSize: 15),
                  ),
                ],
              ),
            ),
            trailer != null
                ? IconButton(
                    icon: Image.asset(
                      trailer,
                      height: 17,
                      width: 17,
                      color: aux4,
                    ),
                    onPressed: trailerClick,
                  )
                : Text(''),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: aux1,
        body: NestedScrollView(
          headerSliverBuilder: (a, b) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: aux1),
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: mytrans,
                      child: Icon(
                        Icons.arrow_back,
                        color: aux1,
                        size: 14,
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: CircleAvatar(
                      backgroundColor: mytrans,
                      radius: 30,
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: aux1,
                          size: 14,
                        ),
                        onSelected: (choice) {
                          if (choice == 'Logout') {}
                        },
                        itemBuilder: (BuildContext context) {
                          return choices.map((choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ),
//                  child: Material(
//                    borderRadius: BorderRadius.circular(20),
//                    color: mytrans,
//                     child: PopupMenuButton<String>(
//                       icon: Icon(Icons.more_vert,color: aux1,size: 14,),
//                       onSelected: (choice) {
//                         if(choice=='Logout'){
//                         }
//                       },
//                       itemBuilder: (BuildContext context) {
//                         return choices.map((choice) {
//                           return PopupMenuItem<String>(
//                             value: choice,
//                             child: Text(choice),
//                           );
//                         }).toList();
//                       },
//                     ),
//                   ),
                  ),
                ],
                elevation: 0,
                expandedHeight: 110 + iconsize / 2,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: //
                      Stack(
                    children: <Widget>[
                      Container(
                        height: 110,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: widget.vendor == null
                              ? ''
                              : widget.vendor.persVInfo.bannerUrl,
                          imageBuilder: (context, imageProvider) => Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          placeholder: (context, url) => Container(
                            height: 110,
                            color: aux2,
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 110,
                            color: aux2,
                          ),
                        ),
                      ),
                      Positioned(
                        left:
                            (MediaQuery.of(context).size.width - iconsize) / 2,
                        top: 100,
                        child: Container(
                          height: iconsize,
                          width: iconsize,
                          child: CachedNetworkImage(
                            imageUrl: widget.vendor == null
                                ? ''
                                : widget.vendor.persVInfo.logoUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              height: iconsize,
                              width: iconsize,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(iconsize / 2),
                                  border: Border.all(color: aux1, width: 2)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(iconsize / 2),
                                child: Image(
                                  image: imageProvider,
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
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ];
          },
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//                SizedBox(
//                  height: 7,
//                ),
//                Container(
//                  height: iconsize,
//                  width: iconsize,
//                  child: CachedNetworkImage(
//                    imageUrl: vendor==null?'':vendor.persVInfo.logoUrl,
//                    imageBuilder: (context, imageProvider) => SizedBox(
//                      height: iconsize,
//                      width: iconsize,
//                      child: ClipRRect(
//                        borderRadius:
//                        BorderRadius.circular( iconsize/2),
//                        child: Image(
//                          image: imageProvider,
//                          width: iconsize,
//                          height: iconsize,
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                    ),
//                    placeholder: (context, url) => Image.asset(
//                      'assets/logo.png',
//                      height: iconsize,
//                      width: iconsize,
//                    ),
//                    errorWidget: (context, url, error) => Image.asset(
//                      'assets/logo.png',
//                      height: iconsize,
//                      width: iconsize,
//                    ),
//                  ),
//                ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.vendor.persVInfo.cname,
                        style: GoogleFonts.asap(
                            color: aux2, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(width: 3,),
                      isVerified?Icon(Icons.verified_user,color: Colors.green,size: 16,):Container()
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.vendor.persVInfo.cemail,
                    style: GoogleFonts.asap(
                        color: aux4, fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      StreamBuilder<List<FoodItem>>(
                          stream: service.foodStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data.isNotEmpty) {
                              List myItems = [];
                              snapshot.data.forEach((element) {
                                if (element.vendor == widget.vendor.id)
                                  myItems.add(element);
                              });
                              return itemsdisplay(
                                  '${myItems.length}', 'Food\nItems');
                            }
                            return itemsdisplay('0', 'Food\nItems');
                          }),
                      hdiv,
                      itemsdisplay('0', 'Deliveries\nThis month'),
                      hdiv,
                      itemsdisplay('NGN 0', 'Bill\nThis month'),
                    ],
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  div(thick: 2.0),
                  details(
                      title: 'Category',
                      subtitle: widget.vendor.persVInfo.category),
                  div(),
                  details(
                      title: 'Address',
                      subtitle: widget.vendor.persVInfo.address +
                          ', ' +
                          widget.vendor.persVInfo.city +
                          ', ' +
                          widget.vendor.persVInfo.state +
                          ', ' +
                          widget.vendor.persVInfo.country),
                  div(),
                  details(
                      title: 'Phone number',
                      subtitle: widget.vendor.persVInfo.cnum,
                      trailer: 'assets/call.png',
                      trailerClick: () {}),
                  div(thick: 2.0),
                  details(
                    title: 'Bank',
                    subtitle: widget.vendor.payVInfo.bank,
                  ),
                  div(),
                  details(
                      title: 'Acct No',
                      subtitle: widget.vendor.payVInfo.account_no,
                      trailer: 'assets/copy.png',
                      trailerClick: () {}),
                  div(thick: 2.0),
                  details(
                      title: 'Delivery',
                      subtitle: widget.vendor.delVInfo.deliver
                          ? 'Yes  -  NGN ' +
                              moneyResolver(widget.vendor.delVInfo.price)
                          : 'No'),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 11),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: aux2,
                      onPressed: () {
                        pr.show();
                        CrudOperations.verifyVendor(
                                widget.vendor.id, !isVerified)
                            .then((value) {
                              pr.hide();
                          if (value.data) {
                            setState(() {
                              isVerified = !isVerified;
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: value.errorMessage,
                                toastLength: Toast.LENGTH_LONG);
                          }
                        });
                      },
                      child: Text(
                        isVerified ? 'unverify' : 'verify',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.asap(
                            color: aux1,
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
