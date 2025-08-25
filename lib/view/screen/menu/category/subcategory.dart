// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, avoid_print, unused_import, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, body_might_complete_normally_nullable, deprecated_member_use, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/subCategrory.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart'
    show Showproduct;
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/lodingstate.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/user_inerface/menu/categroy/subcetegroy/filter.dart';
import '../../../../controller/user_inerface/menu/categroy/subcetegroy/subcetegrory.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/inputField.dart';

class Subcategorys extends StatelessWidget {
  final show = Get.put(SubcetegroryShow());
  String? subcategrorys;
  String? subcategory_slug;
  final String subcategrorysname;

   Subcategorys({
    super.key, this.subcategrorys,
    required this.subcategrorysname,
    this.subcategory_slug,
  });

  @override
  Widget build(BuildContext context) {
    show.onInit();
    show.loadData(subcategrorys: subcategrorys.toString(), subcategory_slug: subcategory_slug.toString());
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.product),
      bottomNavigationBar: Obx((){

        if(show.subcategrory.data.isEmpty){
          return SizedBox();
        }

        return SafeArea(
          child: Container(
            decoration: BoxDecoration(color: AppColor.white_color),
            height: Get.height * 0.05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => Storebay().storebay(context, subcategrorys: subcategrorys.toString(), subcategory_slug: subcategory_slug.toString()),
                      child: Row(
                        children: [
                          Icon(Icons.sort,color: AppColor.glodcolor),
                          SizedBox(width: Get.width / 60),
                          Text(AppString.sortbay,style: TextStyle(fontSize: Get.width / 25,color: AppColor.glodcolor)),
                        ],
                      ),
                    ),
                    Text("|",style: TextStyle(color: AppColor.graycolor)),
                    GestureDetector(
                      onTap: () {
                         ShowBottam().showbottam(
                           context, category_slug: subcategrorys.toString(),
                           subcategrorys: subcategory_slug.toString(),
                          );
                        },
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt_outlined,color: AppColor.glodcolor),
                          SizedBox(width: Get.width / 60),
                          Text(AppString.filter,style: TextStyle(fontSize: Get.width / 25,color: AppColor.glodcolor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: AppColor.white_color,
        child: Obx(() {
          if(show.subcategrory.isLoading.value && show.subcategrory.data.isEmpty){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isDialogOpen != true) {
                Get.dialog(
                  Center(child: Lottie.asset(AppJson.loading2)),
                  barrierDismissible: false,
                );
              }
            });
            return Scaffold(backgroundColor: Colors.transparent);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
            });
          }

          if(show.subcategrory.data.isEmpty){
            return Center(child: Lottie.asset(AppJson.noData));
          }

          return SafeArea(
            child: horizontalpadding(
              child: RefreshIndicator(
                strokeWidth: 3.5,
                color: AppColor.pink_color,
                backgroundColor: AppColor.white_color,
                onRefresh: () async {
                  show.subcategrory.resetPagination();
                  await show.subcategrory.subcategroryuser(category_slug: subcategrorys,subcategory_slug: subcategory_slug);
                },
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    searchField(onChanged: (val) => show.subcategrory.filterSearch(val)),
                    SizedBox(height: Get.height / 50),
                    Expanded(
                      child: GridView.builder(
                        controller: show.scrollController,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Get.height / 50,
                          crossAxisSpacing: Get.width / 50,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: show.subcategrory.data.length + 1,
                        itemBuilder: (context, index) {
                          if (index < show.subcategrory.data.length) {
                            final subcategrorys = show.subcategrory.data[index];
                            return GestureDetector(
                              onTap: () {
                                print('Id :- ${subcategrorys['id']}');
                                print('Slug :- ${subcategrorys['slug']}');
                                Get.to(() => Showproduct(slug: subcategrorys['slug']));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage(subcategrorys['default_image']), fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.height / 150),
                                  Text(
                                    subcategrorys['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: Get.height / 70, fontFamily: 'Lora'),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "₹${double.parse(subcategrorys['discount'].toString()) > 0 ? subcategrorys['offer_price'] : subcategrorys['setting_price']}.00",
                                    style: TextStyle(
                                      fontSize: Get.height / 70,
                                      fontFamily: 'Lora', color: AppColor.pink_color,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    (show.subcategrory.hasMore.value && show.subcategrory.isLoading.value) ?
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          height: 30, width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: AppColor.pink_color,
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class Storebay {
  final subcategrory = Get.put(Subcategrory());
  storebay(context, {required String subcategrorys, required String subcategory_slug}) {
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
            height: Get.height * 0.35,
            width: Get.width,
            child: Column(
              children: [
                SizedBox(height: Get.height / 80),
                SizedBox(
                  width: Get.width / 1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(AppString.filter, style: TextStyle(fontSize: Get.width / 22)),
                      GestureDetector(onTap: () => Get.back(), child: Icon(Icons.cancel_outlined, color: AppColor.graycolor)),
                    ],
                  ),
                ),
                SizedBox(height: Get.height / 80),
                Divider(color: AppColor.graycolor),
                SizedBox(height: Get.height / 80),
                Align(
                  alignment: Alignment.center,
                  child: horizontalpadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            subcategrory.subcategroryuser(
                              sort: 'asc',
                              order_column: 'setting_price',
                              category_slug: subcategrorys,
                              subcategory_slug: subcategory_slug,
                            );
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 220,top: 10,bottom: 10),
                            color: AppColor.white_color,
                            child: Text('Price\n(Low To High)', style: TextStyle(fontSize: Get.width / 26)),
                          ),
                        ),
                        Divider(color: AppColor.textfild_color),
                        SizedBox(height: Get.height / 80),
                        GestureDetector(
                          onTap: (){
                            subcategrory.subcategroryuser(
                              sort: 'desc',
                              order_column: 'setting_price',
                              category_slug: subcategrorys,
                              subcategory_slug: subcategory_slug,
                            );
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 220,top: 10,bottom: 10),
                            color: AppColor.white_color,
                            child: Text('Price\n(High To Low)', style: TextStyle(fontSize: Get.width / 26)),
                          ),
                        ),
                        Divider(color: AppColor.textfild_color),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
     );
  }
}

class ShowBottam {
  final jewellery = Get.put(Jewelleryfilter());
  final category = Get.put(JewelleryFilterCategory());
  final subcategrory = Get.put(Subcategrory());

  final filtertab = Get.put(FilterController());

  showbottam(
      BuildContext context,
      {
        required String category_slug,
        required String subcategrorys
      })
   {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQuery.of(context).size.width / 20),
        ),
      ),
      builder: (BuildContext context) {
        final height = MediaQuery.of(context).size.height;

        return Obx(() {
            if (jewellery.isLoading.value) {
              return Container(
                height: height * 0.7,
                color: AppColor.white_color,
                child: Center(child: Lottie.asset(AppJson.loading2)),
              );
            }

            final filter = jewellery.data.value?.data;
            final categorydata = category.filterData.value;

            // Handle null cases more gracefully
            if (filter == null || categorydata == null) {
              return Container(
                height: height * 0.7,
                color: AppColor.white_color,
                child: Center(child: Text("No filter data found.")),
              );
            }

            Color hexToColor(String colorString) {
              // Handle named colors or slugs
              final predefined = {
                'white-gold': Color(0xFFD8D8D8),
                'yellow-gold': Color(0xFFFFD700),
                'rose-gold': Color(0xFFB76E79),
                'silver': Color(0xFFC0C0C0),
                'platinum': Color(0xFFE5E4E2),
              };

              if (predefined.containsKey(colorString.toLowerCase())) {
                return predefined[colorString.toLowerCase()]!;
              }

              // Handle hex values like "#FFCC00"
              try {
                colorString = colorString.replaceAll('#', '');
                if (colorString.length == 6) colorString = 'FF$colorString';
                return Color(int.parse(colorString, radix: 16));
              } catch (_) {
                return Colors.grey; // fallback color
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
                                  SizedBox(),
                                  Text(AppString.filter, style: TextStyle(fontSize: Get.width / 22)),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Icon(Icons.cancel_outlined, color: AppColor.graycolor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Get.height / 80),
                            Divider(color: AppColor.graycolor),
                            SizedBox(height: Get.height / 50),
                            horizontalpadding(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    //Metal Stamps
                                    Text(AppString.metalstamp, style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor, fontWeight: FontWeight.w500)),
                                    SizedBox(height: Get.height / 100),
                                    Obx(() => Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: filter.metalStamp.map((item) {
                                        final isSelected = filtertab.metalstapid.value == item.id.toString();
                                        return GestureDetector(
                                          onTap: () => filtertab.setMetalStamp(item.id.toString()),
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
                                                color: isSelected ? AppColor.pink_color : AppColor.black_color,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )),

                                    //Metal Tyap
                                    SizedBox(height: Get.height / 50),
                                    Text(AppString.metaltaype, style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor, fontWeight: FontWeight.w500)),
                                    SizedBox(height: Get.height / 100),
                                    Obx(() => Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: filter.metalType.map((item) {
                                        final isSelected = filtertab.selectedMetalType.value == item.id.toString();
                                        return GestureDetector(
                                          onTap: () => filtertab.setMetalType(item.id.toString()),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: hexToColor(item.slug),
                                              border: Border.all(
                                                color: isSelected ? AppColor.glodcolor : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                            child: isSelected
                                                ? const Icon(Icons.check, color: Colors.white, size: 16)
                                                : null,
                                          ),
                                        );
                                      }).toList(),
                                    )),

                                    //Shape
                                    SizedBox(height: Get.height / 50),
                                    Text(AppString.shape, style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor, fontWeight: FontWeight.w500)),
                                    SizedBox(height: Get.height / 100),
                                    Obx((){
                                      return  SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: filter.shape.map((item) {
                                            final isSelected = filtertab.diamondtype.value == item.id.toString();
                                            return GestureDetector(
                                              onTap: () => filtertab.setDiamondType(item.id.toString()),
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
                                                    fit: BoxFit.cover,
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
                                    Text(AppString.categories, style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor, fontWeight: FontWeight.w500)),
                                    SizedBox(height: Get.height / 100),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: categorydata.data.map((item) {
                                          // final isSelected = category.selectedSlug.value == item.slug;
                                          final isSelected = category_slug == item.slug;
                                          return GestureDetector(
                                            onTap: () {
                                              category.selectCategorySlug(item.slug);
                                              subcategrory.subcategroryuser(category_slug: item.slug);
                                              Get.back();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              margin: EdgeInsets.symmetric(horizontal: 5),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: isSelected ? AppColor.pink_color : AppColor.textfild_color),
                                                color: isSelected ? AppColor.pink_color.withOpacity(0.1) : AppColor.white_color,
                                                borderRadius: BorderRadius.circular(Get.width / 50),
                                              ),
                                              child: Text(item.name, style: TextStyle(color: isSelected ? AppColor.pink_color : Colors.black, fontWeight: FontWeight.normal)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                    //Weight
                                    SizedBox(height: Get.height / 50),
                                    Text(AppString.weight, style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor, fontWeight: FontWeight.w500)),
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
                                    Text(AppString.price, style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor, fontWeight: FontWeight.w500)),
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
                                              onTap: () {
                                                filtertab.setPrice(filtertab.price[index]); // cleaner with method
                                              },
                                              child: Center(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: isSelected ? AppColor.pink_color : AppColor.textfild_color,
                                                    ),
                                                    color: isSelected ? AppColor.pink_color.withOpacity(0.1) : AppColor.white_color,
                                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                                  ),
                                                  child: Text(
                                                    filtertab.price[index],
                                                    style: TextStyle(
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
                                      print('Filter values before API call:');

                                      print('subcategory_slug :- $subcategrorys');
                                      print('category_slug :- $category_slug');
                                      print('metal_stamp: ${filtertab.metalstapid.value}');
                                      print('diamondtype: ${filtertab.diamondtype.value}');
                                      print('priceMin: ${filtertab.priceMin.value}, priceMax: ${filtertab.priceMax.value}');
                                      print('weightMin: ${filtertab.weightMin.value}, weightMax: ${filtertab.weightMax.value}');
                                      print('metal_type: ${filtertab.selectedMetalType.value}');

                                      subcategrory.subcategroryuser(
                                        subcategory_slug: (subcategrorys != null) ? subcategrorys : null,
                                        category_slug: (category_slug != null) ? category_slug : null,
                                        metal_stamp: filtertab.metalstapid.value.isNotEmpty ? filtertab.metalstapid.value : null,
                                        center_stone_shape: filtertab.diamondtype.value.isNotEmpty ? filtertab.diamondtype.value : null,
                                        price_min: filtertab.priceMin.value?.toString(),
                                        price_max: filtertab.priceMax.value?.toString(),
                                        weight_min: (filtertab.weightMin.value != null) ? filtertab.weightMin.value.toString() : null,
                                        weight_max: (filtertab.weightMax.value != null) ? filtertab.weightMax.value?.toString() : null,
                                        metal_type: filtertab.selectedMetalType.value,
                                      );
                                      Get.back();
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
