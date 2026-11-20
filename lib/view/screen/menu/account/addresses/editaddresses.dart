// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unnecessary_null_comparison, deprecated_member_use, non_constant_identifier_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/address/edit_address.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../modal/credentials/country.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';

import 'addNewAddresses.dart';

class Editaddresses extends StatelessWidget {
  final String id;
  const Editaddresses({super.key, required this.id});

  EditAddressUserIntrface get edit => Get.put(EditAddressUserIntrface(ids: id));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        await edit.fech.fechaddresses();
        return true;
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          hedingname_2: AppString.editAddresses,
          onTaplefticon: () async {
            Get.back();
            await edit.fech.fechaddresses();
          },
        ),
        bottomNavigationBar: Obx(() {
          if (edit.fechedit.isLoading.value) {
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
          }
          edit.facedataedit();
          return SafeArea(
            child: Container(
              color: AppColor.white_color,
              height: Get.height * 0.080,
              child: horizontalpadding(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => edit.editfechaddresses(),
                          child: button("${AppString.save} ${AppString.Addresses}"),
                        ),
                        SizedBox(height: Get.height / 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
          child: Obx(() {
            if (edit.fechedit.isLoading.value) {
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
            edit.facedataedit();
            final userData = edit.fechedit.data['userAdddress'];

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
                            edit.firstname,
                            hint: AppString.firstname_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "Last Name *",
                            edit.lastname,
                            hint: AppString.lastname_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "Email ID *",
                            edit.mail,
                            hint: AppString.email_hint,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildMobileInput("Mobile No *", edit.mobile),
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
                            edit.address,
                            hint: AppString.address_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildCountryDropdown(userData),
                          const SizedBox(height: 16),
                          _buildStateDropdown(userData),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "City *",
                            edit.city,
                            hint: AppString.city_hint,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledInput(
                            "Zip Code / Pincode *",
                            edit.zip,
                            hint: AppString.zipcode_hint,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                          const SizedBox(height: 12),
                          if (userData?['isdefault'] == 1) ...[
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColor.pink_color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(AppIcon.checkIcon,
                                      size: 13, color: AppColor.white_color),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  AppString.setdefult,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF2D2D2D)),
                                ),
                              ],
                            ),
                          ] else ...[
                            Obx(() => Row(
                                  children: [
                                    Checkbox(
                                      activeColor: AppColor.pink_color,
                                      checkColor: Colors.white,
                                      value: edit.isChecked.value,
                                      onChanged: (bool? value) =>
                                          edit.setDefaultvalue(value),
                                    ),
                                    Text(
                                      AppString.setdefult,
                                      style: TextStyle(
                                          fontSize: 14, color: Color(0xFF2D2D2D)),
                                    ),
                                  ],
                                )),
                          ],
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

  Widget _buildCountryDropdown(dynamic userData) {
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
            final selectedCountry = edit.Country.selectedCountry.value;
            final isValidCountry = selectedCountry != null &&
                edit.Country.countries
                    .any((country) => country.id == selectedCountry.id);
            return DropdownButton2<Data>(
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColor.black_color,
                fontSize: 15,
              ),
              value: isValidCountry ? selectedCountry : null,
              hint: Text(
                userData?['country_data']?['name'] ?? 'Select Country *',
                style: TextStyle(
                  color: AppColor.black_color,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: edit.Country.countries.map((item) {
                return DropdownMenuItem<Data>(
                  value: item,
                  child: Text(item.label.toString()),
                );
              }).toList(),
              onChanged: (newValue) => edit.changeCountryvalue(newValue),
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
                searchController: edit.searchController,
                searchInnerWidgetHeight: 40,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: edit.searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Country...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value?.label
                          ?.toLowerCase()
                          .contains(searchValue.toLowerCase()) ??
                      false;
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStateDropdown(dynamic userData) {
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
            final selectedState = edit.State.selectedState.value;
            final isValidState = selectedState != null &&
                edit.State.states
                    .any((state) => state["id"] == selectedState["id"]);

            return DropdownButton2<Map<String, dynamic>>(
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColor.black_color,
                fontSize: 15,
              ),
              value: isValidState ? selectedState : null,
              hint: Text(
                userData?['state_data']?['name'] ?? 'Select State *',
                style: TextStyle(
                  color: AppColor.black_color,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: edit.State.states.map((item) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Text(item["label"]),
                );
              }).toList(),
              onChanged: (newValue) => edit.changeStatevalue(newValue),
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
                searchController: edit.statesearchController,
                searchInnerWidgetHeight: 40,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: edit.statesearchController,
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
