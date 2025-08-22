// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                          Text(orderdetails.data['orders']['users']['state'] ?? '', style: TextStyle(color: AppColor.grey_color, fontWeight: FontWeight.w500)),
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
                      ),
                      child: ListView.builder(
                        itemCount: orderdetails.data['orders']['order_detail'].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
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
                                          Text('Diamond Quality :- ',style: TextStyle(color: AppColor.grey_color)),
                                          Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['clarity'],style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Metal :- ',style: TextStyle(color: AppColor.grey_color)),
                                          Row(
                                            children: [
                                              Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['metal_stamp']['paraname'],style: TextStyle(color: AppColor.grey_color)),
                                              SizedBox(width: Get.width / 150),
                                              Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['metal_type']['paraname'],style: TextStyle(color: AppColor.grey_color)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Quantity :- ',style: TextStyle(color: AppColor.grey_color)),
                                          Text(orderdetails.data['orders']['order_detail'][index]['qty'].toString(),style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('price :- ',style: TextStyle(color: AppColor.grey_color)),
                                          Text(orderdetails.data['orders']['order_detail'][index]['jewelery']['setting_price'].toString(),style: TextStyle(color: AppColor.pink_color)),
                                        ],
                                      ),
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
