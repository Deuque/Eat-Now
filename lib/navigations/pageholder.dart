
import 'package:eat_now/navigations/cart.dart';
import 'package:eat_now/navigations/food_layout.dart';
import 'package:eat_now/navigations/nav_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/MyServices.dart';

class PageHolder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<PageHolder> {
  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);

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
        appBar: AppBar(
          backgroundColor: appstate.aux1,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: appstate.aux6,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'EAT NOW - PAY LATER',
            style: GoogleFonts.dancingScript(
                color: appstate.aux2,
                fontWeight: FontWeight.w800,
                fontSize: 17),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: Container(),
                backgroundColor: appstate.aux1,
                expandedHeight: 160.0,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: //
                      Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 160,
                        child: Image.asset(
                          'assets/verify_img.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Text(
                          'Our dishes are sorted according to current orders',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.asap(
                              color: appstate.aux1,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SliverPersistentHeader(
                delegate: _SliverTextDelegate(
                  Text(
                    'TODAY',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.asap(
                        color: appstate.aux2,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
                pinned: true,
              ),
            ];
          },

          body:
          ListView(
            children: <Widget>[
              for (final item in appstate.foodlist) FoodLayout(item)
            ],
          ),
        ),

        drawer: Drawer(
          child: drawerItems,
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
    var appstate = Provider.of<MyService>(context, listen: true);
    return new Container(
      color: appstate.aux1,
      alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left:15.0,top: 20,bottom: 10),
      child: _text,
    );
  }

  @override
  bool shouldRebuild(_SliverTextDelegate oldDelegate) {
    return false;
  }
}
