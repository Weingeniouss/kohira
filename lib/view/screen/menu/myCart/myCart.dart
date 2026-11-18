// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/page_controllers/cart_controller.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/wishlist/wishlist.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_routes.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/API/menu/others/count.dart';

class Mycart extends StatefulWidget {
  CartPageController cartPage = Get.put(CartPageController());
   Mycart({super.key});

  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {
  CartPageController get cartPage => widget.cartPage;
  MyCartValueChange get myCart => cartPage.myCart;
  WishlistController get wishController => cartPage.wishlistController;
  CountController get count => cartPage.count;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final Set<int> expandedItemIndices = <int>{};
  final Set<int> expandedPolicyIndices = <int>{0, 1, 2};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myCart.loadCartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        AppRoutes.back();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          lefticon: AppIcon.left,
          hedingname_2: "Shopping Bag",
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        bottomNavigationBar: _buildBottomBar(),
        body: SafeArea(
          child: Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(color: AppColor.white_color),
            child: Obx(() {
              final bool isLoading = myCart.isGuestUser
                  ? myCart.witoutlogin.isLoading.value
                  : myCart.fetchcart.isLoading.value;

              if (isLoading) {
                return _buildSkeletonLoading();
              }

              final rawData = myCart.isGuestUser
                  ? myCart.witoutlogin.data
                  : myCart.fetchcart.data;

              final cartData = extractCartData(rawData);
              final fetch = cartData['carts'] ?? [];

              if (fetch is! List || fetch.isEmpty) {
                return _buildEmptyState();
              }

              final indianFormat = NumberFormat.currency(
                  locale: 'en_IN', symbol: '₹', decimalDigits: 0);

              return RefreshIndicator(
                color: AppColor.pink_color,
                onRefresh: () => myCart.loadCartData(),
                child: horizontalpadding(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCartItemsHeader(
                            fetch.length, myCart.total.value, indianFormat),
                        _buildCartItemsCard(fetch, indianFormat),
                        _buildCouponCard(),
                        _buildCartSummaryCard(fetch.length, indianFormat),
                        _buildPolicyAccordionsSection(),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: AppColor.pink_color,
      onRefresh: () => myCart.loadCartData(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: Get.height * 0.7,
          alignment: Alignment.center,
          child: Lottie.asset(AppJson.noData),
        ),
      ),
    );
  }

  Widget _buildCartItemsHeader(
      int count, double total, NumberFormat indianFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ITEMS ($count)",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.grey_color,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            "TOTAL: ${indianFormat.format(total)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.black_color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsCard(List fetch, NumberFormat indianFormat) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white_color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderGrey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: fetch.length,
        separatorBuilder: (context, index) =>
            Divider(color: AppColor.lightDivider, height: 24),
        itemBuilder: (context, index) {
          final item = fetch[index];
          return _buildCartItemRow(item, index, fetch, indianFormat);
        },
      ),
    );
  }

  Widget _buildCartItemRow(
      dynamic item, int index, List fetch, NumberFormat indianFormat) {
    final fetchdata = item['CartJewelryData'] ?? {};
    final fetchimage = (fetchdata['allImages'] != null &&
            fetchdata['allImages'] is List &&
            fetchdata['allImages'].isNotEmpty)
        ? fetchdata['allImages'][0]
        : fetchdata['default'];

    final int itemQuantity = (index < myCart.itemCounts.length)
        ? myCart.itemCounts[index]
        : (int.tryParse(item['qty']?.toString() ?? '1') ?? 1);

    final double discountVal =
        double.tryParse(fetchdata['discount']?.toString() ?? '0') ?? 0.0;
    final double offerPrice =
        double.tryParse(fetchdata['offer_price']?.toString() ?? '0') ?? 0.0;
    final double settingPrice =
        double.tryParse(fetchdata['setting_price']?.toString() ?? '0') ?? 0.0;

    final double price = discountVal > 0 ? offerPrice : settingPrice;

    final String jewelryId =
        item['jewelryid']?.toString() ?? fetchdata['id']?.toString() ?? '';

    final isExpanded = expandedItemIndices.contains(index);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              if (fetchimage != null)
                GestureDetector(
                  onTap: () {
                    if (fetchdata['slug'] != null) {
                      AppRoutes.toShowProduct(
                        slug: fetchdata['slug'],
                        categoryslug: fetchdata['category'] != null
                            ? fetchdata['category']['slug']
                            : '',
                      );
                    }
                  },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColor.containerBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.lightDivider),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: NetworkImage(
                            fetchimage['thumb'] ?? fetchimage['path'] ?? ''),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(AppIcon.brokenImage, color: AppColor.grey_color),
                      ),
                    ),
                  ),
                ),
              SizedBox(width: 12),

              // Title, Actions & Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            fetchdata['title'] ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColor.black_color,
                              height: 1.3,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),

                        // Wishlist & Delete Icons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                wishController.toggleWishlist(fetchdata);
                              },
                              child: Obx(() {
                                final isLiked =
                                    wishController.isItemWishlisted(jewelryId);
                                return SvgPicture.asset(
                                  isLiked ? AppIcon.heart : AppIcon.like,
                                  width: 18,
                                  height: 18,
                                  colorFilter: isLiked
                                      ? ColorFilter.mode(
                                          AppColor.pink_color, BlendMode.srcIn)
                                      : null,
                                );
                              }),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                if (myCart.isGuestUser) {
                                  myCart.deletvalueoflocal(index);
                                } else {
                                  myCart.deletValueofcount(item, fetch, index);
                                }
                                count.counting();
                              },
                              child: Icon(
                                AppIcon.deleteOutlineRounded,
                                color: AppColor.grey_color,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Price & Quantity Stepper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (discountVal > 0 && settingPrice > 0)
                              Text(
                                indianFormat.format(settingPrice),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.strikeRed,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              indianFormat.format(price),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black_color,
                              ),
                            ),
                          ],
                        ),

                        // Stepper Box
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColor.stepperBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColor.borderGrey),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  myCart.decrementQuantity(index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: Text('-',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.black_color)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  itemQuantity.toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.black_color),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  myCart.incrementQuantity(index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: Text('+',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.black_color)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          // See More Details Toggle
          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedItemIndices.remove(index);
                } else {
                  expandedItemIndices.add(index);
                }
              });
            },
            child: Row(
              children: [
                Text(
                  "See More Details",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.grey_color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  isExpanded
                      ? AppIcon.keyboardArrowUp
                      : AppIcon.keyboardArrowDown,
                  size: 16,
                  color: AppColor.grey_color,
                ),
              ],
            ),
          ),

          // Expanded Details Card
          if (isExpanded) ...[
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.containerBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColor.lightDivider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fetchdata['itemcode'] != null)
                    Text("Item Code: ${fetchdata['itemcode']}",
                        style: TextStyle(
                            fontSize: 11, color: AppColor.grey_color)),
                  if (fetchdata['metal_type_name'] != null)
                    Text("Metal: ${fetchdata['metal_type_name']}",
                        style: TextStyle(
                            fontSize: 11, color: AppColor.grey_color)),
                  if (item['ringsize'] != null)
                    Text(
                        "Ring Size: ${item['ringsize'] is Map ? item['ringsize']['paraname'] : item['ringsize']}",
                        style: TextStyle(
                            fontSize: 11, color: AppColor.grey_color)),
                ],
              ),
            ),
          ],
        ],
      );
  }

  Widget _buildCouponCard() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.white_color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor.reviewContainerColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppIcon.coupon,
              width: 18,
              height: 18,
              colorFilter:
                  ColorFilter.mode(AppColor.pink_color, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Apply Coupon",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.black_color,
              ),
            ),
          ),
          Icon(AppIcon.arrowForwardIosRounded,
              size: 16, color: AppColor.grey_color),
        ],
      ),
    );
  }

  Widget _buildCartSummaryCard(int itemCount, NumberFormat indianFormat) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.white_color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal ($itemCount Items)",
                style: TextStyle(fontSize: 13, color: AppColor.black_color),
              ),
              Text(
                indianFormat.format(myCart.subTotal.value),
                style: TextStyle(
                    fontSize: 13,
                    color: AppColor.black_color,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: TextStyle(fontSize: 13, color: AppColor.black_color),
              ),
              Text(
                "-${indianFormat.format(myCart.discount.value)}",
                style: TextStyle(
                    fontSize: 13,
                    color: AppColor.successGreen,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Divider(color: AppColor.lightDivider, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Payable",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black_color),
              ),
              Text(
                indianFormat.format(myCart.total.value),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black_color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyAccordionsSection() {
    final policies = [
      {
        'title': '7-Day Returnable',
        'desc':
            '7 Days No Questions Asked Return Policy. You may return your product within 7 days from the date of delivery.',
        'footnote': 'Refund to Kohira Coins or Bank Refund.',
      },
      {
        'title': 'Eligible For Lifetime Exchange & Buy Back',
        'desc':
            'Exchange or Buyback anytime! Get 100% value on Gold and up to 100% on Diamonds for exchanges, or up to 85% on Diamonds for buybacks (subject to policy).',
        'footnote': null,
      },
      {
        'title': 'Free & Insured Delivery',
        'desc':
            'For 100% safe purchase, all goods are insured by us until they reach you securely. And it is FREE!',
        'footnote': null,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SizedBox(height: 20),
          // Policy Accordions Box
          Container(
            decoration: BoxDecoration(
              color: AppColor.white_color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.borderGrey),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: policies.length,
              separatorBuilder: (context, index) =>
                  Divider(color: AppColor.lightDivider, height: 1),
              itemBuilder: (context, index) {
                final pol = policies[index];
                final isExpanded = expandedPolicyIndices.contains(index);

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedPolicyIndices.remove(index);
                            } else {
                              expandedPolicyIndices.add(index);
                            }
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(AppIcon.checkCircleRounded,
                                color: AppColor.successGreen, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                pol['title']!,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black_color),
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? AppIcon.keyboardArrowUp
                                  : AppIcon.keyboardArrowDown,
                              size: 18,
                              color: AppColor.grey_color,
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded) ...[
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pol['desc']!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.grey_color,
                                    height: 1.4),
                              ),
                              if (pol['footnote'] != null) ...[
                                SizedBox(height: 6),
                                Text(
                                  pol['footnote']!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.grey_color,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),

          // Customer Support Call Text
          Text("Any Questions?",
              style: TextStyle(fontSize: 13, color: AppColor.grey_color)),
          SizedBox(height: 4),
          Row(
            children: [
              Text("Please Call Us At ",
                  style: TextStyle(fontSize: 13, color: AppColor.grey_color)),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.parse("tel:9909995723");
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
                child: Text(
                  "9909995723",
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColor.pink_color,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Trust Badges Grid (2x2 Box)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white_color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.borderGrey),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcon.ethical,
                              width: 22, height: 22),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text("Ethical Sourcing",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    Container(height: 30, width: 1, color: AppColor.lightDivider),
                    SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcon.warranty,
                              width: 22, height: 22),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text("Lifetime Warranty",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: AppColor.lightDivider, height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcon.diamond,
                              width: 22, height: 22),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text("IGI Certified Diamonds",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    Container(height: 30, width: 1, color: AppColor.lightDivider),
                    SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcon.warranty,
                              width: 22, height: 22),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text("BIS Hallmark",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.white_color,
        border: Border(top: BorderSide(color: AppColor.borderGrey)),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowBlack12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () {
                    AppRoutes.toHome();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColor.promoCardBg,
                    side: BorderSide(color: AppColor.pink_color),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Continue Shopping",
                    style: TextStyle(
                      color: AppColor.pink_color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    AppRoutes.toCheckout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.pink_color,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      color: AppColor.white_color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return horizontalpadding(
      child: Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Column(
          children: [
            SizedBox(height: Get.height / 50),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColor.white_color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColor.white_color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: Get.width * 0.3,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColor.white_color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: Get.width * 0.25,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColor.white_color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
