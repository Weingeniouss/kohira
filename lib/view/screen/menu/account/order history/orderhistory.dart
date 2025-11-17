// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/orderhistory.dart';
import 'package:kohira/view/screen/menu/account/order%20history/orderdetails.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/app_String.dart';
import '../../../../utils/app_icon.dart';
import '../../../../utils/app_json.dart';
import '../../../../utils/widget/aapbar.dart';

class Orderhistory extends StatelessWidget {
  final order = Get.put(OrderhistoryControll());
  Orderhistory({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.orderhistroy),
      body: Container(
        height: Get.height, width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child:  Obx(() {
              final oderData = order.order.data['orders'];
              if(oderData.isEmpty) return Center(child: Lottie.asset(AppJson.noData));
              return horizontalpadding(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),

                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppString.orderid),
                        Text(AppString.orderDate),
                        Text(AppString.orderTotal),
                        Text(AppString.orderstatas),
                      ],
                    ),

                    SizedBox(height: Get.height / 60),

                    // Order List
                    Expanded(
                      child: ListView.builder(
                        itemCount: oderData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = order.order.data['orders'][index];
                          return Column(
                            children: [
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item['order_no'].toString()),
                                    Text(item['order_date'].toString()),
                                    Text(item['totalamount'].toString()),
                                    Text(item['status'], style: TextStyle(color: AppColor.glodcolor)),
                                  ],
                                ),
                                onTap: () => Get.to(() => Orderdetails(id: item['id'].toString())),
                              ),
                              Divider(color: AppColor.dividercolor),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
