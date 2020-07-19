import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/cart_item.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/models/personal_vendor_info.dart';
import 'package:eat_now/models/user_model.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/cart.dart';
import 'package:eat_now/navigations/search.dart';
import 'package:eat_now/navigations/vendor_layout.dart';
import 'package:eat_now/navigations/vendor_layout2.dart';
import 'package:eat_now/navigations/view_vendor.dart';
import 'package:eat_now/services/ApiService.dart';
import 'package:eat_now/services/MyServices.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:eat_now/services/city_model.dart';
import 'package:eat_now/services/country_model.dart';
import 'package:eat_now/services/state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../confirm_order.dart';
import 'fade_route.dart';
import 'food_layout.dart';

RxServices get service => GetIt.I<RxServices>();

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController scontroller = new TextEditingController();
  List<CountryModel> countries = [];
  List<StateModel> states = [];
  List<CityModel> cities = [];
  var selCountry, selState,selCity;
  var country = service.myUser?.personalInfo?.country;
  var state = service.myUser?.personalInfo?.state;
  var city = service.myUser?.personalInfo?.city;
  ApiService apiService = new ApiService();

  void _bottomSheet() {
    selCountry = countries.firstWhere(
            (element) => element.name == country);
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
      ),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState1){return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Find Restaurants around you',
                style: GoogleFonts.roboto(
                    color: aux2,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.6),
              ),
              SizedBox(height: 2.6,),
              Text(
                'choose a location',
                style: GoogleFonts.roboto(
                    color: aux6,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              SizedBox(height: 11,),
              Wrap(
                children: <Widget>[
                  LocItems(initLoc: country,label: 'Country',list: countries,resolveText: (value) {
                    country = value;
                    selCountry = countries.firstWhere(
                            (element) => element.name == value);
                    apiService
                        .getStates(selCountry.code)
                        .then((value) {
                      if (!value.error) {
                        setState1(() {
                          states = value.data;
                        });
                      } else {
                        print(value.errMessage);
                      }
                    });
                  },),
                  SizedBox(width:6,),
                  LocItems(initLoc: state,label: 'State',list: states,resolveText: (value) {
                    state = value;
                    selState = states.firstWhere(
                            (element) => element.region == value);
                    apiService
                        .getCities(selCountry.code, selState.region)
                        .then((value) {
                      if (!value.error) {
                        setState1(() {
                          cities = value.data;
                        });
                      }
                    });
                  },),
                  SizedBox(width: 6,),
                  LocItems(initLoc: city,label: 'City',list: cities,resolveText: (value) {
                    city = value;
                  },),


                ],
              ),
              SizedBox(height: 19,),
              Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.all(5),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: aux2,
                  onPressed: () {
                    setFilter();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Filter',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.asap(
                        color: aux1,
                        fontWeight: FontWeight.w300,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );},)
    );
  }
  setLists() async{
    await apiService.getCountries().then((value) {
      if (!value.error) {
        countries = value.data;
        service.setCountry(countries);
      }else{
        Fluttertoast.showToast(msg: value.errMessage);
      }
    });
    selCountry = countries.firstWhere(
            (element) => element.name == service.myUser.personalInfo.country);
    await apiService
        .getStates(selCountry.code)
        .then((value) {
      if (!value.error) {
        states = value.data;
        service.setStates(states);
      } else {
        Fluttertoast.showToast(msg: value.errMessage);
      }
    });
    selState = states.firstWhere(
            (element) => element.region == service.myUser.personalInfo.state);
    await apiService
        .getCities(selCountry.code, selState.region)
        .then((value) {
      if (!value.error) {
        cities = value.data;
        service.setCities(cities);
        service.setShownFilter();
      }else{
        Fluttertoast.showToast(msg: value.errMessage);
      }
    });
  }

  void setFilter(){
    setState(() {
      service.setCountry(countries);
      service.setStates(states);
      service.setCities(cities);
    });
  }

  @override
  void initState() {
    if(!service.shownFilter){
      setLists();
    }else{

      countries = service.mcountries;
      states = service.mstates;
      cities = service.mcities;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aux1,
      body:  StreamBuilder(
        stream: service.userStream,
        builder: (_, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            User myUser = snapshot.data;
            country = country??myUser?.personalInfo?.country;
            state = state??myUser?.personalInfo?.state;
            city = city??myUser?.personalInfo?.city;
            return  ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 11.0, right: 11, top: 11),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text(
                                  'Hello ${myUser.basicInfo.fname.split(' ')[0]},',
                                  style: GoogleFonts.roboto(
                                      color: aux22,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25),
                                ),
                                Text(
                                  'What do you want to eat?',
                                  style: GoogleFonts.roboto(
                                      color: aux4,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 50,),
                          Wrap(
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              Text(
                                'credit: ',
                                style: GoogleFonts.roboto(
                                    color: aux42,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13),
                              ),
                              Text(
                                myUser==null||myUser.paymentInfo==null?'processing..':myUser.paymentInfo.creditLeft,
                                style: GoogleFonts.roboto(
                                    color: aux77,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoCompleteSearch(),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Exclusive and Popular',
                            style: GoogleFonts.roboto(
                                color: aux4,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.5),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                ),
                      StreamBuilder<List<Vendor>>(
                          stream: service.vendorStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                height: 60,
                                width: 60,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasData && snapshot.data.isNotEmpty) {
                              List<Vendor> vendors = snapshot.data;

                              vendors.sort((a,b)=>b.delVInfo.rating.compareTo(a.delVInfo.rating));
                              int count = vendors.length<10?vendors.length:10;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    for (int i=count-1;i>=0;i--)
                                      VendorLayout2(item: vendors[i],itemClick: (){
                                        Navigator.push(context, FadeRoute(page: ViewVendor(uid: vendors[i].id,)));
                                      },),
                                    SizedBox(width: 11,)
                                  ],
                                ),
                              );
                            }
                            return Container(
                              height: 80,
                              width: 80,
                              child: Center(
                                child: Text(
                                  'No vendors yet',
                                  style: TextStyle(color: aux42),
                                ),
                              ),
                            );
                          }),
                      SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:11.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Restaurants around ${city.split(' ')[0]}, ${state.split(' ')[0]}',
                              style: GoogleFonts.roboto(
                                  color: aux4,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:5.0),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: _bottomSheet,
                                    child: Text(
                                      'Filter',
                                      style: GoogleFonts.roboto(
                                          color: aux4,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(width: 2.4,),
                                  Icon(Icons.filter_list,color: aux42,size: 12,)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),

                StreamBuilder<List<Vendor>>(
                    stream: service.vendorStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 80,
                          width: 80,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasData && snapshot.data.isNotEmpty) {
                        List<Vendor> myItems = snapshot.data;
                        List filteredItems = [];
                        country = country??service.myUser.personalInfo.country;
                        state = state??service.myUser.personalInfo.state;
                        city = city??service.myUser.personalInfo.city;
                        myItems.forEach((element) {
                          PersonalVendorInfo pvi = element.persVInfo;
                          if(pvi.city==city&&pvi.state==state&&pvi.country==country) filteredItems.add(element);
                        });
                        myItems.forEach((element) {
                          PersonalVendorInfo pvi = element.persVInfo;
                          if(pvi.state==state&&pvi.country==country){
                           if(!filteredItems.contains(element)) filteredItems.add(element);
                          }
                        });
//                        myItems.forEach((element) {
//                          PersonalVendorInfo pvi = element.persVInfo;
//                          if(pvi.country==country){
//                            if(!filteredItems.contains(element)) filteredItems.add(element);
//                          }
//                        });
                        if(filteredItems.isNotEmpty) {
                          return SingleChildScrollView(
                            child: GridView.count(
                              physics: ScrollPhysics(),
                              padding: EdgeInsets.all(10),
                              childAspectRatio: 0.9,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 18,
                              shrinkWrap: true,
                              children: <Widget>[
                                for (final item in filteredItems)
                                  VendorLayout(
                                    item: item,
                                    itemClick: () {
                                      Navigator.push(context, FadeRoute(
                                          page: ViewVendor(uid: item.id,)));
                                    },
                                  )
                              ],
                            ),
                          );
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Image.asset('assets/nofood.png',
                              color: aux41, height: 65, width: 65),
                        ),
                      );
                    }),
              ],
            );
          }

          return Text('Error Fetching Data');
        },
      ),


    );
  }
}

class LocItems extends StatefulWidget {
  final initLoc, label, list, resolveText;

  const LocItems({Key key, this.initLoc, this.label, this.list, this.resolveText}) : super(key: key);
  @override
  _LocItemsState createState() => _LocItemsState();
}

class _LocItemsState extends State<LocItems> {
 String text;
 @override
  void initState() {
    text = widget.initLoc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _bottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => Container(
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 20, right: 8, bottom: 7),
                child: Text(
                  'Select ${widget.label}',
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 18, fontWeight: FontWeight.w600, color: aux2),
                ),
              ),
              Divider(
                height: 1,
                color: aux4,
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  separatorBuilder: (_, i) => Divider(
                    color: aux8,
                    height: 1,
                  ),
                  itemBuilder: (_, i) {
                    return ListTile(
                      onTap: () {
                          setState(() {
                            text = widget.list[i].choice;
                          });
                          widget.resolveText(text);
                        Navigator.pop(context);
                      },
                      title: Text(
                        '${widget.list[i].choice}',
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      trailing: widget.list[i].choice == text
                          ? Icon(
                        Icons.check,
                        color: aux2,
                        size: 18,
                      )
                          : Text(''),
                    );
                  },
                  itemCount: widget.list.length,
                ),
              )
            ],
          ),
        ),
      );
    }


    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RaisedButton(
          color: aux1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7)
          ),
          onPressed: _bottomSheet,
          elevation: 2.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: GoogleFonts.roboto(
                    color: aux4,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Icon(Icons.arrow_drop_down,color: aux4,)
            ],
          ),
        ),
      ],
    );
  }
}

//
//class FoodItemLayout extends StatefulWidget {
//  final FoodItem item;
//  final itemClick;
//
//  const FoodItemLayout({Key key, this.item, this.itemClick}) : super(key: key);
//
//  @override
//  _FoodItemLayoutState createState() => _FoodItemLayoutState();
//}
//
//class _FoodItemLayoutState extends State<FoodItemLayout> {
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    var appstate = Provider.of<MyService>(context);
//    double iconsize = 112.7;
//
//    void _bottomSheet() {
//      double iconsize = 65;
//      int qty = 1;
//      showModalBottomSheet(
//        isScrollControlled: true,
//        isDismissible: true,
//        backgroundColor: aux1,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//        ),
//        context: context,
//        builder: (context) => StatefulBuilder(builder: (context, setState) {
//          return Padding(
//            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
//            child: Material(
//              color: aux1,
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  ListTile(
//                    leading: CachedNetworkImage(
//                      imageUrl: widget.item.imgUrl,
//                      imageBuilder: (context, imageProvider) => SizedBox(
//                        height: iconsize,
//                        width: iconsize,
//                        child: ClipRRect(
//                          borderRadius: BorderRadius.circular(
//                              8),
//                          child: Image(
//                            image: imageProvider,
//                            width: iconsize,
//                            height: iconsize,
//                            fit: BoxFit.cover,
//                          ),
//                        ),
//                      ),
//                      placeholder: (context, url) => Image.asset(
//                        'assets/logo1.jpeg',
//                        height: iconsize,
//                        width: iconsize,
//                      ),
//                      errorWidget: (context, url, error) => Image.asset(
//                        'assets/logo1.jpeg',
//                        height: iconsize,
//                        width: iconsize,
//                      ),
//                    ),
//                    title: Text(
//                      widget.item.name,
//                      maxLines: 2,
//                      overflow: TextOverflow.ellipsis,
//                      style: GoogleFonts.roboto(
//                          color: aux6,
//                          fontWeight: FontWeight.w500,
//                          fontSize: 15),
//                    ),
//                    subtitle: Row(
//                      children: <Widget>[
//                        Text(
//                          'QTY: ',
//                          style: GoogleFonts.asap(
//                              color: aux6,
//                              fontWeight: FontWeight.w400,
//                              fontSize: 13),
//                        ),
//                        IconButton(
//                          onPressed: () {
//                            setState(() {
//                              if (qty > 1) qty--;
//                            });
//                          },
//                          icon: Icon(
//                            Icons.remove_circle,
//                            color: aux3,
//                          ),
//                        ),
//                        Text(
//                          '${qty}',
//                          style: GoogleFonts.asap(
//                              color: aux6,
//                              fontWeight: FontWeight.w500,
//                              fontSize: 13),
//                        ),
//                        IconButton(
//                          onPressed: () {
//                            setState(() {
//                              qty++;
//                            });
//                          },
//                          icon: Icon(
//                            Icons.add_circle,
//                            color: aux3,
//                          ),
//                        ),
//                      ],
//                    ),
//                    trailing: Text(
//                      'NGN ${moneyResolver('${widget.item.price}')}',
//                      style: GoogleFonts.sourceSansPro(
//                          color: aux2,
//                          fontWeight: FontWeight.w600,
//                          fontSize: 15),
//                    ),
//                  ),
//                  SizedBox(
//                    height: 10,
//                  ),
//                  Row(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      RaisedButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(10),
//                        ),
//                        color: aux1,
//                        elevation: 2.3,
//                        child: Padding(
//                          padding: const EdgeInsets.symmetric(
//                              vertical: 8.0, horizontal: 8),
//                          child: Text(
//                            'Cancel',
//                            style: GoogleFonts.roboto(
//                                color: aux2,
//                                fontWeight: FontWeight.w400,
//                                fontSize: 13),
//                          ),
//                        ),
//                        onPressed: () {
//                          Navigator.pop(context);
//                        },
//                      ),
//                      SizedBox(
//                        width: 11,
//                      ),
//                      RaisedButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(10),
//                        ),
//                        color: aux2,
//                        elevation: 2.3,
//                        child: Padding(
//                          padding: const EdgeInsets.symmetric(
//                              vertical: 8, horizontal: 8),
//                          child: Text(
//                            'Buy',
//                            style: GoogleFonts.roboto(
//                                color: aux1,
//                                fontWeight: FontWeight.w400,
//                                fontSize: 13),
//                          ),
//                        ),
//                        onPressed: () {
//                          Navigator.push(
//                              context,
//                              FadeRoute(
//                                  page: ConfirmOrder(
//                                    items: [CartItem(widget.item, qty)],
//                                  )));
//                        },
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          );
//    }
//        )
//      );
//    }
//    return FutureBuilder(
//      future: service.vendorStream.first,
//      builder: (context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return Center(
//            child: CircularProgressIndicator(),
//          );
//        }
//        if (snapshot.hasData) {
//          Vendor vendor;
//          for (final v in snapshot.data) {
//            if (v.id == widget.item.vendor) {
//              vendor = v;
//              break;
//            }
//          }
//
//
//          return Container(
//            decoration: BoxDecoration(
//              color: aux1,
//              borderRadius: BorderRadius.circular(9),
//              boxShadow: [
//                BoxShadow(
//                    color: aux42.withOpacity(.5),
//                    offset: Offset(0.0, 3.5),
//                    blurRadius: 8.0)
//              ],
//            ),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                InkWell(
//                  onTap: widget.itemClick??(){},
//                  child: CachedNetworkImage(
//                    imageUrl: widget.item.imgUrl,
//                    imageBuilder: (context, imageProvider) => SizedBox(
//                      height: iconsize,
//                      width: double.maxFinite,
//                      child: ClipRRect(
//                        borderRadius:
//                            BorderRadius.vertical(top: Radius.circular(9)),
//                        child: Image(
//                          image: imageProvider,
//                          width: double.maxFinite,
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                    ),
//                    placeholder: (context, url) => Image.asset(
//                      'assets/logo1.jpeg',
//                      height: iconsize,
//                      width: iconsize,
//                    ),
//                    errorWidget: (context, url, error) => Image.asset(
//                      'assets/logo1.jpeg',
//                      height: iconsize,
//                      width: iconsize,
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(left: 8.0, top: 7, bottom: 4),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Flexible(
//                        child: Text(
//                          widget.item.name,
//                          maxLines: 2,
//                          overflow: TextOverflow.ellipsis,
//                          style: GoogleFonts.roboto(
//                              color: aux6,
//                              fontWeight: FontWeight.w400,
//                              fontSize: 14),
//                        ),
//                      ),
//
////                IconButton(iconSize: 15,icon: Image.asset('assets/cart.png',height: 15,width: 15,color: aux2,),color: aux1,),
//                    ],
//                  ),
//                ),
//                InkWell(
//                  onTap: widget.itemClick??(){},
//                  child: Padding(
//                    padding: const EdgeInsets.only(top: 5, left: 8, bottom: 2),
//                    child: Text(
//                      vendor.persVInfo.cname,
//                      style: GoogleFonts.roboto(
//                          color: aux42,
//                          fontWeight: FontWeight.w500,
//                          fontSize: 12),
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding:
//                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      SmoothStarRating(
//                          allowHalfRating: false,
//                          onRated: (v) {},
//                          starCount: 5,
//                          rating: vendor.delVInfo.rating.toDouble(),
//                          size: 12.0,
//                          isReadOnly: true,
//                          color: aux2,
//                          borderColor: aux2,
//                          spacing: 0.0),
//                      SizedBox(width: 10,),
//                      Flexible(
//                        child: Text(
//                          'NGN ${moneyResolver(widget.item.price)}',
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                          style: GoogleFonts.roboto(
//                              color: aux6,
//                              fontWeight: FontWeight.w400,
//                              fontSize: 13),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                Spacer(),
//                Divider(),
//                Container(
//                  padding: EdgeInsets.only(bottom: 2),
//                  width: double.maxFinite,
//                  height: 30,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      InkWell(
//                        onTap: _bottomSheet,
//                        child: Padding(
//                          padding: const EdgeInsets.all(5.0),
//                          child: Text(
//                            'BUY',
//                            style: GoogleFonts.roboto(
//                                color: aux3,
//                                fontWeight: FontWeight.w600,
//                                fontSize: 13),
//                          ),
//                        ),
//                      ),
//                      VerticalDivider(),
//                      InkWell(
//                        onTap: () {
//                          service
//                              .addToCart(CartItem(widget.item, 1))
//                              .then((value) {
//                            if (value) {
//                              showToast(context, 'Food added to cart',
//                                  snackaction: () {
//                                Scaffold.of(context).hideCurrentSnackBar;
//                                Navigator.push(context,
//                                    MaterialPageRoute(builder: (_) => Cart()));
//                              });
//                            } else {
//                              Fluttertoast.showToast(msg: 'Item already added');
//                            }
//                          });
//                        },
//                        child: Padding(
//                          padding: const EdgeInsets.all(5.0),
//                          child: Text(
//                            'CART',
//                            style: GoogleFonts.roboto(
//                                color: aux3,
//                                fontWeight: FontWeight.w600,
//                                fontSize: 13),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            ),
//          );
//        }
//        return Center(
//          child: CircularProgressIndicator(),
//        );
//      },
//    );
//  }
//}
