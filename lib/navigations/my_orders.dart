import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/MyServices.dart';
import 'delivery_layout.dart';
import 'food_layout.dart';

class MyOrders extends StatefulWidget {
  State<MyOrders> createState() => MyState();
}

class MyState extends State<MyOrders> {
  RxServices get service => GetIt.I<RxServices>();
  BasicInfo basicInfo;
  PersonalInfo personalInfo;


  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
//    Fluttertoast.showToast(msg: '${appstate.deliveries.length}');
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
                backgroundColor: appstate.aux1,
                iconTheme: IconThemeData(color: appstate.aux2),
                elevation: 1,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'My Orders',
                    style: GoogleFonts.roboto(
                        color: appstate.aux2,
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
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
                      Tab(text: "All"),
                      Tab(text: "Delivered"),
                      Tab(text: "Pending"),
                    ],

                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(children: [
            tabViews(index: 0,),
            tabViews(index: 1,),
            tabViews(index: 2,),
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
    var appstate = Provider.of<MyService>(context, listen: true);
    List<DeliveryLayout> deliverylayouts=[];
     for(final item in appstate.deliveries){
       if(index==1 && item.isDone) {deliverylayouts.add(DeliveryLayout(item));}
       else if(index==2 && !item.isDone) {deliverylayouts.add(DeliveryLayout(item));}
       else if(index==0){deliverylayouts.add(DeliveryLayout(item));}
     }


    return ListView(
      children: <Widget>[
        for(final item in deliverylayouts) item
      ],
    );

  }

}


