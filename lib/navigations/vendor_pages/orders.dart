import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/navigations/dash.dart';
import 'package:eat_now/navigations/vendor_pages/delivery_vendor_layout.dart';
import 'package:eat_now/services/MyServices.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  State<Orders> createState() => MyState();
}

class MyState extends State<Orders> {
  RxServices get service => GetIt.I<RxServices>();
//  BasicInfo basicInfo;
//  PersonalInfo personalInfo;

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
//    Fluttertoast.showToast(msg: '${appstate.deliveries.length}');
//    basicInfo = service.myUser.basicInfo;
//    personalInfo = service.myUser.personalInfo;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 100.0,
                floating: false,
                pinned: true,
                backgroundColor: appstate.aux1,
                iconTheme: IconThemeData(color: appstate.aux2),
                elevation: 1,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Orders',
                    style: GoogleFonts.roboto(
                        color: appstate.aux6,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: appstate.aux2,
                    unselectedLabelColor: appstate.aux4,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: "Pending"),
                      Tab(text: "Delivered"),
                      Tab(text: "Cancelled"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(children: [
            tabViews(
              index: 0,
            ),
            tabViews(
              index: 1,
            ),
            tabViews(
              index: 2,
            ),
          ]),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 1;

  @override
  double get maxExtent => _tabBar.preferredSize.height + 1;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _tabBar,
          Divider(
            height: 1,
            color: Color(0xFFE5E5E5),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class tabViews extends StatelessWidget {
  final index;

  tabViews({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    for(final item in appstate.deliveries){
//      if(index==1 && item.status=='PROCESSING') {deliverylayouts.add(DeliveryLayout(item));}
//      else if(index==2 && item.status=='DELIVERED') {deliverylayouts.add(DeliveryLayout(item));}
//      else if(index==0){deliverylayouts.add(DeliveryLayout(item));}
//    }

    return StreamBuilder<List<DeliveryItem>>(
        stream: service.deliveryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List<DeliveryItem> deliveries = snapshot.data;
            List selectedItems = [];
            if (index == 0) {
              deliveries.forEach((element) {
                if(element.status=='PROCESSING'){
                  selectedItems.add(element);
                }
              });
            }
            else  if (index == 1) {
              deliveries.forEach((element) {
                if(element.status=='DELIVERED'){
                  selectedItems.add(element);
                }
              });
            } else if (index == 2) {
              deliveries.forEach((element) {
                if(element.status=='CANCELLED'){
                  selectedItems.add(element);
                }
              });
            }

            if(selectedItems.isNotEmpty) {
              return new ListView(
                children: <Widget>[
                  for (final item in selectedItems) DeliveryVendorLayout(item)
                ],
              );
            }
          }
          return Center(
            child: Image.asset('assets/nofood.png',
                color: aux41, height: 65, width: 65),
          );
        });
  }
}
