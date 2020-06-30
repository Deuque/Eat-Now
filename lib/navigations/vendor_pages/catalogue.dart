import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_now/models/ApiResponse.dart';
import 'package:eat_now/models/food_item.dart';
import 'package:eat_now/navigations/vendor_pages/add_item_forms.dart';
import 'package:eat_now/services/Crud.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class Catalogue extends StatefulWidget {
  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  RxServices get service => GetIt.I<RxServices>();
  TextEditingController ncontrol = new TextEditingController();
  TextEditingController dcontrol = new TextEditingController();
  TextEditingController pcontrol = new TextEditingController();
  FoodItem selItem;
  var image, name, desc, price;
  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var pr = getDialog(context);
    checkFields() {
      final form = formkey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    getImage() async {
      File file = await FilePicker.getFile(type: FileType.image);

      setState(() {
        image = file;
      });
    }

    setSelItem(FoodItem item) {
      setState(() {
        selItem = item;
      });

      ncontrol.text = item.name;
      dcontrol.text = item.desc;
      pcontrol.text = item.price;
    }

    resolveFoodItem() async {
      if (!checkFields()) {
        return;
      }

      if (selItem == null && image == null) {
        Fluttertoast.showToast(msg: 'Select an image');
        return;
      }

      var key = DateTime.now().millisecondsSinceEpoch;
      pr.show();
      if (image != null) {
        ApiResponse image_response = await CrudOperations.uploadImage(
            file: image, path: 'FoodImages', key: '$key');
        if (image_response.error) {
          pr.hide();
          Fluttertoast.showToast(
              msg: 'Image Upload Error: ' + image_response.errorMessage,
              toastLength: Toast.LENGTH_LONG);
          return;
        }

        FoodItem item = new FoodItem(
            vendor: service.firebaseUser.uid,
            name: name,
            desc: desc,
            price: price,
            imgUrl: image_response.data,
            id: '$key');
        ApiResponse data_response = await CrudOperations.uploadFoodItem(item);
        pr.hide();
        if (data_response.error) {
          Fluttertoast.showToast(
              msg: 'Data Upload Error: ' + data_response.errorMessage,
              toastLength: Toast.LENGTH_LONG);
          return;
        }

        Fluttertoast.showToast(msg: 'Item added successfully');
        Navigator.pop(context);
        setState(() {
          image = null;
          selItem = null;
          name = '';
          price = '';
          desc = '';
        });
      } else {
        FoodItem item = new FoodItem(
            vendor: service.firebaseUser.uid,
            name: name,
            desc: desc,
            price: price,
            imgUrl: selItem.imgUrl,
            id: selItem.id);
        ApiResponse data_response = await CrudOperations.uploadFoodItem(item);
        pr.hide();
        if (data_response.error) {
          Fluttertoast.showToast(
              msg: 'Data Upload Error: ' + data_response.errorMessage,
              toastLength: Toast.LENGTH_LONG);
          return;
        }

        Fluttertoast.showToast(msg: 'Item added successfully');
        Navigator.pop(context);
        setState(() {
          image = null;
          selItem = null;
          name = '';
          price = '';
          desc = '';
        });
      }
    }

    void _bottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: aux41,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
        ),
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left:20,right:20,top: 15, bottom:MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 18,
                    ),
                    AddItemImage(
                      label: selItem == null && image == null
                          ? ''
                          : 'Image Selected',
                      resolveFile: getImage,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Food Name',
                      style: GoogleFonts.roboto(
                          color: aux2, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    AddItemForms(
                      controller: ncontrol,
                      resolvetext: (value) {
                        name = value;
                      },
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Food Description',
                      style: GoogleFonts.roboto(
                          color: aux2, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    AddItemForms(
                      controller: dcontrol,
                      isdesc: true,
                      resolvetext: (value) {
                        desc = value;
                      },
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Price',
                      style: GoogleFonts.roboto(
                          color: aux2, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    AddItemForms(
                      isNum: true,
                      controller: pcontrol,
                      resolvetext: (value) {
                        price = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: aux2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 24),
                        child: Text(
                          selItem == null ? 'Add Post' : 'Edit Post',
                          style: GoogleFonts.roboto(
                              color: aux1,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                      onPressed: resolveFoodItem,
                    ),
                    SizedBox(
                      height: 13,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ).then((value) {
        setState(() {
          selItem = null;
          image = null;
          ncontrol.clear();
          dcontrol.clear();
          pcontrol.clear();
        });
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: aux1,
        appBar: AppBar(
          backgroundColor: aux1,
          iconTheme: IconThemeData(color: aux2),
          elevation: 1,
          centerTitle: true,
          title: Text(
            'Catalogue',
            style: GoogleFonts.roboto(
                color: aux6, fontWeight: FontWeight.w700, fontSize: 18.7),
          ),
        ),
        body: StreamBuilder<List<FoodItem>>(
            stream: service.foodStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                List myItems = snapshot.data;
                myItems.removeWhere(
                    (element) => element.vendor != service.firebaseUser.uid);
                myItems.sort((a,b)=>b.id.compareTo(a.id));
                return SingleChildScrollView(
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    childAspectRatio: 0.72,
                    padding: EdgeInsets.all(10),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 18,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (final item in myItems)
                        FoodItemLayout(
                          item: item,
                          editclick: () {
                            setSelItem(item);
                            _bottomSheet();
                          },
                          deleteclick: () {
                            CrudOperations.deleteFoodItem(item).then((value){
                              if (value.error) {
                                Fluttertoast.showToast(
                                    msg: 'Data Upload Error: ' + value.errorMessage,
                                    toastLength: Toast.LENGTH_LONG);
                                return;
                              }
                            });
                          },
                        )
                    ],
                  ),
                );
              }
              return Center(
                child: Image.asset('assets/nofood.png',
                    color: aux41, height: 65, width: 65),
              );
            }),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: aux1,
            ),
            backgroundColor: aux2,
            onPressed: _bottomSheet,
          ),
        ),
      ),
    );
  }
}

class FoodItemLayout extends StatelessWidget {
  final editclick, deleteclick;
  final FoodItem item;

  const FoodItemLayout({Key key, this.item, this.editclick, this.deleteclick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconsize = 112.7;
    return Container(
      decoration: BoxDecoration(
        color: aux1,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
              color: aux42.withOpacity(.5),
              offset: Offset(0.0, 3.5),
              blurRadius: 8.0)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item.imgUrl,
            imageBuilder: (context, imageProvider) => SizedBox(
              height: iconsize,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
                child: Image(
                  image: imageProvider,
                  width: double.maxFinite,
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 7, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        color: aux6, fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),

//                IconButton(iconSize: 15,icon: Image.asset('assets/cart.png',height: 15,width: 15,color: aux2,),color: aux1,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.price,
              style: GoogleFonts.roboto(
                  color: aux6, fontWeight: FontWeight.w400, fontSize: 13),
            ),
          ),
          Spacer(),
          Container(
            width: double.maxFinite,
            height: 47,
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: editclick,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: aux4, width: 0.9),
                        borderRadius: BorderRadius.circular(3)),
                    color: aux1,
                    child: Text(
                      'Edit',
                      style: GoogleFonts.roboto(
                          color: aux4,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: deleteclick,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: aux4, width: 0.9),
                        borderRadius: BorderRadius.circular(3)),
                    color: aux4,
                    child: Text(
                      'Delete',
                      style: GoogleFonts.roboto(
                          color: aux1,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
