import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/vendor_model.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class AutoCompleteSearch extends StatefulWidget {
  @override
  _AutoCompleteSearchState createState() => _AutoCompleteSearchState();
}

class _AutoCompleteSearchState extends State<AutoCompleteSearch> {
  RxServices get service => GetIt.I<RxServices>();
  List<Vendor> vendors=[];
  GlobalKey key =
  new GlobalKey<AutoCompleteTextFieldState<Vendor>>();

  @override
  void initState() {
    getVendors();
    super.initState();
  }

  getVendors() async{
    service.vendorStream.first.then((value){

      setState(() {
        for(final item in value) {
          vendors.add(item);
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    var _vendorController = new TextEditingController(text: '');
    Widget _vendorSuggestion(vendor){
      double iconsize = 30;
      return Container(
        height: 70,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: vendor.persVInfo.logoUrl,
                  imageBuilder: (context, imageProvider) => SizedBox(
                    height: iconsize,
                    width: iconsize,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          6),
                      child: Image(
                        image: imageProvider,
                        width: iconsize,
                        height: iconsize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Image.asset(
                    'assets/logo1.jpeg',
                    height: iconsize,
                    width: iconsize,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/logo1.jpeg',
                    height: iconsize,
                    width: iconsize,
                  ),
                ),
                title: Text(
                  vendor.persVInfo.cname,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      color: aux6,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                trailing:   SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {},
                    starCount: 5,
                    rating: vendor.delVInfo.rating.toDouble(),
                    size: 12.0,
                    isReadOnly: true,
                    color: aux2,
                    borderColor: aux2,
                    spacing: 0.0),
              ),
            ),
            Divider()
          ],
        ),
      );
    }
    return  Container(
      height: 65,
      padding: EdgeInsets.symmetric(vertical: 7),
      child: AutoCompleteTextField<Vendor>(
        key: key,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w400,
          color: aux6,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            fillColor: aux41,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: aux5, width: 0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: aux5, width: 0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            hintText: 'Find a restaurant',
            prefixIcon: IconButton(
              iconSize: 13,
              icon: Image.asset(
                'assets/search.png',
                height: 16,
                width: 16,
                color: aux6,
              ),
            ),
            hintStyle: TextStyle(
              height: 1.3,
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: aux42,
            )),

        clearOnSubmit: false,
        suggestions: vendors,
        itemFilter: (item, query) {
          return item.persVInfo.cname.toLowerCase().startsWith(query.toLowerCase());
        },
        itemSorter: (a, b) {
          return a.persVInfo.cname.compareTo(b.persVInfo.cname);
        },
        itemSubmitted: (item) {
          _vendorController.text = item.persVInfo.cname;
        },
        itemBuilder: (context, item) {
          // ui for the autocomplete row
        return _vendorSuggestion(item);
        },
      ),
    );
  }
}

//class _vendorSuggestions extends StatelessWidget {
//  final Vendor vendor;
//
//  const _vendorSuggestions({Key key, this.vendor}) : super(key: key);
//  @override
//  Widget build(BuildContext context) {
//    double iconsize = 50;
//    return Padding(
//      padding: const EdgeInsets.all(5.0),
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Expanded(
//            child: ListTile(
//              leading: CachedNetworkImage(
//                imageUrl: vendor.persVInfo.logoUrl,
//                imageBuilder: (context, imageProvider) => SizedBox(
//                  height: iconsize,
//                  width: iconsize,
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.circular(
//                        6),
//                    child: Image(
//                      image: imageProvider,
//                      width: iconsize,
//                      height: iconsize,
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
//                placeholder: (context, url) => Image.asset(
//                  'assets/logo1.jpeg',
//                  height: iconsize,
//                  width: iconsize,
//                ),
//                errorWidget: (context, url, error) => Image.asset(
//                  'assets/logo1.jpeg',
//                  height: iconsize,
//                  width: iconsize,
//                ),
//              ),
//              title: Text(
//              vendor.persVInfo.cname,
//              maxLines: 2,
//              overflow: TextOverflow.ellipsis,
//              style: GoogleFonts.roboto(
//              color: aux6,
//              fontWeight: FontWeight.w400,
//              fontSize: 14),
//              ),
//              trailing:   SmoothStarRating(
//                  allowHalfRating: false,
//                  onRated: (v) {},
//                  starCount: 5,
//                  rating: vendor.delVInfo.rating.toDouble(),
//                  size: 12.0,
//                  isReadOnly: true,
//                  color: aux2,
//                  borderColor: aux2,
//                  spacing: 0.0),
//            ),
//          ),
//          Divider()
//        ],
//      ),
//    );
//  }
//}

