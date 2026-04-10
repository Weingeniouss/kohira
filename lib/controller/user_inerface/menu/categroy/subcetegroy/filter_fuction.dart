
// ignore_for_file: unused_element, avoid_print, deprecated_member_use, strict_top_level_inference, prefer_typing_uninitialized_variables, non_constant_identifier_names

//Short
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/subcetegroy/filter.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/subcetegroy/selectsort.dart';
import 'package:lottie/lottie.dart';
import '../../../../../view/screen/menu/home/menuwidget/drawer.dart';
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_color.dart';
import '../../../../../view/utils/app_icon.dart';
import '../../../../../view/utils/app_json.dart';
import '../../../../../view/utils/widget/horizontalpading.dart';
import '../../../../API/menu/category/subcategrory/filtercategory.dart';
import '../../../../API/menu/category/subcategrory/jewelleryfilter.dart';
import '../../../../API/menu/category/subcategrory/subCategrory.dart';
import '../../../../API/menu/others/drawer/Jewellery_list.dart';

class Storebay {
  final subcategrory = Get.put(Subcategrory());
  final selected = Get.put(SelectedSort());
  void storebay(context, {required String subcategrorys, required String subcategory_slug}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Get.width / 20),
              topRight: Radius.circular(Get.width / 20),
            ),
          ),
          height: Get.height * 0.25,
          width: Get.width,
          child: Column(
            children: [
              SizedBox(height: Get.height / 80),
              SizedBox(
                width: Get.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: Get.width / 50),
                    Container(color: AppColor.white_color),
                    Text(AppString.filter, style: TextStyle(fontSize: Get.width / 22)),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        color: AppColor.white_color,
                        padding: EdgeInsets.only(left: 50),
                        child: Icon(Icons.cancel_outlined, color: AppColor.graycolor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height / 80),
              Divider(color: AppColor.graycolor),
              SizedBox(height: Get.height / 80),

              /// filter options
              horizontalpadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Low To High
                    GestureDetector(
                      onTap: () {
                        selected.selectedSort.value = 'asc';
                        subcategrory.subcategroryuser(
                          sort: 'asc',
                          order_column: 'setting_price',
                          category_slug: subcategrorys,
                          subcategory_slug: subcategory_slug,
                        );
                        Get.back(); // keep open if you want to see highlight
                      },
                      child: Obx(() => Container(
                        color: AppColor.white_color,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text(
                          'Price (Low To High)',
                          style: TextStyle(
                            fontSize: Get.width / 26,
                            color: selected.selectedSort.value == 'asc' ? AppColor.pink_color : AppColor.black_color,
                          ),
                        ),
                      ),
                      ),
                    ),

                    Divider(color: AppColor.textfild_color),

                    /// High To Low
                    GestureDetector(
                      onTap: () {
                        selected.selectedSort.value = 'desc';
                        subcategrory.subcategroryuser(
                          sort: 'desc',
                          order_column: 'setting_price',
                          category_slug: subcategrorys,
                          subcategory_slug: subcategory_slug,
                        );
                        Get.back();
                      },
                      child: Obx(() => Container(
                        color: AppColor.white_color,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text(
                          'Price (High To Low)',
                          style: TextStyle(
                            fontSize: Get.width / 26,
                            color: selected.selectedSort.value == 'desc' ? AppColor.pink_color : AppColor.black_color,
                          ),
                        ),
                      ),
                      ),
                    ),
                    Divider(color: AppColor.textfild_color),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

//Filter
class ShowBottam {
  final jewellery = Get.put(Jewelleryfilter());
  final category = Get.put(JewelleryFilterCategory());
  final subcategrory = Get.put(Subcategrory());
  final filtertab = Get.put(FilterController());
  final jewelleryfilter = Get.put(JewelleryList());

  var isSelectedlatter;

  Widget jewelleryColorContainer(String name){
    switch (name) {
      case 'White Gold':
        return SinglContainer(size: 25, singlcolor: AppColor.graycolor);
      case 'Rose Gold':
        return SinglContainer(size: 25, singlcolor: AppColor.rosegoldcolor);
      case 'Yellow Gold':
        return SinglContainer(size: 25, singlcolor: Colors.amber);
      case 'Yellow Gold And White Gold':
        return MyCustomContainer(size: 25, firstColor: Colors.amber, secondColor: AppColor.graycolor);
      case 'Rose Gold and White Gold':
        return MyCustomContainer(size: 25, firstColor: AppColor.rosegoldcolor, secondColor: AppColor.graycolor);
      case 'yellow gold rose gold':
        return MyCustomContainer(size: 25, firstColor: Colors.amber, secondColor: AppColor.rosegoldcolor);
      default:
        return Container();
    }
  }


  void showbottam(BuildContext context, {
    required String category_slug,
    required String subcategrorys,
    required String subcategrorysname,
    required Function(String) onCategoryNameChanged,
  }) {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(MediaQuery.of(context).size.width / 20))),
      builder: (BuildContext context) {
        final height = MediaQuery.of(context).size.height;
        return Obx(() {

          if (jewellery.isLoading.value) {
            return Container(height: height * 0.7, color: AppColor.white_color, child: Center(child: Lottie.asset(AppJson.loading2)));
          }
          final filter = jewellery.data.value?.data;
          final categorydata = category.filterData.value;

          // Handle null cases more gracefully
          if (filter == null || categorydata == null) {
            return Container(height: height * 0.7, color: AppColor.white_color, child: Center(child: Text("No filter data found.")));
          }

          Color hexToColor(String? colorString) {
            if (colorString == null || colorString.isEmpty) {
              return Colors.transparent; // fallback color
            }

            // Handle named colors or slugs
            final predefined = {
              'white-gold': const Color(0xFFD8D8D8),
              'yellow-gold': const Color(0xFFFFD700),
              'rose-gold': const Color(0xFFB76E79),
              'silver': const Color(0xFFC0C0C0),
              'platinum': const Color(0xFFE5E4E2),
            };

            if (predefined.containsKey(colorString)) {
              return predefined[colorString]!;
            }

            try {
              // Handle hex string like "#FFFFFF" or "FFFFFF"
              String hex = colorString.replaceAll("#", "");
              if (hex.length == 6) hex = "FF$hex"; // add alpha if missing
              return Color(int.parse(hex, radix: 16));
            } catch (e) {
              return Colors.transparent; // fallback if parsing fails
            }
          }

          return SafeArea(
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.80,
                  maxChildSize: 0.90,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      height: height * 0.7,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColor.white_color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(MediaQuery.of(context).size.width / 20),
                          topRight: Radius.circular(MediaQuery.of(context).size.width / 20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          SizedBox(height: Get.height / 80),
                          SizedBox(
                            width: Get.width / 1.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: Get.width / 25),
                                Container(padding: EdgeInsets.only(left: 20),color: AppColor.white_color),
                                Text(AppString.filter, style: TextStyle(fontSize: Get.width / 22)),
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 80,top: 10,bottom: 10),
                                    color: AppColor.white_color,
                                    child: SvgPicture.asset(AppIcon.close),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: AppColor.graycolor),
                          SizedBox(height: Get.height / 80),
                          horizontalpadding(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  //Metal Stamps
                                  Text(AppString.metalstamp, style: TextStyle(fontSize: Get.width / 27, color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                                  SizedBox(height: Get.height / 100),
                                  Obx(() => Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: filter.metalStamp.map((item) {
                                      final isSelected = filtertab.metalstapid.value == item.slug.toString();
                                      return GestureDetector(
                                        onTap: () => filtertab.setMetalStamp(item.slug.toString()),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppColor.pink_color.withOpacity(0.1) : AppColor.white_color,
                                            border: Border.all(color: isSelected ? AppColor.pink_color : AppColor.textfild_color),
                                            borderRadius: BorderRadius.circular(Get.width / 50),
                                          ),
                                          child: Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: Get.width / 30,
                                              color: isSelected ? AppColor.pink_color : AppColor.black_color,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )),

                                  //Metal Tyap
                                  SizedBox(height: Get.height / 50),
                                  Text(AppString.metaltaype, style: TextStyle(fontSize: Get.width / 27, color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                                  SizedBox(height: Get.height / 100),
                                  // Obx(() => Wrap(
                                  //   spacing: 8,
                                  //   runSpacing: 8,
                                  //   children: filter.metalType.map((item) {
                                  //     final isSelected = filtertab.selectedMetalType.value == item.slug;
                                  //     return GestureDetector(
                                  //       onTap: () => filtertab.setMetalType(item.slug),
                                  //       child: Container(
                                  //         padding: EdgeInsets.all(2),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(Get.width / 70),
                                  //           border: Border.all(color: isSelected ? hexToColor(item.slug) : Colors.transparent, width: 2),
                                  //         ),
                                  //         child: Container(
                                  //           width: 25, height: 25,
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(Get.width / 70),
                                  //             // shape: BoxShape.circle,
                                  //             color: hexToColor(item.slug),
                                  //           ),
                                  //           // child: isSelected ? Icon(Icons.check, color: Colors.white, size: 13) : null,
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  // )),
                                  Obx((){
                                    return SizedBox(
                                      height: Get.height / 25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: jewelleryfilter.data['data']['Metal_Type'].length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final jewellery = jewelleryfilter.data['data']['Metal_Type'][index];
                                          final String jewelleryName = jewellery['name'];
                                          final isSelected = filtertab.selectedMetalType.value == jewellery['slug'];
                                          return GestureDetector(
                                            onTap: () {
                                              filtertab.setMetalType(jewellery['slug']);
                                              setState((){});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Get.width / 70),
                                                border: Border.all(color: isSelected ? AppColor.pink_color : Colors.transparent, width: 1),
                                              ),
                                              child: Container(
                                                color: AppColor.white_color,
                                                child: jewelleryColorContainer(jewelleryName),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),

                                  //Shape
                                  SizedBox(height: Get.height / 50),
                                  Text(AppString.shape, style: TextStyle(fontSize: Get.width / 27, color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                                  SizedBox(height: Get.height / 100),
                                  Obx((){
                                    return  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: filter.shape.map((item) {
                                          final isSelected = filtertab.diamondtype.value == item.slug;
                                          return GestureDetector(
                                            onTap: () {
                                              setState((){
                                                filtertab.setDiamondType(item.slug,item.id.toString());
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(right: 8),
                                              width: 50,
                                              height: 50,
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: (isSelected) ? AppColor.pink_color : Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(Get.width / 50),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(Get.width / 50),
                                                child: Image.network(
                                                  item.image,
                                                  // fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(Icons.broken_image, color: (isSelected) ? AppColor.pink_color : Colors.grey);
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }),

                                  //Categories
                                  SizedBox(height: Get.height / 50),
                                  Text(AppString.categories, style: TextStyle(fontSize: Get.width / 27, color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                                  SizedBox(height: Get.height / 100),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: categorydata.data.map((item) {
                                        // isSelectedlatter = category.selectedSlug.value == item.slug;
                                        final isSelected = category_slug == item.slug;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              category_slug = item.slug;
                                              isSelectedlatter = category.selectedSlug.value == item.slug;
                                              subcategrorysname = item.name;
                                            });
                                            // category.selectCategorySlug(item.slug);
                                            // subcategrory.subcategroryuser(category_slug: item.slug);
                                            // Get.back();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: isSelected ? AppColor.pink_color : AppColor.textfild_color),
                                              color: isSelected ? AppColor.pink_color.withOpacity(0.1) : AppColor.white_color,
                                              borderRadius: BorderRadius.circular(Get.width / 50),
                                            ),
                                            child: Text(item.name, style: TextStyle(color: isSelected ? AppColor.pink_color : Colors.black, fontWeight: FontWeight.normal,fontSize: Get.width / 30)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                  //Weight
                                  SizedBox(height: Get.height / 50),
                                  Text(AppString.weight, style: TextStyle(fontSize: Get.width / 25, color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                                  SizedBox(height: Get.height / 100),
                                  SizedBox(
                                    height: Get.height * 0.05,
                                    child: ListView.builder(
                                      itemCount: filtertab.weightlist.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Obx(() {
                                          final isSelected = filtertab.selectedWeight.value == filtertab.weightlist[index];
                                          return GestureDetector(
                                            onTap: () => filtertab.setWeight(filtertab.weightlist[index]),
                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                margin: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: isSelected ? AppColor.pink_color : AppColor.textfild_color,
                                                  ),
                                                  color: isSelected ? AppColor.pink_color.withOpacity(0.1) : AppColor.white_color,
                                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                                ),
                                                child: Text(
                                                  filtertab.weightlist[index],
                                                  style: TextStyle(
                                                    fontSize: Get.width / 30,
                                                    color: isSelected ? AppColor.pink_color : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ),

                                  //Price
                                  SizedBox(height: Get.height / 50),
                                  Text(AppString.price, style: TextStyle(fontSize: Get.width / 27, color: AppColor.grey_color, fontWeight: FontWeight.w500)),
                                  SizedBox(height: Get.height / 100),
                                  SizedBox(
                                    height: Get.height * 0.05,
                                    child: ListView.builder(
                                      itemCount: filtertab.price.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Obx(() {
                                          final isSelected = filtertab.selectedPrice.value == filtertab.price[index];
                                          return GestureDetector(
                                            onTap: () => filtertab.setPrice(filtertab.price[index]),
                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                margin: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: isSelected ? AppColor.pink_color : AppColor.textfild_color),
                                                  color: isSelected ? AppColor.pink_color.withOpacity(0.1) : AppColor.white_color,
                                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                                ),
                                                child: Text(filtertab.price[index], style: TextStyle(color: isSelected ? AppColor.pink_color : Colors.black,fontSize: Get.width / 30)),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height / 50),

                          //Button
                          SizedBox(
                            width: Get.width / 1.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Clear
                                GestureDetector(
                                  onTap: () async {
                                    setState((){
                                      filtertab.clearFilters();
                                      onCategoryNameChanged(subcategrorysname);
                                    });
                                    subcategrory.resetPagination();
                                    Get.back();
                                    await subcategrory.subcategroryuser(category_slug: category_slug,subcategory_slug: subcategrorys);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.textfild_color),
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                    child: Text(AppString.clear),
                                  ),
                                ),

                                //Save
                                GestureDetector(
                                  onTap: () {
                                    setState((){
                                      print('Filter values before API call:');

                                      print('subcategory_slug :- $subcategrorys');
                                      print('category_slug :- $category_slug');
                                      print('metal_stamp: ${filtertab.metalstapid.value}');
                                      print('diamondtype: ${filtertab.diamondtype.value}');
                                      print('priceMin: ${filtertab.priceMin.value}, priceMax: ${filtertab.priceMax.value}');
                                      print('weightMin: ${filtertab.weightMin.value}, weightMax: ${filtertab.weightMax.value}');
                                      print('metal_type: ${filtertab.selectedMetalType.value}');

                                      subcategrory.subcategroryuser(
                                        subcategory_slug: (subcategrorys.isNotEmpty) ? subcategrorys : null,
                                        category_slug: (category_slug.isNotEmpty) ? category_slug : null,
                                        metal_stamp: filtertab.metalstapid.value.isNotEmpty ? filtertab.metalstapid.value : null,
                                        center_stone_shape: filtertab.diamondtype.value.isNotEmpty ? filtertab.diamondtype.value : null,
                                        price_min: filtertab.priceMin.value?.toString(),
                                        price_max: filtertab.priceMax.value?.toString(),
                                        weight_min: (filtertab.weightMin.value != null) ? filtertab.weightMin.value.toString() : null,
                                        weight_max: (filtertab.weightMax.value != null) ? filtertab.weightMax.value?.toString() : null,
                                        metal_type: (filtertab.selectedMetalType.value.isNotEmpty) ? filtertab.selectedMetalType.value : null,
                                      );

                                      // Update AppBar name only when Save is clicked and category_slug is not empty
                                      if (category_slug.isNotEmpty) {
                                        try {
                                          final selectedCategory = categorydata.data.firstWhere((item) => item.slug == category_slug);
                                          onCategoryNameChanged(selectedCategory.name);
                                        } catch (e) {
                                          onCategoryNameChanged(subcategrorysname);
                                        }
                                      }
                                    });
                                    Get.back();
                                    setState((){});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.pink_color),
                                      color: AppColor.pink_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                    child: Text(AppString.save, style: TextStyle(color: AppColor.white_color)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Get.height / 50),
                        ]),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        );
      },
    );
  }
}