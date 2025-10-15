// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, deprecated_member_use, non_constant_identifier_names, avoid_print, must_be_immutable, strict_top_level_inference, prefer_typing_uninitialized_variables, unnecessary_null_comparison

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

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/clarity.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/customorder.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/submit_custom_jewelley.dart';
import 'package:kohira/controller/API/menu/others/drawer/Jewellery_list.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/subcetegroy/filter.dart';
import 'package:kohira/modal/menu/category/subcategory/jewelleryfilter.dart';
import 'package:kohira/modal/menu/home/drawar/customJewellery/category_customorder.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/dropdown.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_icon.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/widget/RecaptchaWidget.dart';
import '../../../../utils/widget/aapbar.dart';
import '../../../../utils/widget/pop.dart';

class CustomJewellery extends StatefulWidget {

  const CustomJewellery({super.key});

  @override
  State<CustomJewellery> createState() => _CustomJewelleryState();
}

class _CustomJewelleryState extends State<CustomJewellery> {
  final String siteKey = "6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF";
  final String baseUrl = "https://next.weingenious.in";

  final customorder = Get.put(Customorder());
  final jewelleryfilter = Get.put(JewelleryList());
  final filtertab = Get.put(FilterController());
  final jewellery = Get.put(Jewelleryfilter());
  final clarity = Get.put(Clarity());
  final submit = Get.put(SubmitCustomJewelley());

  var selectedCategory = Rxn<Category_Customorder>();
  var selectedSubcategory = Rxn<Category_Subcategory>();
  var selectedMetalType = Rxn<MetalType>();
  var selectedMetalStamp = Rxn<MetalStamp>();
  var selectedShape = Rxn<BraceletSize>();
  var selectcolor =  Rxn<BraceletSize>();
  var selectedClarity = Rxn<ClarityItem>();

  var jwellery;

  // List<BraceletSize> listofshape = [];
  // List<BraceletSize> listofcolor = [];
  // List<ClarityItem> listofclarity = [];

  var listofshape = <BraceletSize>[].obs;
  var listofcolor = <BraceletSize>[].obs;
  var listofclarity = <ClarityItem>[].obs;

  var shape;
  var color;
  var claritys;

  var metalname;

  //image
  String? imagefile;
  String? videofile;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController subcategorySearchController = TextEditingController();
  final TextEditingController metalsearchcontoller = TextEditingController();
  final TextEditingController metalstampsearchcontoller = TextEditingController();
  final TextEditingController metalWeightController = TextEditingController();
  final TextEditingController metalBudgetController = TextEditingController();
  final TextEditingController metalremarkController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController selectedmetalValueController = TextEditingController();
  final TextEditingController minValueController = TextEditingController();
  final TextEditingController maxValueController = TextEditingController();
  final TextEditingController shapeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController clarityController = TextEditingController();

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
    setState(() {
      if (selectedStamp != null) {
        selectedMetalStampValue.value = selectedStamp;
        metalname = selectedStamp['name'];
        minValueController.text = selectedStamp['min'].toString();
        maxValueController.text = selectedStamp['max'].toString();
      } else {
        selectedMetalStampValue.value = null;
        metalname = '';
        minValueController.clear();
        maxValueController.clear();
      }
    });
  }

  // void onStampSelected(Map<String, dynamic>? selectedStamp) {
  //   if (selectedStamp != null) {
  //     // selectedMetalStampValue.value = selectedStamp;
  //     metalnane = selectedStamp['name'];
  //     // Auto-populate min and max values
  //     minValueController.text = selectedStamp['min'].toString();
  //     maxValueController.text = selectedStamp['max'].toString();
  //   } else {
  //     metalnane = '';
  //     // selectedMetalStampValue.value = null;
  //     minValueController.clear();
  //     maxValueController.clear();
  //   }
  // }

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

  // For Image Upload
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      ).catchError((error) {
        print('Error in pickImage: $error');
        return null;
      });

      if (image != null && mounted) {
        setState(() {
          imagefile = image.name;
        });
        print('Selected image: ${image.path}');
        print('Image name: ${image.name}');
      } else if (image == null) {
        print('No image selected or selection cancelled');
      }
    } catch (e) {
      print('Error picking image: $e');
      // Show error message only if the widget is still mounted
      if (mounted) {
        ToastificationError.Error("Failed to pick image");
      }
    }
  }

  // For Video Upload
  Future<void> _pickVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null && mounted) {

        setState(() {
          videofile= video.name;
        });
        // Handle the selected video
        print('Selected video: ${video.path}');
        // Check file size
        final file = File(video.path);
        final sizeInMB = await file.length() / (1024 * 1024);

        if (sizeInMB > 100) {
          // Get.snackbar('Error', 'Video size too large (max 100MB)');
          ToastificationError.Error("'Error', Video size too large (max 100MB)}");
          return;
        }

        // You can upload the video to your server here
      }
    } catch (e) {
      print('Error picking video: $e');
      Get.snackbar('Error', 'Failed to pick video');
    }
  }

  void side_Stone_bottambar() {
    isCheck_side_stone = true;
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColor.white_color,
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          final filter = jewellery.data.value?.data;

          return Container(
            height: Get.height * 0.7,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: Get.height / 50),

                      // Dropdown for shapes
                      dropDown<BraceletSize>(
                        searchController: shapeController,
                        value: selectedShape,
                        items: filter?.shape ?? [],
                        displayText: (item) => item?.name ?? 'Select Shape',
                        hintText: 'Choose Shape',
                        onChanged: (BraceletSize? selectedItem) {
                          if (selectedItem != null) {
                            selectedShape.value = selectedItem;
                            filtertab.setDiamondType(selectedItem.slug,selectedItem.id.toString());
                          }
                        },
                      ),

                      SizedBox(height: Get.height / 60),

                      // Dropdown for Color
                      dropDown<BraceletSize>(
                        searchController: colorController,
                        value: selectcolor,
                        items: filter?.color ?? [],
                        displayText: (item) => item?.name ?? 'Select Color',
                        hintText: 'Choose Color',
                        onChanged: (BraceletSize? selectedItem) {
                          if (selectedItem != null) {
                            selectcolor.value = selectedItem;
                            filtertab.setColoeType(selectedItem.slug,selectedItem.id.toString());
                          }
                        },
                      ),

                      SizedBox(height: Get.height / 60),

                      // Dropdown for clarity
                      dropDown<ClarityItem>(
                        searchController: clarityController,
                        value: selectedClarity,
                        items: clarity.clarityData,
                        displayText: (item) => item?.name ?? 'Select Clarity',
                        hintText: 'Choose Clarity',
                        onChanged: (ClarityItem? selectedItem) {
                          if (selectedItem != null) {
                            selectedClarity.value = selectedItem;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (selectedShape.value != null && selectcolor.value != null && selectedClarity.value != null) {
                        listofshape.add(selectedShape.value!);
                        listofcolor.add(selectcolor.value!);
                        listofclarity.add(selectedClarity.value!);
                        print("Shapes: ${listofshape.map((e) => e.name).toList()}");
                        print("Colors: ${listofcolor.map((e) => e.name).toList()}");
                        print("Clarity: ${listofclarity.map((e) => e.name).toList()}");

                        // Clear selections after adding
                        selectedShape.value = null;
                        selectcolor.value = null;
                        selectedClarity.value = null;
                      } else {
                        print("Please select shape, color, and clarity first!");
                      }
                      Get.back();
                    },
                    child: button(AppString.add),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  bool isCheck = false;
  String? recaptchaToken;

  void isCheckValue(bool? val) {
    if (val == true) {
      _showRecaptchaVerification();
    } else {
      setState(() {
        isCheck = false;
        recaptchaToken = null;
      });
    }
  }

  void _showRecaptchaVerification() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: AppColor.white_color,
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          height: Get.height * 0.6,
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Optional header or spacing
              SizedBox(height: 16),
              // Expanded must be direct child of Column (a Flex)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: RecaptchaWidget(
                    siteKey: siteKey,
                    baseUrl: baseUrl,
                    onVerified: (String token) {
                      if (kDebugMode) {
                        print('✅ reCAPTCHA Token: $token');
                      }
                      Navigator.pop(context);
                      setState(() {isCheck = true;recaptchaToken = token;});
                      print('recapcha :- $recaptchaToken');
                      ToastificationSuccess.Success('Verification completed!');
                    },
                    onError: () {
                      if (kDebugMode) {
                        print('❌ reCAPTCHA Error');
                      }
                      Navigator.pop(context);
                      setState(() {isCheck = false;recaptchaToken = null;});
                      ToastificationError.Error('Verification failed. Please try again.');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      if (recaptchaToken == null) {
        setState(() => isCheck = false);
      }
    });
  }

  void side_Stone_bottambar_update({
    required int index,
    required Rxn<BraceletSize> selectedShape_edit,
    required Rxn<BraceletSize> selectcolor_edit,
    required Rxn<ClarityItem> selectedClarity_edit,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColor.white_color,
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          final filter = jewellery.data.value?.data;
          return Container(
            height: Get.height * 0.7,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: Get.height / 50),

                      // Dropdown for shapes - Use the passed value
                      dropDown<BraceletSize>(
                        searchController: shapeController,
                        value: selectedShape_edit,
                        items: filter?.shape ?? [],
                        displayText: (item) => item?.name ?? 'Select Shape',
                        hintText: 'Choose Shape',
                        onChanged: (BraceletSize? selectedItem) {
                          selectedShape_edit.value = selectedItem;
                        },
                      ),

                      SizedBox(height: Get.height / 60),

                      // Dropdown for Color - Use the passed value
                      dropDown<BraceletSize>(
                        searchController: colorController,
                        value: selectcolor_edit,
                        items: filter?.color ?? [],
                        displayText: (item) => item?.name ?? 'Select Color',
                        hintText: 'Choose Color',
                        onChanged: (BraceletSize? selectedItem) {
                          selectcolor_edit.value = selectedItem;
                        },
                      ),

                      SizedBox(height: Get.height / 60),

                      // Dropdown for clarity - Use the passed value
                      dropDown<ClarityItem>(
                        searchController: clarityController,
                        value: selectedClarity_edit,
                        items: clarity.clarityData,
                        displayText: (item) => item?.name ?? 'Select Clarity',
                        hintText: 'Choose Clarity',
                        onChanged: (ClarityItem? selectedItem) {
                          selectedClarity_edit.value = selectedItem;
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (selectedShape_edit.value != null && selectcolor_edit.value != null && selectedClarity_edit.value != null) {

                        // Update the existing items in the lists
                        listofshape[index] = selectedShape_edit.value!;
                        listofcolor[index] = selectcolor_edit.value!;
                        listofclarity[index] = selectedClarity_edit.value!;

                        print("Updated Shapes: ${listofshape.map((e) => e.name).toList()}");
                        print("Updated Colors: ${listofcolor.map((e) => e.name).toList()}");
                        print("Updated Clarity: ${listofclarity.map((e) => e.name).toList()}");

                        // Clear the edit values
                        selectedShape_edit.value = null;
                        selectcolor_edit.value = null;
                        selectedClarity_edit.value = null;
                      } else {
                        print("Please select shape, color, and clarity first!");
                      }
                      Get.back();
                    },
                    child: button(AppString.update),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void onCategoryChanged(Category_Customorder? newCategory) {
    selectedCategory.value = newCategory;
    selectedSubcategory.value = null;
    subcategorySearchController.clear();
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
            String jewelryTypeValue = selectedCategory.value?.id.toString() ?? selectedCategory.value?.name.toString() ?? '';
            String subcategoryIdValue = selectedSubcategory.value?.id.toString() ?? selectedSubcategory.value?.name.toString() ?? '';
            String metalTypeValue = selectedMetalType.value?.id.toString() ?? selectedMetalType.value?.name.toString() ?? '';
            String metalStampValue = selectedMetalStamp.value?.id.toString() ?? selectedMetalStamp.value?.name.toString() ?? '';

            var selectedShapeId;
            var colors;
            var clarityy;

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
                      onChanged: onCategoryChanged,
                    ),

                    SizedBox(height: Get.height / 60),

                    // Choose Subcategory
                    Obx(() {
                      if (selectedCategory.value == null || selectedCategory.value!.subcategory == null || selectedCategory.value!.subcategory!.isEmpty) {
                        return SizedBox();
                      }

                      // Ensure the current subcategory value exists in the new list
                      final currentSubcategory = selectedSubcategory.value;
                      if (currentSubcategory != null) {
                        final exists = selectedCategory.value!.subcategory.any((subcat) => subcat.id == currentSubcategory.id);
                        if (!exists) {
                          selectedSubcategory.value = null;
                        }
                      }

                      return Column(
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
                      );
                    }),

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
                      textInputType: TextInputType.number,
                      controller: metalWeightController,
                      icon: AppIcon.earth,
                      iconheight: 10,
                      iconwidth: 10,
                      iconcolor: AppColor.pink_color,
                      hintText: 'Appx Metal Weight (gm)',
                    ),

                    //Budget
                    inputField(
                      textInputType: TextInputType.number,
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
                        controller: metalremarkController,
                        style: TextStyle(fontSize: Get.width * 0.04, color: AppColor.black_color),
                        maxLines: 100,
                        minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(AppIcon.earth, width: 20, height: 20, color: AppColor.pink_color),
                          ),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Remark',
                          hintStyle: TextStyle(color: AppColor.black_color,fontSize: Get.width / 27),
                          contentPadding: EdgeInsets.only(left: 8, right: 12, top: 16, bottom: 16),
                          filled: true,
                          fillColor: AppColor.white_color,
                          isDense: true,
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

                    //isCheck_center == True after Center Stone = true then ....
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
                                      if (isSelected) {
                                        selectedShapeId = item.id.toString();
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          setState((){
                                            filtertab.setDiamondType(item.slug,item.id.toString());
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
                                      if (isSelected) {
                                        colors = item.id.toString();
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          setState((){
                                            filtertab.setColoeType(item.id.toString(),item.slug);
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
                                  clarityy = clar['id'];
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

                            //Select Stamp
                            dropDown<Map<String, dynamic>>(
                              color: AppColor.grey_color,
                              searchController: selectedmetalValueController,
                              value: selectedMetalStampValue,
                              items: stampvalue,
                              displayText: (stamp) => "${stamp['name']}",
                              hintText: 'Select Stamp',
                              onChanged: onStampSelected,
                            ),

                            SizedBox(height: Get.height / 200),

                            //Min Value and max value
                            Row(
                              children: [

                                //Min Value
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

                                  //max value
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
                            onChanged: (val) {
                              side_stone(val);
                              (isCheck_side_stone == true) ? side_Stone_bottambar() : isCheck_side_stone == false;
                              (listofshape.isEmpty && listofclarity.isEmpty && listofcolor.isEmpty) ? isCheck_side_stone == false : isCheck_side_stone == true;
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

                    SizedBox(height: Get.height / 60),

                    //isCheck_isCheck_side_stone == True after isCheck_side_stone = true then ....
                    (listofshape.isNotEmpty && listofclarity.isNotEmpty && listofcolor.isNotEmpty) ? Visibility(
                      visible: isCheck_side_stone,
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
                                  SizedBox(width: Get.width / 4,child: Text('Shape',style: TextStyle(fontWeight: FontWeight.w600))),
                                  SizedBox(width: Get.width / 5,child: Text('Color',style: TextStyle(fontWeight: FontWeight.w600))),
                                  SizedBox(width: Get.width / 4.5,child: Text('Clarity',style: TextStyle(fontWeight: FontWeight.w600))),
                                  SizedBox(width: Get.width / 6,child: Text('Action',style: TextStyle(fontWeight: FontWeight.w600))),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: listofshape.length,
                              itemBuilder: (context, index) {
                                shape = listofshape[index];
                                color = listofcolor[index];
                                claritys = listofclarity[index];
                                return Container(
                                  padding: EdgeInsetsGeometry.symmetric(horizontal: Get.width / 50),
                                  decoration: BoxDecoration(color: AppColor.white_color),
                                  child: Row(
                                    children: [
                                      SizedBox(width: Get.width / 4,child: Text(shape.name,style: TextStyle(fontWeight: FontWeight.w600))),
                                      SizedBox(width: Get.width / 25),
                                      SizedBox(width: Get.width / 10,child: Text(color.name,style: TextStyle(fontWeight: FontWeight.w600))),
                                      SizedBox(width: Get.width / 10),
                                      SizedBox(width: Get.width / 8,child: Text(claritys.name.toString(),style: TextStyle(fontWeight: FontWeight.w600))),
                                      SizedBox(width: Get.width / 13),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            child: SvgPicture.asset(AppIcon.edit,width: 15,height: 15,color: AppColor.grey_color),
                                            onTap: (){
                                              side_Stone_bottambar_update(
                                                index: index,
                                                selectedShape_edit: Rxn<BraceletSize>(listofshape[index]),
                                                selectcolor_edit: Rxn<BraceletSize>(listofcolor[index]),
                                                selectedClarity_edit: Rxn<ClarityItem>(listofclarity[index]),
                                              );
                                            },
                                          ),
                                          SizedBox(width: Get.width / 30),
                                          GestureDetector(
                                            onTap: (){
                                              listofshape.removeAt(index);
                                              listofcolor.removeAt(index);
                                              listofclarity.removeAt(index);
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
                                  onTap: () {
                                    side_Stone_bottambar();
                                  },
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
                    ) : SizedBox(),
                    (listofshape.isNotEmpty && listofclarity.isNotEmpty && listofcolor.isNotEmpty) ? SizedBox(height: Get.height / 50) : SizedBox(),
                    Divider(color: AppColor.textfild_color),

                    SizedBox(height: Get.height / 50),
                    Text('Upload Your Image',style: TextStyle(fontSize: Get.width / 24,color: AppColor.grey_color,fontWeight: FontWeight.w500)),
                    SizedBox(height: Get.height / 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Column(
                              children: [
                                button('Upload Image'),
                                Text(imagefile ?? "No image selected"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: Get.width / 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pickVideo();
                            },
                            child: Column(
                              children: [
                                button('Upload Video'),
                                Text(videofile ?? 'No image selected')
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height / 50),

                    //Url
                    inputField(
                      controller: urlController,
                      icon: AppIcon.earth,
                      iconheight: 10,
                      iconwidth: 10,
                      iconcolor: AppColor.pink_color,
                      hintText: 'Enter URL',
                    ),
                    SizedBox(height: Get.height / 50),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: isCheck,
                            onChanged: (val) => isCheckValue(val),
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
                        Text(
                          AppString.notarobot,
                          style: TextStyle(
                            color: AppColor.pink_color,
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height / 50),

                    GestureDetector(
                      onTap: (){
                        submit.submitCustomJewelley(
                          jewelrytype: jewelryTypeValue,
                          appxmetalWgt: metalWeightController.text,
                          budget: metalBudgetController.text,
                          centerStoneSelect: 'true',
                          password: '',
                          confirm_password: '',
                          diamMaxSelectedCarat: maxValueController.text,
                          diamMinSelectedCarat: minValueController.text,
                          currency_id: '',
                          email: '',
                          firstname: '',
                          lastname: '',
                          engraving: '',
                          metalstamp: metalStampValue,
                          metaltype: metalTypeValue,
                          mobileno: '',
                          referredby: '',
                          ringsize: '',
                          sideStoneSelect: '',
                          subcategory_id: subcategoryIdValue,
                          remark: metalremarkController.text,
                          selectedDiamCarat: metalname,
                          selectedDiamClarity: clarityy.toString(),
                          selectedDiamColor: colors,
                          selectedDiamShape: selectedShapeId,
                          userid: '',
                          url: urlController.text,
                          token: tokans,
                          shape: [shape.name.toString()],
                          color: [color.name.toString()],
                          clarity: [claritys.name.toString()],
                        );

                        print('jewelryTypeValue :- $jewelryTypeValue');
                        print('subcategoryIdValue :- $subcategoryIdValue');
                        print('metalTypeValue :- $metalTypeValue');
                        print('metalStampValue :- $metalStampValue');
                        print('selectedDiamShape: $selectedShapeId');
                        print('selectedDiamCarat: $metalname');
                        print('selectedDiamColor: $colors');
                        print('selectedDiamClarity: $clarityy');
                      },
                      child: button(AppString.submit),
                    ),

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