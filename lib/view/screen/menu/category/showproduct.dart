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
import 'package:kohira/modal/menu/category/recommendedJewelleryList.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/video.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/API/menu/category/addtocart.dart';
import '../../../../controller/API/menu/category/subcategrory/filtercategory.dart';
import '../../../../controller/API/menu/category/wishlist.dart';
import '../../../../controller/database/local/localstore.dart';
import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../../controller/user_inerface/menu/myCart/wishlist/wishlist.dart';
import '../../../../modal/menu/category/subcategory/addtocart.dart';
import '../../../../modal/menu/category/subcategory/addtowish.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/bottomNavigation/bottomNavigation.dart';
import '../../../utils/widget/pop.dart';

class Showproduct extends StatelessWidget {
  final String slug;
  final String categoryslug;

  Showproduct({
    super.key,
    required this.slug,
    required this.categoryslug,
  });

  final bool isGuest = (tokans.isEmpty ?? true);

  // GetX Controllers
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

  void initializeData() {
    productController.resetState();
    jewellerydetail.jewellerydetailservices(slug: slug);
    recommendedjewellerylist.recommendedjewellerylistFuction(slug: slug);
    count.counting();
    initializeWishlistStatus();
  }

  void initializeWishlistStatus() async {
    if (isGuest) {
      List<JewelryItemWish> currentItemswish =
          await localdatabase.getJewelryItemsWish();
      final jewelryId =
          jewellerydetail.data['data']?['id']?.toString() ?? '';
      final exists =
          currentItemswish.any((item) => item.jewelryId == jewelryId);

      productController.isWishlistedGuest.value = exists;
      productController.existingItemsWish.value = currentItemswish;
    }
  }

  void _launchWhatsapp(String title, String sku) async {
    final message =
        Uri.encodeComponent("Hello! I am interested in $title (SKU: $sku).");
    final whatsappUrl = Uri.parse("https://wa.me/917851005200?text=$message");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData();
    });

    return Scaffold(
      backgroundColor: AppColor.white_color,
      appBar: AppBar(
        backgroundColor: AppColor.white_color,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black_color),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppString.details,
          style: TextStyle(
            color: AppColor.pink_color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Lora',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone_outlined, color: AppColor.black_color),
            onPressed: () => _launchWhatsapp("Jewelry", slug),
          ),
          IconButton(
            icon:
                Icon(Icons.shopping_bag_outlined, color: AppColor.black_color),
            onPressed: () {
              Bottom();
              bottamSelect.indexThree();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: AppColor.textfild_color,
            height: 1.0,
          ),
        ),
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

          // Initialize selections in GetX controller
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
          final totals =
              '₹ ${NumberFormat('#,##0.00', 'en_IN').format(total)}';

          final diamondList = currentVariant?['jewelry_diamonds'] ?? [];
          final allImages = currentVariant?['allImages'] ?? [];
          final video = currentVariant?['video'] ?? [];

          final freqItems = recommendedjewellerylist.freqBoughtItems;
          final matchItems = recommendedjewellerylist.matchingItems;
          final legacyList =
              recommendedjewellerylist.data['data'] as List? ?? [];

          final indianFormat = NumberFormat.currency(
              locale: 'en_IN', symbol: '₹', decimalDigits: 0);

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image Gallery with Overlaid Badges, Arrow Controls & Wishlist Icon
                  _buildImageGallery(allImages, video, jewellery),
                  SizedBox(height: 12),

                  horizontalpadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. Title, SKU, Price Row
                        _buildProductHeader(
                            currentVariant, jewellery, indianFormat),
                        SizedBox(height: 16),

                        // 3. Offers Coupon Box
                        _buildOffersCard(),
                        SizedBox(height: 16),

                        // 4. Variant Selectors (Metal, Color Grid, Shapes, Diamond Size Grid, Diamond Quality, Ring Size)
                        _buildVariantOptions(
                          jewellery: jewellery,
                          variants: variants,
                          uniqueMetalStamps: uniqueMetalStamps,
                          availableColors: availableColors,
                          uniqueShapes: uniqueShapes,
                          allRingSizes: allRingSizes,
                          diamondQualities: diamondQualities,
                          currentVariant: currentVariant,
                        ),
                        SizedBox(height: 20),

                        // 5. Expandable Accordion Sections (Product Details, Side Diamond Details, Price Breakup)
                        _buildAccordionSections(
                          currentVariant: currentVariant,
                          jewellery: jewellery,
                          totaldiamondsCenter: totaldiamondsCenter,
                          totalweightCenter: totalweightCenter,
                          totaldiamondsSide: totaldiamondsSide,
                          totalweightSide: totalweightSide,
                          goldPrice: goldPrice,
                          makingCharge: makingCharge,
                          diamondPrice: diamondPrice,
                          indianFormat: indianFormat,
                        ),
                        SizedBox(height: 16),

                        // 6. Description Text with "Read More"
                        _buildDescriptionSection(
                            currentVariant?['description']),
                        SizedBox(height: 20),

                        // 7. Policy & Customer Service Card
                        _buildPolicyCard(),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // 8. Frequently Bought Together Carousel
                  if (freqItems.isNotEmpty) ...[
                    horizontalpadding(
                      child: Text(
                        "Frequently Bought Together",
                        style: TextStyle(
                          fontFamily: 'Lora',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildTypedRecommendedCarousel(freqItems, indianFormat),
                    SizedBox(height: 24),
                  ],

                  // 9. Similar Designs / Matching Items Carousel
                  if (matchItems.isNotEmpty || legacyList.isNotEmpty) ...[
                    horizontalpadding(
                      child: Text(
                        AppString.similarDesigns,
                        style: TextStyle(
                          fontFamily: 'Lora',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    matchItems.isNotEmpty
                        ? _buildTypedRecommendedCarousel(
                            matchItems, indianFormat)
                        : _buildSimilarDesigns(legacyList, indianFormat),
                    SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // 1. Image Gallery Component with Arrows, Wishlist Icon & Overlay Badges
  Widget _buildImageGallery(
      List allImages, List video, Map<String, dynamic> jewellery) {
    return Obx(() {
      final selectindex = productController.selectindex.value;
      return Column(
        children: [
          Container(
            height: Get.height * 0.42,
            width: double.infinity,
            color: Color(0xFFF9F9F9),
            child: Stack(
              children: [
                // Image or Video Display
                Positioned.fill(
                  child: selectindex < allImages.length
                      ? ClipRRect(
                          child: PhotoView(
                            imageProvider:
                                NetworkImage(allImages[selectindex]['feature']),
                            backgroundDecoration:
                                BoxDecoration(color: Color(0xFFF9F9F9)),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered * 4,
                            initialScale: PhotoViewComputedScale.contained,
                            enableRotation: false,
                          ),
                        )
                      : (video.isNotEmpty
                          ? VideoPlayerMenuContainer(videoUrl: video[0]['path'])
                          : Placeholder()),
                ),

                // Left Navigation Arrow
                if (allImages.length > 1)
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (selectindex > 0) {
                            productController.selectindex.value--;
                          } else {
                            productController.selectindex.value =
                                allImages.length - 1;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            AppIcon.arrowBackIosNew,
                            size: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Right Navigation Arrow
                if (allImages.length > 1)
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (selectindex < allImages.length - 1) {
                            productController.selectindex.value++;
                          } else {
                            productController.selectindex.value = 0;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(AppIcon.arrowForwardIos,
                              size: 18, color: Colors.black87),
                        ),
                      ),
                    ),
                  ),

                // Top-Right Floating Wishlist Heart Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Obx(() {
                    final isLiked = wish.isItemWishlisted(jewellery['id'].toString());
                    return GestureDetector(
                      onTap: () => wish.toggleWishlist(jewellery),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.white_color,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          isLiked ? AppIcon.heart : AppIcon.like,
                          width: 22,
                          height: 22,
                          colorFilter: isLiked
                              ? ColorFilter.mode(AppColor.pink_color, BlendMode.srcIn)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),

                // Bottom Overlay Bar with 3 Trust Icons
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      border: Border(
                          top: BorderSide(
                              color: AppColor.textfild_color, width: 0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppIcon.puzzle,
                                width: 14, color: AppColor.pink_color),
                            SizedBox(width: 4),
                            Text(AppString.ethicalSourcing,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black_color)),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcon.social,
                                width: 14, color: AppColor.pink_color),
                            SizedBox(width: 4),
                            Text(AppString.igiCertified,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black_color)),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcon.diamond,
                                width: 14, color: AppColor.pink_color),
                            SizedBox(width: 4),
                            Text(AppString.bisHallmark,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black_color)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Horizontal Thumbnail Strip + 360° Rotate Button
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: allImages.length + (video.isNotEmpty ? 1 : 0) + 1,
              itemBuilder: (context, index) {
                if (index < allImages.length) {
                  final isSelected = selectindex == index;
                  return GestureDetector(
                    onTap: () => productController.selectindex.value = index,
                    child: Container(
                      width: 58,
                      height: 58,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.pink_color
                              : AppColor.textfild_color,
                          width: isSelected ? 2 : 1,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(allImages[index]['feature']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else if (index <
                    allImages.length + (video.isNotEmpty ? 1 : 0)) {
                  return GestureDetector(
                    onTap: () =>
                        productController.selectindex.value = allImages.length,
                    child: Container(
                      width: 58,
                      height: 58,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.textfild_color),
                      ),
                      child: Center(
                        child: Icon(AppIcon.playCircleFill,
                            color: AppColor.pink_color, size: 28),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.textfild_color),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(AppIcon.autorenew,
                            size: 22, color: Colors.black87),
                        SizedBox(height: 2),
                        Text(
                          AppString.threeSixty,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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

  // 2. Product Header (Title, SKU, Price + Strikethrough)
  Widget _buildProductHeader(Map<String, dynamic>? currentVariant,
      Map<String, dynamic> jewellery, NumberFormat indianFormat) {
    final settingPrice = currentVariant?['setting_price'] ?? 0;
    final title =
        currentVariant?['title'] ?? jewellery['title'] ?? 'Product Title';
    final sku = currentVariant?['itemcode'] ?? jewellery['itemcode'] ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Title
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.black_color,
            height: 1.3,
          ),
        ),
        SizedBox(height: 4),

        // SKU Line
        Text(
          "${AppString.skuLabel} $sku",
          style: TextStyle(
            fontSize: 12,
            color: AppColor.grey_color,
          ),
        ),
        SizedBox(height: 8),

        // Price Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              indianFormat.format(settingPrice),
              style: TextStyle(
                color: AppColor.black_color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text(
              indianFormat.format(settingPrice),
              style: TextStyle(
                color: AppColor.pink_color.withOpacity(0.8),
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Offers Coupon Box
  Widget _buildOffersCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppString.offersLabel,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black_color)),
            Text(AppString.viewAll,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.pink_color)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFFFF7F8),
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(color: AppColor.pink_color, width: 4.0),
              top: BorderSide(color: Color(0xFFFDE8EC), width: 1.0),
              right: BorderSide(color: Color(0xFFFDE8EC), width: 1.0),
              bottom: BorderSide(color: Color(0xFFFDE8EC), width: 1.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("KOHIRA253510",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color)),
                  SizedBox(width: 8),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFFFDE8EC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("On Diamond & Making Charges",
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColor.pink_color,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: AppColor.grey_color),
                  children: [
                    TextSpan(text: "Use Code "),
                    TextSpan(
                        text: "KOHIRA253510",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.black_color)),
                    TextSpan(
                        text: " & get 30% off on orders above ₹50,000 ... "),
                    TextSpan(
                        text: AppString.readMore,
                        style: TextStyle(
                            color: AppColor.pink_color,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4. Variant Selection & Action Buttons (Add To Cart + Whatsapp)
  Widget _buildVariantOptions({
    required Map<String, dynamic> jewellery,
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
      final selectedShape = productController.selectedShape.value;
      final selectedDiamondQuality =
          productController.selectedDiamondQuality.value;
      final goldcolor = productController.goldcolor.value;
      final rosegoldcolor = productController.rosegoldcolor.value;
      final graycolor = productController.graycolor.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Metal Stamp Selector
          Text(
            AppString.metalLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.black_color,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: uniqueMetalStamps.map((stamp) {
              final isSelected = selectedMetalStamp == stamp;
              final displayStamp = stamp.toUpperCase().endsWith('KT')
                  ? stamp.toUpperCase()
                  : "${stamp.replaceAll('k', '').toUpperCase()} KT";

              return Expanded(
                child: GestureDetector(
                  onTap: () => productController.selectMetalStamp(
                      stamp, variants),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.pink_color
                            : AppColor.textfild_color,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      color: isSelected
                          ? Color(0xFFFFF7F8)
                          : AppColor.white_color,
                    ),
                    child: Center(
                      child: Text(
                        displayStamp,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w400,
                          fontSize: 12,
                          color: isSelected
                              ? AppColor.pink_color
                              : AppColor.black_color,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),

          // 2. Metal Color Grid Cards
          Text(
            AppString.metalColorLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.black_color,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              if (availableColors['Yellow Gold'] ?? false)
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        productController.updateColorState('Yellow Gold'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: goldcolor
                            ? Color(0xFFFFF7F8)
                            : AppColor.white_color,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: goldcolor
                              ? AppColor.pink_color
                              : AppColor.textfild_color,
                          width: goldcolor ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: AppColor.glodcolor, radius: 10),
                          SizedBox(height: 4),
                          Text('Yellow Gold',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: goldcolor
                                      ? FontWeight.bold
                                      : FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
              if (availableColors['Rose Gold'] ?? false)
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        productController.updateColorState('Rose Gold'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: rosegoldcolor
                            ? Color(0xFFFFF7F8)
                            : AppColor.white_color,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: rosegoldcolor
                              ? AppColor.pink_color
                              : AppColor.textfild_color,
                          width: rosegoldcolor ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: AppColor.rosegoldcolor,
                              radius: 10),
                          SizedBox(height: 4),
                          Text('Rose Gold',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: rosegoldcolor
                                      ? FontWeight.bold
                                      : FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
              if (availableColors['White Gold'] ?? false)
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        productController.updateColorState('White Gold'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: graycolor
                            ? Color(0xFFFFF7F8)
                            : AppColor.white_color,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: graycolor
                              ? AppColor.pink_color
                              : AppColor.textfild_color,
                          width: graycolor ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: AppColor.graycolor, radius: 10),
                          SizedBox(height: 4),
                          Text('White Gold',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: graycolor
                                      ? FontWeight.bold
                                      : FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),

          // 3. Diamond Shape Selector Cards
          if (uniqueShapes.isNotEmpty) ...[
            Text(
              AppString.diamondShapeLabel,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black_color),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
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
                      width: 75,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColor.pink_color
                              : AppColor.textfild_color,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        color: isSelected
                            ? Color(0xFFFFF7F8)
                            : AppColor.white_color,
                      ),
                      child: Column(
                        children: [
                          Image.network(shape['image'],
                              width: 24, height: 24),
                          SizedBox(height: 4),
                          Text(
                            shape['paraname'] ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? AppColor.pink_color
                                  : AppColor.black_color,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
          ],

          // 4. Center Diamond Size / Carat Grid
          if (productController
              .getUniqueCarats(variants, diamondType: 'center')
              .isNotEmpty) ...[
            Text(
              AppString.centerDiamondSizeLabel,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black_color),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: productController
                  .getUniqueCarats(variants, diamondType: 'center')
                  .map((carat) {
                final isSelected = currentVariant?['total_carat'] == carat;
                return GestureDetector(
                  onTap: () => productController.filterVariantsByCarat(
                      carat,
                      diamondType: 'center',
                      variants: variants),
                  child: Container(
                    width: (Get.width - 48) / 3,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(0xFFFFF7F8)
                          : AppColor.white_color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.pink_color
                            : AppColor.textfild_color,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        carat.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColor.pink_color
                              : AppColor.black_color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
          ],

          // 5. Diamond Quality Selector (2 Pills)
          if (diamondQualities.isNotEmpty) ...[
            Text(
              AppString.diamondQualityLabel,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black_color),
            ),
            SizedBox(height: 8),
            Row(
              children: diamondQualities.map((quality) {
                final isSelected = selectedDiamondQuality == quality;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      productController.selectedDiamondQuality.value = quality;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.pink_color
                              : AppColor.textfild_color,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        color: isSelected
                            ? Color(0xFFFFF7F8)
                            : AppColor.white_color,
                      ),
                      child: Center(
                        child: Text(
                          quality,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w400,
                            fontSize: 13,
                            color: isSelected
                                ? AppColor.pink_color
                                : AppColor.black_color,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
          ],

          // 6. Ring Size Dropdown & Size Guide
          if (allRingSizes.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.ringSizeLabel,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black_color),
                ),
                Text(
                  AppString.sizeGuide,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.pink_color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.textfild_color),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  menuMaxHeight: 180,
                  value: productController.selectedRingSizeParaname.value,
                  items: allRingSizes.map<DropdownMenuItem<String>>((ring) {
                    return DropdownMenuItem<String>(
                      value: ring['paraname'].toString(),
                      child: Text("${ring['paraname']} (16.88 mm)",
                          style: TextStyle(fontSize: 13)),
                      onTap: () => productController
                          .selectedRingSizeId.value = ring['id'].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    productController.selectedRingSizeParaname.value = value;
                  },
                  icon: Icon(AppIcon.keyboardArrowDown, size: 20),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ],
      );
    });
  }

  // 5. Accordion Expandable Sections (Product Details, Side Diamond Details, Price Breakup)
  Widget _buildAccordionSections({
    required Map<String, dynamic>? currentVariant,
    required Map<String, dynamic> jewellery,
    required String? totaldiamondsCenter,
    required String? totalweightCenter,
    required String? totaldiamondsSide,
    required String? totalweightSide,
    required double goldPrice,
    required double makingCharge,
    required double diamondPrice,
    required NumberFormat indianFormat,
  }) {
    return Obx(() {
      final productdetails = productController.productdetails.value;
      final sidediamondDetails = productController.sidediamondDetails.value;
      final priceBreakup = productController.priceBreakup.value;

      return Column(
        children: [
          // 1. Product Details Accordion
          _buildAccordionCard(
            title: AppString.productDetailsHeader,
            isOpen: productdetails,
            onTap: () => productController.toggleProductDetails(),
            child: _buildProductDetailsCard(currentVariant, jewellery),
          ),

          // 2. Side Diamond Details Accordion
          _buildAccordionCard(
            title: AppString.sideDiamondDetailsHeader,
            isOpen: sidediamondDetails,
            onTap: () => productController.toggleSideDiamondDetails(),
            child: _buildSideDiamondCard(
                currentVariant, totaldiamondsSide, totalweightSide),
          ),

          // 3. Price Breakup Accordion
          _buildAccordionCard(
            title: AppString.priceBreakUp,
            isOpen: priceBreakup,
            onTap: () => productController.togglePriceBreakup(),
            child: _buildPriceBreakupTable(
              goldPrice: goldPrice,
              makingCharge: makingCharge,
              diamondPrice: diamondPrice,
              currentVariant: currentVariant,
              indianFormat: indianFormat,
            ),
          ),
        ],
      );
    });
  }

  // Reusable Accordion Card Wrapper
  Widget _buildAccordionCard({
    required String title,
    required bool isOpen,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            color: AppColor.white_color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black_color,
                  ),
                ),
                Icon(
                  isOpen ? AppIcon.keyboardArrowUp : AppIcon.keyboardArrowDown,
                  color: AppColor.black_color,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (isOpen) Padding(padding: EdgeInsets.only(bottom: 12), child: child),
        Container(color: AppColor.textfild_color, height: 1.0),
      ],
    );
  }

  // Side Diamond Details Card
  Widget _buildSideDiamondCard(Map<String, dynamic>? currentVariant,
      String? totaldiamondsSide, String? totalweightSide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Color :', style: TextStyle(color: AppColor.grey_color)),
              Text(
                  currentVariant?['jewelry_diamonds']?[0]?['color'] ?? 'N/A',
                  style: TextStyle(color: AppColor.grey_color)),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Clarity :', style: TextStyle(color: AppColor.grey_color)),
              Text(
                  currentVariant?['jewelry_diamonds']?[0]?['clarity'] ?? 'N/A',
                  style: TextStyle(color: AppColor.grey_color)),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pieces :', style: TextStyle(color: AppColor.grey_color)),
              Text(totaldiamondsSide ?? '0',
                  style: TextStyle(color: AppColor.grey_color)),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Weight :', style: TextStyle(color: AppColor.grey_color)),
              Text(totalweightSide ?? '0',
                  style: TextStyle(color: AppColor.grey_color)),
            ],
          ),
        ],
      ),
    );
  }

  // 6. Product Description Section with "Read More"
  Widget _buildDescriptionSection(String? description) {
    final text = description ??
        "Embrace The Captivating Glow Of The Square Radiance Halo Ring. This Exquisite Piece Features Brilliant Type IIA Lab Grown Diamonds...";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: 13, color: AppColor.grey_color, height: 1.4),
            children: [
              TextSpan(text: text),
              TextSpan(
                text: " ${AppString.readMore}",
                style: TextStyle(
                  color: AppColor.pink_color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 7. Policy & Customer Service Grey Card
  Widget _buildPolicyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(AppIcon.autorenew, size: 22, color: Colors.black87),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppString.returnPolicyText,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: const [
              Icon(AppIcon.verifiedOutlined, size: 22, color: Colors.black87),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppString.buybackPolicyText,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 11, color: AppColor.grey_color),
              children: const [
                TextSpan(text: AppString.anyQuestionsText),
                TextSpan(
                    text: "+917851005200",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                TextSpan(text: AppString.supportTiming),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 8. Product Details Grid Card (Specs Grid Box)
  Widget _buildProductDetailsCard(
      Map<String, dynamic>? currentVariant, Map<String, dynamic> jewellery) {
    final sku = currentVariant?['itemcode'] ?? jewellery['itemcode'] ?? 'N/A';
    final metalStamp = currentVariant?['metal_stamp']?['paraname']
            ?.toString()
            .toUpperCase() ??
        '9KT';
    final metalType =
        currentVariant?['metal_type']?['paraname']?.toString() ?? 'Yellow Gold';
    final metalWeight = currentVariant?['metalweight']?.toString() ?? '4.35';

    final diamonds = currentVariant?['jewelry_diamonds'] as List? ?? [];
    final diamondCount = diamonds.isNotEmpty
        ? (diamonds[0]['totaldiamonds']?.toString() ?? '51')
        : '51';
    final diamondClarity = diamonds.isNotEmpty
        ? (diamonds[0]['clarity']?.toString() ?? 'SI IJ')
        : 'SI IJ';
    final totalCarat = currentVariant?['all_total_carat']?.toString() ??
        currentVariant?['total_carat']?.toString() ??
        '0.237';

    final width = currentVariant?['width']?.toString() ??
        jewellery['width']?.toString() ??
        '7.22';
    final height = currentVariant?['height']?.toString() ??
        jewellery['height']?.toString() ??
        '22.11';

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.textfild_color),
      ),
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.productDetailsHeader,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black_color,
                ),
              ),
              Text(
                "${AppString.skuLabel} $sku",
                style: TextStyle(
                  fontSize: 11,
                  color: AppColor.grey_color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.white_color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    children: [
                      Icon(AppIcon.workspacePremiumOutlined,
                          size: 20, color: Colors.black87),
                      SizedBox(height: 4),
                      Text(
                        "$metalStamp $metalType",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "$metalWeight Gram",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppString.goldWeight,
                        style: TextStyle(
                            fontSize: 10, color: AppColor.grey_color),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.white_color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    children: [
                      Icon(AppIcon.diamondOutlined,
                          size: 20, color: Colors.black87),
                      SizedBox(height: 4),
                      Text(
                        "$diamondCount $diamondClarity Diamonds",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "$totalCarat Ct",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppString.diamondWeight,
                        style: TextStyle(
                            fontSize: 10, color: AppColor.grey_color),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.white_color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFEEEEEE)),
            ),
            child: Column(
              children: [
                Text(
                  "$metalWeight Gram",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppString.productWeight,
                  style: TextStyle(fontSize: 10, color: AppColor.grey_color),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.white_color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFEEEEEE)),
            ),
            child: Column(
              children: [
                Icon(AppIcon.straightenOutlined,
                    size: 20, color: Colors.black87),
                SizedBox(height: 4),
                Text(
                  AppString.productDimensions,
                  style: TextStyle(fontSize: 10, color: AppColor.grey_color),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "$height Mm",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(AppString.heightLabel,
                            style: TextStyle(
                                fontSize: 10, color: AppColor.grey_color)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "$width Mm",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(AppString.widthLabel,
                            style: TextStyle(
                                fontSize: 10, color: AppColor.grey_color)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 9. Price Breakup Table Matrix
  Widget _buildPriceBreakupTable({
    required double goldPrice,
    required double makingCharge,
    required double diamondPrice,
    required Map<String, dynamic>? currentVariant,
    required NumberFormat indianFormat,
  }) {
    final metalStamp = currentVariant?['metal_stamp']?['paraname']
            ?.toString()
            .toUpperCase() ??
        '9K';
    final metalType =
        currentVariant?['metal_type']?['paraname']?.toString() ?? 'Yellow Gold';
    final metalWeight = currentVariant?['metalweight']?.toString() ?? '2.000';
    final total = goldPrice + makingCharge + diamondPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.textfild_color),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: AppColor.textfild_color, width: 1.0),
            ),
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1.8),
              2: FlexColumnWidth(1.8),
              3: FlexColumnWidth(2.0),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
                children: const [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.component,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.rate,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.weightHeader,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.finalValue,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold))),
                ],
              ),
              TableRow(
                children: const [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Gold", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("-", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("-", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("-", style: TextStyle(fontSize: 11))),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("$metalStamp $metalType",
                          style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("₹ 2,401/g", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("$metalWeight g",
                          style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(indianFormat.format(goldPrice),
                          style: TextStyle(fontSize: 11))),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
                children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.totalGoldValue,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("-", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("-", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(indianFormat.format(goldPrice),
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold))),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.makingCharges,
                          style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(indianFormat.format(makingCharge),
                          style: TextStyle(fontSize: 11))),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.otherCharges,
                          style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(indianFormat.format(50),
                          style: TextStyle(fontSize: 11))),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
                children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.subTotalLabel,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(indianFormat.format(total),
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600))),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppString.grandTotal,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("", style: TextStyle(fontSize: 11))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(indianFormat.format(total),
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 10. Typed Recommended Items Carousel Widget
  Widget _buildTypedRecommendedCarousel(
      List<RecommendedItem> items, NumberFormat indianFormat) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: () {
              Get.to(() => Showproduct(
                    slug: item.slug,
                    categoryslug: '',
                  ));
            },
            child: Container(
              width: 145,
              margin: EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 135,
                    width: 145,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.textfild_color),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.displayImage,
                            width: 145,
                            height: 135,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(child: Icon(AppIcon.brokenImage)),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Icon(AppIcon.favoriteBorder,
                              size: 16, color: Colors.black54),
                        ),
                        Positioned(
                          left: 4,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Icon(AppIcon.arrowBackIos,
                                size: 12, color: Colors.black45),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Icon(AppIcon.arrowForwardIos,
                                size: 12, color: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        indianFormat.format(item.settingPrice),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        indianFormat.format(item.settingPrice),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColor.pink_color.withOpacity(0.8),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColor.black_color,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Legacy Recommended Items Carousel
  Widget _buildSimilarDesigns(List list, NumberFormat indianFormat) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final recommended = list[index];
          final title = recommended['title']?.toString() ?? '';
          final settingPrice = recommended['setting_price'] ?? 17401;
          final imgUrl =
              recommended['second_image'] ?? recommended['image'] ?? '';

          return GestureDetector(
            onTap: () {
              Get.to(() => Showproduct(
                    slug: recommended['slug'] ?? '',
                    categoryslug: '',
                  ));
            },
            child: Container(
              width: 145,
              margin: EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 135,
                    width: 145,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.textfild_color),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imgUrl,
                            width: 145,
                            height: 135,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(child: Icon(AppIcon.brokenImage)),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Icon(AppIcon.favoriteBorder,
                              size: 16, color: Colors.black54),
                        ),
                        Positioned(
                          left: 4,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Icon(AppIcon.arrowBackIos,
                                size: 12, color: Colors.black45),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Icon(AppIcon.arrowForwardIos,
                                size: 12, color: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        indianFormat.format(settingPrice),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black_color,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        indianFormat.format(settingPrice),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColor.pink_color.withOpacity(0.8),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColor.black_color,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method for Wishlist Toggle
  void _handleWishlistToggle(Map<String, dynamic> jewellery) async {
    if (isGuest) {
      List<JewelryItemWish> currentItemswish =
          await localdatabase.getJewelryItemsWish();
      final jewelryId = jewellery['id'].toString();
      final exists =
          currentItemswish.any((item) => item.jewelryId == jewelryId);
      if (exists) {
        currentItemswish.removeWhere((item) => item.jewelryId == jewelryId);
        ToastificationSuccess.Success(AppString.removedFromWishlist);
      } else {
        currentItemswish.add(
          JewelryItemWish(
            jewelryId: jewellery['id'].toString(),
            ringSize: productController.selectedRingSizeId.value.toString(),
            qty: 1,
          ),
        );
        ToastificationSuccess.Success(AppString.addedToWishlist);
      }
      await localdatabase.saveJewelryItemsWish(currentItemswish);
      WithoutloginWishList().withoutloginwishlist(currentItemswish);

      wishguest.wishcount.value = currentItemswish.length;
      pref!.setString('wishcount', wishguest.wishcount.value.toString());
      wishCount = pref!.getString('wishcount') ?? '0';

      productController.isWishlistedGuest.value = !exists;
      productController.existingItemsWish.value = currentItemswish;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        wish.withoutloginWish.withoutloginwishlist(currentItemswish);
      });
    } else {
      if (categoryslug == 'rings' || categoryslug == 'engagement-rings') {
        if (productController.selectedRingSizeId.value == null &&
            productController.selectedRingSizeParaname.value == null) {
          ToastificationError.Error(AppString.pleaseSelectRingSize);
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
          ringsize: productController.selectedRingSizeParaname.value,
          jewelryid: jewellery['id'].toString(),
          metal_stamp: productController.isWishlisted.value
              ? productController.selectedMetalStamp.value
              : null,
          metal_type: productController.selectedMetalType.value,
          tokan: tokans,
        );
        Get.back();

        productController.isWishlisted.value =
            !productController.isWishlisted.value;

        count.counting();
        wish.fetchwishlist.fechwishlist();
      } catch (e) {
        Get.back();
        print('Wishlist error: $e');
      }
    }
  }

  // Helper method for Add To Cart
  void _handleAddToCart(Map<String, dynamic> jewellery) async {
    if (isGuest) {
      List<JewelryItem> currentItems = await localdatabase.getJewelryItems();
      currentItems.add(
        JewelryItem(
          jewelryId: jewellery['id'].toString(),
          ringSize: productController.selectedRingSizeId.value.toString(),
          qty: 1,
        ),
      );
      await localdatabase.saveJewelryItems(currentItems);
      Withoutlogin().withoutlogin(currentItems);

      userguest.cartcount.value = currentItems.length;
      pref!.setString('count', userguest.cartcount.value.toString());
      cartCount = pref!.getString('count') ?? '0';

      Withoutlogin().data['count'] = userguest.cartcount.value;
      existingItemsCart = currentItems;

      ToastificationSuccess.Success(AppString.addToCartSuccess);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        myCart.loadCartData();
      });
    } else {
      if (categoryslug == 'rings' || categoryslug == 'engagement-rings') {
        if (productController.selectedRingSizeId.value == null &&
            productController.selectedRingSizeParaname.value == null) {
          ToastificationError.Error(AppString.pleaseSelectRingSize);
        } else {
          if (Addtocart().isLoading.value) {
            Get.dialog(Center(child: Lottie.asset(AppJson.loading2)));
          } else {
            Addtocart()
                .addtocartservice(
              jewelryid: jewellery['id'].toString(),
              ringsize: productController.selectedRingSizeId.value.toString(),
              tokan: tokans,
            )
                .then((_) {
              count.counting();
              myCart.onInit();
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
            count.counting();
            myCart.onInit();
          });
        }
      }
    }
  }

  // Bottom Action Bar (Fixed at bottom: Add To Cart & Whatsapp)
  Widget _buildBottomNavigationBar(Map<String, dynamic> jewellery) {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.white_color,
        border: Border(
          top: BorderSide(color: AppColor.textfild_color, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Add To Cart Button (Pink Solid)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleAddToCart(jewellery),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.pink_color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(AppIcon.shoppingCartOutlined,
                  size: 18, color: Colors.white),
              label: Text(
                AppString.addtocart,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 12),

          // Whatsapp Button (Green Solid)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _launchWhatsapp(
                  jewellery['title']?.toString() ?? 'Jewelry',
                  jewellery['itemcode']?.toString() ?? ''),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(AppIcon.chatBubbleOutline,
                  size: 18, color: Colors.white),
              label: Text(
                AppString.whatsapp,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer Skeleton
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.lodingcolor,
      highlightColor: AppColor.highlightColor,
      child: horizontalpadding(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Container(
                height: Get.height * 0.40,
                decoration: BoxDecoration(
                  color: AppColor.white_color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) => Container(
                    width: 60,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Error State Widget
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcon.errorOutline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            AppString.noProductData,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              jewellerydetail.jewellerydetailservices(slug: slug);
            },
            child: Text(AppString.retry),
          ),
        ],
      ),
    );
  }
}

class CartControllor extends GetxController {
  var cartcount = 0.obs;
}

class WishcartControllet extends GetxController {
  var wishcount = 0.obs;
}
