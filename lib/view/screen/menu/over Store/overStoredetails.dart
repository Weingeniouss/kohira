// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/overstore/overstoredetails.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';

import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/aapbar.dart';

class OverstoredetailsScreen extends StatefulWidget {
  final String slug;
  const OverstoredetailsScreen({super.key, required this.slug});

  @override
  State<OverstoredetailsScreen> createState() => _OverstoredetailsScreenState();
}

class _OverstoredetailsScreenState extends State<OverstoredetailsScreen> {
  final overstoredetails = Get.put(OverStoreDetails());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      overstoredetails.getOverStoreDetails(widget.slug);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left,hedingname_2: AppString.OverStoreDetails),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx((){
          if (overstoredetails.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // check if response data is available
          if (overstoredetails.overStoreDetailsData.isEmpty || overstoredetails.overStoreDetailsData['data'] == null) {
            return const Center(child: Text('No Data Found'));
          }
          final storeDetail = overstoredetails.overStoreDetailsData['data']['storeDetail'];
          final image = storeDetail['store_image'];
          final imagetitle = storeDetail['store_title_image'];
          return horizontalpadding(
            child: Column(
              children: [
                SizedBox(height: Get.height / 50),
                SizedBox(
                  width: Get.width,
                  child: Column(
                    children: [
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                      SizedBox(height: Get.height / 50),
                      Image.network(
                        imagetitle,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                      Text(storeDetail['street_name']),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
