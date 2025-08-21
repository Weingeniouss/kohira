// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
import 'package:kohira/controller/API/menu/account/wallet.dart';
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
import '../account/addresses/addNewAddresses.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final myCart = Get.put(MyCartValueChange());
  final wallet = Get.put(WalletController());
  final Country = Get.put(CountryCalling());

  final scroll = ScrollController();
  bool get shouldScroll => !billing || !shipping.value || !shippingtype;

  final shipping = ValueNotifier<bool>(true);
  bool billing = true;
  bool shippingtype = true;

  void isshipping(BuildContext ctx) {
    setState(() {
      shipping.value = !shipping.value;
    });

    if(shipping.value){
      Get.back();
    }

    if (!shipping.value) {
      final fech = Get.put(Fechaddresses());
      fech.fechaddresses();
      showBottomSheet(
        context: ctx,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                height: Get.height / 1.3,
                color: AppColor.white_color,
                child: Column(
                  children: [
                    horizontalpadding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Text("Select Address"),
                          GestureDetector(
                            onTap: (){
                              Get.back();
                              setState(() {
                                shipping.value = true;
                              });
                            },
                            child: SvgPicture.asset(AppIcon.close),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: AppColor.dividercolor),
                    Expanded(
                      flex: 8,
                      child: horizontalpadding(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: fech.data['userAdddress'].length,
                          itemBuilder: (BuildContext context, int index) {
                            final fechs = fech.data['userAdddress'][index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.white_color,
                                border: Border.all(color: Colors.orange),
                                boxShadow: kElevationToShadow[1],
                                borderRadius: BorderRadius.circular(Get.width / 50),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(AppIcon.parson, color: AppColor.grey_color),
                                          SizedBox(width: Get.width / 50),
                                          Row(
                                            children: [
                                              Text(fechs['firstname']),
                                              SizedBox(width: Get.width / 100),
                                              Text(fechs['lastname']),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Get.height / 80),
                                  Row(
                                    children: [
                                      Image.asset(AppGif.earth, scale: 1.9),
                                      SizedBox(width: Get.width / 50),
                                      SizedBox(
                                        width: Get.width / 1.5,
                                        child: Text(fechs['address']),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Get.height / 50),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppIcon.mobile, color: AppColor.grey_color),
                                      SizedBox(width: Get.width / 50),
                                      Text(fechs['mobileno']),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              setState(() {
                                shipping.value = true;
                              });
                              Get.to(() => AddNewAddresses());
                            },
                            child: horizontalpadding(
                              child: button(AppString.addnewAddress),
                            ),
                          ),
                          SizedBox(height: 16), // Small gap instead of huge vertical padding
                          horizontalpadding(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                    border: Border.all(color: AppColor.grey_color),
                                  ),
                                  child: Text(AppString.clear),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColor.pink_color,
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                  ),
                                  child: Text(AppString.save,style: TextStyle(color: AppColor.white_color,fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  void isbilling(){
    setState(() {
      billing =! billing;
    });
  }

  void isshippingtype(){
    setState(() {
      shippingtype =! shippingtype;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        setState(() {
          shipping.value = true;
        });
        return false;
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          hedingname: AppString.cheackout,
        ),
        bottomNavigationBar: ValueListenableBuilder(valueListenable: shipping, builder: (BuildContext context, bool value, Widget? child) {
          return (!shipping.value) ? SizedBox() : Container(
            color: AppColor.white_color,
            height: Get.height * 0.080,
            child: horizontalpadding(
              child: Column(
                children: [
                  button(AppString.paynow),
                ],
              ),
            ),
          );
        },),
        body: SingleChildScrollView(
          controller: scroll,
          physics: shouldScroll ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
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
                                  return ValueListenableBuilder(valueListenable: shipping, builder: (BuildContext context, value, Widget? child) {
                                    return Checkbox(
                                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      value: shipping.value,
                                      overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                                      side: BorderSide(color: AppColor.grey_color, width: 2),
                                      checkColor: AppColor.white_color,
                                      activeColor: AppColor.grey_color,
                                      onChanged: (bool? value) => isshipping(innerContext),
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
                                value: billing,
                                overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                                side: BorderSide(color: AppColor.grey_color, width: 2),
                                checkColor: AppColor.white_color,
                                activeColor: AppColor.grey_color,
                                onChanged: (bool? value) => isbilling(),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !billing,
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
                            value: shippingtype,
                            overlayColor: WidgetStatePropertyAll(AppColor.grey_color),
                            side: BorderSide(color: AppColor.grey_color, width: 2),
                            checkColor: AppColor.white_color,
                            activeColor: AppColor.grey_color,
                            onChanged: (bool? value) => isshippingtype(),
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
    );
  }
}
