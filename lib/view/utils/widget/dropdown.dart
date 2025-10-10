// ignore_for_file: deprecated_member_use, null_check_on_nullable_type_parameter, avoid_print

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';

Widget dropDown<T>({
  required TextEditingController searchController,
  Rxn<T>? value, // Make it optional
  required List<T> items,
  required String Function(T item) displayText,
  required String hintText,
  Color? color,
  String? icons,
  void Function(T?)? onChanged,
})
{
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: color ?? AppColor.textfild_color))),
    child: Row(
      children: [
        SizedBox(width: Get.width / 200),
        SvgPicture.asset(icons ?? AppIcon.earth, width: 28, height: 28, color: color ?? AppColor.pink_color),
        Expanded(
          child: DropdownButton2<T>(
            style: TextStyle(fontWeight: FontWeight.w400,color: AppColor.black_color,fontSize: Get.width / 28),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              iconEnabledColor: AppColor.grey_color,
              iconDisabledColor: AppColor.grey_color,
              openMenuIcon: Icon(Icons.keyboard_arrow_up),
            ),
            value: value?.value, // Safe access
            dropdownSearchData: DropdownSearchData(
              searchController: searchController,
              searchInnerWidgetHeight: 40,
              searchInnerWidget: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(controller: searchController, decoration: InputDecoration(hintText: 'Search...', border: OutlineInputBorder())),
              ),
              searchMatchFn: (item, searchValue) => displayText(item.value!).toLowerCase().contains(searchValue.toLowerCase()),
            ),
            underline: SizedBox(),
            hint: Text(hintText, style: TextStyle(fontSize: Get.width / 27,color: AppColor.black_color,fontWeight: FontWeight.w400)),
            isExpanded: true,
            items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text(displayText(item)))).toList(),
            onChanged: onChanged ?? (T? newValue) => value?.value = newValue,
            dropdownStyleData: DropdownStyleData(
              offset: Offset(0, -10),
              maxHeight: Get.height / 3,
              decoration: BoxDecoration(color: AppColor.white_color),
            ),
          ),
        ),
      ],
    ),
  );
}