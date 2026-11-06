// ignore_for_file: dead_null_aware_expression, avoid_print, unused_local_variable, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use, prefer_collection_literals, prefer_conditional_assignment, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/category/jewelleryDetail.dart'
    show JewellerydetailCall;
import 'package:kohira/controller/API/menu/category/recommendedJewelleryList.dart';
import 'package:kohira/controller/API/menu/myCart/withoutlogin.dart';
import 'package:kohira/controller/API/menu/others/count.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/showproduct_controller.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/view/screen/credentials/login.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/video.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/API/menu/category/addtocart.dart';
import '../../../../controller/API/menu/category/subcategrory/filtercategory.dart';
import '../../../../controller/API/menu/category/wishlist.dart';
import '../../../../controller/database/local/localstore.dart';
import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../../controller/user_inerface/menu/myCart/wishlist/wishlist.dart';
import '../../../../modal/menu/category/subcategory/addtocart.dart';
import '../../../../modal/menu/category/subcategory/addtowish.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/bottomNavigation/bottomNavigation.dart';
import '../../../utils/widget/pop.dart';

class Showproduct extends StatefulWidget {
  final String slug;
  final String categoryslug;

  const Showproduct(
      {super.key, required this.slug, required this.categoryslug});

  @override
  State<Showproduct> createState() => _ShowproductState();
}

class _ShowproductState extends State<Showproduct> {
  final bool isGuest = (tokans.isEmpty ?? true);

  // Controllers
  final productController = Get.put(ShowproductController());
  final bottamSelect = Get.put(Bottamnavigation());
  final jewellerydetail = Get.put(JewellerydetailCall());
  final recommendedjewellerylist = Get.put(Recommendedjewellerylist());
  final wishlist = Get.put(Wishlist());
  final count = Get.put(CountController());
  final myCart = Get.put(MyCartValueChange());
  final wish = Get.put(WishlistController());
  final category = Get.put(JewelleryFilterCategory());
  final userguest = Get.put(CartControllor());
  final wishguest = Get.put(WishcartControllet());

  List<String> savewishlist = [];
  bool isWishlisted = false;
  bool isWishlistedGuest = false;
  List<JewelryItemWish> existingItemsWish = [];

  String? ringsizeid;

  @override
  void initState() {
    super.initState();
    productController.resetState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jewellerydetail.jewellerydetailservices(slug: widget.slug);
      recommendedjewellerylist.recommendedjewellerylistFuction(
          slug: widget.slug);
      count.counting();
      initializeWishlistStatus();
    });
  }

  void initializeWishlistStatus() async {
    if (isGuest) {
      List<JewelryItemWish> currentItemswish =
          await localdatabase.getJewelryItemsWish();
      final jewelryId = jewellerydetail.data['data']['id'].toString();
      final exists =
          currentItemswish.any((item) => item.jewelryId == jewelryId);

      setState(() {
        isWishlistedGuest = exists;
        existingItemsWish = currentItemswish;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname: AppString.productdetails,
        suffixicon_1: AppIcon.like,
        suffixicon_2: AppIcon.shop,
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(() {
          if (jewellerydetail.isLoading.value || jewellerydetail.data == null) {
            return SizedBox.shrink();
          } else {
            final jewellery = jewellerydetail.data['data'] ?? {};
            return _buildBottomNavigationBar(jewellery);
          }
        }),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Obx(() {
          if (jewellerydetail.isLoading.value) {
            return _buildShimmerLoading();
          }

          if (jewellerydetail.data == null ||
              jewellerydetail.data['data'] == null ||
              jewellerydetail.data['data'] is! Map) {
            return _buildErrorState();
          }

          final jewellery = jewellerydetail.data['data'];
          final variants = jewellery['variants'] ?? [];
          final allRingSizes = jewellery['allRingSize'] ?? [];

          // Initialize selections in controller
          productController.initSelections(jewellery);

          final uniqueMetalStamps =
              productController.getUniqueMetalStamps(variants);
          final availableColors =
              productController.getAvailableColors(variants);
          final currentVariant = productController.getCurrentVariant(variants);
          final diamondQualities =
              productController.getDiamondQualities(variants);
          final uniqueShapes =
              productController.getUniqueShapes(variants, 'center');

          final diamonds = currentVariant?['jewelry_diamonds'] as List? ?? [];
          final totaldiamondsCenter = diamonds.isNotEmpty
              ? (diamonds[0]['totaldiamonds']?.toString())
              : null;
          final totalweightCenter = diamonds.isNotEmpty
              ? (diamonds[0]['totalweight']?.toString())
              : null;
          final totaldiamondsSide = diamonds.length > 1
              ? (diamonds[1]['totaldiamonds']?.toString())
              : null;
          final totalweightSide = diamonds.length > 1
              ? (diamonds[1]['totalweight']?.toString())
              : null;

          final double goldPrice = double.tryParse(
                  currentVariant?['sync_metal_price']?.toString() ?? '0') ??
              0.0;
          final double makingCharge = double.tryParse(
                  currentVariant?['sync_labour_charge_price']?.toString() ??
                      '0') ??
              0.0;
          final double diamondPrice = double.tryParse(
                  currentVariant?['sync_dia_price']?.toString() ?? '0') ??
              0.0;

          final double total = goldPrice + makingCharge + diamondPrice;

          final goldPrices =
              '₹ ${NumberFormat('#,##0.00', 'en_IN').format(goldPrice)}';
          final makingChargs =
              '₹ ${NumberFormat('#,##0.00', 'en_IN').format(makingCharge)}';
          final diamoinds =
              '₹ ${NumberFormat('#,##0.00', 'en_IN').format(diamondPrice)}';
          final totals = '₹ ${NumberFormat('#,##0.00', 'en_IN').format(total)}';

          final diamondList = currentVariant?['jewelry_diamonds'] ?? [];
          final allImages = currentVariant?['allImages'] ?? [];
          final video = currentVariant?['video'] ?? [];

          final list = recommendedjewellerylist.data['data'];

          String getShapeText() {
            try {
              return currentVariant!['jewelry_diamonds']?[1]?['shape']
                      ?['paraname'] ??
                  'N/A';
            } catch (e) {
              return 'N/A';
            }
          }

          final indianFormat = NumberFormat.currency(
              locale: 'en_IN', symbol: '₹', decimalDigits: 2);

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height / 80),
                  _buildImageGallery(allImages, video),
                  SizedBox(height: Get.height / 80),
                  horizontalpadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height / 50),
                        _buildProductHeader(
                            currentVariant, jewellery, indianFormat),
                        SizedBox(height: Get.height / 50),
                        _buildVariantOptions(
                          variants: variants,
                          uniqueMetalStamps: uniqueMetalStamps,
                          availableColors: availableColors,
                          uniqueShapes: uniqueShapes,
                          allRingSizes: allRingSizes,
                          diamondQualities: diamondQualities,
                          currentVariant: currentVariant,
                        ),
                        SizedBox(height: Get.height / 50),
                        _buildDescriptionSection(
                            currentVariant?['description']),
                        SizedBox(height: Get.height / 50),
                        _buildAccordionSections(
                          currentVariant: currentVariant,
                          totaldiamondsCenter: totaldiamondsCenter,
                          totalweightCenter: totalweightCenter,
                          totaldiamondsSide: totaldiamondsSide,
                          totalweightSide: totalweightSide,
                          shapeText: getShapeText(),
                          goldPrices: goldPrices,
                          makingChargs: makingChargs,
                          diamoinds: diamoinds,
                          totals: totals,
                        ),
                        SizedBox(height: Get.height / 50),
                        _buildCustomerSupportInfo(),
                        SizedBox(height: Get.height / 50),
                        Divider(color: AppColor.textfild_color),
                        SizedBox(height: Get.height / 50),
                        _buildTrustBadges(),
                        SizedBox(height: Get.height / 50),
                        if (list != null) ...[
                          Text(AppString.youMay,
                              style: TextStyle(
                                  fontFamily: 'Lora',
                                  fontSize: Get.width * 0.045)),
                          SizedBox(height: Get.height / 80),
                        ],
                      ],
                    ),
                  ),
                  if (list != null) _buildRecommendedProducts(list),
                  SizedBox(height: Get.height / 80),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // 1. Bottom Navigation Bar Widget (Add to Cart / Buy Now)
  Widget _buildBottomNavigationBar(Map<String, dynamic> jewellery) {
    return Container(
      height: Get.height * 0.070,
      color: AppColor.white_color,
      child: horizontalpadding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Add to cart
            GestureDetector(
              onTap: () async {
                if (isGuest) {
                  List<JewelryItem> currentItems =
                      await localdatabase.getJewelryItems();
                  currentItems.add(
                    JewelryItem(
                      jewelryId: jewellery['id'].toString(),
                      ringSize:
                          productController.selectedRingSizeId.value.toString(),
                      qty: 1,
                    ),
                  );
                  await localdatabase.saveJewelryItems(currentItems);
                  Withoutlogin().withoutlogin(currentItems);

                  userguest.cartcount.value = currentItems.length;
                  pref!
                      .setString('count', userguest.cartcount.value.toString());
                  cartCount = pref!.getString('count') ?? '0';

                  Withoutlogin().data['count'] = userguest.cartcount.value;
                  existingItemsCart = currentItems;

                  ToastificationSuccess.Success('Add To cart Suessfully');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    myCart.loadCartData();
                  });
                  setState(() {});
                } else {
                  if (widget.categoryslug == 'rings' ||
                      widget.categoryslug == 'engagement-rings') {
                    if (productController.selectedRingSizeId.value == null &&
                        productController.selectedRingSizeParaname.value ==
                            null) {
                      ToastificationError.Error('Please select ring size');
                    } else {
                      if (Addtocart().isLoading.value) {
                        Get.dialog(
                            Center(child: Lottie.asset(AppJson.loading2)));
                      } else {
                        Addtocart()
                            .addtocartservice(
                          jewelryid: jewellery['id'].toString(),
                          ringsize: productController.selectedRingSizeId.value
                              .toString(),
                          tokan: tokans,
                        )
                            .then((_) {
                          setState(() {
                            count.counting();
                            myCart.onInit();
                          });
                        });
                      }
                    }
                  } else {
                    if (Addtocart().isLoading.value) {
                      Get.dialog(Center(child: Lottie.asset(AppJson.loading2)));
                    } else {
                      Addtocart()
                          .addtocartservice(
                        jewelryid: jewellery['id'].toString(),
                        ringsize: "",
                        tokan: tokans,
                      )
                          .then((_) {
                        setState(() {
                          count.counting();
                          myCart.onInit();
                        });
                      });
                    }
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.105,
                    vertical: Get.height * 0.015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Get.width / 50),
                  color: Colors.black,
                ),
                child: Text(AppString.addtocart,
                    style: TextStyle(color: AppColor.white_color)),
              ),
            ),

            // Buy Now
            GestureDetector(
              onTap: () async {
                if (isGuest) {
                  Get.offAll(() => Login());
                } else {
                  if (widget.categoryslug == 'rings' ||
                      widget.categoryslug == 'engagement-rings') {
                    if (productController.selectedRingSizeId.value == null &&
                        productController.selectedRingSizeParaname.value ==
                            null) {
                      ToastificationError.Error('Please select ring size');
                    } else {
                      if (Addtocart().isLoading.value) {
                        Get.dialog(
                            Center(child: Lottie.asset(AppJson.loading2)));
                      } else {
                        await Addtocart().addtocartservice(
                          jewelryid: jewellery['id'].toString(),
                          ringsize: productController.selectedRingSizeId.value
                              .toString(),
                          tokan: tokans,
                        );
                        if (!mounted) return;
                        setState(() {
                          count.counting();
                          myCart.onInit();
                        });
                        Bottom();
                        bottamSelect.indexThree();
                        Get.back();
                        Get.back();
                        Get.back();
                      }
                    }
                  } else {
                    if (Addtocart().isLoading.value) {
                      Get.dialog(Center(child: Lottie.asset(AppJson.loading2)));
                    } else {
                      await Addtocart().addtocartservice(
                        jewelryid: jewellery['id'].toString(),
                        ringsize: '',
                        tokan: tokans,
                      );
                      if (!mounted) return;
                      setState(() {
                        count.counting();
                        myCart.onInit();
                      });
                      Bottom();
                      bottamSelect.indexThree();
                      Get.back();
                      Get.back();
                      Get.back();
                    }
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.14, vertical: Get.height * 0.015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Get.width / 50),
                  color: Colors.black,
                ),
                child: Text(AppString.buynow,
                    style: TextStyle(color: AppColor.white_color)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Shimmer Loading Skeleton
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.lodingcolor,
      highlightColor: AppColor.highlightColor,
      child: horizontalpadding(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height / 50),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Get.width / 50),
                    border: Border.all(color: AppColor.white_color)),
                child: Container(
                  height: Get.height * 0.50,
                  decoration: BoxDecoration(
                    color: AppColor.white_color,
                    borderRadius: BorderRadius.circular(Get.width / 50),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 80),
              SizedBox(
                height: Get.height / 8.5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Get.width / 50),
                          border: Border.all(color: AppColor.white_color)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Get.width / 50),
                          color: AppColor.white_color,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Get.height / 50),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 140, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColor.white_color,
                          borderRadius: BorderRadius.circular(Get.width / 50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height / 130),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 120, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColor.white_color,
                          borderRadius: BorderRadius.circular(Get.width / 50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Get.height / 50),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Error State Widget
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No product data available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              jewellerydetail.jewellerydetailservices(slug: widget.slug);
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  // 4. Image Gallery & Thumbnail Slider
  Widget _buildImageGallery(List allImages, List video) {
    return Obx(() {
      final selectindex = productController.selectindex.value;
      return Column(
        children: [
          horizontalpadding(
            child: Container(
              height: video.isNotEmpty ? Get.height / 2 : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                border: Border.all(color: AppColor.textfild_color),
              ),
              child: selectindex < allImages.length
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(Get.width / 50),
                      child: PhotoView(
                        imageProvider:
                            NetworkImage(allImages[selectindex]['feature']),
                        backgroundDecoration:
                            BoxDecoration(color: Colors.transparent),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 4,
                        initialScale: PhotoViewComputedScale.covered,
                        enableRotation: false,
                      ),
                    )
                  : (video.isNotEmpty
                      ? horizontalpadding(
                          child: VideoPlayerMenuContainer(
                              videoUrl: video[0]['path']))
                      : Placeholder()),
            ),
          ),
          SizedBox(height: Get.height / 80),
          SizedBox(
            height: Get.height * 0.11,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allImages.length + video.length,
              itemBuilder: (context, index) {
                if (index < allImages.length) {
                  return GestureDetector(
                    onTap: () => productController.selectindex.value = index,
                    child: Container(
                      width: Get.width / 4.5,
                      margin: EdgeInsets.only(left: Get.width / 25),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadiusDirectional.circular(Get.width / 50),
                        border: Border.all(color: AppColor.textfild_color),
                        image: DecorationImage(
                            image: NetworkImage(allImages[index]['feature']),
                            fit: BoxFit.cover),
                      ),
                    ),
                  );
                } else {
                  final videoIndex = index - allImages.length;
                  return GestureDetector(
                    onTap: () => productController.selectindex.value =
                        allImages.length + videoIndex,
                    child: Container(
                      width: Get.width / 4.5,
                      margin: EdgeInsets.only(
                          right: Get.width / 50, left: Get.width / 50),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadiusDirectional.circular(Get.width / 50),
                        border: Border.all(color: AppColor.textfild_color),
                      ),
                      child: Center(
                          child: VideoPlayerMenuContainer(
                              videoUrl: video[0]['path'])),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );
    });
  }

  // 5. Product Title, SKU, Wishlist Heart & Price
  Widget _buildProductHeader(Map<String, dynamic>? currentVariant,
      Map<String, dynamic> jewellery, NumberFormat indianFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width / 1.5,
                  child: Text(
                    currentVariant?['title'] ?? 'Product Title',
                    style: TextStyle(
                        fontFamily: 'Lora', fontSize: Get.width * 0.045),
                  ),
                ),
                SizedBox(height: Get.width / 50),
                SizedBox(
                  width: Get.width / 1.5,
                  child: Text(
                    'SKU: ${currentVariant?['itemcode'] ?? 'N/A'}',
                    style: TextStyle(
                        fontSize: Get.width * 0.040,
                        color: AppColor.grey_color),
                  ),
                ),
                SizedBox(height: Get.width / 50),
              ],
            ),
            SizedBox(width: Get.width / 10),
            // Wishlist Toggle Button
            GestureDetector(
              onTap: () async {
                if (isGuest) {
                  List<JewelryItemWish> currentItemswish =
                      await localdatabase.getJewelryItemsWish();
                  final jewelryId = jewellery['id'].toString();
                  final exists = currentItemswish
                      .any((item) => item.jewelryId == jewelryId);
                  if (exists) {
                    currentItemswish
                        .removeWhere((item) => item.jewelryId == jewelryId);
                    ToastificationSuccess.Success('Removed from Wishlist');
                  } else {
                    currentItemswish.add(
                      JewelryItemWish(
                        jewelryId: jewellery['id'].toString(),
                        ringSize: productController.selectedRingSizeId.value
                            .toString(),
                        qty: 1,
                      ),
                    );
                    ToastificationSuccess.Success('Added to Wishlist');
                  }
                  await localdatabase.saveJewelryItemsWish(currentItemswish);
                  WithoutloginWishList().withoutloginwishlist(currentItemswish);

                  wishguest.wishcount.value = currentItemswish.length;
                  pref!.setString(
                      'wishcount', wishguest.wishcount.value.toString());
                  wishCount = pref!.getString('wishcount') ?? '0';

                  setState(() {
                    isWishlistedGuest = !exists;
                  });
                  existingItemsWish = currentItemswish;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    wish.withoutloginWish
                        .withoutloginwishlist(currentItemswish);
                  });
                  Get.forceAppUpdate();
                  setState(() {});
                } else {
                  if (widget.categoryslug == 'rings' ||
                      widget.categoryslug == 'engagement-rings') {
                    if (productController.selectedRingSizeId.value == null &&
                        productController.selectedRingSizeParaname.value ==
                            null) {
                      ToastificationError.Error('Please select ring size');
                      return;
                    }
                  }

                  if (wishlist.isLoading.value) {
                    Get.dialog(Center(child: Lottie.asset(AppJson.loading2)),
                        barrierDismissible: false);
                    return;
                  }

                  try {
                    Get.dialog(Center(child: Lottie.asset(AppJson.loading2)),
                        barrierDismissible: false);
                    await wishlist.wishlistservice(
                      ringsize:
                          productController.selectedRingSizeParaname.value,
                      jewelryid: currentVariant?['id'].toString(),
                      metal_stamp: isWishlisted
                          ? productController.selectedMetalStamp.value
                          : null,
                      metal_type: productController.selectedMetalType.value,
                      tokan: tokans,
                    );
                    Get.back();

                    setState(() {
                      isWishlisted = !isWishlisted;
                    });

                    count.counting();
                    wish.fetchwishlist.fechwishlist();
                  } catch (e) {
                    Get.back();
                    print('Wishlist error: $e');
                  }
                }
              },
              child: (isGuest)
                  ? FutureBuilder<List<JewelryItemWish>>(
                      future: localdatabase.getJewelryItemsWish(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final exists = snapshot.data!.any((item) =>
                              item.jewelryId == jewellery['id'].toString());
                          return SvgPicture.asset(
                            exists ? AppIcon.heart : AppIcon.like,
                            width: 30,
                            height: 30,
                            color: exists ? AppColor.pink_color : null,
                          );
                        }
                        return SvgPicture.asset(AppIcon.like,
                            width: 30, height: 30);
                      },
                    )
                  : (count.data['wishlist']?['jewelry_ids']
                              ?.contains(currentVariant?['id']) ??
                          false)
                      ? SvgPicture.asset(AppIcon.heart,
                          width: 30, height: 30, color: AppColor.pink_color)
                      : SvgPicture.asset(AppIcon.like, width: 30, height: 30),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              indianFormat.format(currentVariant?['setting_price']),
              style: TextStyle(
                  color: AppColor.pink_color,
                  fontWeight: FontWeight.w600,
                  fontSize: Get.width * 0.045),
            ),
            SizedBox(width: Get.width / 150),
            Text("(inclusive of all taxes)",
                style: TextStyle(color: AppColor.grey_color)),
          ],
        ),
      ],
    );
  }

  // 6. Variant Options (Metal Stamp, Color, Shape, Carat, Ring Size, Diamond Quality)
  Widget _buildVariantOptions({
    required List variants,
    required List<String> uniqueMetalStamps,
    required Map<String, bool> availableColors,
    required List<Map<String, dynamic>> uniqueShapes,
    required List allRingSizes,
    required List<String> diamondQualities,
    required Map<String, dynamic>? currentVariant,
  }) {
    return Obx(() {
      final selectedMetalStamp = productController.selectedMetalStamp.value;
      final selectedMetalType = productController.selectedMetalType.value;
      final selectedShape = productController.selectedShape.value;
      final selectedDiamondQuality =
          productController.selectedDiamondQuality.value;
      final goldcolor = productController.goldcolor.value;
      final rosegoldcolor = productController.rosegoldcolor.value;
      final graycolor = productController.graycolor.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metal Stamp Selection
          Row(
            children: [
              Text('Metal:',
                  style: TextStyle(
                      fontSize: Get.width * 0.040,
                      fontWeight: FontWeight.w500)),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uniqueMetalStamps.length,
                    itemBuilder: (context, index) {
                      final stamp = uniqueMetalStamps[index];
                      final isSelected = selectedMetalStamp == stamp;

                      return GestureDetector(
                        onTap: () {
                          productController.selectMetalStamp(stamp, variants);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isSelected
                                    ? Colors.amber
                                    : AppColor.textfild_color),
                            color: isSelected
                                ? Colors.amber.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              stamp,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Get.width / 30,
                                color: isSelected ? Colors.amber : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height / 50),

          // Color Selection
          Row(
            children: [
              Text('Color:',
                  style: TextStyle(
                      fontSize: Get.width * 0.040,
                      fontWeight: FontWeight.w500)),
              SizedBox(width: Get.width / 50),
              if (availableColors['Yellow Gold'] ?? false) ...[
                _buildColorButton(
                  border: BoxBorder.all(color: AppColor.glodcolor),
                  color: AppColor.glodcolor,
                  isSelected: goldcolor,
                  onTap: () =>
                      productController.updateColorState('Yellow Gold'),
                ),
                SizedBox(width: Get.width / 80),
              ],
              if (availableColors['Rose Gold'] ?? false) ...[
                _buildColorButton(
                  border: BoxBorder.all(color: AppColor.rosegoldcolor),
                  color: AppColor.rosegoldcolor,
                  isSelected: rosegoldcolor,
                  onTap: () => productController.updateColorState('Rose Gold'),
                ),
                SizedBox(width: Get.width / 80),
              ],
              if (availableColors['White Gold'] ?? false) ...[
                _buildColorButton(
                  border: BoxBorder.all(color: AppColor.graycolor),
                  color: AppColor.graycolor,
                  isSelected: graycolor,
                  onTap: () => productController.updateColorState('White Gold'),
                ),
              ],
            ],
          ),
          SizedBox(height: Get.height / 50),

          // Diamond Shape Selector
          if (uniqueShapes.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Shape:',
                  style: TextStyle(
                    fontSize: Get.width * 0.040,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: Get.width / 50),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: uniqueShapes.map((shape) {
                        bool isSelected = selectedShape != null &&
                            selectedShape['id'] == shape['id'];
                        return GestureDetector(
                          onTap: () => productController.filterVariantsByShape(
                            shape: shape,
                            diamondType: 'center',
                            variants: variants,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? Colors.amber : Colors.grey,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Image.network(shape['image'],
                                width: 40, height: 40),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height / 50),
          ],

          // Carat Weight
          if (productController
              .getUniqueCarats(variants, diamondType: 'center')
              .isNotEmpty) ...[
            Row(
              children: [
                Text('Carat Weight : ',
                    style: TextStyle(
                        fontSize: Get.width * 0.040,
                        fontWeight: FontWeight.w500)),
                SizedBox(width: Get.width / 50),
                Expanded(
                  child: SizedBox(
                    height: Get.height / 20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: productController
                          .getUniqueCarats(variants, diamondType: 'center')
                          .length,
                      itemBuilder: (context, index) {
                        final carat = productController.getUniqueCarats(
                            variants,
                            diamondType: 'center')[index];
                        final isSelected =
                            currentVariant?['total_carat'] == carat;

                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            color: WidgetStatePropertyAll(
                                Colors.amber.withOpacity(0.1)),
                            label: Text(
                                '${carat.toStringAsFixed(3).replaceAll(RegExp(r'\.0+$'), '')} ct',
                                style: TextStyle(color: Colors.amber)),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                productController.filterVariantsByCarat(carat,
                                    diamondType: 'center', variants: variants);
                              }
                            },
                            backgroundColor: Colors.amber.withOpacity(0.1),
                            selectedColor: Colors.amber.withOpacity(0.1),
                            shape: StadiumBorder(
                                side: BorderSide(
                                    color: Colors.amber, width: 1.5)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height / 50),
          ],

          // Ring Size
          if (allRingSizes.isNotEmpty) ...[
            Row(
              children: [
                Text('Ring Size:',
                    style: TextStyle(
                        fontSize: Get.width * 0.040,
                        fontWeight: FontWeight.w500)),
                SizedBox(width: Get.width / 50),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.textfild_color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    hint: Text(""),
                    menuMaxHeight: Get.height / 5,
                    borderRadius: BorderRadius.circular(Get.width / 50),
                    value: productController.selectedRingSizeParaname.value,
                    items: allRingSizes.map<DropdownMenuItem<String>>((ring) {
                      return DropdownMenuItem<String>(
                        value: ring['paraname'].toString(),
                        child: Text(ring['paraname'].toString()),
                        onTap: () => productController
                            .selectedRingSizeId.value = ring['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      productController.selectedRingSizeParaname.value = value;
                    },
                    underline: SizedBox(),
                    icon: SizedBox(),
                  ),
                ),
                SizedBox(width: Get.width / 50),
                Text('Find Ring Size'),
              ],
            ),
            SizedBox(height: Get.height / 50),
          ],

          // Diamond Quality Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Diamond Quality:',
                  style: TextStyle(
                      fontSize: Get.width * 0.040,
                      fontWeight: FontWeight.w500)),
              SizedBox(width: Get.width / 40),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: diamondQualities.length,
                    itemBuilder: (context, index) {
                      final quality = diamondQualities[index];
                      final isSelected = selectedDiamondQuality == quality;

                      return GestureDetector(
                        onTap: () {
                          productController.selectedDiamondQuality.value =
                              quality;
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isSelected
                                    ? Colors.amber
                                    : AppColor.textfild_color),
                            color: isSelected
                                ? Colors.amber.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Center(
                              child: Text(quality,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: Get.width / 30,
                                      color: isSelected
                                          ? Colors.amber
                                          : Colors.black))),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  // 7. Product Description Text
  Widget _buildDescriptionSection(String? description) {
    if (description == null || description.isEmpty) return SizedBox.shrink();
    return Text(
      description,
      style: TextStyle(color: AppColor.grey_color, fontSize: Get.width * 0.035),
    );
  }

  // 8. Accordion Details Sections
  Widget _buildAccordionSections({
    required Map<String, dynamic>? currentVariant,
    required String? totaldiamondsCenter,
    required String? totalweightCenter,
    required String? totaldiamondsSide,
    required String? totalweightSide,
    required String shapeText,
    required String goldPrices,
    required String makingChargs,
    required String diamoinds,
    required String totals,
  }) {
    return Obx(() {
      final productdetails = productController.productdetails.value;
      final sidediamondDetails = productController.sidediamondDetails.value;
      final centerdiamondDetails = productController.centerdiamondDetails.value;
      final metal = productController.metal.value;
      final priceBreakup = productController.priceBreakup.value;

      return Column(
        children: [
          // Product Details Accordion
          GestureDetector(
            onTap: () => productController.toggleProductDetails(),
            child: Container(
              color: AppColor.white_color,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product details',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                        Text(productdetails ? '-' : '+',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Divider(color: AppColor.dividercolor),
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          SizedBox(height: Get.height / 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Product Code :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(currentVariant?['itemcode'] ?? 'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Category :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['metal_type']?['slug'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Product Weight(apx) :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  "${currentVariant?['metalweight'].toString()} gram",
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          if (currentVariant?['total_carat'] != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Diamond Weight(apx) :',
                                    style:
                                        TextStyle(color: AppColor.grey_color)),
                                Text(currentVariant!['total_carat'].toString(),
                                    style:
                                        TextStyle(color: AppColor.grey_color)),
                              ],
                            ),
                          SizedBox(height: Get.height / 100),
                        ],
                      ),
                      crossFadeState: productdetails
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height / 150),

          // Side Diamond Details Accordion
          GestureDetector(
            onTap: () => productController.toggleSideDiamondDetails(),
            child: Container(
              color: AppColor.white_color,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Side Diamond Details',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                        Text(sidediamondDetails ? '-' : '+',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Divider(color: AppColor.dividercolor),
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          SizedBox(height: Get.height / 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Color :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['jewelry_diamonds']?[0]
                                          ?['color'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Clarity :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['jewelry_diamonds']?[0]
                                          ?['clarity'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shape :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(shapeText,
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pieces :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(totaldiamondsSide ?? '0',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Weight :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(totalweightSide ?? '0',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          SizedBox(height: Get.height / 100),
                        ],
                      ),
                      crossFadeState: sidediamondDetails
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height / 150),

          // Center Diamond Details Accordion
          GestureDetector(
            onTap: () => productController.toggleCenterDiamondDetails(),
            child: Container(
              color: AppColor.white_color,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Center Diamond Details',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                        Text(centerdiamondDetails ? '-' : '+',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Divider(color: AppColor.dividercolor),
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          SizedBox(height: Get.height / 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shape :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['jewelry_diamonds']?[0]
                                          ?['shape']?['paraname'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Color :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['jewelry_diamonds']?[0]
                                          ?['color'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Clarity :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['jewelry_diamonds']?[0]
                                          ?['clarity'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pieces :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(totaldiamondsCenter ?? '0',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Weight :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(totalweightCenter ?? '0',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          SizedBox(height: Get.height / 100),
                        ],
                      ),
                      crossFadeState: centerdiamondDetails
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height / 150),

          // Metal Accordion
          GestureDetector(
            onTap: () => productController.toggleMetal(),
            child: Container(
              color: AppColor.white_color,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Metal',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                        Text(metal ? '-' : '+',
                            style: TextStyle(
                                fontSize: Get.width * 0.040,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Divider(color: AppColor.dividercolor),
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          SizedBox(height: Get.height / 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Type :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['metal_type']?['paraname'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Stamp :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(
                                  currentVariant?['metal_stamp']?['paraname'] ??
                                      'N/A',
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          SizedBox(height: Get.height / 100),
                        ],
                      ),
                      crossFadeState: metal
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height / 150),

          // Price Breakup Accordion
          GestureDetector(
            onTap: () => productController.togglePriceBreakup(),
            child: Container(
              color: AppColor.white_color,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price Breakup',
                          style: TextStyle(
                              fontSize: Get.width * 0.040,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          priceBreakup ? '-' : '+',
                          style: TextStyle(
                              fontSize: Get.width * 0.040,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          SizedBox(height: Get.height / 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Gold Price :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(goldPrices,
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Making Charges :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(makingChargs,
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Diamond Price :',
                                  style: TextStyle(color: AppColor.grey_color)),
                              Text(diamoinds,
                                  style: TextStyle(color: AppColor.grey_color)),
                            ],
                          ),
                          SizedBox(height: Get.height / 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total :-',
                                  style: TextStyle(
                                      color: AppColor.pink_color,
                                      fontSize: Get.width / 24,
                                      fontWeight: FontWeight.w600)),
                              Text(totals,
                                  style: TextStyle(
                                      color: AppColor.pink_color,
                                      fontSize: Get.width / 24,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(height: Get.height / 100),
                        ],
                      ),
                      crossFadeState: priceBreakup
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                    Divider(color: AppColor.textfild_color),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // 9. Customer Support Info Icons & Text
  Widget _buildCustomerSupportInfo() {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(AppIcon.support,
                color: AppColor.graycolor, width: 28),
            SizedBox(width: Get.width / 30),
            Text('24 / 7 Customer Service Live Chat',
                style: TextStyle(fontSize: Get.width / 28)),
          ],
        ),
        SizedBox(height: Get.height / 150),
        Row(
          children: [
            SvgPicture.asset(AppIcon.mobileIcon,
                color: AppColor.graycolor, width: 28),
            SizedBox(width: Get.width / 30),
            SizedBox(
              width: Get.width / 1.3,
              child: Text('Call us at +917851005200 (9:30 AM to 8:00 PM)',
                  style: TextStyle(fontSize: Get.width / 28)),
            ),
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(AppIcon.mail,
                color: AppColor.graycolor, width: 28),
            SizedBox(width: Get.width / 30),
            Text('Have a question? Send us an email',
                style: TextStyle(fontSize: Get.width / 28)),
          ],
        ),
      ],
    );
  }

  // 10. Trust Badges (Ethical Sourcing, Lifetime Warranty, IGI Certified, BIS Hallmark)
  Widget _buildTrustBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppString.headingMade,
            style: TextStyle(fontFamily: 'Lora', fontSize: Get.width * 0.045)),
        SizedBox(height: Get.height / 150),
        Text(AppString.conceptMade,
            style: TextStyle(
                fontSize: Get.width * 0.035, color: AppColor.grey_color)),
        SizedBox(height: Get.height / 50),
        Container(
          decoration: BoxDecoration(
            color: AppColor.showcontainercolor,
            borderRadius: BorderRadius.circular(Get.width / 80),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SvgPicture.asset(AppIcon.puzzle,
                      color: AppColor.grey_color, width: 35),
                  SizedBox(height: Get.height / 80),
                  Text(
                      textAlign: TextAlign.center,
                      'Ethical\nSourcing',
                      style: TextStyle(
                          fontSize: Get.width / 28,
                          color: AppColor.grey_color)),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(AppIcon.warranty,
                      color: AppColor.grey_color, width: 35),
                  SizedBox(height: Get.height / 80),
                  Text(
                      textAlign: TextAlign.center,
                      'Lifetime\nWarranty',
                      style: TextStyle(
                          fontSize: Get.width / 28,
                          color: AppColor.grey_color)),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(AppIcon.social,
                      color: AppColor.grey_color, width: 35),
                  SizedBox(height: Get.height / 80),
                  Text(
                      textAlign: TextAlign.center,
                      'IGI Certified\nDiamonds',
                      style: TextStyle(
                          fontSize: Get.width / 28,
                          color: AppColor.grey_color)),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(AppIcon.diamond,
                      color: AppColor.grey_color, width: 35),
                  SizedBox(height: Get.height / 80),
                  Text(
                      textAlign: TextAlign.center,
                      'BIS\nHallmark',
                      style: TextStyle(
                          fontSize: Get.width / 28,
                          color: AppColor.grey_color)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 11. Recommended Products Horizontal Carousel
  Widget _buildRecommendedProducts(List list) {
    return SizedBox(
      height: Get.height * 0.25,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imageSize = constraints.maxHeight * 0.65;
          double textHeight = constraints.maxHeight * 0.2;
          double imageRadius = Get.width / 50;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final recommended = list[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.back();
                  print(recommended['slug']);
                  Get.to(() => Showproduct(
                        slug: recommended['slug'],
                        categoryslug: '',
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: Get.width / 25, right: Get.width / 50),
                  width: Get.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: imageSize,
                        width: imageSize,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(recommended['second_image']),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(imageRadius),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      SizedBox(
                        height: textHeight,
                        child: Text(
                          recommended['title'],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColor.grey_color,
                              fontSize: Get.width * 0.03),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Color Selection Circle Button
Widget _buildColorButton({
  required Color color,
  required bool isSelected,
  required VoidCallback onTap,
  required BoxBorder border,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected ? border : null,
      ),
      child: CircleAvatar(backgroundColor: color, radius: 16),
    ),
  );
}

class CartControllor extends GetxController {
  var cartcount = 0.obs;
}

class WishcartControllet extends GetxController {
  var wishcount = 0.obs;
}
