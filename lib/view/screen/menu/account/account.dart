// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kohira/controller/page_controllers/account_controller.dart';
import 'package:kohira/modal/menu/account/accountlist.dart';
import 'package:kohira/view/screen/menu/account/profile%20edit/profileedit.dart';
import 'package:kohira/view/screen/menu/account/addresses/addresses.dart';
import 'package:kohira/view/screen/menu/account/order%20history/orderhistory.dart';
import 'package:kohira/view/screen/menu/myCart/wishList/wishlist.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../utils/app_string.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';

class Account extends StatelessWidget {
  AccountPageController get accountPage =>
      Get.isRegistered<AccountPageController>()
          ? Get.find<AccountPageController>()
          : Get.put(AccountPageController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Account({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        if (Get.isRegistered<Bottamnavigation>()) {
          Get.find<Bottamnavigation>().indexOne();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          prefixicon: AppIcon.menu,
          prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
          hedingname: AppString.accounttitale,
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        body: Container(
          width: Get.width,
          height: Get.height,
          color: AppColor.white_color,
          child: Obx(() {
            if (accountPage.profileDetails.isLoading.value) {
              return _buildShimmerLoading();
            }
            if (accountPage.profileDetails.data['data'] == null) {
              return Center(child: Lottie.asset(AppJson.noData));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  _buildTopGrid(),
                  SizedBox(height: 15),
                  _buildAccountList(context),
                  SizedBox(height: 15),
                  _buildContactFooter(),
                  SizedBox(height: 15),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.lodingcolor,
      highlightColor: AppColor.highlightColor,
      child: horizontalpadding(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (_, __) => Container(
                  height: 20,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  color: AppColor.white_color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopGrid() {
    return horizontalpadding(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildGridCard(
                  AppIcon.personIcon,
                  AppColor.pink_color,
                  AppString.profileLabel,
                  AppString.manageYourAccount,
                  () => Get.to(() => Profileedit()),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildGridCard(
                  AppIcon.inventoryIcon,
                  AppColor.glodcolor,
                  AppString.ordersLabel,
                  AppString.trackYourOrderStatus,
                  () => Get.to(() => Orderhistory()),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildGridCard(
                  AppIcon.favoriteIcon,
                  AppColor.pink_color,
                  AppString.wishlistLabel,
                  AppString.mostLovedJewellery,
                  () => Get.to(() => WishlistScreen()),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildGridCard(
                  AppIcon.locationOnIcon,
                  AppColor.strikeRed,
                  AppString.addressLabel,
                  AppString.changeYourAddress,
                  () => Get.to(() => Addresses()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountList(BuildContext context) {
    return horizontalpadding(
      child: Container(
        clipBehavior: Clip.antiAlias, // Clip for rounded corners
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColor.borderGrey,
          ),
          boxShadow: kElevationToShadow[2],
        ),
        child: ListView.builder(
          itemCount: accountlist.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => accountPage.account.listButton(
                accountlist[index]['route_id'],
                context,
              ),
              child: horizontalpadding(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColor.white_color,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        accountlist[index]['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black_color,
                        ),
                      ),
                      Icon(
                        AppIcon.arrowForwardIos,
                        size: 16,
                        color: AppColor.grey_color,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridCard(
    IconData icon,
    Color iconColor,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.black_color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: AppColor.grey_color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactFooter() {
    return horizontalpadding(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColor.promoCardBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildContactOption(AppIcon.callOutlined, AppString.call, () {}),
            Container(width: 1, height: 60, color: AppColor.shadowBlack12),
            _buildContactOption(AppIcon.mailOutline, AppString.mail, () {}),
            Container(width: 1, height: 60, color: AppColor.shadowBlack12),
            _buildContactOption(null, AppString.whatsappLabel, () {},
                isWhatsApp: true),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(IconData? icon, String label, VoidCallback onTap,
      {bool isWhatsApp = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.white_color,
              shape: BoxShape.circle,
            ),
            child: isWhatsApp
                ? Image.asset(
                    AppIcon.whatsapp,
                    width: 24,
                    height: 24,
                    color: AppColor.black_color,
                  )
                : Icon(
                    icon,
                    color: AppColor.black_color,
                    size: 24,
                  ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.black_color,
            ),
          ),
        ],
      ),
    );
  }
}
