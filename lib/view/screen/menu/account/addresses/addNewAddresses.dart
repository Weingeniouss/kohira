// ignore_for_file: avoid_unnecessary_containers, file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print, deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/address/add_address.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
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
          child: Obx((){
            if(AddAddress.fech.isLoading.value){
              return horizontalpadding(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColor.lodingcolor,
                        highlightColor: AppColor.highlightColor,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(color: AppColor.grey_color,borderRadius:BorderRadiusDirectional.circular(Get.width * (3 / 400))),
                          child: Center(child: Text('')),
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                    ],
                  ),
                ),
              );
            }else{
             return Container(
                color: AppColor.white_color,
                height: Get.height * 0.080,
                child: Obx(() {
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
          })
        ),
        body: Container(
          width: Get.width, height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            // if (AddAddress.fech.isLoading.value) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     if (Get.isDialogOpen != true) {
            //       Get.dialog(
            //         Center(child: Lottie.asset(AppJson.loading2)),
            //         barrierDismissible: false,
            //       );
            //     }
            //   });
            //   return Scaffold(backgroundColor: Colors.transparent);
            // } else {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     if (Get.isDialogOpen == true) {
            //       Get.back();
            //     }
            //   });
            // }

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
                    SizedBox(height: Get.height / 50),
                    inputField(icon: AppIcon.parson, hintText: AppString.firstname_hint, controller: AddAddress.fristname),
                    inputField(icon: AppIcon.parson, hintText: AppString.lastname_hint, controller: AddAddress.lastname),
                    inputField(icon: AppIcon.location, hintText: AppString.address_hint, controller: AddAddress.address, iconcolor: AppColor.pink_color),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                      child: Row(
                        children: [
                          SizedBox(width: Get.width / 50),
                          SvgPicture.asset(AppIcon.location, fit: BoxFit.cover, color: AppColor.pink_color, width: 20, height: 20),
                          //Country
                          Expanded(
                            child: Obx(() {
                              return DropdownButton2<Data>(
                                style: TextStyle(fontWeight: FontWeight.w400,color: AppColor.black_color,fontSize: Get.width / 28),
                                value: AddAddress.Country.selectedCountry.value,
                                hint: Text('Select Country *', style: TextStyle(color: AppColor.black_color, fontWeight: FontWeight.w400,fontSize: Get.width / 28)),
                                isExpanded: true,
                                underline: SizedBox(),
                                items: AddAddress.Country.countries.map((item) {
                                  return DropdownMenuItem<Data>(value: item, child: Text(item.label.toString()));
                                }).toList(),
                                onChanged: (newValue) => AddAddress.countryCalling(newValue),
                                dropdownStyleData: DropdownStyleData(offset: Offset(0, -10), maxHeight: Get.height / 3, decoration: BoxDecoration(color: AppColor.white_color)),
                                iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColor.dividercolor), iconSize: 24),
                                dropdownSearchData: DropdownSearchData(
                                  searchController: AddAddress.searchController,
                                  searchInnerWidgetHeight: 40,
                                  searchInnerWidget: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      controller: AddAddress.searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search Country...',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) =>  item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height / 80),
                    // inputField(icon: AppIcon.location, hintText: 'Selected State',controller: state,iconcolor: AppColor.pink_color),

                    //State
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                      child: Row(
                        children: [
                          SizedBox(width: Get.width / 50),
                          SvgPicture.asset(AppIcon.location, fit: BoxFit.cover, color: AppColor.pink_color, width: 20, height: 20),
                          Expanded(
                            child: DropdownButton2<Map<String, dynamic>>(
                              style: TextStyle(fontWeight: FontWeight.w400,color: AppColor.black_color,fontSize: Get.width / 27),
                              value: AddAddress.State.selectedState.value,
                              hint: Text('Select State *', style: TextStyle(color: AppColor.black_color, fontWeight: FontWeight.w400,fontSize: Get.width / 27)),
                              isExpanded: true,
                              underline: SizedBox(),
                              items: AddAddress.State.states.map((item) {
                                return DropdownMenuItem<Map<String, dynamic>>(value: item, child: Text(item["label"]));
                              }).toList(),
                              onChanged: (newValue) => AddAddress.stateCalling(newValue),
                              dropdownStyleData: DropdownStyleData(offset: Offset(0, -10), maxHeight: Get.height / 3, decoration: BoxDecoration(color: AppColor.white_color)),
                              iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColor.dividercolor), iconSize: 24),
                              dropdownSearchData: DropdownSearchData(
                                searchController: AddAddress.statesearchController,
                                searchInnerWidgetHeight: 40,
                                searchInnerWidget: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextField(
                                    controller: AddAddress.statesearchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search State...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  final map = item.value as Map<String, dynamic>;
                                  return map["label"].toLowerCase().contains(searchValue.toLowerCase());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height / 80),
                    inputField(icon: AppIcon.location, hintText: AppString.city_hint, controller: AddAddress.city, iconcolor: AppColor.pink_color),
                    inputField(icon: AppIcon.earth, hintText: AppString.zipcode_hint, controller: AddAddress.zip, iconwidth: 20, iconheight: 20, iconcolor: AppColor.pink_color, textInputType: TextInputType.number, maxLength: 6),
                    inputField(icon: AppIcon.mail, hintText: AppString.email_hint, controller: AddAddress.mail),
                    inputField(icon: AppIcon.mobile, hintText: AppString.phone_hint, controller: AddAddress.mobile, maxLength: 10, textInputType: TextInputType.number),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.pink_color,
                          checkColor: Colors.white,
                          value: AddAddress.isChecked.value,
                          onChanged: (bool? value) => AddAddress.setDefaultAddress(value),
                        ),
                        Text(AppString.setdefult, style: TextStyle(fontSize: Get.width / 25)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}


Widget loadingpanal(){
  return Column(
    children: [
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
      SizedBox(height: Get.height / 100),
      Container(
        height: Get.height * 0.05, width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.grey_color,
          borderRadius: BorderRadius.circular(Get.width / 60),
        ),
      ),
    ],
  );
}
