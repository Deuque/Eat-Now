import 'package:eat_now/navigations/dash.dart';
import 'package:eat_now/navigations/my_orders.dart';
import 'package:eat_now/navigations/nav_items.dart';
import 'package:eat_now/navigations/profile.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bottomAppBar.dart';
import '../services/MyServices.dart';
import 'cart.dart';

class PageHolder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<PageHolder> {
  Widget current;
  @override
  Widget build(BuildContext context) {

    final drawerHeader = UserAccountsDrawerHeader(
        accountName: Text('Mine'),
        accountEmail: Text('Mine@email.com'),
        currentAccountPicture: CircleAvatar(
          child: FlutterLogo(size: 30.0),
          backgroundColor: Colors.white,
        ));
    final drawerItems = NavItems();

    return SafeArea(
      child: Scaffold(
//        appBar: AppBar(
//          backgroundColor: aux1,
//          leading: Builder(
//            builder: (BuildContext context) {
//              return IconButton(
//                icon: Icon(
//                  Icons.menu,
//                  color: aux6,
//                ),
//                onPressed: () => Scaffold.of(context).openDrawer(),
//              );
//            },
//          ),
//          elevation: 1,
//          centerTitle: true,
//          title: Text(
//            'EAT NOW - PAY LATER',
//            style: GoogleFonts.dancingScript(
//                color: aux2,
//                fontWeight: FontWeight.w800,
//                fontSize: 17),
//          ),
//        ),
        body: current??Dashboard(),

//        NestedScrollView(
//          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//            return <Widget>[
//              SliverAppBar(
//                leading: Container(),
//                backgroundColor: aux1,
//                expandedHeight: 160.0,
//                floating: false,
//                pinned: false,
//                flexibleSpace: FlexibleSpaceBar(
//                  background: //
//                      Stack(
//                    children: <Widget>[
//                      Container(
//                        width: double.infinity,
//                        height: 160,
//                        child: Image.asset(
//                          'assets/verify_img.jpg',
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                      Positioned(
//                        bottom: 10,
//                        left: 10,
//                        right: 10,
//                        child: Text(
//                          'Our dishes are sorted according to current orders',
//                          textAlign: TextAlign.center,
//                          style: GoogleFonts.asap(
//                              color: aux1,
//                              fontWeight: FontWeight.w700,
//                              fontSize: 16),
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//              SliverPersistentHeader(
//                delegate: _SliverTextDelegate(
//                  Text(
//                    'TODAY',
//                    textAlign: TextAlign.center,
//                    style: GoogleFonts.asap(
//                        color: aux2,
//                        fontWeight: FontWeight.w700,
//                        fontSize: 16),
//                  ),
//                ),
//                pinned: true,
//              ),
//            ];
//          },
//          body: ListView(
//            children: <Widget>[
//              for (final item in foodlist) FoodLayout(item)
//            ],
//          ),
//        ),
//        drawer: Drawer(
//          child: drawerItems,
//        ),
//        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//        floatingActionButton: SizedBox(
//          height: 50,
//          width: 50,
//          child: FloatingActionButton(
//            child: Image.asset('assets/cart.png',width: 20,height: 20,color: aux1,),
//            backgroundColor: aux2,
//            onPressed: (){
//
//            },
//          ),
//        ),
        bottomNavigationBar: FABBottomAppBar(
          selectedColor: aux2,
          backgroundColor: aux1,
          color: aux6,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: (value){
            setState(() {
              if(value==0){
                current=Dashboard();
              }else if(value==1){
                current=MyOrders();
              }else if(value==2){
                current = Cart();
              }else if(value==3){
                current = Profile();
              }
            });
          },
          items: [
            FABBottomAppBarItem(iconData: 'assets/home.png', text: 'Explore'),
            FABBottomAppBarItem(iconData: 'assets/orders.png', text: 'Orders'),
//            FABBottomAppBarItem(iconData: '', text: ''),
            FABBottomAppBarItem(iconData: 'assets/cart.png', text: 'Cart'),
            FABBottomAppBarItem(iconData: 'assets/user.png', text: 'Profile'),

          ],
        ),
      ),
    );
  }
}

class _SliverTextDelegate extends SliverPersistentHeaderDelegate {
  _SliverTextDelegate(this._text);

  final Text _text;

  @override
  double get minExtent => 46;

  @override
  double get maxExtent => 46;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: aux1,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15.0, top: 20, bottom: 10),
      child: _text,
    );
  }

  @override
  bool shouldRebuild(_SliverTextDelegate oldDelegate) {
    return false;
  }
}
