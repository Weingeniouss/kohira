// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, deprecated_member_use, unused_local_variable, unnecessary_null_comparison, unused_import, prefer_const_literals_to_create_immutables

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
import 'package:kohira/controller/API/menu/account/wallet.dart';
import 'package:kohira/controller/API/menu/myCart/process-payment.dart';
import 'package:kohira/controller/API/menu/others/count.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/cheackout.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/API/credentials/country.dart';
import '../../../../controller/user_inerface/menu/myCart/buynow.dart';
import '../../../../modal/credentials/country.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_gif.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/containershadow.dart';
import '../account/addresses/addresses.dart';
import '../category/showproduct.dart';

class Checkout extends StatelessWidget {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());
  final Country = Get.put(CountryCalling());
  final processpayment = Get.put(Processpayment());
  final scroll = ScrollController();
  final cheackout = Get.put(Cheackout_Controller());
  final buynowUI = Get.put(BuynowController());
  final fech = Get.put(Fechaddresses());

  Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    void paymentprosess() async {
      await processpayment.processpayment(
        firstname: 'Khemesh',
        lastname: 'Soni',
        email: 'guestuser@gmail.com',
        companyname: 'Gram',
        address: '181',
        city: 'Dfgxzfb',
        state: '85',
        state_name: 'hzsdgvihbjsfvbbsfb',
        country: '+852',
        countrycode: '+852',
        zip: '123456',
        mobileno: '1234567890',
        samebilling: 'true',
        totalamount: '3577852',
        walletAmount: '0',
        remainingAmount: '110259',
      );

      // Check response
      if (processpayment.data != null) {
        final int code = processpayment.data['code'];
        final String? gatewayUrl = processpayment.data['gatewayUrl'];
        final Uri url = Uri.parse(gatewayUrl!);
        launchUrl(url, mode: LaunchMode.externalApplication);
        }
    }

    final TextEditingController searchController = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        cheackout.shipping.value = true;
        return false;
      },
      child: Scaffold(
        appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.cheackout),
        // bottomNavigationBar: SafeArea(
        //   child: ValueListenableBuilder(
        //     valueListenable: cheackout.shipping,
        //     builder: (BuildContext context, bool value, Widget? child) {
        //       return (!cheackout.shipping.value)
        //           ? SizedBox()
        //           : Container(
        //               color: AppColor.white_color,
        //               height: Get.height * 0.080,
        //               child: horizontalpadding(
        //                 child: Column(
        //                   children: [
        //                     GestureDetector(
        //                       onTap: paymentprosess,
        //                       child: button(AppString.paynow),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             );
        //     },
        //   ),
        // ),
        body: SafeArea(
          child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(color: AppColor.white_color),
              child: Obx(() {
                final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
                if (myCart.fetchcart.data.isNotEmpty && myCart.fetchcart.data['carts'] != null && myCart.itemCounts.length != myCart.fetchcart.data['carts'].length) {
                  myCart.initializeItemCounts();
                }
                final fetch = myCart.fetchcart.data['carts'] ?? [];
                if (fetch.isEmpty) return Center(child: Lottie.asset(AppJson.noData));
                var remaining = wallet.data['myWalletAmount'] - myCart.subTotal.value;
                return SingleChildScrollView(
                  child: horizontalpadding(
                    child: Column(
                      children: [
                        SizedBox(height: Get.height / 50),

                        //item in List of cart
                        containershadow(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
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
                                        )),
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
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: Get.height / 50),

                        //Shiping Address
                        containershadow(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.shippingaddress, style: TextStyle(height: 1.0,fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    child: GestureDetector(
                                      onTap: () => Get.to(() => Addresses()),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColor.pink_color,
                                          borderRadius: BorderRadius.circular(Get.width / 70),
                                        ),
                                        child: Text('Change Address', style: TextStyle(color: AppColor.white_color, fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ),
                                  // Builder(
                                  //   builder: (BuildContext innerContext) {
                                  //     return ValueListenableBuilder(
                                  //       valueListenable: cheackout.shipping,
                                  //       builder: (BuildContext context, value, Widget? child) {
                                  //         return Checkbox(
                                  //           visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                  //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  //           value: cheackout.shipping.value,
                                  //           overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                                  //           side: BorderSide(color: AppColor.grey_color, width: 2),
                                  //           checkColor: AppColor.white_color,
                                  //           activeColor: AppColor.grey_color,
                                  //           onChanged: (bool? value) => cheackout.isshipping(innerContext),
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),
                              SizedBox(height: Get.height / 80),
                              SizedBox(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: fech.data['userAdddress'].length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final userData = fech.data['userAdddress'][index];
                                    if (userData['isdefault'] == 1) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              // SizedBox(width: Get.width / 5, child: Text('Name :',style: TextStyle(fontWeight: FontWeight.w500))),
                                              Row(
                                                children: [
                                                  Text(userData['firstname']),
                                                  SizedBox(width: Get.width / 50),
                                                  Text(userData['lastname']),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              // SizedBox(width: Get.width / 5,child: Text('Email :',style: TextStyle(fontWeight: FontWeight.w500))),
                                              SizedBox(width: Get.width / 1.2,child: Text(userData['email'])),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              // SizedBox(width: Get.width / 5,child: Text('Country :',style: TextStyle(fontWeight: FontWeight.w500))),
                                              SizedBox(width: Get.width / 1.2,child: Text(userData['countryName'])),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              // SizedBox(width: Get.width / 5,child: Text('State :',style: TextStyle(fontWeight: FontWeight.w500))),
                                              SizedBox(width: Get.width / 1.2,child: Text(userData['stateName'])),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              // SizedBox(width: Get.width / 5,child: Text('City :',style: TextStyle(fontWeight: FontWeight.w500))),
                                              SizedBox(width: Get.width / 1.2,child: Text(userData['city'])),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              // SizedBox(width: Get.width / 5,child: Text('Mobile :',style: TextStyle(fontWeight: FontWeight.w500))),
                                              SizedBox(width: Get.width / 1.2,child: Text(userData['mobileno'])),
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Get.height / 50),

                        //Billing Statemants
                        containershadow(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.billing, style: TextStyle(height: 1.0, fontWeight: FontWeight.w500)),
                                  Checkbox(
                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: cheackout.billing.value,
                                    overlayColor: WidgetStatePropertyAll(AppColor.pink_color),
                                    side: BorderSide(color: AppColor.pink_color, width: 2),
                                    checkColor: AppColor.white_color,
                                    activeColor: AppColor.pink_color,
                                    onChanged: (bool? value) => cheackout.isbilling(),
                                  ),
                                ],
                              ),

                              AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: cheackout.billing.value
                                    ? SizedBox.shrink()
                                    : Column(
                                  children: [
                                    SizedBox(height: Get.height / 60),
                                    inputField(hintText: AppString.firstname, icon: AppIcon.parson),
                                    inputField(hintText: AppString.lastname, icon: AppIcon.parson),
                                    inputField(hintText: AppString.Addresses, icon: AppIcon.Addresses, iconcolor: AppColor.pink_color),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppIcon.earth, fit: BoxFit.cover, color: AppColor.pink_color, width: 25, height: 25),
                                          SizedBox(width: Get.width / 50),
                                          Expanded(
                                            child: DropdownButton2<Data>(
                                              iconStyleData: IconStyleData(
                                                icon: Icon(Icons.keyboard_arrow_down),
                                                iconSize: 20,
                                                iconEnabledColor: AppColor.grey_color,
                                                iconDisabledColor: AppColor.grey_color,
                                                openMenuIcon: Icon(Icons.keyboard_arrow_up),
                                              ),
                                              value: Country.selectedCountry.value,
                                              dropdownSearchData: DropdownSearchData(
                                                searchController: searchController,
                                                searchInnerWidgetHeight: 40,
                                                searchInnerWidget: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: TextField(
                                                    controller: searchController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Search...',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn: (item, searchValue) {
                                                  return item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                                                },
                                              ),
                                              underline: SizedBox(),
                                              isExpanded: true,
                                              items: Country.countries.map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text("${item.label} (${item.countrycode})"),
                                              )).toList(),
                                              onChanged: (newValue) =>
                                              Country.selectedCountry.value = newValue!,
                                              dropdownStyleData: DropdownStyleData(
                                                offset: Offset(0, -10),
                                                maxHeight: Get.height / 3,
                                                decoration:
                                                BoxDecoration(color: AppColor.white_color),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Get.height / 60),
                                    inputField(hintText: AppString.zipcode, icon: AppIcon.Addresses, iconcolor: AppColor.pink_color),
                                    inputField(hintText: AppString.city, icon: AppIcon.Addresses, iconcolor: AppColor.pink_color),
                                    inputField(hintText: AppString.email, icon: AppIcon.mail),
                                    inputField(hintText: AppString.hintmobile, icon: AppIcon.mobile),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Get.height / 50),

                        //Paymant type
                        containershadow(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(AppString.payments, style: TextStyle(fontSize: Get.width / 25, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppIcon.carts,width: 40,height: 40),
                                      SizedBox(width: Get.width / 100),
                                      SvgPicture.asset(AppIcon.upi,width: 40,height: 40),
                                      SizedBox(width: Get.width / 100),
                                      SvgPicture.asset(AppIcon.visa,width: 40,height: 40),
                                    ],
                                  ),
                                  Checkbox(
                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: cheackout.shippingtype.value,
                                    overlayColor: WidgetStatePropertyAll(AppColor.pink_color),
                                    side: BorderSide(color: AppColor.pink_color, width: 2),
                                    checkColor: AppColor.white_color,
                                    activeColor: AppColor.pink_color,
                                    onChanged: (bool? value) => cheackout.isshippingtype(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Get.height / 50),

                        //Price Details
                        containershadow(
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
                                  Text(AppString.totalwallet),
                                  Text(indianFormat.format(wallet.data['myWalletAmount']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                                ],
                              ),
                              Divider(color: AppColor.textfild_color),
                              (buynowUI.ischeack.value) ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(AppString.deduct),
                                      Text(indianFormat.format(wallet.data['myWalletAmount']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
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
                                  Divider(color: AppColor.textfild_color),
                                ],
                              ) : SizedBox(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.estimatedamount),
                                  Text(indianFormat.format(buynowUI.useWallet.value), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Get.height / 50),

                        ValueListenableBuilder(
                          valueListenable: cheackout.shipping,
                          builder: (BuildContext context, bool value, Widget? child) {
                            return (!cheackout.shipping.value)
                                ? SizedBox()
                                : Container(
                              color: AppColor.white_color,
                              height: Get.height * 0.080,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: paymentprosess,
                                    child: button(AppString.paynow),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        SizedBox(height: Get.height / 80),
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
