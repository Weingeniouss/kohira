// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unnecessary_null_comparison, deprecated_member_use, non_constant_identifier_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/address/edit_address.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../modal/credentials/country.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';

import 'addNewAddresses.dart';

class Editaddresses extends StatelessWidget {
  final String id;
  const Editaddresses({super.key, required this.id});
  EditAddressUserIntrface get edit => Get.put(EditAddressUserIntrface(ids: id));
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Get.back();
        await edit.fech.fechaddresses();
        return true;
      },
      child: Scaffold(
        appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.editAddresses),
        bottomNavigationBar:Obx((){
          if(edit.fechedit.isLoading.value){
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
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            // if (fechedit.isLoading.value) {
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

            return horizontalpadding(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    inputField(icon: AppIcon.parson, controller: edit.firstname),
                    inputField(icon: AppIcon.parson, controller: edit.lastname),
                    inputField(icon: AppIcon.location, controller: edit.address,iconcolor: AppColor.pink_color),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                        child: Row(children: [
                          SizedBox(width: Get.width / 50),
                          SvgPicture.asset(AppIcon.location,fit: BoxFit.cover,color: AppColor.pink_color,width: 20,height: 20),
                          Expanded(
                            child: Obx(() {
                              final userData = edit.fechedit.data['userAdddress'];
                              return DropdownButton2<Data>(
                                style: TextStyle(color: AppColor.black_color,fontWeight: FontWeight.w400,fontSize: Get.width / 27),
                                value: edit.Country.selectedCountry.value,
                                hint: Text(
                                  userData['country_data']?['name'] ?? '',
                                  style: TextStyle(
                                    color: AppColor.black_color,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Get.width / 27,
                                  ),
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                items: edit.Country.countries.map((item) {
                                  return DropdownMenuItem<Data>(
                                    value: item,
                                    child: Text(item.label.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue) => edit.changeCountryvalue(newValue),
                                dropdownStyleData: DropdownStyleData(
                                  offset: Offset(0, -10),
                                  maxHeight: Get.height / 3,
                                  decoration: BoxDecoration(color: AppColor.white_color),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColor.dividercolor),
                                  iconSize: 24,
                                ),
                                dropdownSearchData: DropdownSearchData(
                                  searchController: edit.searchController,
                                  searchInnerWidgetHeight: 40,
                                  searchInnerWidget: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      controller: edit.searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search Country...',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                                  },
                                ),
                              );
                            }),
                          ),
                        ])),
                    SizedBox(height: Get.height / 80),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                        child: Row(children: [
                          SizedBox(width: Get.width / 50),
                          SvgPicture.asset(AppIcon.location,fit: BoxFit.cover,color: AppColor.pink_color,width: 20,height: 20),
                          Expanded(
                            child: Obx((){
                              final userData = edit.fechedit.data['userAdddress'];
                              return DropdownButton2<Map<String, dynamic>>(
                                style: TextStyle(color: AppColor.black_color,fontWeight: FontWeight.w400,fontSize: Get.width / 27),
                                value: edit.State.selectedState.value,
                                hint: Text(
                                  userData['state_data']?['name'] ?? '',
                                  style: TextStyle(
                                    color: AppColor.black_color,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Get.width / 27,
                                  ),
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                items: edit.State.states.map((item) {
                                  return DropdownMenuItem<Map<String, dynamic>>(
                                    value: item,
                                    child: Text(item["label"]),
                                  );
                                }).toList(),
                                onChanged: (newValue) => edit.changeStatevalue(newValue),
                                dropdownStyleData: DropdownStyleData(
                                  offset: Offset(0, -10),
                                  maxHeight: Get.height / 3,
                                  decoration: BoxDecoration(color: AppColor.white_color),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColor.dividercolor),
                                  iconSize: 24,
                                ),
                                dropdownSearchData: DropdownSearchData(
                                  searchController: edit.statesearchController,
                                  searchInnerWidgetHeight: 40,
                                  searchInnerWidget: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      controller: edit.statesearchController,
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
                              );
                            }),
                          ),
                        ])),
                    SizedBox(height: Get.height / 80),
                    // inputField(icon: AppIcon.location, controller: state,iconcolor: AppColor.pink_color),
                    inputField(icon: AppIcon.location,controller: edit.city,iconcolor: AppColor.pink_color),
                    inputField(icon: AppIcon.earth, controller: edit.zip,iconheight: 20,iconcolor: AppColor.pink_color,textInputType: TextInputType.number,maxLength: 6),
                    inputField(icon: AppIcon.mail, controller: edit.mail),
                    inputField(icon: AppIcon.mobile, controller: edit.mobile,maxLength: 10,textInputType: TextInputType.number),
                    (edit.fechedit.data['userAdddress']['isdefault'] ==  1) ? Column(
                      children: [
                        SizedBox(height: Get.height / 80),
                        Row(
                          children: [
                            SizedBox(width: Get.width / 30),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: AppColor.pink_color,borderRadius: BorderRadius.circular(Get.width / 80)),
                                  child: Icon(Icons.check,size: 13,color: AppColor.white_color),
                                ),
                                SizedBox(width: Get.width / 50),
                                Text(AppString.setdefult,style: TextStyle(fontSize: Get.width / 25)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ) : SizedBox(),

                    (edit.fechedit.data['userAdddress']['isdefault'] == 0) ?  Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.pink_color,
                          checkColor: Colors.white,
                          value: edit.isChecked.value,
                          onChanged: (bool? value) => edit.setDefaultvalue(value),
                        ),
                        Text(AppString.setdefult,style: TextStyle(fontSize: Get.width / 25)),
                      ],
                    ) : SizedBox(),
                  ],
                ),
              ),
            );
          },
          ),
        ),
      ),
    );
  }
}