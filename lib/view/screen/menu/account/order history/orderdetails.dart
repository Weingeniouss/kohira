// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/myOrderDetails.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/app_String.dart';
import '../../../../utils/app_icon.dart';
import '../../../../utils/app_json.dart';
import '../../../../utils/widget/aapbar.dart';

class Orderdetails extends StatefulWidget {
  final String id;

  const Orderdetails({super.key, required this.id});

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {
  final orderdetails = Get.put(Myorderdetails());

  @override
  void initState() {
    super.initState();
    orderdetails.myorderdatails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.orderDetails),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
          if (orderdetails.isLoading.value) {
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
            final totalamount = orderdetails.data['orders']['totalamount'];
            final discountamt_amount = orderdetails.data['orders']['discountamt'];
            final tax = orderdetails.data['orders']['globaltaxcharge'];
            final shipping = orderdetails.data['orders']['shippingcharge'];

            // Convert both to numbers
            final numTotal = double.tryParse(totalamount.toString()) ?? 0;
            final numDiscount = double.tryParse(discountamt_amount.toString()) ?? 0;
            final numtax = double.tryParse(tax.toString()) ?? 0;
            final numshipping = double.tryParse(shipping.toString()) ?? 0;

            // Subtract
            final total = numTotal - numDiscount + numshipping + numtax;
            
            return SingleChildScrollView(
              child: horizontalpadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Order Details
                    SizedBox(height: Get.height / 50),
                    Text(AppString.orderDetails, style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width / 26)),
                    SizedBox(height: Get.height / 80),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.dividercolor),
                        borderRadius: BorderRadius.circular(Get.width / 50),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Order ID : ', style: TextStyle(fontSize: Get.width / 28, fontWeight: FontWeight.w500)),
                              Text(orderdetails.data['orders']['id'].toString(), style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Date Added : ', style: TextStyle(fontSize: Get.width / 28, fontWeight: FontWeight.w500)),
                              Text(orderdetails.data['orders']['order_date'].toString(), style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Shipping Address : ', style: TextStyle(fontSize: Get.width / 28, fontWeight: FontWeight.w500)),
                              Text('Free Shipping', style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Payment Method : ', style: TextStyle(fontSize: Get.width / 28, fontWeight: FontWeight.w500)),
                              Text(orderdetails.data['orders']['paymenttype'].toString(), style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Transaction Id : ', style: TextStyle(fontSize: Get.width / 28, fontWeight: FontWeight.w500)),
                              Text(orderdetails.data['orders']['payment_transaction_id'].toString(), style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Get.height / 50),

                    // Shipping Address
                    Text(AppString.shippingAddress, style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width / 26)),
                    SizedBox(height: Get.height / 80),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Get.width / 50),
                        border: Border.all(color: AppColor.textfild_color),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(orderdetails.data['orders']['users']['firstname'], style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                              SizedBox(width: Get.width / 50),
                              Text(orderdetails.data['orders']['users']['lastname'], style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text(orderdetails.data['orders']['users']['address'], style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              Text(orderdetails.data['orders']['users']['city'], style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                              SizedBox(width: Get.width / 50),
                              Text(orderdetails.data['orders']['users']['pincode'], style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          (orderdetails.data['orders']['users']['state'] == null)
                              ? SizedBox()
                              : Text(orderdetails.data['orders']['users']['state'], style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                          Text(orderdetails.data['orders']['order_addresses_data'][0]['order_country_data']['name'], style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),

                    SizedBox(height: Get.height / 50),

                    // Order Items
                    Text(AppString.orderitem, style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width / 26)),
                    SizedBox(height: Get.height / 80),

                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: kElevationToShadow[1],
                        color: AppColor.white_color,
                        borderRadius: BorderRadius.circular(Get.width / 50),
                      ),
                      child: ListView.builder(
                        itemCount: orderdetails.data['orders']['order_detail'].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final order = orderdetails.data['orders']['order_detail'][index]['jewelery']['order_current_status']['customerstatuscaption'];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    orderdetails.data['orders']['order_detail'][index]['jewelery']['default']['path'],
                                    height: 80,
                                  ),
                                  SizedBox(width: Get.width / 30),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: Get.width / 1.8,child: Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['title'],style: TextStyle(fontWeight: FontWeight.w500))),
                                      Row(
                                        children: [
                                          Text('Diamond Quality :- ',style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                          Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['clarity'],style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Metal :- ',style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                          Row(
                                            children: [
                                              Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['metal_stamp']['paraname'],style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                              SizedBox(width: Get.width / 150),
                                              Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['metal_type']['paraname'],style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Quantity :- ',style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                          Text(orderdetails.data['orders']['order_detail'][index]['qty'].toString(),style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('price :- ',style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 33)),
                                          Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['setting_price'].toString(),style: TextStyle(color: AppColor.pink_color,fontSize: Get.width / 331)),
                                        ],
                                      ),
                                      SizedBox(height: Get.height / 180),
                                      (order == 'Order Placed') ? Row(
                                        children: [
                                          Text(textAlign: TextAlign.center,'Order\nConfirm',style: TextStyle(color: AppColor.pink_color,fontWeight: FontWeight.w500)),
                                          SizedBox(width: Get.width / 20),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Get.width / 50),
                                              color: Colors.red
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: Get.width / 30,vertical: Get.height / 150),
                                            child: Text(textAlign: TextAlign.center, 'Cancel\nOrder',style: TextStyle(color: AppColor.white_color)),
                                          ),
                                        ],
                                      ) : SizedBox(),
                                      (order == 'Delivered') ? Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: Get.width / 30,vertical: Get.height / 150),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Get.width / 50),
                                              color: Colors.red,
                                            ),
                                            child: Text('Retrun',style: TextStyle(color: AppColor.white_color)),
                                          ),
                                          SizedBox(width: Get.width / 30),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: Get.width / 30,vertical: Get.height / 150),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Get.width / 50),
                                              color: Colors.red,
                                            ),
                                            child: Text('Exchange',style: TextStyle(color: AppColor.white_color)),
                                          ),
                                        ],
                                      ) : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(color: AppColor.dividercolor),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: Get.height / 50),

                    //Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sub Total :- ',style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                        Text(indianFormat.format(double.tryParse(orderdetails.data['orders']['totalamount'].toString()) ?? 0),style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Coupon Discount :- ',style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                        Text(indianFormat.format(double.tryParse(orderdetails.data['orders']['discountamt'].toString()) ?? 0),style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping & Handling :- ',style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                        Text(indianFormat.format(double.tryParse(orderdetails.data['orders']['shippingcharge'].toString()) ?? 0),style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paid by Wallet :- ',style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                        Text(indianFormat.format(double.tryParse(orderdetails.data['orders']['walletAmount'].toString()) ?? 0),style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tax : 3(%) :- ',style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                        Text(indianFormat.format(double.tryParse(orderdetails.data['orders']['globaltaxcharge'].toString()) ?? 0),style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand Total :- ',style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(indianFormat.format(double.tryParse(total.toString())),style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(height: Get.height / 50),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
