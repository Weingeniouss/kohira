// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, deprecated_member_use, non_constant_identifier_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/modal/credentials/country.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../../../../controller/API/credentials/country.dart';
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_icon.dart';
import '../../../../utils/widget/aapbar.dart';

class CustomJewellery extends StatelessWidget {
  final Country = Get.put(CountryCalling());
  final TextEditingController searchController = TextEditingController();
  CustomJewellery({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.customJewellery),
      body: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx((){
            return horizontalpadding(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                  child: Row(
                    children: [
                      SizedBox(width: Get.width / 60),
                      SvgPicture.asset(AppIcon.earth,width: 25,height: 25,color: AppColor.pink_color),
                      SizedBox(width: Get.width / 50),
                      Expanded(
                        child: DropdownButton2<Data>(
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down),
                            iconSize: 20,
                            iconEnabledColor: AppColor.grey_color,
                            iconDisabledColor: AppColor.grey_color,
                            openMenuIcon: Icon(Icons.keyboard_arrow_up),
                          ),
                          value: Country.selectedCountry.value,
                          dropdownSearchData: DropdownSearchData(
                            searchController: searchController,
                            searchInnerWidgetHeight: 40,
                            searchInnerWidget: Padding(
                              padding: EdgeInsets.all(8),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                            },
                          ),
                          underline: SizedBox(),
                          isExpanded: true,
                          items: Country.countries.map((item) => DropdownMenuItem(value: item, child: Text("${item.label} (${item.countrycode})"))).toList(),
                          onChanged: (newValue) {
                            Country.selectedCountry.value = newValue!;
                          },
                          dropdownStyleData: DropdownStyleData(
                            offset: Offset(0, -10),
                            maxHeight: Get.height / 3,
                            decoration: BoxDecoration(color: AppColor.white_color),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
          })
        ),
      ),
    );
  }
}
