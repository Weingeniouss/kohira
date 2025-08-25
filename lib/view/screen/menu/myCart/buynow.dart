// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/wallet.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart';
import 'package:kohira/view/screen/menu/myCart/checkout.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/user_inerface/menu/myCart/myCart.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/horizontalpading.dart';

class Buynow extends StatefulWidget {
  const Buynow({super.key});

  @override
  State<Buynow> createState() => _BuynowState();
}

class _BuynowState extends State<Buynow> {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());
  bool ischeack = false;

  void ischack(){
    setState(() {
      ischeack =! ischeack;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        myCart.fetchcart.fetchcartcall();
        return true;
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          onTaplefticon: () {
            myCart.fetchcart.fetchcartcall();
            Get.back();
          },
          hedingname: AppString.buynow,
        ),
        bottomNavigationBar: SafeArea(
            child:
             Obx((){
               final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

               return Container(
                 height: Get.height * 0.070,
                 color: AppColor.white_color,
                 child: horizontalpadding(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       GestureDetector(
                         onTap: () {},
                         child: Container(
                           padding: EdgeInsets.symmetric(horizontal: Get.width * 0.065, vertical: Get.height * 0.015),
                           decoration: BoxDecoration(
                             border: Border.all(color: AppColor.grey_color),
                             borderRadius: BorderRadius.circular(Get.width / 50),
                             color: AppColor.white_color,
                           ),
                           child: Text(indianFormat.format((myCart.subTotal.value)), style: TextStyle(color: AppColor.grey_color,fontWeight: FontWeight.w600)),
                         ),
                       ),
                       GestureDetector(
                         onTap: () => Get.to(() => Checkout()),
                         child: Container(
                           padding: EdgeInsets.symmetric(horizontal: Get.width * 0.14, vertical: Get.height * 0.015),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(Get.width / 50),
                             color: Colors.black,
                           ),
                           child: Text(AppString.Checkout, style: TextStyle(color: AppColor.white_color)),
                         ),
                       ),
                     ],
                   ),
                 ),
               );
             })
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

            // Initialize item counts when data is loaded
            if (myCart.fetchcart.data.isNotEmpty && myCart.fetchcart.data['carts'] != null && myCart.itemCounts.length != myCart.fetchcart.data['carts'].length) {
              myCart.initializeItemCounts();
            }
            final fetch = myCart.fetchcart.data['carts'] ?? [];
            if (fetch.isEmpty) return Center(child: Lottie.asset(AppJson.noData));

            return SingleChildScrollView(
              child: horizontalpadding(
                child: Column(
                  children: [
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
                          margin: EdgeInsets.symmetric(vertical: Get.height / 120),
                          child: Row(
                            children: [
                              if (fetchimage != null)
                                GestureDetector(
                                  onTap: () => Get.to(() => Showproduct(slug: fetchdata['slug'])),
                                  child: Image(image: NetworkImage(fetchimage['thumb']), fit: BoxFit.cover, width: 100, height: 100, errorBuilder: (context, error, stackTrace) => Icon(Icons.error)),
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
                                                  myCart.decrementValueOfCount(index).then((_) {
                                                    Future.delayed(Duration(seconds: 2), () {
                                                      myCart.onInit();
                                                    });
                                                  });
                                                },
                                                child: Text('-', style: TextStyle(fontSize: Get.width / 20)),
                                              ),
                                              SizedBox(width: Get.width / 20),
                                              Text(myCart.itemCounts[index].toString()),
                                              SizedBox(width: Get.width / 20),
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

                    //Infromation
                    Column(
                      children: [
                        SizedBox(height: Get.height / 50),
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcon.puzzle, color: AppColor.graycolor, width: 30),
                                SizedBox(width: Get.width / 80),
                                Text(
                                  textAlign: TextAlign.center,
                                  'Ethical Sourcing',
                                  style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                ),
                              ],
                            ),
                            SizedBox(width: Get.width / 20),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcon.warranty, color: AppColor.graycolor, width: 30),
                                SizedBox(width: Get.width / 80),
                                Text(
                                  textAlign: TextAlign.center,
                                  'Lifetime Warranty',
                                  style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcon.social, color: AppColor.graycolor, width: 30),
                                SizedBox(width: Get.width / 80),
                                Text(
                                  textAlign: TextAlign.center,
                                  'IGI Certified Diamonds',
                                  style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                ),
                              ],
                            ),
                            SizedBox(width: Get.width / 20),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcon.diamond, color: AppColor.graycolor, width: 30),
                                SizedBox(width: Get.width / 80),
                                Text(
                                  textAlign: TextAlign.center,
                                  'BIS Hallmark',
                                  style: TextStyle(fontSize: Get.width / 32, color: AppColor.grey_color),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: Get.height / 50),

                        //Price Details
                        Container(
                          padding: EdgeInsets.all(10),
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Get.width / 100),
                            boxShadow: kElevationToShadow[1],
                            color: AppColor.white_color,
                          ),
                          child: Column(
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
                                  Text(AppString.totalprice),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.tax),
                                  Text(indianFormat.format(myCart.fetchcart.data['global_tax']['globaltaxcharge']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                                ],
                              ),
                              Divider(color: AppColor.textfild_color),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.totalwallet),
                                  Text(indianFormat.format(wallet.data['myWalletAmount']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                                ],
                              ),
                              Divider(color: AppColor.textfild_color),
                            ],
                          ),
                        ),

                        SizedBox(height: Get.height / 50),

                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                value: ischeack,
                                overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                                side: BorderSide(color: AppColor.grey_color, width: 2),
                                checkColor: AppColor.white_color,
                                activeColor: AppColor.grey_color,
                                onChanged: (bool? value) => ischack(),
                              ),
                            ),
                            Text(AppString.usewallet, style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500, fontSize: Get.width * 0.04)),
                          ],
                        ),

                        SizedBox(height: Get.height / 50),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcon.cart),
                                SizedBox(width: Get.width / 50),
                                Text(AppString.couponcode,style: TextStyle(color: AppColor.grey_color,fontWeight: FontWeight.w500)),
                              ],
                            ),
                            button(AppString.Apply),
                          ],
                        ),

                        SizedBox(height: Get.height / 50),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
