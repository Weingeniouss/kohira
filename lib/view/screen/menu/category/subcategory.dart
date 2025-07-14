// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, avoid_print, unused_import, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/subCategrory.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart' show Showproduct;
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/lodingstate.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/inputField.dart';

class Subcategorys extends StatefulWidget {
  final String subcategrorys;
  final String subcategrorysname;

  const Subcategorys({
    super.key,
    required this.subcategrorys,
    required this.subcategrorysname,
  });

  @override
  State<Subcategorys> createState() => _SubcategorysState();
}

class _SubcategorysState extends State<Subcategorys> {
  final subcategrory = Get.put(Subcategrory());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    subcategrory.resetPagination();
    subcategrory.subcategroryuser(category_slug: widget.subcategrorys);

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 && !subcategrory.isLoading.value && subcategrory.hasMore.value) {
        subcategrory.subcategroryuser(
          category_slug: widget.subcategrorys,
          isLoadMore: true,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: widget.subcategrorysname),
      bottomNavigationBar: SafeArea(
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
                    onTap: () => Storebay.storebay(context),
                    child: Row(
                      children: [
                        Icon(Icons.sort,color: AppColor.glodcolor),
                        SizedBox(width: Get.width / 60),
                        Text(AppString.sortbay,style: TextStyle(fontSize: Get.width / 25,color: AppColor.glodcolor)),
                      ],
                    ),
                  ),
                  Text("|",style: TextStyle(color: AppColor.graycolor),),
                  GestureDetector(
                    onTap: () => ShowBottam.showbottam(context),
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
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: AppColor.white_color,
        child: Obx(() => loading(
          conditiona: subcategrory.isLoading.value && subcategrory.data.isEmpty,
          widget: SafeArea(
            child: horizontalpadding(
              child: RefreshIndicator(
                strokeWidth: 3.5,
                color: AppColor.pink_color,
                backgroundColor: AppColor.white_color,
                onRefresh: () async {
                    subcategrory.resetPagination();
                    await subcategrory.subcategroryuser(category_slug: widget.subcategrorys);
                  },
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    searchField(onChanged: (val) => subcategrory.filterSearch(val)),
                    SizedBox(height: Get.height / 50),
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Get.height / 50,
                          crossAxisSpacing: Get.width / 50,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: subcategrory.data.length + 1,
                        itemBuilder: (context, index) {
                          if (index < subcategrory.data.length) {
                            final subcategrorys = subcategrory.data[index];
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
                                    "₹ ${subcategrorys['offerprice']}.00",
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
                    (subcategrory.hasMore.value && subcategrory.isLoading.value) ?
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
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
          ),
        )),
      ),
    );
  }
}

class Storebay{
  static storebay(context){
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Get.width / 20),
            topRight: Radius.circular(Get.width / 20),
          )
        ),
        height: Get.height * 0.21, width: Get.width,
        child: Column(
          children: [
            SizedBox(height: Get.height / 80),
            SizedBox(
              width: Get.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(AppString.filter,style: TextStyle(fontSize: Get.width / 22)),
                  GestureDetector(onTap: () => Get.back(), child: Icon(Icons.cancel_outlined,color: AppColor.graycolor)),
                ],
              ),
            ),
            SizedBox(height: Get.height / 80),
            Divider(color: AppColor.graycolor),
            SizedBox(height: Get.height / 80),
            
            Align(
              alignment: Alignment.centerLeft,
              child: horizontalpadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price(Low To High)',style: TextStyle(fontSize: Get.width / 26)),
                    SizedBox(height: Get.height / 80),
                    Text('Price(High To Low)',style: TextStyle(fontSize: Get.width / 26)),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class ShowBottam {
  static showbottam(BuildContext context) {
    final jewellery = Get.put(Jewelleryfilter());
    final category = Get.put(JewelleryFilterCategory());

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
         return Container(height: height * 0.7,color: AppColor.white_color, child: Center(child: Lottie.asset(AppJson.loading2)),);
         }

         final filter = jewellery.data.value?.data;
         final categorydata = category.filterData.value;
         if (filter == null) {
           return Container(height: height * 0.7,color: AppColor.white_color, child: const Center(child: Text("No filter data found.")));
         }

         final filterData = filter;

         if (filterData == null || filterData.metalStamp.isEmpty) {
           print('No metal stamps available');
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

         List<String> weightlist = [
           'Less Then 2 Grams',
           '2 Grams To 4 Grams',
           '4 Grams To 8 Grams',
           '8 Grams To 15 Grams',
           '15 Grams To 18 Grams'
         ];

         List<String> price = [
           'Below ₹10,000',
           '₹10,000 To ₹20,000',
           '₹20,000 To ₹30,000',
           '₹30,000 To ₹40,000',
           '₹40,000 To ₹50,000'
         ];

        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.65,
                maxChildSize: 0.80,
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
                      child: Column(
                          children: [
                            SizedBox(height: Get.height / 80),
                            SizedBox(
                              width: Get.width / 1.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(AppString.filter,style: TextStyle(fontSize: Get.width / 22)),
                                  GestureDetector(onTap: () => Get.back(), child: Icon(Icons.cancel_outlined,color: AppColor.graycolor)),
                                ],
                              ),
                            ),
                            SizedBox(height: Get.height / 80),
                            Divider(color: AppColor.graycolor),
                            SizedBox(height: Get.height / 50),
                            SingleChildScrollView(
                              controller: scrollController,
                              child: Expanded(
                                child: horizontalpadding(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppString.metalstamp,style: TextStyle(fontSize: Get.width / 25,color: AppColor.graycolor,fontWeight: FontWeight.w500)),
                                        SizedBox(height: Get.height / 100),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: filter.metalStamp.map((item) =>
                                              GestureDetector(
                                                onTap: (){
                                                  print(item.name);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: AppColor.textfild_color),
                                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                                  ),
                                                  child: Text(item.name),
                                                ),
                                              ),
                                          ).toList(),
                                        ),
                                        SizedBox(height: Get.height / 50),
                                        Text(AppString.metaltaype, style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor, fontWeight: FontWeight.w500)),
                                        SizedBox(height: Get.height / 100),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: filter.metalType.map((item) {
                                            return Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: hexToColor(item.slug),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: Get.height / 50),
                                        Text('Shape',style: TextStyle(fontSize: Get.width / 25,color: AppColor.graycolor,fontWeight: FontWeight.w500)),
                                        SizedBox(height: Get.height / 100),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: filter.shape.map((item) {
                                              return Container(
                                                margin: EdgeInsets.only(right: 8), // spacing between items
                                                width: 50,
                                                height: 50,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey.shade300),
                                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                                  child: Image.network(
                                                    item.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Icon(Icons.broken_image, color: Colors.grey);
                                                    },
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(height: Get.height / 50),
                                        Text("Category", style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor,fontWeight: FontWeight.w500)),
                                        SizedBox(height: Get.height / 100),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: categorydata!.data.map((item) {
                                              final isSelected = category.selectedSlug.value == item.slug;
                                              return GestureDetector(
                                                onTap: () {
                                                    category.selectCategorySlug(item.slug);
                                                    setState((){});
                                                  },
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
                                                    item.name,
                                                    style: TextStyle(
                                                      color: isSelected ? AppColor.pink_color : Colors.black,
                                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(height: Get.height / 50),
                                        Text("Weight", style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor,fontWeight: FontWeight.w500)),
                                        SizedBox(height: Get.height / 100),
                                        SizedBox(
                                          height: Get.height * 0.05,
                                          child: ListView.builder(
                                            itemCount: weightlist.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Center(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color:  AppColor.textfild_color),
                                                    color: AppColor.white_color,
                                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                                  ),
                                                  child: Text(weightlist[index], style: TextStyle(color:  Colors.black, fontWeight:  FontWeight.normal)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: Get.height / 50),
                                        Text("Price", style: TextStyle(fontSize: Get.width / 25, color: AppColor.graycolor,fontWeight: FontWeight.w500)),
                                        SizedBox(height: Get.height / 100),
                                        SizedBox(
                                          height: Get.height * 0.05,
                                          child: ListView.builder(
                                            itemCount: price.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Center(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color:  AppColor.textfild_color),
                                                    color: AppColor.white_color,
                                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                                  ),
                                                  child: Text(price[index], style: TextStyle(color:  Colors.black, fontWeight:  FontWeight.normal)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height / 50),
                            SizedBox(
                              width: Get.width / 1.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.textfild_color),
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                    child: Text('Clear'),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.pink_color),
                                      color: AppColor.pink_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                    child: Text('Save',style: TextStyle(color: AppColor.white_color)),
                                  ),
                                ],
                              ),
                            ),
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
      });
   }
}
