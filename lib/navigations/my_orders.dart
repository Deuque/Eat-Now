import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/navigations/dash.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/MyServices.dart';
import 'delivery_layout.dart';

class MyOrders extends StatefulWidget {
  State<MyOrders> createState() => MyState();
}

class MyState extends State<MyOrders> {
  RxServices get service => GetIt.I<RxServices>();
  BasicInfo basicInfo;
  PersonalInfo personalInfo;
  List<DeliveryItem> deliveries;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    Fluttertoast.showToast(msg: '${deliveries.length}');
    basicInfo = service.myUser.basicInfo;
    personalInfo = service.myUser.personalInfo;

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
                backgroundColor: aux1,
                iconTheme: IconThemeData(color: aux2),
                elevation: 1,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'My Orders',
                    style: GoogleFonts.roboto(
                        color: aux2,
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(

                    labelColor: aux2,
                    unselectedLabelColor: aux4,
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
            new tabViews(index: 0,),
            new tabViews(index: 1,),
            new tabViews(index: 2,),
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
  double get minExtent => _tabBar.preferredSize.height+1;

  @override
  double get maxExtent => _tabBar.preferredSize.height+1;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _tabBar,
          Divider(height: 1,color: Color(0xFFE5E5E5),)
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
    return new StreamBuilder<List<DeliveryItem>>(
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
                  for (final item in selectedItems) DeliveryLayout(item)
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


