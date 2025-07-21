// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/myCart/fetchcart.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/API/menu/myCart/countcart.dart';
import '../../../../controller/API/menu/myCart/deletcart.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../menuwidget/drawer.dart';

class Mycart extends StatefulWidget {
  const Mycart({super.key});

  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final fetchcart = Get.put(FetchcartCalling());
  final countcart = Get.put(CountCart());
  final deletcount = Get.put(Deletcart());

  @override
  void initState() {
    super.initState();
    fetchcart.fetchcartcall();
  }

  final List<int> itemCounts = List.generate(11000, (index) => 1);

  Timer? _debounce;

  void incrementValueOfCount(int index) {
    setState(() {
      itemCounts[index]++;
    });
  }

  void decrementValueOfCount(int index) {
    if (itemCounts[index] > 1) {
      itemCounts[index] -= 1;
      final updatedCount = itemCounts[index];
      final cartId = fetchcart.data['carts'][index]['id'];
      countcart.countcardcall(qty: updatedCount.toString(), jewelryid: cartId.toString());
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 800), () => fetchcart.fetchcartcall());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Appbar(
        prefixicon: AppIcon.menu,
        prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
        hedingname: AppString.myCart,
      ),
      drawer: Drawers(),
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if (fetchcart.isLoading.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen != true) {
                  Get.dialog(
                    Center(child: Lottie.asset(AppJson.loading2)),
                    barrierDismissible: false,
                  );
                }
              });
              return Scaffold(backgroundColor: Colors.transparent);
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen == true) {
                  Get.back();
                }
              });

              final fetch = fetchcart.data['carts'];

              if(fetchcart.data.isEmpty){
                return Center(child: Lottie.asset(AppJson.noData));
              }

              return horizontalpadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 50),
                    Text(AppString.shoppingcart, style: TextStyle(color: AppColor.pink_color, fontSize: Get.width / 18, fontWeight: FontWeight.w500, fontFamily: 'Lora')),
                    SizedBox(height: Get.height / 50),

                    //Add Cart List
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: fetch.length,
                        itemBuilder: (context, index) {
                          final item = fetch[index];
                          final fetchdata = item['CartJewelryData'];
                          final fetchimage = (fetchdata['allImages'].isNotEmpty) ? fetchdata['allImages'][0] : null;
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: Get.height / 120),
                            child: Row(
                              children: [
                                Image(image: NetworkImage(fetchimage['thumb']), fit: BoxFit.cover, width: 100, height: 100),
                                Expanded(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(fetchdata['title'],style: TextStyle(fontSize: Get.width / 27)),
                                        subtitle: Text(
                                          '₹${fetchdata['offerprice'].toString()}.00',
                                          style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(height: Get.height / 300),
                                      horizontalpadding(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => decrementValueOfCount(index),
                                                  child: Text('-',style: TextStyle(fontSize: Get.width / 20)),
                                                ),
                                                SizedBox(width: Get.width / 50),
                                                Text(itemCounts[index].toString()),
                                                SizedBox(width: Get.width / 50),
                                                GestureDetector(
                                                  onTap: () => incrementValueOfCount(index),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColor.textfild_color,
                                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 1),
                                                    child: Text('+',style: TextStyle(fontSize: Get.width / 20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              child: SvgPicture.asset(AppIcon.close,width: 10,height: 10),
                                              onTap: () async{
                                                final deletid = fetchcart.data['carts'][index]['id'].toString();
                                                final diamondid = fetchcart.data['carts'][index]['diamondid'].toString();
                                                final jewelryid = fetchcart.data['carts'][index]['jewelryid'].toString();
                                                await deletcount.deletcartcall(id: deletid, jewelryid: jewelryid, diamondid: diamondid);
                                                setState(() {
                                                  fetchcart.data['carts'].removeAt(index);
                                                });
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    //Details Cart List
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppString.CartTotal, style: TextStyle(fontSize: Get.width / 18, fontWeight: FontWeight.w500, color: AppColor.grey_color, fontFamily: 'Lora')),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.subTotal),
                              Text('₹${fetchcart.data['old_gross_total'].toString()}.00'),
                            ],
                          ),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.discount),
                              Text('₹${fetchcart.data['discount_price'].toString()}.00'),
                            ],
                          ),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.shipping),
                              Text("Free"),
                            ],
                          ),
                          SizedBox(height: Get.height / 50),
                          Row(
                            children: [
                              Text(AppString.total),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
