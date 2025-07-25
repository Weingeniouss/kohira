// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/orderhistory.dart';
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
      appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.orderhistroy),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child:  Obx(() {
            if (order.order.isLoading.value) {
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
                        itemCount: order.order.data['orders'].length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = order.order.data['orders'][index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['order_no'].toString()),
                                  Text(item['order_date'].toString()),
                                  Text(item['totalamount'].toString()),
                                  Text(item['status'], style: TextStyle(color: AppColor.glodcolor)),
                                ],
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
          },
        ),
      ),
    );
  }
}
