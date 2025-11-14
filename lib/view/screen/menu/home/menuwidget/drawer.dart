// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_constructors_in_immutables

// drawerIcon(icon: AppIcon.bracelet, text: AppString.bracelet, color: AppColor.white_color),
// drawerIcon(icon: AppIcon.collection, text: AppString.collection, color: AppColor.white_color),
// drawerIcon(icon: AppIcon.earrings, text: AppString.earrings, color: AppColor.white_color),
// drawerIcon(icon: AppIcon.mangalsutra, text: AppString.mangalsutra, color: AppColor.white_color),
// drawerIcon(icon: AppIcon.necklace, text: AppString.necklace, color: AppColor.white_color),
// drawerIcon(icon: AppIcon.ring, text: AppString.ring, color: AppColor.white_color),
// drawerIcon(icon: AppIcon.custom, text: AppString.custom, color: AppColor.white_color),
// drawerIcon(icon: AppIcon.dummy, text: AppString.dummy, color: AppColor.white_color),

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/database/local/localstore.dart';
import 'package:kohira/controller/user_inerface/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/screen/credentials/login.dart';
import 'package:kohira/view/screen/menu/account/wallet/wallet.dart';
import 'package:kohira/view/screen/menu/category/subcategory.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/customjewellery.dart';
import 'package:kohira/view/screen/menu/myCart/wishList/wishlist.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_logo.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../../controller/API/menu/others/drawer/Jewellery_list.dart';
import '../../../../../controller/API/menu/others/drawer/collection.dart';
import '../../../../utils/app_constants.dart';
import '../../account/addresses/addresses.dart';
import '../../account/order history/orderhistory.dart';
import '../../account/privacy policy/privacy.dart';

class Drawers extends StatefulWidget {
  Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  final jewellery = Get.put(Jewelleryfilter());
  final category = Get.put(JewelleryFilterCategory());
  final drawer = Get.put(DrawerInterface());
  final collection = Get.put(Collection());
  final jewelleryfilter = Get.put(JewelleryList());

  Widget jewelleryColorContainer(String name){
    switch (name) {
      case 'White Gold':
        return SinglContainer(size: 20, singlcolor: AppColor.graycolor);
      case 'Rose Gold':
        return SinglContainer(size: 20, singlcolor: AppColor.rosegoldcolor);
      case 'Yellow Gold':
        return SinglContainer(size: 20, singlcolor: Colors.amber);
      case 'Yellow Gold And White Gold':
        return MyCustomContainer(size: 20, firstColor: Colors.amber, secondColor: AppColor.graycolor);
      case 'Rose Gold and White Gold':
        return MyCustomContainer(size: 20, firstColor: AppColor.rosegoldcolor, secondColor: AppColor.graycolor);
      default:
        return Container();
    }
  }

  String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'engagement rings': return AppIcon.ring;
      case 'bracelet': return AppIcon.bracelet;
      case 'collection': return AppIcon.collection;
      case 'earrings': return AppIcon.earrings;
      case 'mangalsutra': return AppIcon.mangalsutra;
      case 'necklaces': return AppIcon.cat_necklace;
      case 'mangalsutras': return AppIcon.mangalsutra;
      case 'bangles bracelets': return AppIcon.cat_bracelet;
      case 'for him' : return AppIcon.ring;
      case 'pendants': return AppIcon.necklace;
      case 'rings': return AppIcon.ring;
      default: return AppIcon.remark;
    }
  }

  List price = [
    {'min' : '10000'},
    {'min' : '10001', 'max' : '20001'},
    {'min' : '30001', 'max' : '40001'},
    {'min' : '40001', 'max' : '50001'},
    {'max' : '50001'}
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCategories = category.filterData.value!.data.where((item) => ![7, 8, 9].contains(item.id)).toList();
    final filteredCategories2 = category.filterData.value!.data.where((item) => ![1, 2, 3, 4, 5, 6].contains(item.id)).toList();
    return Drawer(
      width: Get.width * 0.650,
      elevation: 0,
      backgroundColor: AppColor.white_color,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.030),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset(AppLogo.logo, scale: 13)]),
            SizedBox(height: Get.height * 0.030),
            Divider(color: AppColor.textfild_color),
            SizedBox(height: Get.height * 0.030),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  if (category.filterData.value == null) {
                    return Scaffold(body: Center(child: Lottie.asset(AppJson.noData)));
                  }
                  return Obx(() {
                    return Column(
                      children: [

                        //List of Categories
                        horizontalpadding(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredCategories.length,
                            itemBuilder: (BuildContext context, int index) {
                              final categoryItem = filteredCategories[index];
                              return (categoryItem.subcategory.isEmpty)
                                  ? null
                                  : Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              for (var item in filteredCategories) {
                                                if (item != categoryItem) {
                                                  item.isExpanded = false;
                                                }
                                              }
                                              categoryItem.isExpanded = !categoryItem.isExpanded;
                                              drawer.allJewellery.value = false;
                                              drawer.metaltype.value = false;
                                              drawer.price.value = false;
                                              drawer.collection.value = false;
                                            });
                                          },
                                          child: Container(
                                            color: AppColor.white_color,
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(vertical: Get.width * 0.020),
                                                  decoration: BoxDecoration(color: AppColor.pink_color, borderRadius: BorderRadius.circular(Get.width / 50)),
                                                  padding: EdgeInsets.all(10),
                                                  child: SvgPicture.asset(getCategoryIcon(categoryItem.name), width: Get.width * 0.018, height: Get.height * 0.018, color: AppColor.white_color),
                                                ),
                                                SizedBox(width: Get.width / 30),
                                                SizedBox(
                                                  width: Get.width / 3.5,
                                                  child: Text(categoryItem.name.toUpperCase(), style: TextStyle(fontSize: Get.width * 0.032, fontWeight: FontWeight.w500)),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        AnimatedCrossFade(
                                          duration: Duration(milliseconds: 200),
                                          firstChild: SizedBox.shrink(),
                                          secondChild:
                                              categoryItem.subcategory.isNotEmpty
                                                  ? Padding(
                                                      padding: EdgeInsets.only(left: Get.width * 0.08),
                                                      child: Column(
                                                        children: [
                                                          ...categoryItem.subcategory.take(6).map((subItem) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                category.selectCategorySlug(subItem.slug);
                                                                Get.to(() => Subcategorys(subcategory_slug: subItem.slug, subcategrorysname: subItem.name),
                                                                  transition: Transition.rightToLeft,
                                                                  duration: Duration(milliseconds: 600),
                                                                );
                                                              },
                                                              child: Container(
                                                                color: AppColor.white_color,
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                                  child: Row(
                                                                    children: [
                                                                      Text("*"),
                                                                      SizedBox(width: Get.width * 0.015),
                                                                      SizedBox(width: Get.width / 3, child: Text(subItem.name.toUpperCase(), style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400))),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                          if (categoryItem.subcategory.length > 6)
                                                            GestureDetector(
                                                              onTap: () {
                                                                Get.to(() => Subcategorys(subcategrorys: categoryItem.slug, subcategrorysname: categoryItem.name),
                                                                  transition: Transition.rightToLeft,
                                                                  duration: Duration(milliseconds: 600),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                                                    color: AppColor.black_color,
                                                                  ),
                                                                  padding: EdgeInsets.all(5),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text("*"),
                                                                      SizedBox(width: Get.width * 0.015),
                                                                      Text("View All (${categoryItem.subcategory.length})",
                                                                        style: TextStyle(
                                                                          fontSize: Get.width * 0.030,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: AppColor.white_color,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                          crossFadeState: categoryItem.isExpanded == true ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                        ),
                                        Divider(color: AppColor.textfild_color, height: 1),
                                      ],
                                    );
                            },
                          ),
                        ),

                        // All Jewellery
                        GestureDetector(onTap: (){
                           drawer.selectedJewellery();
                           for (var item in filteredCategories) {
                             item.isExpanded = false;
                           }
                           setState(() {});
                          },
                          child: Container(color: AppColor.white_color, child: drawerIcon(icon: AppIcon.cat_jewelry, color: AppColor.white_color, text: AppString.allJewellery)),
                        ),
                        AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 600),
                          child: (drawer.allJewellery.value)
                              ? horizontalpadding(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: Get.width / 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: filteredCategories2.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final categoryItem = filteredCategories2[index];
                                        return ((categoryItem.subcategory.isEmpty))
                                            ? null
                                            : Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var item in filteredCategories2){
                                                          if(item != categoryItem){
                                                            item.isExpanded = false;
                                                          }
                                                        }
                                                        categoryItem.isExpanded = !(categoryItem.isExpanded);
                                                        drawer.metaltype.value = false;
                                                        drawer.price.value = false;
                                                        drawer.collection.value = false;
                                                      });
                                                    },
                                                    child: Container(
                                                      color: AppColor.white_color,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.symmetric(vertical: Get.width * 0.020),
                                                            decoration: BoxDecoration(color: AppColor.pink_color, borderRadius: BorderRadius.circular(Get.width / 50)),
                                                            padding: EdgeInsets.all(10),
                                                            child: SvgPicture.asset(getCategoryIcon(categoryItem.name), width: Get.width * 0.018, height: Get.height * 0.018,color: AppColor.white_color),
                                                          ),
                                                          SizedBox(width: Get.width / 30),
                                                          SizedBox(
                                                            width: Get.width / 3.5,
                                                            child: Text(categoryItem.name.toUpperCase(), style: TextStyle(fontSize: Get.width * 0.032, fontWeight: FontWeight.w500)),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  AnimatedCrossFade(
                                                    duration: Duration(milliseconds: 200),
                                                    firstChild: SizedBox.shrink(),
                                                    secondChild: (categoryItem.subcategory.isNotEmpty)
                                                        ? Padding(
                                                                padding: EdgeInsets.only(left: Get.width * 0.08),
                                                                child: Column(
                                                                  children: [
                                                                    ...categoryItem.subcategory.take(6).map((subItem) {
                                                                      return GestureDetector(
                                                                        onTap: () {
                                                                          category.selectCategorySlug(subItem.slug);
                                                                          Get.to(() => Subcategorys(
                                                                            subcategory_slug: subItem.slug,
                                                                            subcategrorysname: subItem.name,
                                                                          ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
                                                                        },
                                                                        child: Container(
                                                                          color: AppColor.white_color,
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                                            child: Row(
                                                                              children: [
                                                                                Text("*"),
                                                                                SizedBox(width: Get.width * 0.015),
                                                                                SizedBox(
                                                                                  width: Get.width / 3,
                                                                                  child: Text(subItem.name.toUpperCase(), style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                                    if (categoryItem.subcategory.length > 6)
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          Get.to(() => Subcategorys(
                                                                            subcategrorys: categoryItem.slug,
                                                                            subcategrorysname: categoryItem.name,
                                                                          ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(Get.width / 50),
                                                                              color: AppColor.black_color,
                                                                            ),
                                                                            padding: EdgeInsets.all(5),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text("*"),
                                                                                SizedBox(width: Get.width * 0.015),
                                                                                Text("View All (${categoryItem.subcategory.length})", style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400, color: AppColor.white_color)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox.shrink(),
                                                    crossFadeState: categoryItem.isExpanded == true ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                  ),
                                                  Divider(color: AppColor.textfild_color, height: 1),
                                                ],
                                              );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),

                        //Collection
                        GestureDetector(
                          onTap: () {
                            drawer.collectionTab();
                            for (var item in filteredCategories) {
                              item.isExpanded = false;
                            }
                            setState(() {});
                          },
                          child: Container(color: AppColor.white_color, child: drawerIcon(icon: AppIcon.collection, color: AppColor.white_color, text: AppString.collection)),
                        ),
                        Visibility(
                          visible: drawer.collection.value,
                          child: Column(
                            children: [
                               ListView.builder(
                                  shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                                  itemCount: collection.data['data'].length > 6 ? 6 : collection.data['data'].length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final collctions = collection.data['data'][index];
                                    return Padding(
                                      padding: EdgeInsets.only(left: Get.width / 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(() => Subcategorys(
                                            collection_id: collctions['slug'],
                                            subcategrorysname: collctions['name'],
                                          ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
                                        },
                                        child: Container(
                                          color: AppColor.white_color,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                            child: Row(
                                              children: [
                                                Text("o",style: TextStyle(color: AppColor.pink_color)),
                                                SizedBox(width: Get.width * 0.015),
                                                SizedBox(
                                                  width: Get.width / 3,
                                                  child: Text(collctions['name'].toUpperCase(), style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                }),
                               Padding(
                                  padding: EdgeInsets.only(left: Get.width / 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => Subcategorys(
                                        subcategrorys: collection.data['data'].toString(),
                                        subcategrorysname: AppString.collection_product,
                                      ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
                                    },
                                    child: horizontalpadding(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Get.width / 50),
                                            color: AppColor.black_color,
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("*"),
                                              SizedBox(width: Get.width * 0.015),
                                              Text(
                                                "View All (${collection.data['data'].length})",
                                                style: TextStyle(
                                                  fontSize: Get.width * 0.030,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.white_color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                             ],
                          ),
                        ),

                        //Metal Type
                        GestureDetector(
                          onTap: () {
                            drawer.metaltypeTab();
                            for (var item in filteredCategories) {
                              item.isExpanded = false;
                            }
                            setState(() {});
                          },
                          child: Container(color: AppColor.white_color, child: drawerIcon(icon: AppIcon.metal_type, text: AppString.metaltyoe, color: AppColor.white_color)),
                        ),
                        Visibility(
                          visible: drawer.metaltype.value,
                          child: Column(
                            children: [
                              SizedBox(height: Get.height * 0.015),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: jewelleryfilter.data['data']['Metal_Type'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  final jewellery = jewelleryfilter.data['data']['Metal_Type'][index];
                                  final String jewelleryName = jewellery['name'];
                                  return Padding(
                                    padding: EdgeInsets.only(left: Get.width / 10),
                                    child: GestureDetector(
                                      onTap: () => Get.to(() => Subcategorys(metal_type: jewellery['slug'], subcategrorysname: jewellery['name'])),
                                      child: Container(
                                        color: AppColor.white_color,
                                        child: Column(
                                          children: [
                                            SizedBox(height: Get.height * 0.005),
                                            Row(
                                              children: [
                                                jewelleryColorContainer(jewelleryName),
                                                // Container(decoration: BoxDecoration(color: getJewelleryColor(jewelleryName)), padding: EdgeInsets.all(10)),
                                                SizedBox(width: Get.width * 0.015),
                                                SizedBox(width: Get.width / 3, child: Text(jewellery['name'].toUpperCase())),
                                              ],
                                            ),
                                            SizedBox(height: Get.height * 0.015),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (jewelleryfilter.data['data']['Metal_Type'].length > 6)
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width / 10),
                                  child: GestureDetector(
                                    onTap: () => Get.to(() => Subcategorys(subcategrorys: jewelleryfilter.data['data']['Metal_Type']['slug'].toString(), subcategrorysname: AppString.product),transition: Transition.rightToLeft, duration: Duration(milliseconds: 600)),
                                    child: horizontalpadding(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 50), color: AppColor.black_color),
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("*"),
                                              SizedBox(width: Get.width * 0.015),
                                              Text(
                                                "View All (${jewelleryfilter.data['data']['Metal_Type'].length})",
                                                style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w500, color: AppColor.white_color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        //Buy Price Rang
                        GestureDetector(onTap: (){
                          drawer.priceTab();
                          for (var item in filteredCategories) {
                            item.isExpanded = false;
                          }
                          setState(() {});
                         },
                          child: Container(color: AppColor.white_color, child: drawerIcon(icon: AppIcon.returns,color: AppColor.white_color, text: AppString.buypricerang)),
                        ),
                        Visibility(
                          visible: drawer.price.value,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: price.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(left: Get.width / 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => Subcategorys(
                                      price_min: price[index]['min'].toString(),
                                      price_max: price[index]['max'].toString(),
                                      subcategrorysname: AppString.product,
                                    ));
                                  },
                                  child: Container(
                                    color: AppColor.white_color,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: Get.height * 0.015),
                                        Row(
                                          children: [
                                            (price[index]['min'] != null) ? Text(price[index]['min'].toString()) : Text('About'),
                                            (price[index]['min'] != null && price[index]['max'] != null) ? SizedBox(width: Get.width * 0.025) : SizedBox(),
                                            (price[index]['min'] != null && price[index]['max'] != null) ? Text('To') : SizedBox(),
                                            (price[index]['min'] != null && price[index]['max'] != null) ? SizedBox(width: Get.width * 0.025) : SizedBox(width: Get.width * 0.010),
                                            (price[index]['max'] != null) ? Text(price[index]['max'].toString()) : Text('Below'),
                                          ],
                                        ),
                                        SizedBox(height: Get.height * 0.015),
                                        Divider(color: AppColor.textfild_color, height: 1),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        //Order History
                        drawerIcon(
                          icon: AppIcon.remark,
                          color: AppColor.white_color,
                          text: AppString.Order,
                          onTap: () {
                            for (var item in filteredCategories) {
                              item.isExpanded = false;
                            }
                            drawer.allJewellery.value = false;
                            drawer.metaltype.value = false;
                            drawer.price.value = false;
                            drawer.collection.value = false;
                            setState(() {});
                            Get.to(() => Orderhistory(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 800));
                          },
                        ),

                        //Wishlist
                        drawerIcon(
                          icon: AppIcon.Wishlist,
                          text: AppString.Wishlist,
                          onTap: () {
                            for (var item in filteredCategories) {
                              item.isExpanded = false;
                            }
                            drawer.allJewellery.value = false;
                            drawer.metaltype.value = false;
                            drawer.price.value = false;
                            drawer.collection.value = false;
                            setState(() {});
                            Get.to(() => WishlistScreen(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 800));
                            },
                        ),

                        //Wallet
                        drawerIcon(
                          icon: AppIcon.Wallet,
                          text: AppString.Wallet,
                          onTap: () {
                            for (var item in filteredCategories) {
                              item.isExpanded = false;
                            }
                            drawer.allJewellery.value = false;
                            drawer.metaltype.value = false;
                            drawer.price.value = false;
                            drawer.collection.value = false;
                            setState(() {});
                            Get.to(() => Wallet(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 800));
                            },
                        ),

                        //Address
                        drawerIcon(
                          icon: AppIcon.Addresses,
                          text: AppString.Addresses,
                          onTap: () {
                            for (var item in filteredCategories) {
                              item.isExpanded = false;
                            }
                            drawer.allJewellery.value = false;
                            drawer.metaltype.value = false;
                            drawer.price.value = false;
                            drawer.collection.value = false;
                            setState(() {});
                            Get.to(() => Addresses(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 800));
                            },
                        ),

                        //Helpcenter
                        // drawerIcon(icon: AppIcon.HelpCenter, text: AppString.HelpCenter),

                        //Privacy Policy
                        drawerIcon(
                          icon: AppIcon.PrivacyPolicy,
                          text: AppString.PrivacyPolicy,
                          onTap: () {
                            for (var item in filteredCategories) {
                              item.isExpanded = false;
                            }
                            drawer.allJewellery.value = false;
                            drawer.metaltype.value = false;
                            drawer.price.value = false;
                            drawer.collection.value = false;
                            setState(() {});
                            Get.to(() => Privacy(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 800));
                            },
                        ),

                        //CustomJewellery
                        (tokans?.isEmpty ?? true) ?  SizedBox() : drawerIcon(
                          icon: AppIcon.custom,
                           color: AppColor.white_color,
                           text: AppString.customJewellery,
                            onTap: () {  
                            setState(() {
                              drawer.allJewellery.value = false;
                              drawer.metaltype.value = false;
                              drawer.price.value = false;
                              drawer.collection.value = false;
                              for (var item in filteredCategories) {
                                item.isExpanded = false;
                              }
                            });
                            Get.to(() => CustomJewellery(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 800));
                        }),

                        //Logout
                        (tokans?.isEmpty ?? true)
                             ? drawerIcon(icon: AppIcon.Logout, text: AppString.Login, onTap: () => Get.off(() => Login()))
                             : drawerIcon(icon: AppIcon.Logout, text: AppString.Logout, onTap: () => logoutUser()),
                        SizedBox(height: Get.height * 0.030),
                      ],
                    );
                  });
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget drawerIcon({required String icon, required String text, void Function()? onTap, Color? color}) {
  return horizontalpadding(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColor.white_color,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: Get.width * 0.020),
                  decoration: BoxDecoration(color: AppColor.pink_color, borderRadius: BorderRadius.circular(Get.width / 50)),
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset(icon, width: Get.width * 0.018, height: Get.height * 0.018, color: color),
                ),
                 SizedBox(width: Get.width / 30),
                 Text(text.toUpperCase(), style: TextStyle(fontSize: Get.width * 0.032, fontWeight: FontWeight.w500)),
               ],
             ),
            Divider(color: AppColor.textfild_color, height: 1),
          ],
        ),
      ),
    ),
  );
}

class MyCustomContainer extends StatelessWidget {
  final Color? firstColor;
  final Color? secondColor;
  final double size;
  const MyCustomContainer({this.firstColor, this.secondColor, required this.size, super.key,});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, width: size,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(color: firstColor),
              child: Container(
                decoration: BoxDecoration(
                  color: firstColor,
                  border: Border.all(color: AppColor.white_color,width: 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(color: secondColor),
              child: Container(
                decoration: BoxDecoration(
                  color: secondColor,
                  border: Border.all(color: AppColor.white_color,width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SinglContainer extends StatelessWidget {
  final double size;
  final Color? singlcolor;
  const SinglContainer({super.key, required this.size, this.singlcolor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, width: size,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(color: singlcolor),
        child: Container(
          decoration: BoxDecoration(
            color: singlcolor,
            border: Border.all(color: AppColor.white_color,width: 2)
          ),
        ),
      ),
    );
  }
}
