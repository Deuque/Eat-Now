import 'package:carousel_slider/carousel_slider.dart';
import 'package:eat_now/initial_pages/validation_type.dart';
import 'package:eat_now/models/caroussels.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyState();
  }
}

class MyState extends State<Onboarding> {
  int _current = 0;
  List items = sampleCaroussels;
  var next_text = 'NEXT';
  CarouselController buttonCarouselController = CarouselController();
  Widget changing_text = NewWidget(0);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
            body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 300,
          padding: EdgeInsets.only(top: 5.0),
          child: CarouselSlider.builder(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
                height: 300.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                    changing_text = NewWidget(index);
                  });
                }),
            itemCount: items.length,
            itemBuilder: (BuildContext context, i) => Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  items[i].path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          switchInCurve: Curves.fastOutSlowIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              child: child,
              scale: animation,
            );
          },
          child: changing_text,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ValType())),
                child: Text(
                  'SKIP',
                  style: GoogleFonts.asap(
                      color: aux2,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items.map((url) {
                  int index = items.indexOf(url);
                  return Container(
                    width: _current == index ? 21.0 : 17.0,
                    height: 3.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: _current == index ? aux2 : aux3,
                    ),
                  );
                }).toList(),
              ),
              FlatButton(
                onPressed: () => buttonCarouselController.nextPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.linear),
                child: Text(
                  next_text,
                  style: GoogleFonts.asap(
                      color: aux2,
                      fontWeight: FontWeight.w300,
                      fontSize: 14),
                ),
              ),
            ],
          ),
        )
      ],
    )));
  }
}

class NewWidget extends StatefulWidget {
  var index;

  NewWidget(this.index) : super(key: ValueKey(index));

  @override
  State<StatefulWidget> createState() {
    return MyState2();
  }
}

class MyState2 extends State<NewWidget> {
  List items = sampleCaroussels;

  @override
  Widget build(BuildContext context) {
    var index = widget.index;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              items[index].title,
              style: GoogleFonts.dancingScript(
                  color: aux2,
                  fontWeight: FontWeight.w700,
                  fontSize: 38),
            ),
          ),
          Text(
            items[index].body,
            textAlign: TextAlign.center,
            style: GoogleFonts.asap(
                color: aux2,
                fontWeight: FontWeight.w200,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
