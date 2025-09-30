// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/wallet.dart';
import 'package:kohira/controller/API/menu/others/count.dart';
import 'package:kohira/controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/buynow.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart';
import 'package:kohira/view/screen/menu/myCart/checkout.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/user_inerface/menu/myCart/myCart.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/containershadow.dart';
import '../../../utils/widget/horizontalpading.dart';
import '../home/menuwidget/drawer.dart';

class Buynow extends StatefulWidget {
  Buynow({super.key});
  @override
  State<Buynow> createState() => _BuynowState();
}
class _BuynowState extends State<Buynow> {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());
  final buynowUI = Get.put(BuynowController());
  final count = Get.put(CountController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final Bottamnavigation bottomSelectController = Get.find<Bottamnavigation>();
        Bottom();
        bottomSelectController.indexOne();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          prefixicon: AppIcon.menu,
          prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
          hedingname_2: AppString.myCart,
          // suffixicon_1: AppIcon.like,
          // suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        // bottomNavigationBar: SafeArea(
        //     child: Obx((){
        //        final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
        //        return Container(
        //          height: Get.height * 0.070,
        //          color: AppColor.white_color,
        //          child: horizontalpadding(
        //            child: Row(
        //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //              children: [
        //                  Container(
        //                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.065, vertical: Get.height * 0.015),
        //                    decoration: BoxDecoration(
        //                      border: Border.all(color: AppColor.grey_color),
        //                      borderRadius: BorderRadius.circular(Get.width / 50),
        //                      color: AppColor.white_color,
        //                    ),
        //                    child: Text(indianFormat.format((buynowUI.useWallet.value)), style: TextStyle(color: AppColor.grey_color,fontWeight: FontWeight.w600)),
        //                  ),
        //                GestureDetector(
        //                  onTap: () => Get.to(() => Checkout()),
        //                  child: Container(
        //                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.14, vertical: Get.height * 0.015),
        //                    decoration: BoxDecoration(
        //                      borderRadius: BorderRadius.circular(Get.width / 50),
        //                      color: AppColor.black_color,
        //                    ),
        //                    child: Text(AppString.Checkout, style: TextStyle(color: AppColor.white_color)),
        //                  ),
        //                ),
        //              ],
        //            ),
        //          ),
        //        );
        //      })
        // ),
        body: SafeArea(
          child: Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(color: AppColor.white_color),
            child: Obx(() {
              final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

              // Initialize item counts when data is loaded
              // if (myCart.fetchcart.data.isNotEmpty && myCart.fetchcart.data['carts'] != null && myCart.itemCounts.length != myCart.fetchcart.data['carts'].length) {
              //   myCart.initializeItemCounts();
              // }
              final fetch = myCart.fetchcart.data['carts'] ?? [];

              if (fetch.isEmpty) return Center(child: Lottie.asset(AppJson.noData));

              var remaining = wallet.data['myWalletAmount'] - myCart.subTotal.value;
              var totalprice  = myCart.subTotal.value + myCart.fetchcart.data['global_tax']['globaltaxcharge'];
              int myWalletAmount = int.tryParse(wallet.data['myWalletAmount'].toString()) ?? 0;

              return SingleChildScrollView(
                child: horizontalpadding(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 80),

                      //Items
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: fetch.length,
                        itemBuilder: (context, index) {
                          final item = fetch[index];
                          final fetchdata = item['CartJewelryData'];
                          final fetchimage = (fetchdata['allImages'].isNotEmpty) ? fetchdata['allImages'][0] : null;
                          if (index >= myCart.itemCounts.length) return Container();
                          return Container(
                            child: Row(
                              children: [
                                if (fetchimage != null)
                                  GestureDetector(
                                    onTap: () => Get.to(() => Showproduct(
                                      slug: fetchdata['slug'],
                                      categoryslug: fetchdata['category']['slug'],
                                     ),
                                    ),
                                    child: Image(
                                      image: NetworkImage(fetchimage['thumb']),
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      errorBuilder: (context, error, stackTrace) =>Icon(Icons.error),
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
                                        subtitle: Text(
                                          indianFormat.format((fetchdata['discount'] > 0) ? fetchdata['offer_price'] : fetchdata['setting_price']),
                                          style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w600),
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
                                            GetX<MyCartValueChange>(builder: (controller) => Text(controller.itemCounts[index].toString())),
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
                                    child: Icon(Icons.delete_outline_outlined, color: AppColor.pink_color, size: 20),
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

                      SizedBox(height: Get.height / 50),

                      //Use Wallet Amount
                      (myWalletAmount == 0) ? SizedBox() : Column(
                        children: [
                          containershadow(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: buynowUI.ischeack.value,
                                        overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                                        side: BorderSide(color: AppColor.grey_color, width: 1),
                                        checkColor: AppColor.white_color,
                                        activeColor: AppColor.pink_color,
                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (bool? value) {
                                          buynowUI.ischack();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    SizedBox(width: Get.width / 50),
                                    Text(AppString.usewallet),
                                  ],
                                ),
                                Text(indianFormat.format(wallet.data['myWalletAmount']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                              ],
                            ),
                          ),
                          SizedBox(height: Get.height / 100),
                        ],
                      ),

                      //Coupan code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsetsGeometry.only(top: 14),
                                hintText: 'Coupon Code',
                                helperStyle: TextStyle(fontSize: Get.width / 30),
                                prefixIcon: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                                  child: SvgPicture.asset(AppIcon.cart, height: 10, width: 10),
                                ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColor.textfild_color)),
                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColor.textfild_color)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColor.textfild_color)),
                              ),
                            ),
                          ),
                          SizedBox(width: Get.width / 20),
                          button(AppString.Apply),
                        ],
                      ),
                      SizedBox(height: Get.height / 50),


                      //Price Details
                      containershadow(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(AppString.pricedetails, style: TextStyle(fontSize: Get.width / 25, fontWeight: FontWeight.w600)),
                              SizedBox(width: Get.width / 80),
                              Text('(${myCart.fetchcart.data['count']} ${AppString.items})', style: TextStyle(fontSize: Get.width / 25, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.subtotalprice),
                              Text(indianFormat.format((myCart.subTotal.value)), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                            ],
                          ),
                          Divider(color: AppColor.textfild_color),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.discountprice),
                              Text(indianFormat.format((myCart.discount.value)), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                            ],
                          ),
                          Divider(color: AppColor.textfild_color),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.shippingcharges),
                              Text('FREE', style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                            ],
                          ),
                          Divider(color: AppColor.textfild_color),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.tax),
                              Text(indianFormat.format(myCart.fetchcart.data['global_tax']['globaltaxcharge']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                            ],
                          ),
                          Divider(color: AppColor.textfild_color),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.totalprice),
                              Text(indianFormat.format(totalprice), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                            ],
                          ),
                          (buynowUI.ischeack.value) ?  Divider(color: AppColor.textfild_color) : SizedBox(),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(AppString.totalwallet),
                          //     Text(indianFormat.format(wallet.data['myWalletAmount']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                          //   ],
                          // ),
                          // Divider(color: AppColor.textfild_color),
                          (buynowUI.ischeack.value) ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.deduct),
                                  Text(indianFormat.format(myCart.subTotal.value), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                                ],
                              ),
                              Divider(color: AppColor.textfild_color),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.remaining),
                                  Text(indianFormat.format(remaining), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                                ],
                              ),
                              // Divider(color: AppColor.textfild_color),
                            ],
                          ) : SizedBox(),

                        ],
                      )),

                      SizedBox(height: Get.height / 50),

                      //Infromation
                      containershadow(
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width / 2.5,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppIcon.puzzle, color: AppColor.grey_color, width: 30),
                                        SizedBox(width: Get.width / 80),
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Ethical Sourcing',
                                          style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(color: AppColor.textfild_color, thickness: 1, width: 20),
                                  SizedBox(
                                    width: Get.width / 2.5,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppIcon.warranty, color: AppColor.grey_color, width: 30),
                                        SizedBox(width: Get.width / 80),
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Lifetime Warranty',
                                          style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Get.height / 150),
                            Row(
                              children: [
                                Expanded(child: Divider(color: AppColor.textfild_color, height: 1, thickness: 1)),
                                SizedBox(width: Get.width / 20),
                                Expanded(child: Divider(color: AppColor.textfild_color, height: 1, thickness: 1)),
                              ],
                            ),
                            SizedBox(height: Get.height / 150),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width / 2.5,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppIcon.social, color: AppColor.grey_color, width: 30),
                                        SizedBox(width: Get.width / 80),
                                        Text(
                                          textAlign: TextAlign.start,
                                          'IGI Certified\nDiamonds',
                                          style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(color: AppColor.textfild_color, thickness: 1, width: 20),
                                  SizedBox(
                                    width: Get.width / 2.5,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppIcon.diamond, color: AppColor.grey_color, width: 30),
                                        SizedBox(width: Get.width / 80),
                                        Text(
                                          textAlign: TextAlign.center,
                                          'BIS Hallmark',
                                          style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: Get.height / 50),

                      Container(
                        height: Get.height * 0.070,
                        color: AppColor.white_color,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.065, vertical: Get.height * 0.015),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.grey_color),
                                borderRadius: BorderRadius.circular(Get.width / 50),
                                color: AppColor.white_color,
                              ),
                              child: Text(indianFormat.format((buynowUI.useWallet.value)), style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w600)),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => Checkout()),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.14, vertical: Get.height * 0.015),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                  color: AppColor.black_color,
                                ),
                                child: Text(AppString.Checkout, style: TextStyle(color: AppColor.white_color)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
