// ignore_for_file: annotate_overrides, override_on_non_overriding_member, prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, avoid_print, unused_import, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, body_might_complete_normally_nullable, deprecated_member_use, non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables, strict_top_level_inference

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/subCategrory.dart';
import 'package:kohira/controller/API/menu/others/drawer/Jewellery_list.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/subcetegroy/filter_fuction.dart';
import 'package:kohira/view/screen/menu/category/filter_screen.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart'
    show Showproduct;
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/lodingstate.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/user_inerface/menu/categroy/subcetegroy/filter.dart';
import '../../../../controller/user_inerface/menu/categroy/subcetegroy/subcetegrory.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/inputField.dart';

class Subcategorys extends StatefulWidget {
  String? subcategrorys;
  String? subcategory_slug;
  String? collection_id;
  String? subcategrorysname;
  String? metal_type;
  String? price_min;
  String? price_max;

  Subcategorys({
    super.key,
    this.subcategrorys,
    this.subcategory_slug,
    this.collection_id,
    this.subcategrorysname,
    this.metal_type,
    this.price_min,
    this.price_max,
  });

  @override
  State<Subcategorys> createState() => _SubcategorysState();
}

class _SubcategorysState extends State<Subcategorys> {
  late SubcetegroryUIController subUI;

  @override
  void initState() {
    super.initState();
    subUI = Get.put(
      SubcetegroryUIController(
        subcategrorys: widget.subcategrorys,
        subcategory_slug: widget.subcategory_slug,
        collection_id: widget.collection_id,
        subcategrorysname: widget.subcategrorysname,
        metal_type: widget.metal_type,
        price_min: widget.price_min,
        price_max: widget.price_max,
      ),
      tag: widget.subcategory_slug,
    );
    loadData();
  }

  void loadData() {
    subUI.subcategrory.resetPagination();
    subUI.subcategrory.subcategroryuser(
      category_slug: widget.subcategrorys,
      subcategory_slug: widget.subcategory_slug,
      collection_id: widget.collection_id,
      metal_type: widget.metal_type,
      price_min: widget.price_min,
      price_max: widget.price_max,
    );
  }

  @override
  void dispose() {
    Get.delete<SubcetegroryUIController>(tag: widget.subcategory_slug);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColor.white_color,
        appBar: Appbar(
          lefticon: AppIcon.left,
          hedingname_2: subUI.currentSubcategoryName.value.toUpperCase(),
        ),
        bottomNavigationBar: (subUI.subcategrory.isLoading.value)
            ? null
            : _buildBottomNavigationBar(context),
        body: Container(
          height: Get.height,
          width: Get.width,
          color: AppColor.white_color,
          child: Obx(() {
            if (subUI.subcategrory.isLoading.value &&
                subUI.subcategrory.data.isEmpty) {
              return _buildShimmerLoading();
            }
            return _buildBodyContent();
          }),
        ),
      );
    });
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.pink_color.withOpacity(0.35),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: _buildSortButton(context)),
            const SizedBox(width: 12),
            Expanded(child: _buildFilterButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Storebay().storebay(
        context,
        subcategrorys: widget.subcategrorys.toString(),
        subcategory_slug: widget.subcategory_slug.toString(),
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.brown_color, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swap_vert_rounded, color: AppColor.pink_color, size: 22),
            const SizedBox(width: 8),
            Text(
              "SORT",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.pink_color,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showFilterBottomSheet(
        context,
        category_slug: widget.subcategrorys,
        subcategory_slug: widget.subcategory_slug,
        subcategrorysname: widget.subcategrorysname,
        onApply: () {
          final filtertab = Get.put(FilterController());

          String newHeadingName = '';
          if (filtertab.selectedSubcategoryName.value.isNotEmpty) {
            newHeadingName = filtertab.selectedSubcategoryName.value;
          } else if (filtertab.selectedCategoryName.value.isNotEmpty) {
            newHeadingName = filtertab.selectedCategoryName.value;
          } else if (widget.subcategrorysname != null) {
            newHeadingName = widget.subcategrorysname!;
          }

          if (newHeadingName.isNotEmpty) {
            subUI.updateSubcategoryName(newHeadingName);
          }

          subUI.subcategrory.resetPagination();
          subUI.subcategrory.subcategroryuser(
            category_slug: filtertab.selectedCategorySlug.value.isNotEmpty
                ? filtertab.selectedCategorySlug.value
                : widget.subcategrorys,
            subcategory_slug: filtertab.selectedSubcategorySlug.value.isNotEmpty
                ? filtertab.selectedSubcategorySlug.value
                : widget.subcategory_slug,
            metal_type: filtertab.selectedMetalType.value,
            metal_stamp: filtertab.metalstapid.value,
            diamond_type: filtertab.diamondtype.value,
            price_min: filtertab.priceMin.value?.toString(),
            price_max: filtertab.priceMax.value?.toString(),
            weight_min: filtertab.weightMin.value?.toString(),
            weight_max: filtertab.weightMax.value?.toString(),
          );
        },
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.brown_color, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              color: AppColor.pink_color,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              "FILTERS",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.pink_color,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return horizontalpadding(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height / 50),
            Shimmer.fromColors(
              baseColor: AppColor.lodingcolor,
              highlightColor: AppColor.highlightColor,
              child: Container(
                height: Get.height * 0.05,
                decoration: BoxDecoration(
                  color: AppColor.white_color,
                  border: Border.all(color: AppColor.textfild_color),
                  borderRadius:
                      BorderRadiusDirectional.circular(Get.width / 50),
                ),
              ),
            ),
            SizedBox(height: Get.height / 50),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Get.height / 50,
                crossAxisSpacing: Get.width / 50,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return _buildShimmerItem();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: AppColor.lodingcolor,
      highlightColor: AppColor.highlightColor,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.white_color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(47),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: Get.height * 0.010),
            Container(
              width: Get.width / 4,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: Get.height * 0.010),
            Container(
              width: Get.width / 6,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    final indianFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return SafeArea(
      child: horizontalpadding(
        child: RefreshIndicator(
          strokeWidth: 3.5,
          color: AppColor.pink_color,
          backgroundColor: AppColor.white_color,
          onRefresh: () async {
            subUI.subcategrory.resetPagination();
            await subUI.subcategrory.subcategroryuser(
              category_slug: widget.subcategrorys,
              subcategory_slug: widget.subcategory_slug,
            );
          },
          child: Column(
            children: [
              SizedBox(height: Get.height / 50),
              searchField(onChanged: (value) {
                subUI.subcategrory.handleSearch(value);
                subUI.subcategrory.update();
              }),
              SizedBox(height: Get.height / 50),
              _buildActiveFiltersRow(),
              subUI.subcategrory.data.isEmpty
                  ? _buildNoDataState()
                  : _buildProductGrid(indianFormat),
              _buildPaginationLoader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFiltersRow() {
    final filtertab = Get.put(FilterController());

    return Obx(() {
      final List<Map<String, String>> activeChips = [];

      if (filtertab.selectedCategoryName.value.isNotEmpty) {
        activeChips.add({
          'type': 'category',
          'label': filtertab.selectedCategoryName.value,
        });
      }
      if (filtertab.selectedSubcategoryName.value.isNotEmpty) {
        activeChips.add({
          'type': 'subcategory',
          'label': filtertab.selectedSubcategoryName.value,
        });
      }
      if (filtertab.selectedMetalType.value.isNotEmpty) {
        activeChips.add({
          'type': 'metal_type',
          'label': filtertab.selectedMetalType.value.capitalizeFirst ??
              filtertab.selectedMetalType.value,
        });
      }
      if (filtertab.metalstapid.value.isNotEmpty) {
        activeChips.add({
          'type': 'metal_stamp',
          'label': filtertab.metalstapid.value.toUpperCase(),
        });
      }
      if (filtertab.diamondtype.value.isNotEmpty) {
        activeChips.add({
          'type': 'diamond_type',
          'label': filtertab.diamondtype.value.capitalizeFirst ??
              filtertab.diamondtype.value,
        });
      }
      if (filtertab.selectedPrice.value.isNotEmpty) {
        activeChips.add({
          'type': 'price',
          'label': filtertab.selectedPrice.value,
        });
      }
      if (filtertab.selectedWeight.value.isNotEmpty) {
        activeChips.add({
          'type': 'weight',
          'label': filtertab.selectedWeight.value,
        });
      }

      if (activeChips.isEmpty) {
        return SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(bottom: Get.height / 70),
        child: SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activeChips.length + 1,
            itemBuilder: (context, index) {
              if (index == activeChips.length) {
                return GestureDetector(
                  onTap: () {
                    filtertab.clearFilters();
                    if (widget.subcategrorysname != null) {
                      subUI.updateSubcategoryName(widget.subcategrorysname!);
                    }
                    _applyCurrentFilters(filtertab);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 4),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      border: Border.all(color: AppColor.grey_color),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Clear All",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.grey_color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final chip = activeChips[index];
              return Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.spicalcontainer,
                  border: Border.all(color: AppColor.textfild_color),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chip['label']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.black_color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        _removeSingleFilter(chip['type']!, filtertab);
                      },
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: AppColor.grey_color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  void _removeSingleFilter(String type, FilterController filtertab) {
    switch (type) {
      case 'category':
        filtertab.selectedCategorySlug.value = '';
        filtertab.selectedCategoryName.value = '';
        break;
      case 'subcategory':
        filtertab.selectedSubcategorySlug.value = '';
        filtertab.selectedSubcategoryName.value = '';
        break;
      case 'metal_type':
        filtertab.selectedMetalType.value = '';
        break;
      case 'metal_stamp':
        filtertab.metalstapid.value = '';
        break;
      case 'diamond_type':
        filtertab.diamondtype.value = '';
        filtertab.selectedShapeId.value = '';
        break;
      case 'price':
        filtertab.selectedPrice.value = '';
        filtertab.priceMin.value = null;
        filtertab.priceMax.value = null;
        break;
      case 'weight':
        filtertab.selectedWeight.value = '';
        filtertab.weightMin.value = null;
        filtertab.weightMax.value = null;
        break;
    }

    String newHeadingName = '';
    if (filtertab.selectedSubcategoryName.value.isNotEmpty) {
      newHeadingName = filtertab.selectedSubcategoryName.value;
    } else if (filtertab.selectedCategoryName.value.isNotEmpty) {
      newHeadingName = filtertab.selectedCategoryName.value;
    } else if (widget.subcategrorysname != null) {
      newHeadingName = widget.subcategrorysname!;
    }
    if (newHeadingName.isNotEmpty) {
      subUI.updateSubcategoryName(newHeadingName);
    }

    _applyCurrentFilters(filtertab);
  }

  void _applyCurrentFilters(FilterController filtertab) {
    subUI.subcategrory.resetPagination();
    subUI.subcategrory.subcategroryuser(
      category_slug: filtertab.selectedCategorySlug.value.isNotEmpty
          ? filtertab.selectedCategorySlug.value
          : widget.subcategrorys,
      subcategory_slug: filtertab.selectedSubcategorySlug.value.isNotEmpty
          ? filtertab.selectedSubcategorySlug.value
          : widget.subcategory_slug,
      metal_type: filtertab.selectedMetalType.value,
      metal_stamp: filtertab.metalstapid.value,
      diamond_type: filtertab.diamondtype.value,
      price_min: filtertab.priceMin.value?.toString(),
      price_max: filtertab.priceMax.value?.toString(),
      weight_min: filtertab.weightMin.value?.toString(),
      weight_max: filtertab.weightMax.value?.toString(),
    );
  }

  Widget _buildNoDataState() {
    return Expanded(
      child: Center(
        child: Lottie.asset(AppJson.noData),
      ),
    );
  }

  Widget _buildProductGrid(NumberFormat indianFormat) {
    return Expanded(
      child: GridView.builder(
        controller: subUI.scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: Get.height / 50,
          crossAxisSpacing: Get.width / 50,
          childAspectRatio: 0.68,
        ),
        itemCount: subUI.subcategrory.data.length,
        itemBuilder: (context, index) {
          final item = subUI.subcategrory.data[index];
          return _buildProductItem(item, indianFormat);
        },
      ),
    );
  }

  Widget _buildProductItem(dynamic item, NumberFormat indianFormat) {
    final discount =
        double.tryParse(item['discount']?.toString() ?? '0') ?? 0.0;
    final price = discount > 0 ? item['offer_price'] : item['setting_price'];
    final couponType =
        item['coupon_type']?.toString().capitalizeFirst ?? 'Labour';

    return GestureDetector(
      onTap: () {
        print('Id :- ${item['id']}');
        print('Slug :- ${item['slug']}');
        Get.to(() => Showproduct(
              slug: item['slug'],
              categoryslug: item.toString(),
            ));
        print('Title :- ${item.toString()}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (discount > 0) ...[
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColor.pink_color.withOpacity(0.35),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "${discount.toStringAsFixed(0)}% off on $couponType price!",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.white_color,
                  fontSize: Get.height / 90,
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: Get.height / 150),
          ],
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(item['default_image']),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: Get.height / 150),
          Text(
            item['title'] ?? '',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: Get.height / 70, fontFamily: 'Lora'),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                indianFormat.format(price),
                style: TextStyle(
                  fontSize: Get.height / 70,
                  fontFamily: 'Lora',
                  color: AppColor.pink_color,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              if (discount > 0 && item['setting_price'] != null) ...[
                SizedBox(width: 4),
                Text(
                  indianFormat.format(item['setting_price']),
                  style: TextStyle(
                    fontSize: Get.height / 80,
                    fontFamily: 'Lora',
                    color: AppColor.grey_color,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationLoader() {
    if (subUI.subcategrory.hasMore.value &&
        subUI.subcategrory.isLoading.value) {
      return Padding(
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
      );
    }
    return SizedBox.shrink();
  }
}
