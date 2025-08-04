// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/user_inerface/menu/myCart/myCart.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../category/showproduct.dart';

class Mycart extends StatelessWidget {
  final myCart = Get.put(MyCartValueChange());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool show = false;
  Mycart({super.key});
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
          height: Get.height, width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if (myCart.fetchcart.isLoading.value) {
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
              final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

              // Initialize item counts when data is loaded
              if (myCart.fetchcart.data.isNotEmpty && myCart.fetchcart.data['carts'] != null && myCart.itemCounts.length != myCart.fetchcart.data['carts'].length) {
                myCart.initializeItemCounts();
              }
              final fetch = myCart.fetchcart.data['carts'] ?? [];
              if (fetch.isEmpty) return Center(child: Lottie.asset(AppJson.noData));

              return horizontalpadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 50),
                    Text(AppString.shoppingcart, style: TextStyle(color: AppColor.pink_color, fontSize: Get.width / 18, fontWeight: FontWeight.w500, fontFamily: 'Lora')),
                    SizedBox(height: Get.height / 50),

                    // Add Cart List
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: fetch.length,
                        itemBuilder: (context, index) {
                          final item = fetch[index];
                          final fetchdata = item['CartJewelryData'];
                          final fetchimage = (fetchdata['allImages'].isNotEmpty) ? fetchdata['allImages'][0] : null;
                          if (index >= myCart.itemCounts.length) return Container();
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: Get.height / 120),
                            child: Row(
                              children: [
                                if (fetchimage != null)
                                  GestureDetector(
                                    onTap: () => Get.to(() =>Showproduct(slug: fetchdata['slug'])),
                                    child: Image(
                                      image: NetworkImage(fetchimage['thumb']),
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          fetchdata['title'],
                                          style: TextStyle(fontSize: Get.width / 27),
                                        ),
                                        subtitle: Text(indianFormat.format(fetchdata['offerprice']),
                                          style: TextStyle(
                                            color: AppColor.pink_color,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                                                  onTap: () {
                                                     myCart.decrementValueOfCount(index).then((_){
                                                       Future.delayed(Duration(seconds: 2), () {
                                                         myCart.onInit();
                                                       });
                                                     });
                                                    },
                                                  child: Text('-', style: TextStyle(fontSize: Get.width / 20)),
                                                ),
                                                SizedBox(width: Get.width / 50),
                                                Text(myCart.itemCounts[index].toString()),
                                                SizedBox(width: Get.width / 50),
                                                GestureDetector(
                                                  onTap: () {
                                                      myCart.incrementValueOfCount(index).then((_) {
                                                        Future.delayed(Duration(seconds: 2), () {
                                                          myCart.onInit();
                                                        });
                                                      });
                                                    },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColor.textfild_color,
                                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                                    child: Text('+', style: TextStyle(fontSize: Get.width / 20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              child: SvgPicture.asset(AppIcon.close, width: 10, height: 10),
                                              onTap: () {
                                                   myCart.deletValueofcount(item, fetch, index).then((_){
                                                     Future.delayed(Duration(seconds: 2), () {
                                                      myCart.onInit();
                                                    });
                                                  });
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

                    // Details Cart List
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
                              Text(indianFormat.format((myCart.subTotal.value))),
                            ],
                          ),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.discount),
                              Text(indianFormat.format(myCart.discount.value)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.total),
                              Text(indianFormat.format((myCart.total.value)),style: TextStyle(fontWeight: FontWeight.w600),),
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