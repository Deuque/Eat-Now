import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/delivery_item.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/navigations/admin_pages/admin_vendor_layout.dart';
import 'package:eat_now/navigations/dash.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminVendorsList extends StatefulWidget {
  State<AdminVendorsList> createState() => MyState();
}

class MyState extends State<AdminVendorsList> {
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

    return Scaffold(
      body: DefaultTabController(
        length: 2,
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
                    'Vendors',
                    style: GoogleFonts.roboto(
                        color: aux6,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(

                    labelColor: aux2,
                    unselectedLabelColor: aux42,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: "Unverified"),
                      Tab(text: "Verified"),
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
    return new StreamBuilder<List<Vendor>>(
        stream: service.vendorStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List vendors = [];
            if (index == 0) {
              snapshot.data.forEach((element) {
                if(!element.isVerified){
                  vendors.add(element);
                }
              });
            }
            else  if (index == 1) {
              snapshot.data.forEach((element) {
                if(element.isVerified){
                  vendors.add(element);
                }
              });
          }

            if(vendors.isNotEmpty) {
              return new ListView(
                children: <Widget>[
                  for (final item in vendors) AdminVendorLayout(vendor: item,)
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


