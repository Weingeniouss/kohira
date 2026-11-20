// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/address/address.dart';
import 'package:kohira/view/screen/menu/account/addresses/addNewAddresses.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Addresses extends StatelessWidget {
  final address = Get.put(AddressUserInterface());

  Addresses({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back();
        address.fech.fechaddresses();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          hedingname_2: AppString.Addresses,
          onTaplefticon: () {
            address.fech.fechaddresses();
            Get.back();
          },
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: SafeArea(
            child: horizontalpadding(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Obx(() {
                  if (address.fech.isLoading.value) {
                    return _buildLoadingShimmer();
                  }

                  final addresses = address.fech.data['userAdddress'] ?? [];

                  if (addresses == null ||
                      (addresses is List && addresses.isEmpty)) {
                    return _buildEmptyState();
                  }

                  return _buildAddressCard(addresses);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: Get.height * 0.7,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppJson.noData),
          SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Get.to(() => AddNewAddresses()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.pink_color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Add New Address",
                style: TextStyle(
                  color: AppColor.white_color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(List addresses) {
    return Column(
      children: [
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.borderGrey),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Adress",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black_color,
                ),
              ),
              SizedBox(height: 12),
              Divider(color: AppColor.lightDivider, height: 1),
              SizedBox(height: 16),
              ListView.builder(
                itemCount: addresses.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _buildAddressItem(
                      addresses[index], index, addresses.length);
                },
              ),
              SizedBox(height: 20),
              _buildAddAddressButton(),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAddressItem(dynamic fechs, int index, int totalCount) {
    final String addressText = fechs['address']?.toString() ?? '';
    final String cityText = fechs['city']?.toString() ?? '';
    final String stateText = fechs['state'] is Map
        ? fechs['state']['name']?.toString() ?? ''
        : fechs['state']?.toString() ?? '';
    final String zipText = fechs['zip']?.toString() ?? '';
    final String fullAddress = [addressText, cityText, stateText, zipText]
        .where((s) => s.isNotEmpty)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullAddress.isNotEmpty ? fullAddress : addressText,
          style: TextStyle(
            fontSize: 13,
            color: AppColor.black_color,
            height: 1.4,
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => address.isPopSelected('edit', fechs, index),
              child: Text(
                "Change Address",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black_color,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => address.deleteAddress(fechs),
              child: Text(
                "Remove",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColor.grey_color,
                ),
              ),
            ),
          ],
        ),
        if (index < totalCount - 1) ...[
          SizedBox(height: 16),
          Divider(color: AppColor.lightDivider, height: 1),
          SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildAddAddressButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () => Get.to(() => AddNewAddresses()),
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFFF9F6F0),
          side: BorderSide(color: AppColor.borderGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "Add Other Address",
          style: TextStyle(
            color: AppColor.black_color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
