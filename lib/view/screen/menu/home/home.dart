// ignore_for_file: strict_top_level_inference, prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, deprecated_member_use, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/home/homejewelry.dart';
import 'package:kohira/controller/API/menu/home/offer_banner.dart';
import 'package:kohira/controller/API/menu/home/slider.dart';
import 'package:kohira/controller/user_inerface/menu/home/menuwidget/homedashbord.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_image.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_logo.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/horizontalpading.dart';
import '../../../utils/widget/inputField.dart';
import '../../../utils/widget/video.dart';
import 'Search.dart';

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final homedashbord = Get.put(Homedashbord());

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: aapbar(scaffoldKey),
      drawer: Drawers(),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: SingleChildScrollView(
          child: Column(
            children: [
              sarchfild(),
              // Silder(),
              productList(),
              plan(),
              offerBannerList(),
              // instagramVideo(),
              benner(),
              jewelrySection1(),
              jewelrySection2(),
              storeSliderBanner(),
              lovedCollection(),
              gifts(),
            ],
          ),
        ),
      ),
    );
  }
}

//AppBar
PreferredSizeWidget aapbar(scaffoldKey) {
  return Appbar(
    prefixicon: AppIcon.menu,
    prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
    logo: AppLogo.logo,
    suffixicon_1: AppIcon.like,
    suffixicon_2: AppIcon.shop,
  );
}

//Search
Widget sarchfild() {
  return Column(
    children: [
      SizedBox(height: Get.height * 0.02),
      horizontalpadding(
        child: searchField(
          readOnly: true,
          onTap: () => Get.to(Search()),
        ),
      ),
    ],
  );
}

//Slider
Widget Silder() {
  final sliderCtrl = Get.put(SliderCalling());
  final homedashbord = Get.find<Homedashbord>();

  return Obx(() {
    final isLoading = sliderCtrl.isLoading.value;
    final sliderDataList = sliderCtrl.data;

    if (isLoading && sliderDataList.isEmpty) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.35,
          width: Get.width,
          margin: EdgeInsets.symmetric(vertical: Get.height / 50),
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    if (sliderDataList.isNotEmpty) {
      return Column(
        children: [
          SizedBox(height: Get.height / 50),
          CarouselSlider.builder(
            itemCount: sliderDataList.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final sliderItem = sliderDataList[index];
              final String mobileImg = sliderItem.mobileImg ?? '';
              final String mainImg = sliderItem.image ?? '';
              final String urlToUse =
                  mobileImg.isNotEmpty ? mobileImg : mainImg;
              final String imageType =
                  (sliderItem.imageType ?? '').toLowerCase();
              final bool isVideo = imageType == 'video' ||
                  urlToUse.toLowerCase().endsWith('.mp4') ||
                  urlToUse.toLowerCase().contains('.mp4');

              return Stack(
                fit: StackFit.expand,
                children: [
                  if (isVideo)
                    VideoPlayerMenu(videoUrl: urlToUse)
                  else
                    Image.network(
                      urlToUse,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text("Image load failed"),
                        );
                      },
                    ),
                ],
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1,
              height: Get.height * 0.35,
            ),
          ),
        ],
      );
    }

    // Fallback to homedashbord data if slideruser list is empty
    final silderValue =
        homedashbord.homeDashborData['mainSliderDetail'] as List<dynamic>?;
    if (silderValue == null || silderValue.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: Get.height / 50),
        CarouselSlider.builder(
          itemCount: silderValue.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final sliderItem = silderValue[index];
            final String mobileImg =
                (sliderItem['mobile_img'] ?? '').toString();
            final String mainImg = (sliderItem['image'] ?? '').toString();
            final String urlToUse = mobileImg.isNotEmpty ? mobileImg : mainImg;
            final String imageType =
                (sliderItem['image_type'] ?? '').toString().toLowerCase();

            final bool isVideo = imageType == 'video' ||
                urlToUse.toLowerCase().endsWith('.mp4') ||
                urlToUse.toLowerCase().contains('.mp4');

            return Stack(
              fit: StackFit.expand,
              children: [
                if (isVideo)
                  VideoPlayerMenu(videoUrl: urlToUse)
                else
                  Image.network(
                    urlToUse,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text("Image load failed"),
                      );
                    },
                  ),
              ],
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            height: Get.height * 0.35,
          ),
        ),
      ],
    );
  });
}

//Offer Banner List
Widget offerBannerList() {
  final offerBannerCtrl = Get.put(OfferBannerCalling());
  return Obx(() {
    final isLoading = offerBannerCtrl.isLoading.value;
    final banners = offerBannerCtrl.offerBanners;
    if (isLoading && banners.isEmpty) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.22,
          width: Get.width,
          margin: EdgeInsets.symmetric(vertical: Get.height / 50),
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
    if (banners.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(height: Get.height / 50),
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final banner = banners[index];
            final imageUrl =
                (banner.mobileImg != null && banner.mobileImg!.isNotEmpty)
                    ? banner.mobileImg!
                    : (banner.image ?? '');

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: Get.width,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text("Image load failed"),
                    );
                  },
                ),
              ],
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            height: Get.height * 0.22,
          ),
        ),
      ],
    );
  });
}

// Jewelry Section 1
Widget jewelrySection1() {
  final homejewelry = Get.put(Homejewelry());
  return Obx(() {
    final isLoading = homejewelry.isLoading.value;
    final model = homejewelry.sectionsData.value;
    final section1 = model?.data?.section1;

    if (isLoading && section1 == null) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.28,
          margin: EdgeInsets.symmetric(
            vertical: Get.height * 0.02,
            horizontal: 10,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.40,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      );
    }

    final items = section1?.items ?? [];
    final String mobileImg = (section1?.mobileImg ?? '').trim();
    final String mainImg = (section1?.image ?? '').trim();
    final String bannerUrl = mobileImg.isNotEmpty ? mobileImg : mainImg;

    if (items.isEmpty && bannerUrl.isEmpty) return SizedBox.shrink();

    final title =
        section1?.title ?? section1?.titleEn ?? "Most Thoughtful Gifts";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bannerUrl.isNotEmpty) ...[
          SizedBox(height: Get.height * 0.015),
          Image.network(
            bannerUrl,
            width: Get.width,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        ],
        SizedBox(height: Get.height * 0.02),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.w600,
              fontFamily: 'Zapf',
              color: AppColor.brown_color,
            ),
          ),
        ),
        SizedBox(height: Get.height * 0.01),
        if (items.isNotEmpty)
          SizedBox(
            height: Get.height * 0.28,
            child: ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                final imgUrl =
                    (item.allImages != null && item.allImages!.isNotEmpty)
                        ? (item.allImages![0].thumb ?? '')
                        : '';
                return GestureDetector(
                  onTap: () {
                    if (item.slug != null) {
                      Get.to(
                        () => Showproduct(
                          slug: item.slug!,
                          categoryslug: item.title ?? '',
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: Get.width * 0.40,
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.pink_color.withOpacity(0.3),
                      ),
                      boxShadow: kElevationToShadow[2],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(
                              imgUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Get.width * 0.030,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black_color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹ ${item.settingPrice ?? 0}",
                          style: TextStyle(
                            fontSize: Get.width * 0.032,
                            fontWeight: FontWeight.bold,
                            color: AppColor.pink_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  });
}

// Jewelry Section 2
Widget jewelrySection2() {
  final homejewelry = Get.put(Homejewelry());
  return Obx(() {
    final isLoading = homejewelry.isLoading.value;
    final model = homejewelry.sectionsData.value;
    final section2 = model?.data?.section2;

    if (isLoading && section2 == null) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.28,
          margin:
              EdgeInsets.symmetric(vertical: Get.height * 0.02, horizontal: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.40,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      );
    }

    final items = section2?.items ?? [];
    final String mobileImg = (section2?.mobileImg ?? '').trim();
    final String mainImg = (section2?.image ?? '').trim();
    final String bannerUrl = mobileImg.isNotEmpty ? mobileImg : mainImg;

    if (items.isEmpty && bannerUrl.isEmpty) return SizedBox.shrink();

    final title =
        section2?.title ?? section2?.titleEn ?? "New Timeless Editorial";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bannerUrl.isNotEmpty) ...[
          SizedBox(height: Get.height * 0.015),
          Image.network(
            bannerUrl,
            width: Get.width,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ],
        SizedBox(height: Get.height * 0.02),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.w600,
              fontFamily: 'Zapf',
              color: AppColor.brown_color,
            ),
          ),
        ),
        if (section2?.descriptionEn != null &&
            section2!.descriptionEn!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              section2.descriptionEn!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Get.width * 0.030,
                color: AppColor.textgray,
              ),
            ),
          ),
        ],
        SizedBox(height: Get.height * 0.01),
        if (items.isNotEmpty)
          SizedBox(
            height: Get.height * 0.28,
            child: ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                final imgUrl =
                    (item.allImages != null && item.allImages!.isNotEmpty)
                        ? (item.allImages![0].thumb ?? '')
                        : '';
                return GestureDetector(
                  onTap: () {
                    if (item.slug != null) {
                      Get.to(
                        () => Showproduct(
                          slug: item.slug!,
                          categoryslug: item.title ?? '',
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: Get.width * 0.40,
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.pink_color.withOpacity(0.3),
                      ),
                      boxShadow: kElevationToShadow[2],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(
                              imgUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Get.width * 0.030,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black_color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹ ${item.settingPrice ?? 0}",
                          style: TextStyle(
                            fontSize: Get.width * 0.032,
                            fontWeight: FontWeight.bold,
                            color: AppColor.pink_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  });
}

//Product
Widget productList() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final isLoading = homedashbord.isLoading.value;
    final model = homedashbord.dashboardData.value;
    final listFromModel = model?.maindesignledjewelleryDetail;

    if (isLoading && (listFromModel == null || listFromModel.isEmpty)) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height / 2.8,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.35,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    final productList = listFromModel ?? [];
    if (productList.isEmpty) {
      final productLists = homedashbord
          .homeDashborData['maindesignledjewelleryDetail'] as List<dynamic>?;
      if (productLists == null || productLists.isEmpty) {
        return SizedBox.shrink();
      }
      return Column(
        children: [
          SizedBox(
            height: Get.height / 2.8,
            child: ListView.builder(
              itemCount: productLists.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final product = productLists[index];
                final String imgUrl =
                    (product['mobile_img'] ?? product['image'] ?? '')
                        .toString();
                final String title = (product['title_en'] ?? '').toString();
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.white_color,
                          border: Border.all(
                            color: AppColor.pink_color.withOpacity(0.5),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(imgUrl),
                          ),
                          borderRadius: BorderRadius.circular(
                            Get.width * 0.025,
                          ),
                          boxShadow: kElevationToShadow[2],
                        ),
                        padding: EdgeInsets.all(50),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColor.brown_color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          height: Get.height / 2.8,
          child: ListView.builder(
            itemCount: productList.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final product = productList[index];
              final String imgUrl =
                  (product.mobileImg != null && product.mobileImg!.isNotEmpty)
                      ? product.mobileImg!
                      : (product.image ?? '');
              final String title = product.titleEn ?? '';
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white_color,
                        border: Border.all(
                          color: AppColor.pink_color.withOpacity(0.5),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imgUrl),
                        ),
                        borderRadius: BorderRadius.circular(
                          Get.width * 0.025,
                        ),
                        boxShadow: kElevationToShadow[2],
                      ),
                      padding: EdgeInsets.all(50),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColor.brown_color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  });
}

Widget plan() {
  return Container(
    width: Get.width,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColor.pink_color.withOpacity(1.0),
          AppColor.pink_color.withOpacity(0.2),
        ],
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppString.gold_Mine,
              style: TextStyle(
                color: AppColor.brown_color,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: Get.width * 0.02),
            Text(
              AppString.num,
              style: TextStyle(
                color: AppColor.brown_color,
                fontWeight: FontWeight.w600,
                fontSize: Get.width * 0.050,
              ),
            ),
            SizedBox(width: Get.width * 0.02),
            Text(
              AppString.monthlyPlan,
              style: TextStyle(
                color: AppColor.brown_color,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        Text(
          AppString.installments,
          style: TextStyle(
            color: AppColor.brown_color,
            fontWeight: FontWeight.w500,
            fontSize: Get.width * 0.028,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06,
            vertical: Get.height * 0.01,
          ),
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(
              Get.width * 0.01,
            ),
            border: Border.all(
              color: AppColor.brown_color,
            ),
          ),
          child: Text(
            AppString.enrollNow,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    ),
  );
}

Widget benner() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final isLoading = homedashbord.isLoading.value;
    final model = homedashbord.dashboardData.value;
    final goldMineBanners = model?.goldMineBanner;

    if (isLoading && (goldMineBanners == null || goldMineBanners.isEmpty)) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.25,
          width: Get.width,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    if (goldMineBanners != null && goldMineBanners.isNotEmpty) {
      final imgUrl = (goldMineBanners[0].mobileImg != null &&
              goldMineBanners[0].mobileImg!.isNotEmpty)
          ? goldMineBanners[0].mobileImg!
          : (goldMineBanners[0].image ?? '');
      return Container(
        padding: EdgeInsets.all(160),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imgUrl),
          ),
        ),
      );
    }

    final rawLists =
        homedashbord.homeDashborData['goldMineBanner'] as List<dynamic>?;
    if (rawLists == null || rawLists.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(160),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            rawLists[0]['mobile_img'] ?? rawLists[0]['image'] ?? '',
          ),
        ),
      ),
    );
  });
}

Widget instagramVideo() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final isLoading = homedashbord.isLoading.value;
    final model = homedashbord.dashboardData.value;
    final reels = model?.mainhomepagesinstareelDetail;

    if (isLoading && (reels == null || reels.isEmpty)) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.40,
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.45,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    final reelList = reels ?? [];
    if (reelList.isEmpty) {
      final rawReels = homedashbord
          .homeDashborData['mainhomepagesinstareelDetail'] as List<dynamic>?;
      if (rawReels == null || rawReels.isEmpty) {
        return SizedBox.shrink();
      }
      return Column(
        children: [
          Text(
            AppString.withPride,
            style: TextStyle(
              fontFamily: 'Zapf',
              fontSize: Get.width * 0.06,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            AppString.customersWear,
            style: TextStyle(
              fontSize: Get.width * 0.030,
              color: AppColor.textgray,
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          CarouselSlider.builder(
            itemCount: rawReels.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final product = rawReels[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: VideoPlayerMenu(videoUrl: product['image'] ?? ''),
                ),
              );
            },
            options: CarouselOptions(
              height: Get.height * 0.40,
              autoPlay: true,
              viewportFraction: 0.45,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
            ),
          ),
          SizedBox(height: Get.height * 0.02),
        ],
      );
    }

    return Column(
      children: [
        Text(
          AppString.withPride,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          AppString.customersWear,
          style: TextStyle(
            fontSize: Get.width * 0.030,
            color: AppColor.textgray,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        CarouselSlider.builder(
          itemCount: reelList.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final product = reelList[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: VideoPlayerMenu(videoUrl: product.image ?? ''),
              ),
            );
          },
          options: CarouselOptions(
            height: Get.height * 0.40,
            autoPlay: true,
            viewportFraction: 0.45,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  });
}

Widget storeSliderBanner() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final isLoading = homedashbord.isLoading.value;
    final model = homedashbord.dashboardData.value;
    final editorialList = model?.editorialbannerDetail;

    if (isLoading && (editorialList == null || editorialList.isEmpty)) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.40,
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.45,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    final productList = editorialList ?? [];
    if (productList.isEmpty) {
      final rawEditorial = homedashbord.homeDashborData['editorialbannerDetail']
          as List<dynamic>?;
      if (rawEditorial == null || rawEditorial.isEmpty) {
        return SizedBox.shrink();
      }
      return Column(
        children: [
          Text(
            AppString.celebrate,
            style: TextStyle(
              fontFamily: 'Zapf',
              fontSize: Get.width * 0.06,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            AppString.elegance,
            style: TextStyle(
              fontSize: Get.width * 0.030,
              color: AppColor.textgray,
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          SizedBox(
            height: Get.height * 0.40,
            child: ListView.builder(
              itemCount: rawEditorial.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final product = rawEditorial[index];
                return Container(
                  width: Get.width * 0.45,
                  margin: EdgeInsets.only(right: 5, left: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(product['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Get.height * 0.02),
        ],
      );
    }

    return Column(
      children: [
        Text(
          AppString.celebrate,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          AppString.elegance,
          style: TextStyle(
            fontSize: Get.width * 0.030,
            color: AppColor.textgray,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        SizedBox(
          height: Get.height * 0.40,
          child: ListView.builder(
            itemCount: productList.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final product = productList[index];
              return Container(
                width: Get.width * 0.45,
                margin: EdgeInsets.only(right: 5, left: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(product.image ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  });
}

Widget lovedCollection() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final isLoading = homedashbord.isLoading.value;
    final model = homedashbord.dashboardData.value;
    final categoryList = model?.categories;

    if (isLoading && (categoryList == null || categoryList.isEmpty)) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.40,
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.45,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    final productList = categoryList ?? [];
    if (productList.isEmpty) {
      final rawCategories =
          homedashbord.homeDashborData['categories'] as List<dynamic>?;
      if (rawCategories == null || rawCategories.isEmpty) {
        return SizedBox.shrink();
      }
      return Column(
        children: [
          Text(
            AppString.lovedCollections,
            style: TextStyle(
              fontFamily: 'Zapf',
              fontSize: Get.width * 0.06,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            AppString.boldEngagement,
            style: TextStyle(
              fontSize: Get.width * 0.030,
              color: AppColor.textgray,
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          SizedBox(
            height: Get.height * 0.40,
            child: ListView.builder(
              itemCount: rawCategories.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final product = rawCategories[index];
                return Container(
                  width: Get.width * 0.45,
                  margin: EdgeInsets.only(right: 5, left: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(product['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Get.height * 0.02),
        ],
      );
    }

    return Column(
      children: [
        Text(
          AppString.lovedCollections,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          AppString.boldEngagement,
          style: TextStyle(
            fontSize: Get.width * 0.030,
            color: AppColor.textgray,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        SizedBox(
          height: Get.height * 0.40,
          child: ListView.builder(
            itemCount: productList.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final product = productList[index];
              return Container(
                width: Get.width * 0.45,
                margin: EdgeInsets.only(right: 5, left: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(product.image ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  });
}

Widget gifts() {
  return Container(
    padding: EdgeInsets.all(200),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          AppImage.gift,
        ),
      ),
    ),
  );
}
