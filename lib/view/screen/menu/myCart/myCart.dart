// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, must_be_immutable

// if (myCart.fetchcart.isLoading.value) {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     if (Get.isDialogOpen != true) {
//       Get.dialog(
//         Center(child: Lottie.asset(AppJson.loading2)),
//         barrierDismissible: false,
//       );
//     }
//   });
//   return Scaffold(backgroundColor: Colors.transparent);
// } else {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     if (Get.isDialogOpen == true) {
//       Get.back();
//     }
//   }); //Wdeget
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/API/menu/others/count.dart';
import '../category/showproduct.dart';

class Mycart extends StatelessWidget {
  final myCart = Get.put(MyCartValueChange());
  final count = Get.put(CountController());
  final bottamSelect = Get.put(Bottamnavigation());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool show = false;
  Mycart({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        // final Bottamnavigation bottomSelectController = Get.find<Bottamnavigation>();
        // Bottom();
        // bottomSelectController.indexOne();
        Get.back();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          // prefixicon: AppIcon.menu,
          // prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
          lefticon: AppIcon.left,
          hedingname_2: AppString.myCart,
        ),
        drawer: Drawers(),
        body: SafeArea(
          child: Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(color: AppColor.white_color),
            child: Obx(() {
              // if (myCart.fetchcart.isLoading.value) {
              //   return horizontalpadding(
              //     child: Shimmer.fromColors(
              //       baseColor: AppColor.lodingcolor,
              //       highlightColor: AppColor.highlightColor,
              //       child: Column(
              //         children: [
              //           SizedBox(height: Get.height / 50),
              //           Expanded(
              //             flex: 2,
              //             child: ListView.builder(
              //               itemBuilder: (BuildContext context, int index) {
              //                 return Row(
              //                   children: [
              //                     Container(
              //                       padding: EdgeInsets.all(5),
              //                       margin: EdgeInsets.symmetric(vertical: Get.height / 200),
              //                       decoration: BoxDecoration(
              //                         border: Border.all(color: AppColor.Appbercolor),
              //                         borderRadius: BorderRadius.circular(Get.width / 80),
              //                       ),
              //                       child: Container(
              //                         padding: EdgeInsets.all(50),
              //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                       ),
              //                     ),
              //                     SizedBox(width: Get.width / 30),
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Container(
              //                           padding: EdgeInsets.symmetric(horizontal: 90,vertical: 5),
              //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                         ),
              //                         SizedBox(height: Get.height / 150),
              //                         Container(
              //                           padding: EdgeInsets.symmetric(horizontal: 70,vertical: 5),
              //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                         ),
              //                         SizedBox(height: Get.height / 150),
              //                         Container(
              //                           padding: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                         ),
              //                         SizedBox(height: Get.height / 150),
              //                         Container(
              //                           padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
              //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                         ),
              //                         SizedBox(height: Get.height / 50),
              //                         SizedBox(
              //                           width: Get.width / 3.5,
              //                           child: Row(
              //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                             children: [
              //                               Container(
              //                                 padding: EdgeInsets.symmetric(horizontal: 13,vertical: 13),
              //                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                               ),
              //                               Container(
              //                                 padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              //                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                               ),
              //                               Container(
              //                                 padding: EdgeInsets.symmetric(horizontal: 13,vertical: 13),
              //                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 );
              //               },
              //             ),
              //           ),
              //           SizedBox(height: Get.height / 50),
              //           Expanded(
              //             flex: 1,
              //             child: ListView.builder(
              //               itemBuilder: (BuildContext context, int index) {
              //                 return Column(
              //                   children: [
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Container(
              //                           padding: EdgeInsets.symmetric(horizontal: 35,vertical: 7),
              //                           margin: EdgeInsets.symmetric(vertical: Get.height / 200),
              //                           decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(Get.width / 80)),
              //                         ),
              //                         Container(
              //                           padding: EdgeInsets.symmetric(horizontal: 115, vertical: 7),
              //                           margin: EdgeInsets.symmetric(vertical: Get.height / 200),
              //                           decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(Get.width / 80)),
              //                         ),
              //                       ],
              //                     )
              //                   ],
              //                 );
              //               },
              //             ),
              //           ),
              //           SizedBox(height: Get.height / 50),
              //           Container(
              //             padding: EdgeInsets.all(25),
              //             width: Get.width,
              //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 80), color: AppColor.white_color),
              //           ),
              //           SizedBox(height: Get.height / 50),
              //         ],
              //       ),
              //     ),
              //   );
              // }

              final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

              // Initialize item counts when data is loaded
              // if (myCart.fetchcart.data.isNotEmpty && myCart.fetchcart.data['carts'] != null && myCart.itemCounts.length != myCart.fetchcart.data['carts'].length) {
              //   myCart.initializeItemCounts();
              // }
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
                            color: AppColor.white_color,
                            child: Row(
                              children: [
                                if (fetchimage != null)
                                  GestureDetector(
                                    onTap: () => Get.to(() => Showproduct(
                                      slug: fetchdata['slug'],
                                      categoryslug: fetchdata['category']['slug'],
                                    )),
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
                                        title: Text(fetchdata['title'], style: TextStyle(fontSize: Get.width / 27)),
                                        subtitle: Text(
                                          indianFormat.format((fetchdata['discount'] > 0) ? fetchdata['offer_price'] : fetchdata['setting_price']),
                                          style: TextStyle(
                                            color: AppColor.pink_color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Get.height / 300),
                                      horizontalpadding(
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                myCart.decrementValueOfCount(index);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.textfild_color,
                                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                child: Text('-', style: TextStyle(fontSize: Get.width / 20)),
                                              ),
                                            ),
                                            SizedBox(width: Get.width / 20),
                                            Text(myCart.itemCounts[index].toString()),
                                            SizedBox(width: Get.width / 20),
                                            GestureDetector(
                                              onTap: () {
                                                myCart.incrementValueOfCount(index);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.textfild_color,
                                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                child: Text('+', style: TextStyle(fontSize: Get.width / 20)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.white_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                    padding: EdgeInsets.only(left: 22, top: 38, bottom: 38),
                                    child: Icon(Icons.delete_outline_outlined, color: AppColor.pink_color,size: 20),
                                  ),
                                  onTap: () {
                                    myCart.deletValueofcount(item, fetch, index);
                                    count.counting();
                                  },
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
                              Text(
                                indianFormat.format((myCart.total.value)),
                                style: TextStyle(
                                  color: AppColor.pink_color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height / 50),

                    //Buuton
                    Expanded(
                      flex: -1,
                      child: GestureDetector(
                        onTap: () {
                            Bottom();
                            bottamSelect.indexThree();
                            Get.back();
                            },
                        child: button(AppString.proceedcheckout),
                      ),
                    ),
                    SizedBox(height: Get.height / 80),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
