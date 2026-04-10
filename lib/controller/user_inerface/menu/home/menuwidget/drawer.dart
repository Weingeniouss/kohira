// ignore_for_file: dead_null_aware_expression, unused_field, strict_top_level_inference, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kohira/controller/API/menu/account/profiledetails.dart';
import '../../../../../modal/menu/category/subcategory/jewelleryfilter.dart';
import '../../../../../modal/menu/home/drawar/customJewellery/category_customorder.dart';
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_color.dart';
import '../../../../../view/utils/app_constants.dart';
import '../../../../../view/utils/widget/button.dart';
import '../../../../../view/utils/widget/dropdown.dart';
import '../../../../API/menu/category/subcategrory/jewelleryfilter.dart';
import '../../../../API/menu/home/drawar/customJewellery/clarity.dart';
import '../../../../API/menu/home/drawar/customJewellery/customorder.dart';
import '../../../../API/menu/home/drawar/customJewellery/submit_custom_jewelley.dart';
import '../../../../API/menu/others/drawer/Jewellery_list.dart';
import '../../categroy/subcetegroy/filter.dart';

class DrawerInterface extends GetxController{
  var allJewellery = false.obs;
  var collection = false.obs;
  var metaltype = false.obs;
  var price = false.obs;

  void selectcategoryitem(categoryItem,filteredCategories) {
    for (var item in filteredCategories) {
      if (item != categoryItem) {
        item.isExpanded = false;
      }
    }
    categoryItem.isExpanded = !categoryItem.isExpanded;
    metaltype.value = false;
    price.value = false;
    collection.value = false;
  }

  void selectedJewellery() {
    allJewellery.value =! allJewellery.value;
    metaltype.value = false;
    price.value = false;
    collection.value = false;
  }

  void collectionTab() {
    collection.value =! collection.value;
    metaltype.value = false;
    price.value = false;
    allJewellery.value = false;
  }

  void metaltypeTab() {
    metaltype.value =! metaltype.value;
    collection.value = false;
    price.value = false;
    allJewellery.value = false;
  }

  void priceTab() {
    price.value =! price.value;
    metaltype.value = false;
    collection.value = false;
    allJewellery.value = false;
  }
}

class CustomJewelleryUI extends GetxController{
  final String siteKey = "6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF";
  final String baseUrl = "https://next.weingenious.in/";

  final customorder = Get.put(Customorder());
  final jewelleryfilter = Get.put(JewelleryList());
  final filtertab = Get.put(FilterController());
  final jewellery = Get.put(Jewelleryfilter());
  final clarity = Get.put(Clarity());
  final submit = Get.put(SubmitCustomJewelley());
  final profile = Get.put(ProfiledetailsController());

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
   TextEditingController firstname_controller = TextEditingController();
   TextEditingController lastname_controller = TextEditingController();
   TextEditingController mobile_controller = TextEditingController();
   TextEditingController email_controller = TextEditingController();

  var selectedCategory = Rxn<Category_Customorder>();
  var selectedSubcategory = Rxn<Category_Subcategory>();
  var selectedMetalType = Rxn<MetalType>();
  var selectedMetalStamp = Rxn<MetalStamp>();
  var selectedShape = Rxn<BraceletSize>();
  var selectcolor =  Rxn<BraceletSize>();
  var selectedClarity = Rxn<ClarityItem>();

  @override
  void onInit() {
    super.onInit();

    // Initialize with empty values
    firstname_controller = TextEditingController();
    lastname_controller = TextEditingController();
    email_controller = TextEditingController();
    mobile_controller = TextEditingController();

    loadData();
  }

  void loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await profile.profiledetailscall();

      // Update controllers after profile data is loaded
      if (profile.data['data'] != null) {
        final info = profile.data['data'];
        firstname_controller.text = info['firstname']?.toString() ?? '';
        lastname_controller.text = info['lastname']?.toString() ?? '';
        email_controller.text = info['email']?.toString() ?? '';
        mobile_controller.text = info['mobileno']?.toString() ?? '';
      }
    });
  }

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
  var imagefile = Rx<File?>(null);
  var videofile = Rx<File?>(null);

  //Bottam
  var isCheck_center = false.obs;
  var isCheck_side_stone = false.obs;

  var tokanRecaptcha = '';

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

  //I,M Robort
  var isCheck = false.obs;
  String? recaptchaToken;

  // void isCheckValue(bool? val) {
  //   if (val == true) {
  //     _verifyRecaptcha();
  //     isCheck.value = true;
  //   } else {
  //     isCheck.value = false;
  //   }
  // }

  void isCheckValue(bool? val) async {
    if (val == true) {
      bool verified = await _verifyRecaptcha();
      isCheck.value = verified;
    } else {
      isCheck.value = false;
    }
  }

  static const platform = MethodChannel('com.example.recaptcha');
  String _verificationStatus = 'Not Verified';

  // Future<void> _verifyRecaptcha() async {
  //   try {
  //     final String token = await platform.invokeMethod('verifyRecaptcha');
  //     _verificationStatus = 'Verified! Token: ${token.substring(0, 20)}...';
  //     print('Full reCAPTCHA Token: $token');
  //   } on PlatformException catch (e) {
  //     _verificationStatus = 'Failed: ${e.message}';
  //   }
  // }

  Future<bool> _verifyRecaptcha() async {
    try {
      final String token = await platform.invokeMethod('verifyRecaptcha');
      _verificationStatus = 'Verified! Token: ${token.substring(0, 20)}...';
      tokanRecaptcha = token;
      print('Full reCAPTCHA Token: $token');
      return true;
    } on PlatformException catch (e) {
      _verificationStatus = 'Failed: ${e.message}';
      print('Recaptcha failed: ${e.message}');
      return false;
    } catch (e) {
      _verificationStatus = 'Error: $e';
      print('Unexpected error: $e');
      return false;
    }
  }

  // Function to handle stamp selection
  void onStampSelected(Map<String, dynamic>? selectedStamp) {
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
      update();
  }


  var selectedSlug = ''.obs;

  void center(val){
    isCheck_center.value = val;
  }

  void side_stone(val){
    isCheck_side_stone.value = val;
  }

  // For Image Upload
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagefile.value = File(pickedFile.path);
    }
  }

  // For Video Upload
  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videofile.value = File(pickedFile.path);
    }
  }

  void side_Stone_bottambar(context) {
    isCheck_side_stone.value = true;
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
                        displayText: (item) => item.name ?? 'Select Shape',
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
                        displayText: (item) => item.name ?? 'Select Color',
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
                        displayText: (item) => item.name ?? 'Select Clarity',
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
                      covariantoflist();
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

  void side_Stone_bottambar_update({
    required int index,
    required Rxn<BraceletSize> selectedShape_edit,
    required Rxn<BraceletSize> selectcolor_edit,
    required Rxn<ClarityItem> selectedClarity_edit,
    context
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
                        displayText: (item) => item.name ?? 'Select Shape',
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
                        displayText: (item) => item.name ?? 'Select Color',
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
                        displayText: (item) => item.name ?? 'Select Clarity',
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

   void shape_add(item){
     filtertab.setDiamondType(item.slug,item.id.toString());
     update();
   }

   void color_add(item){
     filtertab.setColoeType(item.id.toString(),item.slug);
     update();
   }

   void clariy_add(isSelected,slug){
     selectedSlug.value = (isSelected ? null : slug)!;
     update();
   }

  void onCategoryChanged(Category_Customorder? newCategory) {
    selectedCategory.value = newCategory;
    selectedSubcategory.value = null;
    subcategorySearchController.clear();
  }

  void covariantoflist(){
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
  }

  late String jewelryTypeValue = selectedCategory.value?.id.toString() ?? selectedCategory.value?.name.toString() ?? '';
  late String subcategoryIdValue = selectedSubcategory.value?.id.toString() ?? selectedSubcategory.value?.name.toString() ?? '';
  late String metalTypeValue = selectedMetalType.value?.id.toString() ?? selectedMetalType.value?.name.toString() ?? '';
  late String metalStampValue = selectedMetalStamp.value?.id.toString() ?? selectedMetalStamp.value?.name.toString() ?? '';

  var selectedShapeId = ''.obs;
  var colors = ''.obs;
  var clarityy = ''.obs;

  void submits(){
    submit.submitCustomJewelley(
      captcha: tokanRecaptcha,
      userid: profile.data['data']['userid'].toString(),
      jewelrytype: selectedCategory.value?.id.toString() ?? selectedCategory.value?.name.toString() ?? '',
      appxmetalWgt: metalWeightController.text,
      budget: metalBudgetController.text,
      centerStoneSelect: 'true',
      diamMaxSelectedCarat: maxValueController.text,
      diamMinSelectedCarat: minValueController.text,
      email: email_controller.text,
      firstname: firstname_controller.text,
      lastname: lastname_controller.text,
      metalstamp: selectedMetalStamp.value?.id.toString() ?? selectedMetalStamp.value?.name.toString() ?? '',
      metaltype: selectedMetalType.value?.id.toString() ?? selectedMetalType.value?.name.toString() ?? '',
      mobileno: mobile_controller.text,
      subcategory_id: selectedSubcategory.value?.id.toString() ?? selectedSubcategory.value?.name.toString() ?? '',
      remark: metalremarkController.text,
      selectedDiamCarat: metalname,
      selectedDiamClarity: clarityy.value.toString(),
      selectedDiamColor: colors.value,
      selectedDiamShape: selectedShapeId.value,
      url: urlController.text,
      token: tokans,
      shape: [shape.name.toString()],
      color: [color.name.toString()],
      clarity: [claritys.name.toString()],
      image: imagefile.value,
      video: videofile.value,
    );

    print('jewelryTypeValue :- $jewelryTypeValue');
    print('subcategoryIdValue :- $subcategoryIdValue');
    print('jewelryTypeValue :- $jewelryTypeValue');
    print('subcategoryIdValue :- $subcategoryIdValue');
    print('metalTypeValue :- $metalTypeValue');
    print('metalStampValue :- $metalStampValue');
    print('selectedDiamShape: $selectedShapeId');
    print('selectedDiamCarat: $metalname');
    print('selectedDiamColor: $colors');
    print('selectedDiamClarity: $clarityy');
    print('captcha: $tokanRecaptcha');
    print('UserId:- ${profile.data['data']['userid'].toString()}');
  }
}