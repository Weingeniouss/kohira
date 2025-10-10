// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, deprecated_member_use, non_constant_identifier_names, avoid_print, must_be_immutable, strict_top_level_inference

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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/clarity.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/customorder.dart';
import 'package:kohira/controller/API/menu/others/drawer/Jewellery_list.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/subcetegroy/filter.dart';
import 'package:kohira/modal/menu/home/drawar/customJewellery/category_customorder.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/dropdown.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_icon.dart';
import '../../../../utils/widget/aapbar.dart';

class CustomJewellery extends StatefulWidget {

  const CustomJewellery({super.key});

  @override
  State<CustomJewellery> createState() => _CustomJewelleryState();
}

class _CustomJewelleryState extends State<CustomJewellery> {
  final customorder = Get.put(Customorder());
  final jewelleryfilter = Get.put(JewelleryList());
  final filtertab = Get.put(FilterController());
  final jewellery = Get.put(Jewelleryfilter());
  final clarity = Get.put(Clarity());

  var selectedCategory = Rxn<Category_Customorder>();
  var selectedSubcategory = Rxn<Category_Subcategory>();
  var selectedMetalType = Rxn<MetalType>();
  var selectedMetalStamp = Rxn<MetalStamp>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController subcategorySearchController = TextEditingController();
  final TextEditingController metalsearchcontoller = TextEditingController();
  final TextEditingController metalstampsearchcontoller = TextEditingController();
  final TextEditingController metalWeightController = TextEditingController();
  final TextEditingController metalBudgetController = TextEditingController();
  final TextEditingController selectedmetalValueController = TextEditingController();
  final TextEditingController minValueController = TextEditingController();
  final TextEditingController maxValueController = TextEditingController();

  // Define variables for your dropdown values
  final selectedMetalStampValue = Rxn<Map<String, dynamic>>();

  List<Map<String, dynamic>> stampvalue = [
    {"id": 1, "name": "All", "min": 0.0, "max": 15.0},
    {"id": 2, "name": "0.15-0.22", "min": 0.15, "max": 0.22},
    {"id": 3, "name": "0.23-0.29", "min": 0.23, "max": 0.29},
    {"id": 4, "name": "0.30-0.39", "min": 0.30, "max": 0.39},
    {"id": 5, "name": "0.40-0.49", "min": 0.40, "max": 0.49},
    {"id": 6, "name": "0.50-0.59", "min": 0.50, "max": 0.59},
    {"id": 7, "name": "0.60-0.69", "min": 0.60, "max": 0.69},
    {"id": 8, "name": "0.70-0.79", "min": 0.70, "max": 0.79},
    {"id": 9, "name": "0.80-0.89", "min": 0.80, "max": 0.89},
    {"id": 10, "name": "0.90-0.99", "min": 0.90, "max": 0.99},
    {"id": 11, "name": "1.00-1.49", "min": 1.00, "max": 1.49},
    {"id": 12, "name": "1.50-1.99", "min": 1.50, "max": 1.99},
    {"id": 13, "name": "2.00-2.99", "min": 2.00, "max": 2.99},
  ];

  // Function to handle stamp selection
  void onStampSelected(Map<String, dynamic>? selectedStamp) {
    if (selectedStamp != null) {
      selectedMetalStampValue.value = selectedStamp;

      // Auto-populate min and max values
      minValueController.text = selectedStamp['min'].toString();
      maxValueController.text = selectedStamp['max'].toString();
    } else {
      selectedMetalStampValue.value = null;
      minValueController.clear();
      maxValueController.clear();
    }
  }

  bool isCheck_center = false;
  bool isCheck_side_stone = false;

  String? _selectedSlug;

  void center(val){
    setState(() {
      isCheck_center = val;
    });
  }

   void side_stone(val){
    setState(() {
      isCheck_side_stone = val;
    });
  }

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
            final filter = jewellery.data.value?.data;
            return horizontalpadding(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 100),

                    //Jewelry Type
                    dropDown<Category_Customorder>(
                      searchController: searchController,
                      value: selectedCategory,
                      items: customorder.categories,
                      displayText: (category) => category.name,
                      hintText: 'Choose Jewelry Type',
                    ),

                    SizedBox(height: Get.height / 60),

                    //Choose Subcategory
                    (selectedCategory.value != null)
                        ? Column(
                          children: [
                            dropDown<Category_Subcategory>(
                               searchController: subcategorySearchController,
                               value: selectedSubcategory,
                               items: selectedCategory.value!.subcategory,
                               displayText: (subcategory) => subcategory.name,
                               hintText: 'Choose Subcategory',
                            ),
                            SizedBox(height: Get.height / 60),
                          ],
                        ) : SizedBox(),

                    //Metal Type
                    dropDown(
                      searchController: metalsearchcontoller,
                      value: selectedMetalType,
                      items: jewelleryfilter.metalTypes,
                      displayText: (metalType) => metalType.name,
                      hintText: 'Choose Metal Type',
                    ),

                    SizedBox(height: Get.height / 60),

                    //Metal Stamp
                    dropDown(
                      searchController: metalstampsearchcontoller,
                      value: selectedMetalStamp,
                      items: jewelleryfilter.metalStamp,
                      displayText: (metalType) => metalType.name,
                      hintText: 'Choose Metal Stamp',
                    ),

                    SizedBox(height: Get.height / 100),

                    //Weight
                    inputField(
                      controller: metalWeightController,
                      icon: AppIcon.earth,
                      iconheight: 10,
                      iconwidth: 10,
                      iconcolor: AppColor.pink_color,
                      hintText: 'Appx Metal Weight (gm)',
                    ),

                    //Budget
                    inputField(
                      controller: metalBudgetController,
                      icon: AppIcon.earth,
                      iconheight: 10,
                      iconwidth: 10,
                      iconcolor: AppColor.pink_color,
                      hintText: 'Budget',
                    ),

                   //Remark
                  Container(
                    height: Get.height / 9,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColor.textfild_color)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: Get.width * 0.04, color: AppColor.black_color),
                      maxLines: 100,
                      minLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            AppIcon.earth,
                            width: 20,
                            height: 20,
                            color: AppColor.pink_color,
                          ),
                        ),
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Remark',
                        hintStyle: TextStyle(color: AppColor.black_color,fontSize: Get.width / 27),
                        contentPadding: EdgeInsets.only(left: 8, right: 12, top: 16, bottom: 16),
                        filled: true,
                        fillColor: AppColor.white_color,
                        isDense: true, // Reduces the overall height
                      ),
                    ),
                  ),

                    SizedBox(height: Get.height / 50),

                    Text('Diamond And Gemstone Details',style: TextStyle(fontSize: Get.width / 24,color: AppColor.grey_color,fontWeight: FontWeight.w500)),

                    SizedBox(height: Get.height / 50),

                    //Center Stone
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: isCheck_center,
                            onChanged: (val) => center(val),
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            side: BorderSide(color: AppColor.black_color, width: 1),
                            checkColor: AppColor.white_color,
                            activeColor: AppColor.black_color,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(width: Get.width / 50),
                        Text(
                          'Center Stone',
                          style: TextStyle(
                            color: AppColor.black_color,
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height / 80),

                    Visibility(
                      visible: isCheck_center,
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
                                    final isSelected = filtertab.diamondtype.value == item.slug;
                                    return GestureDetector(
                                      onTap: () {
                                         setState((){
                                            filtertab.setDiamondType(item.slug);
                                          });
                                        },
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
                            Text('Color', style: TextStyle(fontSize: Get.width / 25, color: AppColor.black_color, fontWeight: FontWeight.w500)),
                            SizedBox(height: Get.height / 200),
                            Obx((){
                              return  SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: filter!.color.map((item) {
                                    final isSelected = filtertab.colortype.value == item.id.toString();
                                    return GestureDetector(
                                      onTap: () {
                                         setState((){
                                            filtertab.setColoeType(item.id.toString());
                                          });
                                        },
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
                            Text('Clarity', style: TextStyle(fontSize: Get.width / 25, color: AppColor.black_color, fontWeight: FontWeight.w500)),
                            SizedBox(height: Get.height / 200),
                            SizedBox(
                              height: Get.height / 20,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: clarity.clarity_data['data'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  final clar = clarity.clarity_data['data'][index];
                                  final String slug = clar['slug'];
                                  final bool isSelected = _selectedSlug == slug;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedSlug = isSelected ? null : slug;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 2),
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected ? AppColor.black_color : Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(Get.width / 50),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColor.white_color,
                                          borderRadius: BorderRadius.circular(Get.width / 80),
                                        ),
                                        child: Center(
                                          child: Text(
                                            clar['name'],
                                            style: TextStyle(
                                              color: AppColor.black_color,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: Get.height / 50),

                            dropDown<Map<String, dynamic>>(
                              color: AppColor.grey_color,
                              searchController: selectedmetalValueController,
                              value: selectedMetalStampValue, // Use .value to get the actual Map
                              items: stampvalue,
                              displayText: (stamp) => "${stamp['name']}",
                              hintText: 'Select Stamp',
                              onChanged: onStampSelected,
                            ),

                            SizedBox(height: Get.height / 200),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: inputField(
                                    readOnly: true,
                                    controller: minValueController,
                                    icon: AppIcon.earth,
                                    textfildcolor: AppColor.grey_color,
                                    iconheight: 10,
                                    iconwidth: 10,
                                    iconcolor: AppColor.grey_color,
                                    hintText: 'Min Value',
                                  ),
                                ),

                                SizedBox(width: Get.width / 20),
                                
                                Expanded(
                                  child: inputField(
                                    readOnly: true,
                                    controller: maxValueController,
                                    icon: AppIcon.earth,
                                    textfildcolor: AppColor.grey_color,
                                    iconheight: 10,
                                    iconwidth: 10,
                                    iconcolor: AppColor.grey_color,
                                    hintText: 'Max Value',
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
                            value: isCheck_side_stone,
                            onChanged: (val) => side_stone(val),
                            overlayColor: WidgetStatePropertyAll(AppColor.black_color),
                            side: BorderSide(color: AppColor.black_color, width: 1),
                            checkColor: AppColor.white_color,
                            activeColor: AppColor.black_color,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(width: Get.width / 50),
                        Text(
                          'Side Stone',
                          style: TextStyle(
                            color: AppColor.black_color,
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Get.height / 50),
                    Divider(color: AppColor.textfild_color),
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