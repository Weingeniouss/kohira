// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, deprecated_member_use, non_constant_identifier_names, avoid_print, must_be_immutable, strict_top_level_inference, prefer_typing_uninitialized_variables, unnecessary_null_comparison, unrelated_type_equality_checks

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
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/clarity.dart';
import 'package:kohira/controller/user_inerface/menu/home/menuwidget/drawer.dart';
import 'package:kohira/modal/menu/category/subcategory/jewelleryfilter.dart';
import 'package:kohira/modal/menu/home/drawar/customJewellery/category_customorder.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/dropdown.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_icon.dart';
import '../../../../utils/widget/aapbar.dart';

class CustomJewellery extends StatelessWidget {
  final customUI = Get.put(CustomJewelleryUI());
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
            final filter = customUI.jewellery.data.value?.data;
            return horizontalpadding(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 100),

                    //Jewelry Type
                    dropDown<Category_Customorder>(
                      icons: AppIcon.jewellery_type,
                      searchController: customUI.searchController,
                      value: customUI.selectedCategory,
                      items: customUI.customorder.categories,
                      displayText: (category) => category.name,
                      hintText: AppString.jewelery_Type,
                      onChanged: customUI.onCategoryChanged,
                    ),

                    SizedBox(height: Get.height / 60),

                    // Choose Subcategory
                    Obx(() {
                      if (customUI.selectedCategory.value == null || customUI.selectedCategory.value!.subcategory == null || customUI.selectedCategory.value!.subcategory.isEmpty) {
                        return SizedBox();
                      }

                      // Ensure the current subcategory value exists in the new list
                      final currentSubcategory = customUI.selectedSubcategory.value;
                      if (currentSubcategory != null) {
                        final exists = customUI.selectedCategory.value!.subcategory.any((subcat) => subcat.id == currentSubcategory.id);
                        if (!exists) {
                          customUI.selectedSubcategory.value = null;
                        }
                      }

                      return Column(
                        children: [
                          dropDown<Category_Subcategory>(
                            icons: AppIcon.jewellery_type,
                            searchController: customUI.subcategorySearchController,
                            value: customUI.selectedSubcategory,
                            items: customUI.selectedCategory.value!.subcategory,
                            displayText: (subcategory) => subcategory.name,
                            hintText: AppString.jewelery_Subcategory,
                          ),
                          SizedBox(height: Get.height / 60),
                        ],
                      );
                    }),

                    //Metal Type
                    dropDown(
                      icons: AppIcon.metal_type,
                      searchController: customUI.metalsearchcontoller,
                      value: customUI.selectedMetalType,
                      items: customUI.jewelleryfilter.metalTypes,
                      displayText: (metalType) => metalType.name,
                      hintText: AppString.metal_Type,
                    ),

                    SizedBox(height: Get.height / 60),

                    //Metal Stamp
                    dropDown(
                      icons: AppIcon.ethical,
                      searchController: customUI.metalstampsearchcontoller,
                      value: customUI.selectedMetalStamp,
                      items: customUI.jewelleryfilter.metalStamp,
                      displayText: (metalType) => metalType.name,
                      hintText: AppString.metal_stamp,
                    ),

                    SizedBox(height: Get.height / 100),

                    //Weight
                    inputField(
                      textInputType: TextInputType.number,
                      controller: customUI.metalWeightController,
                      icon: AppIcon.appx_weight,
                      iconheight: 10,
                      iconwidth: 10,
                      iconcolor: AppColor.pink_color,
                      hintText: AppString.metal_Weight,
                    ),

                    //Budget
                    inputField(
                      textInputType: TextInputType.number,
                      controller: customUI.metalBudgetController,
                      icon: AppIcon.returns,
                      iconheight: 10,
                      iconwidth: 10,
                      iconcolor: AppColor.pink_color,
                      hintText: AppString.budget,
                    ),

                    //Remark
                    Container(
                      height: Get.height / 9,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColor.textfild_color)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: customUI.metalremarkController,
                        style: TextStyle(fontSize: Get.width / 30, color: AppColor.black_color),
                        maxLines: 100,
                        minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(15),
                            child: SvgPicture.asset(AppIcon.remark, width: 20, height: 20, color: AppColor.pink_color),
                          ),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: AppString.remark,
                          hintStyle: TextStyle(color: AppColor.black_color,fontSize: Get.width / 30),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          filled: true,
                          fillColor: AppColor.white_color,
                          isDense: true,
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height / 50),
                    Text(AppString.diamond_Type,style: TextStyle(fontSize: Get.width / 24,color: AppColor.grey_color,fontWeight: FontWeight.w500)),
                    SizedBox(height: Get.height / 50),

                    //Center Stone
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: customUI.isCheck_center.value,
                            onChanged: (val) => customUI.center(val),
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            side: BorderSide(color: AppColor.black_color, width: 1),
                            checkColor: AppColor.white_color,
                            activeColor: AppColor.black_color,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(width: Get.width / 50),
                        Text(AppString.centerStone, style: TextStyle(color: AppColor.black_color, fontWeight: FontWeight.w500, fontSize: Get.width / 27)),
                      ],
                    ),
                    SizedBox(height: Get.height / 80),

                    //isCheck_center == True after Center Stone = true then ....
                    Visibility(
                      visible: customUI.isCheck_center.value,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColor.graycolor,borderRadius: BorderRadius.circular(Get.width / 50)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              //Shap
                              Text(AppString.shape, style: TextStyle(fontSize: Get.width / 25, color: AppColor.black_color, fontWeight: FontWeight.w500)),
                              SizedBox(height: Get.height / 100),
                              Obx((){
                                return  SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: filter!.shape.map((item) {
                                      final isSelected = customUI.filtertab.diamondtype.value == item.slug;
                                      if (isSelected) {
                                        customUI.selectedShapeId.value = item.id.toString();
                                      }
                                      return GestureDetector(
                                        onTap: () => customUI.shape_add(item),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 2),
                                          width: Get.width / 5,
                                          height: Get.height / 12,
                                          padding: EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: (isSelected) ? AppColor.black_color : Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(Get.width / 50),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(color: AppColor.white_color,borderRadius: BorderRadius.circular(Get.width / 80)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                                  child: Image.network(
                                                    item.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {return Icon(Icons.broken_image, color: (isSelected) ? AppColor.pink_color : Colors.grey);},
                                                  ),
                                                ),
                                                Text(item.name,style: TextStyle(fontSize: Get.width / 30)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),

                              //Color
                              SizedBox(height: Get.height / 100),
                              Text(AppString.color, style: TextStyle(fontSize: Get.width / 25, color: AppColor.black_color, fontWeight: FontWeight.w500)),
                              SizedBox(height: Get.height / 200),
                              Obx((){
                                return  SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: filter!.color.map((item) {
                                      final isSelected = customUI.filtertab.colortype.value == item.id.toString();
                                      if (isSelected) customUI.colors.value = item.id.toString();
                                      return GestureDetector(
                                        onTap: () => customUI.color_add(item),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 2),
                                          width: 30,
                                          height: 30,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: (isSelected) ? AppColor.black_color : Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(Get.width / 50),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(color: AppColor.white_color,borderRadius: BorderRadius.circular(Get.width / 80)),
                                            child: Center(child: Text(item.name)),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),

                              //Clarity
                            SizedBox(height: Get.height / 100),
                            Text(AppString.clarity, style: TextStyle(fontSize: Get.width / 25, color: AppColor.black_color, fontWeight: FontWeight.w500)),
                            SizedBox(height: Get.height / 200),
                            GetBuilder<CustomJewelleryUI>(
                              builder: (GetxController controller) {
                                return SizedBox(
                                  height: Get.height / 20,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: customUI.clarity.clarity_data['data'].length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final clar = customUI.clarity.clarity_data['data'][index];
                                      final String slug = clar['slug'];
                                      final bool isSelected = customUI.selectedSlug.value == slug;
                                      customUI.clarityy.value = clar['id'].toString();
                                      return GestureDetector(
                                        onTap: () => customUI.clariy_add(isSelected, slug),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 2),
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: isSelected ? AppColor.black_color : Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(Get.width / 50),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            decoration: BoxDecoration(
                                              color: AppColor.white_color,
                                              borderRadius: BorderRadius.circular(Get.width / 80),
                                            ),
                                            child: Center(child: Text(clar['name'], style: TextStyle(color: AppColor.black_color, fontWeight: FontWeight.normal))),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: Get.height / 50),

                            //Select Stamp
                            dropDown<Map<String, dynamic>>(
                              color: AppColor.grey_color,
                              searchController: customUI.selectedmetalValueController,
                              value: customUI.selectedMetalStampValue,
                              items: customUI.stampvalue,
                              displayText: (stamp) => "${stamp['name']}",
                              hintText: AppString.selected_Stamp,
                              onChanged: customUI.onStampSelected,
                            ),

                            SizedBox(height: Get.height / 200),

                            //Min Value and max value
                            Row(
                              children: [

                                //Min Value
                                Expanded(
                                  child: inputField(
                                    readOnly: true,
                                    controller: customUI.minValueController,
                                    icon: AppIcon.earth,
                                    textfildcolor: AppColor.grey_color,
                                    iconheight: 10,
                                    iconwidth: 10,
                                    iconcolor: AppColor.grey_color,
                                    hintText: AppString.minValue,
                                  ),
                                ),

                                SizedBox(width: Get.width / 20),

                                Expanded(

                                  //max value
                                  child: inputField(
                                    readOnly: true,
                                    controller: customUI.maxValueController,
                                    icon: AppIcon.earth,
                                    textfildcolor: AppColor.grey_color,
                                    iconheight: 10,
                                    iconwidth: 10,
                                    iconcolor: AppColor.grey_color,
                                    hintText: AppString.maxValue,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ),
                    ),

                    SizedBox(height: Get.height / 80),

                    //Side Stone
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: customUI.isCheck_side_stone.value,
                            onChanged: (val) {
                              customUI.side_stone(val);
                              (customUI.isCheck_side_stone == true) ? customUI.side_Stone_bottambar(context) : customUI.isCheck_side_stone == false;
                              (customUI.listofshape.isEmpty && customUI.listofclarity.isEmpty && customUI.listofcolor.isEmpty) ? customUI.isCheck_side_stone == false : customUI.isCheck_side_stone == true;
                            },
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            side: BorderSide(color: AppColor.black_color, width: 1),
                            checkColor: AppColor.white_color,
                            activeColor: AppColor.black_color,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(width: Get.width / 50),
                        Text(AppString.sideStone, style: TextStyle(color: AppColor.black_color, fontWeight: FontWeight.w500, fontSize: Get.width / 27)),
                      ],
                    ),

                    SizedBox(height: Get.height / 60),

                    //isCheck_isCheck_side_stone == True after isCheck_side_stone = true then ....
                    (customUI.listofshape.isNotEmpty && customUI.listofclarity.isNotEmpty && customUI.listofcolor.isNotEmpty)
                        ? Visibility(
                            visible: customUI.isCheck_side_stone.value,
                            child: Obx(() => Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.graycolor,
                                borderRadius: BorderRadius.circular(Get.width / 50),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: AppColor.Appbercolor),
                                    child: Row(
                                      children: [
                                        SizedBox(width: Get.width / 4,child: Text(AppString.shape,style: TextStyle(fontWeight: FontWeight.w600))),
                                        SizedBox(width: Get.width / 5,child: Text(AppString.color,style: TextStyle(fontWeight: FontWeight.w600))),
                                        SizedBox(width: Get.width / 4.5,child: Text(AppString.clarity,style: TextStyle(fontWeight: FontWeight.w600))),
                                        SizedBox(width: Get.width / 6,child: Text(AppString.action,style: TextStyle(fontWeight: FontWeight.w600))),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: customUI.listofshape.length,
                                    itemBuilder: (context, index) {
                                      customUI.shape = customUI.listofshape[index];
                                      customUI.color = customUI.listofcolor[index];
                                      customUI.claritys = customUI.listofclarity[index];
                                      return Container(
                                        padding: EdgeInsetsGeometry.symmetric(horizontal: Get.width / 50),
                                        decoration: BoxDecoration(color: AppColor.white_color),
                                        child: Row(
                                          children: [
                                            SizedBox(width: Get.width / 4,child: Text(customUI.shape.name,style: TextStyle(fontWeight: FontWeight.w600))),
                                            SizedBox(width: Get.width / 25),
                                            SizedBox(width: Get.width / 10,child: Text(customUI.color.name,style: TextStyle(fontWeight: FontWeight.w600))),
                                            SizedBox(width: Get.width / 10),
                                            SizedBox(width: Get.width / 8,child: Text(customUI.claritys.name.toString(),style: TextStyle(fontWeight: FontWeight.w600))),
                                            SizedBox(width: Get.width / 13),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  child: SvgPicture.asset(AppIcon.edit,width: 15,height: 15,color: AppColor.grey_color),
                                                  onTap: (){
                                                    customUI.side_Stone_bottambar_update(
                                                      context: context,
                                                      index: index,
                                                      selectedShape_edit: Rxn<BraceletSize>(customUI.listofshape[index]),
                                                      selectcolor_edit: Rxn<BraceletSize>(customUI.listofcolor[index]),
                                                      selectedClarity_edit: Rxn<ClarityItem>(customUI.listofclarity[index]),
                                                    );
                                                  },
                                                ),
                                                SizedBox(width: Get.width / 30),
                                                GestureDetector(
                                                  onTap: (){
                                                    customUI.listofshape.removeAt(index);
                                                    customUI.listofcolor.removeAt(index);
                                                    customUI.listofclarity.removeAt(index);
                                                  },
                                                  child: Icon(Icons.delete_outline_outlined, color: AppColor.grey_color, size: 20),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: Get.height / 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () => customUI.side_Stone_bottambar(context),
                                        child: Text(
                                          '${AppString.add} +',
                                            style: TextStyle(
                                              color: AppColor.pink_color,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                              decorationColor: AppColor.pink_color,
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          )
                        : SizedBox(),

                    (customUI.listofshape.isNotEmpty && customUI.listofclarity.isNotEmpty && customUI.listofcolor.isNotEmpty)
                        ? SizedBox(height: Get.height / 50)
                        : SizedBox(),

                    //Information
                    Divider(color: AppColor.textfild_color),

                    SizedBox(height: Get.height / 50),
                    Text(AppString.information,style: TextStyle(fontSize: Get.width / 24,color: AppColor.grey_color,fontWeight: FontWeight.w500)),
                    SizedBox(height: Get.height / 50),

                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.graycolor,
                        borderRadius: BorderRadius.circular(Get.width / 50),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: Get.height / 80),
                          inputField(
                            textfildcolor: AppColor.grey_color,
                            controller: customUI.firstname_controller,
                            icon: AppIcon.parson,
                            iconheight: 10,
                            iconwidth: 10,
                            iconcolor: AppColor.grey_color,
                            hintText: AppString.firstname_hint,
                          ),
                          SizedBox(height: Get.height / 80),
                          inputField(
                            textInputType: TextInputType.number,
                            textfildcolor: AppColor.grey_color,
                            controller: customUI.lastname_controller,
                            icon: AppIcon.parson,
                            iconheight: 10,
                            iconwidth: 10,
                            iconcolor: AppColor.grey_color,
                            hintText: AppString.lastname_hint,
                          ),
                          SizedBox(height: Get.height / 80),
                          inputField(
                            textfildcolor: AppColor.grey_color,
                            controller: customUI.email_controller,
                            icon: AppIcon.mail,
                            iconheight: 10,
                            iconwidth: 10,
                            iconcolor: AppColor.grey_color,
                            hintText: AppString.email_hint,
                          ),
                          SizedBox(height: Get.height / 80),
                          inputField(
                            textInputType: TextInputType.number,
                            textfildcolor: AppColor.grey_color,
                            controller: customUI.mobile_controller,
                            icon: AppIcon.mobile,
                            iconheight: 10,
                            iconwidth: 10,
                            iconcolor: AppColor.grey_color,
                            hintText: AppString.phone_hint,
                          ),
                          SizedBox(height: Get.height / 80),
                        ],
                      ),
                    ),
                    Divider(color: AppColor.textfild_color),

                    //Upload Image or Video
                    SizedBox(height: Get.height / 50),
                    Text(AppString.upyourImage,style: TextStyle(fontSize: Get.width / 24,color: AppColor.grey_color,fontWeight: FontWeight.w500)),
                    SizedBox(height: Get.height / 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => customUI.pickImage(),
                            child: Column(
                              children: [
                                button(AppString.upImage),
                                Text(customUI.imagefile.value.toString()),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: Get.width / 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => customUI.pickVideo(),
                            child: Column(
                              children: [
                                button(AppString.upVideo),
                                Text(customUI.videofile.value.toString())
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height / 50),

                    //Url
                    inputField(
                      controller: customUI.urlController,
                      icon: AppIcon.returns,
                      iconheight: 10, iconwidth: 10,
                      iconcolor: AppColor.pink_color,
                      hintText: AppString.URl,
                    ),

                    SizedBox(height: Get.height / 50),

                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: customUI.isCheck.value,
                            onChanged: (val) => customUI.isCheckValue(val),
                            overlayColor: WidgetStatePropertyAll(AppColor.pink_color),
                            side: BorderSide(color: AppColor.pink_color, width: 2),
                            checkColor: AppColor.white_color,
                            activeColor: AppColor.pink_color,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(width: Get.width / 50),
                        Text(AppString.notarobot, style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w500, fontSize: Get.width * 0.04)),
                      ],
                    ),
                    SizedBox(height: Get.height / 50),
                    GestureDetector(onTap: () => customUI.submits(), child: button(AppString.submit)),
                    SizedBox(height: Get.height / 50),
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


