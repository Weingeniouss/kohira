// ignore_for_file: avoid_unnecessary_containers, file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print, deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/address/add_address.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../modal/credentials/country.dart';
import '../../../../utils/app_string.dart';

class AddNewAddresses extends StatelessWidget {
  final AddAddress = Get.put(AddAddressController());
  AddNewAddresses({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        await AddAddress.fech.fechaddresses();
        return true;
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          onTaplefticon: () async {
            Get.back();
            await AddAddress.fech.fechaddresses();
          },
          hedingname_2: 'Add New ${AppString.Addresses}',
        ),
        bottomNavigationBar: SafeArea(
          child: Obx(() {
            if (AddAddress.fech.isLoading.value) {
              return horizontalpadding(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColor.lodingcolor,
                        highlightColor: AppColor.highlightColor,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColor.grey_color,
                            borderRadius: BorderRadiusDirectional.circular(
                                Get.width * (3 / 400)),
                          ),
                          child: Center(child: Text('')),
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                color: AppColor.white_color,
                height: Get.height * 0.080,
                child: Obx(
                  () {
                    if (AddAddress.fech.isLoading.value) SizedBox();
                    return horizontalpadding(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: AddAddress.addAddress,
                              child: button("${AppString.save} ${AppString.Addresses}"),
                            ),
                            SizedBox(height: Get.height / 50),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
          child: Obx(() {
            if (AddAddress.fech.isLoading.value) {
              return Shimmer.fromColors(
                baseColor: AppColor.lodingcolor,
                highlightColor: AppColor.highlightColor,
                child: horizontalpadding(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 50),
                      loadingpanal(),
                      SizedBox(height: Get.height / 50),
                    ],
                  ),
                ),
              );
            }

            return horizontalpadding(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    // Personal Information Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLabeledInput(
                            "First Name *",
                            AddAddress.fristname,
                            hint: AppString.firstname_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "Last Name *",
                            AddAddress.lastname,
                            hint: AppString.lastname_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "Email ID *",
                            AddAddress.mail,
                            hint: AppString.email_hint,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildMobileInput("Mobile No *", AddAddress.mobile),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Address Details Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Address Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLabeledInput(
                            "Address *",
                            AddAddress.address,
                            hint: AppString.address_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildCountryDropdown(),
                          const SizedBox(height: 16),
                          _buildStateDropdown(),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "City *",
                            AddAddress.city,
                            hint: AppString.city_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "Zip Code / Pincode *",
                            AddAddress.zip,
                            hint: AppString.zipcode_hint,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                          const SizedBox(height: 12),
                          Obx(() => Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColor.pink_color,
                                    checkColor: Colors.white,
                                    value: AddAddress.isChecked.value,
                                    onChanged: (bool? value) =>
                                        AddAddress.setDefaultAddress(value),
                                  ),
                                  const Text(
                                    AppString.setdefult,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2D2D2D),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLabeledInput(
    String label,
    TextEditingController? controller, {
    String? hint,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              style: TextStyle(
                fontSize: 15,
                color: AppColor.black_color,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                counterText: "",
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileInput(String label, TextEditingController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 50,
              width: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Center(
                child: Image.asset(AppIcon.india, width: 28),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.white_color,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFE0E0E0)),
                    bottom: BorderSide(color: Color(0xFFE0E0E0)),
                    right: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
                child: Center(
                  child: TextField(
                    controller: controller,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.black_color,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: AppString.phone_hint,
                      hintStyle: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: "",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Country *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Obx(() {
            return DropdownButton2<Data>(
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColor.black_color,
                fontSize: 15,
              ),
              value: AddAddress.Country.selectedCountry.value,
              hint: const Text(
                'Select Country *',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: AddAddress.Country.countries.map((item) {
                return DropdownMenuItem<Data>(
                  value: item,
                  child: Text(item.label.toString()),
                );
              }).toList(),
              onChanged: (newValue) => AddAddress.countryCalling(newValue),
              dropdownStyleData: DropdownStyleData(
                offset: const Offset(0, -10),
                maxHeight: Get.height / 3,
                decoration: BoxDecoration(color: AppColor.white_color),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  AppIcon.keyboardArrowDownOutlined,
                  color: AppColor.dividercolor,
                ),
                iconSize: 24,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: AddAddress.searchController,
                searchInnerWidgetHeight: 40,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: AddAddress.searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Country...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) =>
                    item.value?.label
                        ?.toLowerCase()
                        .contains(searchValue.toLowerCase()) ??
                    false,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "State *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Obx(() {
            return DropdownButton2<Map<String, dynamic>>(
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColor.black_color,
                fontSize: 15,
              ),
              value: AddAddress.State.selectedState.value,
              hint: const Text(
                'Select State *',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: AddAddress.State.states.map((item) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Text(item["label"]),
                );
              }).toList(),
              onChanged: (newValue) => AddAddress.stateCalling(newValue),
              dropdownStyleData: DropdownStyleData(
                offset: const Offset(0, -10),
                maxHeight: Get.height / 3,
                decoration: BoxDecoration(color: AppColor.white_color),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  AppIcon.keyboardArrowDownOutlined,
                  color: AppColor.dividercolor,
                ),
                iconSize: 24,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: AddAddress.statesearchController,
                searchInnerWidgetHeight: 40,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: AddAddress.statesearchController,
                    decoration: const InputDecoration(
                      hintText: 'Search State...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  final map = item.value as Map<String, dynamic>;
                  return map["label"]
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

Widget loadingpanal() {
  return Column(
    children: [
      Container(
        height: Get.height * 0.05,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
    ],
  );
}
