// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/wallet.dart';
import 'package:kohira/controller/API/menu/myCart/process-payment.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/cheackout.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/API/credentials/country.dart';
import '../../../../modal/credentials/country.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_gif.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';

class Checkout extends StatelessWidget {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());
  final Country = Get.put(CountryCalling());
  final processpayment = Get.put(Processpayment());
  final scroll = ScrollController();
  final cheackout = Get.put(Cheackout_Controller());
  Checkout({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        cheackout.shipping.value = true;
        return false;
      },
      child: Scaffold(
        appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.cheackout),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: cheackout.shipping,
            builder: (BuildContext context, bool value, Widget? child) {
              return (!cheackout.shipping.value) ? SizedBox() : Container(
                color: AppColor.white_color,
                height: Get.height * 0.080,
                child: horizontalpadding(
                  child: Column(
                    children: [
                      GestureDetector(
                      onTap: (){
                         processpayment.processpayment(
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
                         },
                        child: button(AppString.paynow),
                      ),
                    ]
                  ),
                ),
              );
            }),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: scroll,
            physics: cheackout.shouldScroll ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(color: AppColor.white_color),
              child: Obx((){

                final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

                // Initialize item counts when data is loaded
                if (myCart.fetchcart.data.isNotEmpty && myCart.fetchcart.data['carts'] != null && myCart.itemCounts.length != myCart.fetchcart.data['carts'].length) {
                  myCart.initializeItemCounts();
                }
                final fetch = myCart.fetchcart.data['carts'] ?? [];
                if (fetch.isEmpty) return Center(child: Lottie.asset(AppJson.noData));

                return horizontalpadding(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 50),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppString.shippingaddress, style: TextStyle(height: 1.0)),
                                Builder(
                                  builder: (BuildContext innerContext) {
                                    return ValueListenableBuilder(valueListenable: cheackout.shipping, builder: (BuildContext context, value, Widget? child) {
                                      return Checkbox(
                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        value: cheackout.shipping.value,
                                        overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                                        side: BorderSide(color: AppColor.grey_color, width: 2),
                                        checkColor: AppColor.white_color,
                                        activeColor: AppColor.grey_color,
                                        onChanged: (bool? value) => cheackout.isshipping(innerContext),
                                      );
                                    },);
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppString.billing, style: TextStyle(height: 1.0)),
                                Checkbox(
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: cheackout.billing.value,
                                  overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                                  side: BorderSide(color: AppColor.grey_color, width: 2),
                                  checkColor: AppColor.white_color,
                                  activeColor: AppColor.grey_color,
                                  onChanged: (bool? value) => cheackout.isbilling(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !cheackout.billing.value,
                            child: SizedBox(
                              height: Get.height /2,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: Get.height / 60),
                                    inputField(hintText: AppString.firstname,icon: AppIcon.parson),
                                    inputField(hintText: AppString.lastname,icon: AppIcon.parson),
                                    inputField(hintText: AppString.Addresses,icon: AppIcon.Addresses,iconcolor: AppColor.pink_color),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                                      child: Row(
                                        children: [
                                          Image.asset(AppGif.earth, scale: 1.5),
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
                                              items: Country.countries.map((item) => DropdownMenuItem(value: item, child: Text("${item.label} (${item.countrycode})"))).toList(),
                                              onChanged: (newValue) => Country.selectedCountry.value = newValue!,
                                              dropdownStyleData: DropdownStyleData(
                                                offset: Offset(0, -10),
                                                maxHeight: Get.height / 3,
                                                decoration: BoxDecoration(color: AppColor.white_color),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    inputField(hintText: AppString.zipcode,icon: AppIcon.Addresses,iconcolor: AppColor.pink_color),
                                    inputField(hintText: AppString.city,icon: AppIcon.Addresses,iconcolor: AppColor.pink_color),
                                    inputField(hintText: AppString.email,icon: AppIcon.mail),
                                    inputField(hintText: AppString.hintmobile,icon: AppIcon.mobile),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: Get.height / 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(AppString.payments, style: TextStyle(fontSize: Get.width / 25,fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppString.paymentstype, style: TextStyle(height: 1.0)),
                            Checkbox(
                              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: cheackout.shippingtype.value,
                              overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                              side: BorderSide(color: AppColor.grey_color, width: 2),
                              checkColor: AppColor.white_color,
                              activeColor: AppColor.grey_color,
                              onChanged: (bool? value) => cheackout.isshippingtype(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height / 50),

                      Expanded(
                        child: SizedBox(
                          width: Get.width,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.estimatedamount),
                                  Text(indianFormat.format(wallet.data['myWalletAmount']), style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.green_color)),
                                ],
                              ),
                              Divider(color: AppColor.textfild_color),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ),
          ),
        ),
      ),
    );
  }
}
