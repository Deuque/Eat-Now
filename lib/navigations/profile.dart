import 'package:eat_now/models/basic_info.dart';
import 'package:eat_now/models/personal_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:provider/provider.dart';
import '../models/MyServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_item_layout.dart';
import 'food_layout.dart';

class Profile extends StatefulWidget {
  State<Profile> createState() => MyState();
}

class MyState extends State<Profile> {
  int _totalPrice = 0;
  bool checkedValue = true;
  List cartitems = [];
  List choices = ['Edit Profile'];
  double percent = 40;

  BasicInfo basicInfo;
  PersonalInfo personalInfo;

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);
    basicInfo = appstate.myUser.basicInfo;
    personalInfo = appstate.myUser.personalInfo;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appstate.aux1,
          iconTheme: IconThemeData(color: appstate.aux2),
          elevation: 1,
          centerTitle: true,
          title: Text(
            'PROFILE',
            style: GoogleFonts.roboto(
                color: appstate.aux2,
                fontWeight: FontWeight.w900,
                fontSize: 15),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (choice) {},
              itemBuilder: (BuildContext context) {
                return choices.map((choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: Container(),
                backgroundColor: appstate.aux1,
                expandedHeight: 260.0,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: //
                        Container(
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: appstate.aux2,
                            child: Center(
                              child: Icon(
                                Icons.person,
                                color: appstate.aux1,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        basicInfo.fname,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.asap(
                            color: appstate.aux2,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${personalInfo.state}, ${personalInfo.country}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.asap(
                            color: appstate.aux2,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            displayItems(
                              title: '14',
                              subtitle: 'Orders',
                            ),
                            Container(
                              height: 35,
                              width: 1,
                              color: appstate.aux8,
                            ),
                            displayItems(
                              title: '7000',
                              subtitle: 'Food Credit',
                            ),
                            Container(
                              height: 35,
                              width: 1,
                              color: appstate.aux8,
                            ),
                            displayItems(
                              title: '3000',
                              subtitle: 'Credit Used',
                            ),
                          ],
                        ),
                      ),
                      RoundedProgressBar(
                        height: 9,
                        style: RoundedProgressBarStyle(
                            borderWidth: 0,
                            widthShadow: 0,
                            colorProgress: appstate.aux22,
                            backgroundProgress: appstate.aux3),
                        margin: EdgeInsets.only(
                            top: 8, left: 8, right: 8, bottom: 2),
                        borderRadius: BorderRadius.circular(24),
                        percent: percent,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(right: 6, top: 2, bottom: 8),
                        child: Text(
                          'Credit Bar',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.asap(
                              color: appstate.aux2,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        width: double.infinity,
                        height: 35,
                        child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                            ),
                            color: appstate.aux2,
                            elevation: 3.0,
                            child: Text(
                              'PAY BACK',
                              style: GoogleFonts.asap(
                                  color: appstate.aux1,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            ),
                            onPressed: () {}),
                      )
                    ],
                  ),
                )),
              ),
              SliverPersistentHeader(
                delegate: _SliverTextDelegate(
                  Text(
                    'ORDER HISTORY',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.asap(
                        color: appstate.aux2,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: ListView(
            children: <Widget>[
              for (final item in appstate.foodlist) FoodLayout(item)
            ],
          ),
        ));
  }
}

class _SliverTextDelegate extends SliverPersistentHeaderDelegate {
  _SliverTextDelegate(this._text);

  final Text _text;

  @override
  double get minExtent => 42;

  @override
  double get maxExtent => 42;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var appstate = Provider.of<MyService>(context, listen: true);
    return new Container(
      color: appstate.aux1,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15.0),
      child: _text,
    );
  }

  @override
  bool shouldRebuild(_SliverTextDelegate oldDelegate) {
    return false;
  }
}

class displayItems extends StatelessWidget {
  final title;
  final subtitle;

  const displayItems({Key key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<MyService>(context, listen: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.asap(
              color: appstate.aux2, fontWeight: FontWeight.w400, fontSize: 19),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.asap(
              color: appstate.aux4, fontWeight: FontWeight.w400, fontSize: 13),
        ),
      ],
    );
  }
}
