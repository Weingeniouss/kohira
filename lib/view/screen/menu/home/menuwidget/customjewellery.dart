// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, deprecated_member_use, non_constant_identifier_names, avoid_print, must_be_immutable

// Container(
//   padding: EdgeInsets.symmetric(horizontal: 8),
//   decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
//   child: Row(
//     children: [
//       SizedBox(width: Get.width / 60),
//       SvgPicture.asset(AppIcon.earth, width: 25, height: 25, color: AppColor.pink_color),
//       SizedBox(width: Get.width / 50),
//       Expanded(
//         child: DropdownButton2<Category_Customorder>(
//           iconStyleData: IconStyleData(
//             icon: Icon(Icons.keyboard_arrow_down),
//             iconSize: 20,
//             iconEnabledColor: AppColor.grey_color,
//             iconDisabledColor: AppColor.grey_color,
//             openMenuIcon: Icon(Icons.keyboard_arrow_up),
//           ),
//           // Fix 1: Use selectedCategory instead of Country.selectedCountry
//           value: selectedCategory.value,
//           dropdownSearchData: DropdownSearchData(
//             searchController: searchController,
//             searchInnerWidgetHeight: 40,
//             searchInnerWidget: Padding(
//               padding: EdgeInsets.all(8),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             searchMatchFn: (item, searchValue) {
//               // Fix 2: Use Category_Customorder properties
//               return item.value?.name?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
//             },
//           ),
//           underline: SizedBox(),
//           hint: Text('Choose Jewelley Type', style: TextStyle(fontSize: Get.width / 28)),
//           isExpanded: true,
//           // Fix 3: Correct the items mapping with proper types
//           items: customorder.categories.map((category) => DropdownMenuItem<Category_Customorder>(value: category, child: Text(category.name))).toList(),
//           onChanged: (Category_Customorder? newValue) => selectedCategory.value = newValue,
//           dropdownStyleData: DropdownStyleData(
//             offset: Offset(0, -10),
//             maxHeight: Get.height / 3,
//             decoration: BoxDecoration(color: AppColor.white_color),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),

// Obx(() {
//   if (selectedCategory.value != null) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8),
//       child: Row(
//         children: [
//           SizedBox(width: Get.width / 60),
//           SvgPicture.asset(AppIcon.like, width: 25, height: 25, color: AppColor.pink_color),
//           SizedBox(width: Get.width / 50),
//           Expanded(
//             child: DropdownButton2<Category_Subcategory>(
//               hint: Text('Choose Subcategory', style: TextStyle(fontSize: Get.width / 28)),
//               value: null, // You can store selected subcategory in another Rx variable
//               items: selectedCategory.value!.subcategory.map((subcategory) =>
//                   DropdownMenuItem<Category_Subcategory>(
//                     value: subcategory,
//                     child: Text(subcategory.name),
//                   )
//               ).toList(),
//               onChanged: (Category_Subcategory? newValue) {
//                 // Handle subcategory selection
//                 print('Selected subcategory: ${newValue?.name}');
//               },
//               dropdownStyleData: DropdownStyleData(
//                 maxHeight: Get.height / 3,
//                 decoration: BoxDecoration(color: AppColor.white_color),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   return SizedBox();
// }),

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/customorder.dart';
import 'package:kohira/controller/API/menu/others/drawer/Jewellery_list.dart';
import 'package:kohira/modal/menu/home/drawar/customJewellery/category_customorder.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/dropdown.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../../../../controller/API/credentials/country.dart';
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_icon.dart';
import '../../../../utils/widget/aapbar.dart';

class CustomJewellery extends StatelessWidget {
  final Country = Get.put(CountryCalling());
  final customorder = Get.put(Customorder());
  final jewelleryfilter = Get.put(JewelleryList());

  var selectedCategory = Rxn<Category_Customorder>();
  var selectedSubcategory = Rxn<Category_Subcategory>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController subcategorySearchController = TextEditingController();

  // itemCount: jewelleryfilter.data['data']['Metal_Type'].length,

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
          child: Obx(() {
            return horizontalpadding(
              child: Column(
                children: [
                  dropDown<Category_Customorder>(
                    searchController: searchController,
                    customorder: customorder,
                    value: selectedCategory,
                    items: customorder.categories,
                    displayText: (category) => category.name,
                    hintText: 'Choose Jewelry Type',
                  ),

                  SizedBox(height: Get.height / 80),

                  (selectedCategory.value != null)
                      ? dropDown<Category_Subcategory>(
                         searchController: subcategorySearchController,
                         customorder: customorder,
                         value: selectedSubcategory,
                         items: selectedCategory.value!.subcategory,
                         displayText: (subcategory) => subcategory.name,
                         hintText: 'Choose Subcategory',
                  ) : SizedBox()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
