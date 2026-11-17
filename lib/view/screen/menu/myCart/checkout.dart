// ignore_for_file: dead_null_aware_expression, prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, deprecated_member_use, unused_local_variable, unnecessary_null_comparison, unused_import, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
import 'package:kohira/controller/API/menu/account/profiledetails.dart';
import 'package:kohira/controller/API/menu/account/wallet.dart';
import 'package:kohira/controller/API/menu/myCart/process-payment.dart';
import 'package:kohira/controller/API/menu/others/count.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/buynow.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/cheackout.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/view/screen/credentials/login.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_routes.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';

class Checkout extends StatelessWidget {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());
  final processpayment = Get.put(Processpayment());
  final checkout = Get.put(Cheackout_Controller());
  final buynowUI = Get.put(BuynowController());
  final fech = Get.put(Fechaddresses());
  final profile = Get.put(ProfiledetailsController());

  Checkout({super.key});

  double getProductPrice(Map<String, dynamic> fetchdata) {
    final double discountVal =
        double.tryParse(fetchdata['discount']?.toString() ?? '0') ?? 0.0;
    final offerPrice = fetchdata['offer_price'];
    final settingPrice = fetchdata['setting_price'];

    if (discountVal > 0 && offerPrice != null) {
      return double.tryParse(offerPrice.toString()) ?? 0.0;
    } else if (settingPrice != null) {
      return double.tryParse(settingPrice.toString()) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        AppRoutes.back();
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          hedingname_2: AppString.shippingaddress,
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        bottomNavigationBar: _buildBottomBar(),
        body: SafeArea(
          child: Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(color: AppColor.white_color),
            child: Obx(() {
              final bool isGuest = (tokans.isEmpty ?? true);
              final rawData =
                  isGuest ? myCart.witoutlogin.data : myCart.fetchcart.data;
              final cartData = extractCartData(rawData);
              final fetch = cartData['carts'] ?? [];

              if (fetch is! List || fetch.isEmpty) {
                return Center(
                  child: Lottie.asset(AppJson.noData),
                );
              }

              final indianFormat = NumberFormat.currency(
                locale: 'en_IN',
                symbol: '₹',
                decimalDigits: 0,
              );

              double subTotalValue = myCart.subTotal.value;
              double globalTax = 0.0;
              if (cartData['global_tax'] != null &&
                  cartData['global_tax'] is Map) {
                globalTax = (cartData['global_tax']['globaltaxcharge'] as num?)
                        ?.toDouble() ??
                    0.0;
              }
              if (globalTax == 0.0) {
                globalTax = subTotalValue * 0.03; // Default 3% GST
              }

              double totalCost =
                  subTotalValue + globalTax - myCart.discount.value;
              if (totalCost < 0) totalCost = 0.0;

              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildOrderSummaryHeader(totalCost, indianFormat),
                    Obx(() {
                      if (checkout.showOrderSummary.value) {
                        return _buildOrderSummaryCard(fetch, subTotalValue,
                            globalTax, totalCost, indianFormat);
                      }
                      return SizedBox.shrink();
                    }),
                    horizontalpadding(
                      child: Column(
                        children: [
                          _buildGiftWrapAndNoteSection(),
                          _buildSavedAddressFormCard(),
                          _buildPriceDetailsCard(
                              isGuest,
                              fetch.length,
                              subTotalValue,
                              myCart.discount.value,
                              globalTax,
                              totalCost,
                              indianFormat),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryHeader(double total, NumberFormat indianFormat) {
    return GestureDetector(
      onTap: checkout.toggleOrderSummary,
      child: Obx(() {
        final isShown = checkout.showOrderSummary.value;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: AppColor.pink_color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isShown
                    ? "${AppString.hideOrderSummary} (${indianFormat.format(total)})"
                    : "${AppString.showOrderSummary} (${indianFormat.format(total)})",
                style: TextStyle(
                  color: AppColor.white_color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                isShown ? AppIcon.keyboardArrowUp : AppIcon.keyboardArrowDown,
                color: AppColor.white_color,
                size: 20,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderSummaryCard(List fetch, double subTotal, double tax,
      double totalCost, NumberFormat indianFormat) {
    return horizontalpadding(
      child: Container(
        margin: EdgeInsets.only(top: 12, bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.borderGrey),
        ),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: fetch.length,
              separatorBuilder: (context, index) =>
                  Divider(color: AppColor.lightDivider, height: 20),
              itemBuilder: (context, index) {
                final item = fetch[index];
                final fetchdata = item['CartJewelryData'] ?? {};
                final fetchimage = (fetchdata['allImages'] != null &&
                        fetchdata['allImages'] is List &&
                        fetchdata['allImages'].isNotEmpty)
                    ? fetchdata['allImages'][0]
                    : fetchdata['default'];

                return Obx(() {
                  final isExpanded =
                      checkout.expandedItemDetails.contains(index);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (fetchimage != null)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColor.containerBg,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColor.lightDivider),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: NetworkImage(fetchimage['thumb'] ??
                                      fetchimage['path'] ??
                                      ''),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(AppIcon.brokenImage,
                                          color: AppColor.grey_color),
                                ),
                              ),
                            ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              fetchdata['title'] ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColor.black_color,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // See More Details Toggle
                      GestureDetector(
                        onTap: () => checkout.toggleItemDetail(index),
                        child: Row(
                          children: [
                            Text(
                              isExpanded
                                  ? AppString.seeLess
                                  : AppString.seeMoreDetails,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.grey_color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              isExpanded
                                  ? AppIcon.keyboardArrowUp
                                  : AppIcon.keyboardArrowDown,
                              size: 16,
                              color: AppColor.grey_color,
                            ),
                          ],
                        ),
                      ),

                      // Expanded Product Details Specs Box
                      if (isExpanded) ...[
                        SizedBox(height: 10),
                        Text(
                          AppString.productDetailsHeader,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black_color,
                          ),
                        ),
                        SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Column(
                            children: [
                              _buildSpecRow("Diamond Quality",
                                  ": ${fetchdata['diamond_quality'] ?? 'FG/VVS VS'}"),
                              SizedBox(height: 4),
                              _buildSpecRow("Metal",
                                  ": ${fetchdata['metal_type_name'] ?? '9k Yellow Gold'}"),
                              SizedBox(height: 4),
                              _buildSpecRow("SKU",
                                  ": ${fetchdata['itemcode'] ?? 'KOLER11561-9KT-2Y'}"),
                              SizedBox(height: 4),
                              _buildSpecRow(
                                  "Shape", ": ${fetchdata['shape'] ?? 'Oval'}"),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                });
              },
            ),

            SizedBox(height: 16),

            // Pricing Summary Box
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.containerBgAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.containerBorderAlt),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppString.subTotal,
                          style: TextStyle(
                              fontSize: 13, color: AppColor.black_color)),
                      Text(indianFormat.format(subTotal),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppString.shipping,
                          style: TextStyle(
                              fontSize: 13, color: AppColor.black_color)),
                      Text("Free",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppString.tax,
                          style: TextStyle(
                              fontSize: 13, color: AppColor.black_color)),
                      Text(indianFormat.format(tax),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: checkout.toggleKohiraCoins,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Obx(
                                () => Checkbox(
                                  value: checkout.useKohiraCoins.value,
                                  activeColor: AppColor.pink_color,
                                  onChanged: (val) =>
                                      checkout.toggleKohiraCoins(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(AppString.useKohiraCoins,
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.black_color)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            AppIcon.stars,
                            size: 14,
                            color: AppColor.starAmber,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "₹0",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: AppColor.borderGrey, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.totalCost,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                      Text(
                        indianFormat.format(totalCost),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12,
                color: AppColor.black_color,
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 12, color: AppColor.grey_color),
          ),
        ),
      ],
    );
  }

  Widget _buildGiftWrapAndNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: checkout.toggleGiftWrap,
          child: Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Obx(() => Checkbox(
                      value: checkout.giftWrapOrder.value,
                      activeColor: AppColor.pink_color,
                      onChanged: (val) => checkout.toggleGiftWrap(),
                    )),
              ),
              SizedBox(width: 8),
              Text(
                AppString.giftWrapOrder,
                style: TextStyle(
                    fontSize: 13,
                    color: AppColor.black_color,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Obx(() {
          if (checkout.giftWrapOrder.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text(
                  AppString.addPersonalisedNote,
                  style: TextStyle(fontSize: 12, color: AppColor.grey_color),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: checkout.noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: AppString.typeSomethingHere,
                    hintStyle:
                        TextStyle(color: AppColor.grey_color, fontSize: 13),
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColor.borderGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColor.borderGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColor.pink_color),
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        }),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSavedAddressFormCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saved Address Container
        Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.borderGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.savedAddress,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black_color,
                ),
              ),
              SizedBox(height: 12),
              _buildOutlinedInput(
                  checkout.firstNameController, AppString.firstname),
              SizedBox(height: 10),
              _buildOutlinedInput(
                  checkout.lastNameController, AppString.lastname),
              SizedBox(height: 10),
              _buildOutlinedInput(
                  checkout.addressController, AppString.address_hint,
                  maxLines: 2),
              SizedBox(height: 10),
              // Country Box (India)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColor.containerBgGrey,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColor.borderGrey),
                ),
                child: Text(
                  AppString.india,
                  style: TextStyle(fontSize: 13, color: AppColor.black_color),
                ),
              ),
              SizedBox(height: 10),
              // State Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColor.white_color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColor.borderGrey),
                ),
                child: DropdownButtonHideUnderline(
                  child: Obx(() => DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(AppString.selectState,
                            style: TextStyle(
                                fontSize: 13, color: AppColor.grey_color)),
                        value: checkout.selectedState.value,
                        icon: Icon(AppIcon.keyboardArrowDown,
                            color: AppColor.grey_color),
                        items: checkout.statesList.map((st) {
                          return DropdownMenuItem<String>(
                            value: st,
                            child: Text(st,
                                style: TextStyle(
                                    fontSize: 13, color: AppColor.black_color)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          checkout.selectedState.value = val;
                        },
                      )),
                ),
              ),
              SizedBox(height: 10),
              _buildOutlinedInput(checkout.pincodeController, AppString.zipcode,
                  keyboardType: TextInputType.number),
              SizedBox(height: 10),
              _buildOutlinedInput(checkout.emailController, AppString.email,
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 10),
              // Mobile Input with Flag
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColor.containerBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.borderGrey),
                    ),
                    child: Row(
                      children: [
                        Text("🇮🇳", style: TextStyle(fontSize: 16)),
                        SizedBox(width: 4),
                        Text("+91",
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black_color,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildOutlinedInput(
                        checkout.mobileController, AppString.hintmobile,
                        keyboardType: TextInputType.phone),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 14),

        // Checkbox: My delivery and billing addresses are same.
        GestureDetector(
          onTap: checkout.toggleSameAsBilling,
          child: Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Obx(() => Checkbox(
                      value: checkout.sameAsBillingAddress.value,
                      activeColor: AppColor.pink_color,
                      onChanged: (val) => checkout.toggleSameAsBilling(),
                    )),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppString.sameAsBillingAddress,
                  style: TextStyle(fontSize: 12, color: AppColor.black_color),
                ),
              ),
            ],
          ),
        ),

        // Expanded Billing Address Card if sameAsBillingAddress is false
        Obx(() {
          if (!checkout.sameAsBillingAddress.value) {
            return Column(
              children: [
                SizedBox(height: 14),
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColor.white_color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.borderGrey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.billingAddress,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildOutlinedInput(checkout.billingFirstNameController,
                          AppString.firstname),
                      SizedBox(height: 10),
                      _buildOutlinedInput(checkout.billingLastNameController,
                          AppString.lastname),
                      SizedBox(height: 10),
                      _buildOutlinedInput(checkout.billingAddressController,
                          AppString.address_hint,
                          maxLines: 2),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColor.containerBgGrey,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColor.borderGrey),
                        ),
                        child: Text(
                          AppString.india,
                          style: TextStyle(
                              fontSize: 13, color: AppColor.black_color),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColor.white_color,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColor.borderGrey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(() => DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(AppString.selectState,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColor.grey_color)),
                                value: checkout.selectedBillingState.value,
                                icon: Icon(AppIcon.keyboardArrowDown,
                                    color: AppColor.grey_color),
                                items: checkout.statesList.map((st) {
                                  return DropdownMenuItem<String>(
                                    value: st,
                                    child: Text(st,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: AppColor.black_color)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  checkout.selectedBillingState.value = val;
                                },
                              )),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildOutlinedInput(
                          checkout.billingPincodeController, AppString.zipcode,
                          keyboardType: TextInputType.number),
                      SizedBox(height: 10),
                      _buildOutlinedInput(
                          checkout.billingEmailController, AppString.email,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColor.containerBg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColor.borderGrey),
                            ),
                            child: Row(
                              children: [
                                Text("🇮🇳", style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text("+91",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColor.black_color,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildOutlinedInput(
                                checkout.billingMobileController,
                                AppString.hintmobile,
                                keyboardType: TextInputType.phone),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildPriceDetailsCard(
      bool isGuest,
      int itemCount,
      double subTotal,
      double discount,
      double tax,
      double totalCost,
      NumberFormat indianFormat) {
    int walletAmount =
        int.tryParse(wallet.data['myWalletAmount']?.toString() ?? '0') ?? 0;
    double remaining =
        (walletAmount - totalCost) > 0 ? (walletAmount - totalCost) : 0.0;
    double walletTotal =
        (totalCost - walletAmount) > 0 ? (totalCost - walletAmount) : 0.0;

    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.white_color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppString.pricedetails,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black_color),
              ),
              SizedBox(width: 6),
              Text(
                "($itemCount ${AppString.items})",
                style: TextStyle(
                    fontSize: 13,
                    color: AppColor.grey_color,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppString.totalprice,
                  style: TextStyle(fontSize: 13, color: AppColor.black_color)),
              Text(indianFormat.format(subTotal),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.green_color)),
            ],
          ),
          Divider(color: AppColor.lightDivider, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppString.discountprice,
                  style: TextStyle(fontSize: 13, color: AppColor.black_color)),
              Text("-${indianFormat.format(discount)}",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.green_color)),
            ],
          ),
          Divider(color: AppColor.lightDivider, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppString.shippingcharges,
                  style: TextStyle(fontSize: 13, color: AppColor.black_color)),
              Text("FREE",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.green_color)),
            ],
          ),
          Divider(color: AppColor.lightDivider, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppString.tax,
                  style: TextStyle(fontSize: 13, color: AppColor.black_color)),
              Text(indianFormat.format(tax),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.green_color)),
            ],
          ),
          if (!isGuest && walletAmount > 0) ...[
            Divider(color: AppColor.lightDivider, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppString.totalwallet,
                    style:
                        TextStyle(fontSize: 13, color: AppColor.black_color)),
                Text(indianFormat.format(walletAmount),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.green_color)),
              ],
            ),
          ],
          Obx(() {
            final isWalletChecked = buynowUI.ischeack.value;
            if (!isGuest && isWalletChecked) {
              return Column(
                children: [
                  Divider(color: AppColor.lightDivider, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppString.deduct,
                          style: TextStyle(
                              fontSize: 13, color: AppColor.black_color)),
                      Text("-${indianFormat.format(walletAmount)}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColor.green_color)),
                    ],
                  ),
                  Divider(color: AppColor.lightDivider, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppString.remaining,
                          style: TextStyle(
                              fontSize: 13, color: AppColor.black_color)),
                      Text(indianFormat.format(remaining),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColor.green_color)),
                    ],
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          }),
          Divider(color: AppColor.borderGrey, height: 24),
          Obx(() {
            final isWalletChecked = buynowUI.ischeack.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isGuest
                      ? AppString.totalPayableAmount
                      : AppString.estimatedamount,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black_color),
                ),
                Text(
                  indianFormat.format(
                      (!isGuest && isWalletChecked) ? walletTotal : totalCost),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pink_color),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOutlinedInput(TextEditingController ctrl, String hint,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 13, color: AppColor.black_color),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColor.grey_color, fontSize: 13),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColor.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColor.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColor.pink_color),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.white_color,
        border: Border(top: BorderSide(color: AppColor.borderGrey)),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowBlack12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () async {
              final bool isGuest = (tokans.isEmpty ?? true);
              if (isGuest) {
                Get.offAll(() => Login());
              } else {
                checkout.paymantProess();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.pink_color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppString.proceedToPayment,
              style: TextStyle(
                color: AppColor.white_color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
