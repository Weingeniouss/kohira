// ignore_for_file: strict_top_level_inference, prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, deprecated_member_use, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/home/homejewelry.dart';
import 'package:kohira/controller/API/menu/home/news_list.dart';
import 'package:kohira/controller/API/menu/home/offer_banner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kohira/controller/user_inerface/menu/home/menuwidget/homedashbord.dart';
import 'package:kohira/controller/user_inerface/menu/overStore/store_locations_controller.dart';
import 'package:kohira/modal/menu/home/dashboard.dart';
import 'package:kohira/modal/menu/home/store_locations.dart';
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

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Get.put(Homedashbord());
    Get.put(OfferBannerCalling());
    Get.put(Homejewelry());
    Get.put(StoreLocationsController());
    Get.put(NewsListCalling());
    Get.put(HomepageJewelryList());
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> homeSections = [
      sarchfild(),
      mainSlider(),
      horizontalpadding(child: productList()),
      plan(),
      Silder(),
      instagramVideo(),
      benner(),
      gifts(),
      jewelrySection2(),
      jewelrySection1(),
      horizontalpadding(child: storeSliderBanner()),
      horizontalpadding(child: timelessEditorialSection()),
      horizontalpadding(child: newsStorySection()),
      horizontalpadding(child: educationSection()),
      offerBannerList(),
      horizontalpadding(child: customerReviews()),
      lovedCollection(),
      promise(),
      storeLocationsSection(),
      horizontalpadding(child: newsListSection()),
    ];

    return Scaffold(
      key: scaffoldKey,
      appBar: aapbar(scaffoldKey),
      drawer: Drawers(),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: ListView.builder(
          itemCount: homeSections.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            return RepaintBoundary(child: homeSections[index]);
          },
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

//MainSlider
Widget mainSlider() {
  final homedashbord = Get.find<Homedashbord>();

  return Obx(() {
    final model = homedashbord.dashboardData.value;
    final mainSliders = model?.mainSliderDetail;
    final rawMainSliders =
        homedashbord.homeDashborData['mainSliderDetail'] as List<dynamic>?;

    List<dynamic> items = mainSliders ?? [];
    if (items.isEmpty) {
      items = rawMainSliders ?? [];
    }

    if (items.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: Get.height / 50),
        CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final sliderItem = items[index];
            final String mobileImg = sliderItem is MainSliderDetail
                ? (sliderItem.mobileImg ?? '')
                : (sliderItem['mobile_img'] ?? '').toString();
            final String mainImg = sliderItem is MainSliderDetail
                ? (sliderItem.image ?? '')
                : (sliderItem['image'] ?? '').toString();
            final String urlToUse = mobileImg.isNotEmpty ? mobileImg : mainImg;
            final String imageType = sliderItem is MainSliderDetail
                ? (sliderItem.imageType ?? '').toLowerCase()
                : (sliderItem['image_type'] ?? '').toString().toLowerCase();

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
                        child: Text(AppString.imageLoadFailed),
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

//Slider
Widget Silder() {
  final homedashbord = Get.find<Homedashbord>();

  return Obx(() {
    final model = homedashbord.dashboardData.value;
    final offerSliders = model?.mainOfferSliderDetail;
    final rawOfferSliders =
        homedashbord.homeDashborData['mainOfferSliderDetail'] as List<dynamic>?;

    List<dynamic> activeSliders = [];
    if (offerSliders != null && offerSliders.isNotEmpty) {
      activeSliders = offerSliders;
    } else if (rawOfferSliders != null && rawOfferSliders.isNotEmpty) {
      activeSliders = rawOfferSliders;
    }

    if (activeSliders.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: Get.height / 50),
        CarouselSlider.builder(
          itemCount: activeSliders.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final sliderItem = activeSliders[index];
            final String mobileImg = sliderItem is MainOfferSliderDetail
                ? (sliderItem.mobileImg ?? '')
                : (sliderItem['mobile_img'] ?? '').toString();
            final String mainImg = sliderItem is MainOfferSliderDetail
                ? (sliderItem.image ?? '')
                : (sliderItem['image'] ?? '').toString();
            final String urlToUse = mobileImg.isNotEmpty ? mobileImg : mainImg;
            final String imageType = sliderItem is MainOfferSliderDetail
                ? (sliderItem.imageType ?? '').toLowerCase()
                : (sliderItem['image_type'] ?? '').toString().toLowerCase();

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
                        child: Text(AppString.imageLoadFailed),
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
  final offerBannerCtrl = Get.find<OfferBannerCalling>();
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
  final homejewelry = Get.isRegistered<Homejewelry>()
      ? Get.find<Homejewelry>()
      : Get.put(Homejewelry());
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
        section1?.title ?? section1?.titleEn ?? AppString.mostThoughtfulGifts;

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
                                  const Icon(AppIcon.imageNotSupported),
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
  final homejewelry = Get.isRegistered<Homejewelry>()
      ? Get.find<Homejewelry>()
      : Get.put(Homejewelry());
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
        section2?.title ?? section2?.titleEn ?? AppString.newTimelessEditorial;

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
                                  const Icon(AppIcon.imageNotSupported),
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

Widget productList() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final model = homedashbord.dashboardData.value;
    final listFromModel = model?.maindesignledjewelleryDetail;
    final customBanners = model?.customOrderBanner;

    List<dynamic> items = listFromModel ?? [];
    if (items.isEmpty) {
      items = homedashbord.homeDashborData['maindesignledjewelleryDetail']
              as List<dynamic>? ??
          [];
    }

    if (items.isEmpty) {
      return SizedBox.shrink();
    }

    String bannerImg = '';
    if (customBanners != null && customBanners.isNotEmpty) {
      bannerImg = customBanners[0].mobileImg ?? '';
      if (bannerImg.isEmpty || bannerImg.endsWith('.mp4')) {
        bannerImg = customBanners[0].image ?? '';
      }
    }
    if (bannerImg.isEmpty || bannerImg.endsWith('.mp4')) {
      final rawBanners =
          homedashbord.homeDashborData['customOrderBanner'] as List<dynamic>?;
      if (rawBanners != null && rawBanners.isNotEmpty) {
        bannerImg = rawBanners[0]['mobile_img'] ?? rawBanners[0]['image'] ?? '';
      }
    }
    if (bannerImg.isEmpty || bannerImg.endsWith('.mp4')) {
      bannerImg =
          "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/OdrMaVSOxYlj4K4K2eoL7ffWQaj4KV8wCHVVweDO.png";
    }

    return Column(
      children: [
        SizedBox(height: Get.height * 0.02),
        Text(
          AppString.designLedJewellery,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
            fontWeight: FontWeight.bold,
            color: AppColor.brown_color,
          ),
        ),
        SizedBox(height: Get.height * 0.015),
        SizedBox(
          height: Get.height * 0.38,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: 0,
                left: 12,
                right: 12,
                bottom: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    bannerImg,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColor.pink_color.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: Get.height * 0.20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final product = items[index];
                    final String imgUrl =
                        product is MaindesignledjewelleryDetail
                            ? (product.mobileImg?.isNotEmpty == true
                                ? product.mobileImg!
                                : (product.image ?? ''))
                            : (product['mobile_img']?.isNotEmpty == true
                                ? product['mobile_img']
                                : (product['image'] ?? ''));
                    final String title = product is MaindesignledjewelleryDetail
                        ? (product.titleEn ?? '')
                        : (product['title_en'] ?? '');

                    return Container(
                      width: Get.width * 0.32,
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: Get.height * 0.13,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.white_color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColor.pink_color,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  imgUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(AppIcon.imageNotSupported,
                                          color: AppColor.grey_color),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Get.width * 0.032,
                              fontWeight: FontWeight.w600,
                              color: AppColor.brown_color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
        SizedBox(height: Get.height * 0.02),
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
            getHomepageTitleText('instagramtitle', AppString.withPride),
            style: TextStyle(
              fontFamily: 'Zapf',
              fontSize: Get.width * 0.06,
            ),
          ),
          buildHtmlOrText(
            getHomepageDescText('instagramtitle', AppString.customersWear),
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
          getHomepageTitleText('instagramtitle', AppString.withPride),
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
          ),
        ),
        buildHtmlOrText(
          getHomepageDescText('instagramtitle', AppString.customersWear),
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

Widget timelessEditorialSection() {
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColor.white_color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    List<String> images = [];
    if (editorialList != null && editorialList.isNotEmpty) {
      for (var item in editorialList) {
        final img = item.image ?? '';
        if (img.isNotEmpty) images.add(img);
      }
    } else {
      final rawEditorial = homedashbord.homeDashborData['editorialbannerDetail']
          as List<dynamic>?;
      if (rawEditorial != null && rawEditorial.isNotEmpty) {
        for (var item in rawEditorial) {
          final img = item['image'] ?? '';
          if (img.isNotEmpty) images.add(img);
        }
      }
    }

    if (images.isEmpty) {
      return SizedBox.shrink();
    }

    final title = getHomepageTitleText(
        'editorialbannertitle', AppString.timelessEditorialElegance);

    return Column(
      children: [
        SizedBox(height: Get.height * 0.02),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
            fontWeight: FontWeight.bold,
            color: AppColor.brown_color,
          ),
        ),
        SizedBox(height: Get.height * 0.015),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: buildEditorialCollage(images),
        ),
        SizedBox(height: Get.height * 0.010),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: buildEditorialCollage2(images),
        )
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
            getHomepageTitleText('editorialbannertitle', AppString.celebrate),
            style: TextStyle(
              fontFamily: 'Zapf',
              fontSize: Get.width * 0.06,
            ),
          ),
          buildHtmlOrText(
            getHomepageDescText('editorialbannertitle', AppString.elegance),
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
          getHomepageTitleText('editorialbannertitle', AppString.celebrate),
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
          ),
        ),
        buildHtmlOrText(
          getHomepageDescText('editorialbannertitle', AppString.elegance),
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

Widget buildEditorialCollage(List<String> images) {
  if (images.length == 1) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(images[0],
          height: Get.height * 0.40, width: double.infinity, fit: BoxFit.cover),
    );
  }

  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[0],
                height: Get.height * 0.38,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                if (images.length > 1)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[1],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (images.length > 1) SizedBox(height: 8),
                if (images.length > 2)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[2],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      if (images.length > 3) ...[
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[3],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images.length > 4 ? images[4] : images[3],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images.length > 5
                      ? images[5]
                      : (images.length > 4 ? images[4] : images[3]),
                  height: Get.height * 0.38,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    ],
  );
}

Widget buildEditorialCollage2(List<String> images) {
  if (images.length == 1) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(images[0],
          height: Get.height * 0.40, width: double.infinity, fit: BoxFit.cover),
    );
  }

  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                if (images.length > 1)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[1],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (images.length > 1) SizedBox(height: 8),
                if (images.length > 2)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[2],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[0],
                height: Get.height * 0.38,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      if (images.length > 3) ...[
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[3],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images.length > 4 ? images[4] : images[3],
                      height: Get.height * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images.length > 5
                      ? images[5]
                      : (images.length > 4 ? images[4] : images[3]),
                  height: Get.height * 0.38,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    ],
  );
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
          height: Get.height * 0.32,
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.48,
              margin: EdgeInsets.symmetric(horizontal: 6),
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
    List<dynamic> items = productList.isNotEmpty
        ? productList
        : (homedashbord.homeDashborData['categories'] as List<dynamic>? ?? []);

    if (items.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          AppString.kohiraMasterpieces,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            textAlign: TextAlign.center,
            AppString.boldEngagement,
            style: TextStyle(
              fontSize: Get.width * 0.030,
              color: AppColor.textgray,
            ),
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        SizedBox(
          height: Get.height * 0.38,
          child: ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final product = items[index];
              final String imageUrl = product is HomeCategoryItem
                  ? (product.image ?? '')
                  : (product['image'] ?? '');
              final String name = product is HomeCategoryItem
                  ? (product.name ?? '')
                  : (product['name'] ?? '');

              return Container(
                width: Get.width * 0.75,
                margin: EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Get.width * 0.035,
                        color: AppColor.black_color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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

Widget customerReviews() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final isLoading = homedashbord.isLoading.value;
    final model = homedashbord.dashboardData.value;
    final reviewListModel = model?.homeCustomerReviewDetail;

    if (isLoading && (reviewListModel == null || reviewListModel.isEmpty)) {
      return SizedBox.shrink();
    }

    List<dynamic> items = [];
    if (reviewListModel != null && reviewListModel.isNotEmpty) {
      items = reviewListModel;
    } else {
      final rawReviews = homedashbord
          .homeDashborData['homeCustomerReviewDetail'] as List<dynamic>?;
      if (rawReviews != null && rawReviews.isNotEmpty) {
        items = rawReviews;
      }
    }

    if (items.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          AppString.customerReviewsTitle,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            textAlign: TextAlign.center,
            AppString.customerReviewsSubtitle,
            style: TextStyle(
              fontSize: Get.width * 0.030,
              color: AppColor.textgray,
            ),
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final item = items[index];
            final String name = item is HomeCustomerReviewDetail
                ? (item.userName ?? '')
                : (item['user_name'] ?? '');
            final String body = item is HomeCustomerReviewDetail
                ? (item.body ?? '')
                : (item['body'] ?? '');
            final String rateStr = item is HomeCustomerReviewDetail
                ? (item.rateUs ?? '5')
                : (item['rate_us'] ?? '5');
            final String imageUrl = item is HomeCustomerReviewDetail
                ? (item.image ?? '')
                : (item['image'] ?? '');
            final int rating = int.tryParse(rateStr) ?? 5;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 35),
                    padding: EdgeInsets.fromLTRB(16, 45, 16, 16),
                    decoration: BoxDecoration(
                      color: AppColor.reviewContainerColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 80),
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * 0.04,
                            color: AppColor.black_color,
                          ),
                        ),
                        SizedBox(height: 6),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              body,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Get.width * 0.030,
                                color: AppColor.textgray,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              starIndex < rating
                                  ? AppIcon.starIcon
                                  : AppIcon.starBorderIcon,
                              color: AppColor.glodcolor,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: Get.width * 0.32,
                      height: Get.height * 0.17,
                      decoration: BoxDecoration(
                        color: AppColor.white_color,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppColor.brown_color, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.5),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: AppColor.grey_color),
                                ),
                              )
                            : Center(
                                child: Icon(Icons.image_not_supported,
                                    color: AppColor.grey_color),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: Get.height * 0.45,
            autoPlay: true,
            viewportFraction: 0.82,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  });
}

Widget promise() {
  return horizontalpadding(child: Image.asset(AppImage.promise));
}

Widget storeLocationsSection() {
  final storeController = Get.find<StoreLocationsController>();
  return Obx(() {
    final isLoading = storeController.isLoading.value;
    final states = storeController.storeLocations;

    if (isLoading && states.isEmpty) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.24,
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: Get.width * 0.75,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      );
    }

    if (states.isEmpty) {
      return SizedBox.shrink();
    }

    List<Map<String, dynamic>> allStores = [];
    for (var state in states) {
      if (state.cities != null) {
        for (var city in state.cities!) {
          if (city.stores != null) {
            for (var store in city.stores!) {
              allStores.add({
                'state': state.stateName ?? '',
                'city': city.cityName ?? '',
                'store': store,
              });
            }
          }
        }
      }
    }

    if (allStores.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          AppString.ourStores,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
            fontWeight: FontWeight.bold,
            color: AppColor.brown_color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          textAlign: TextAlign.center,
          AppString.experienceKohira,
          style: TextStyle(
            fontSize: Get.width * 0.030,
            color: AppColor.textgray,
          ),
        ),
        SizedBox(height: Get.height * 0.025),
        SizedBox(
          height: Get.height * 0.22,
          child: ListView.builder(
            itemCount: allStores.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final item = allStores[index];
              final store = item['store'] as StoreItem;
              final String stateName = item['state'];
              final String cityName = item['city'];

              return Container(
                width: Get.width * 0.78,
                margin: EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColor.white_color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColor.brown_color.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.white_color,
                          Color(0xFFFBF9F7),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.brown_color.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                AppIcon.storefrontRoundedIcon,
                                color: AppColor.brown_color,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store.name ?? '',
                                    style: TextStyle(
                                      fontSize: Get.width * 0.038,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.brown_color,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "$cityName, $stateName",
                                    style: TextStyle(
                                      fontSize: Get.width * 0.030,
                                      color: AppColor.textgray,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            color: AppColor.dividercolor.withOpacity(0.5),
                            height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(AppIcon.locationPinIcon,
                                    color: AppColor.pink_color, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  store.pincode != null
                                      ? "Pincode: ${store.pincode}"
                                      : "Store Location",
                                  style: TextStyle(
                                    fontSize: Get.width * 0.030,
                                    color: AppColor.grey_color,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColor.pink_color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "View Store",
                                style: TextStyle(
                                  fontSize: Get.width * 0.028,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.pink_color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

String getHomepageTitleText(String key, String fallback) {
  try {
    final homedashbord = Get.find<Homedashbord>();
    final model = homedashbord.dashboardData.value;
    final hp = model?.homepageTitle;
    TitleDetailItem? item;
    if (hp != null) {
      if (key == 'instagramtitle') {
        item = hp.instagramtitle;
      } else if (key == 'ledjewelrttitle') {
        item = hp.ledjewelrttitle;
      } else if (key == 'homenewstitle') {
        item = hp.homenewstitle;
      } else if (key == 'homeeeducationtitle') {
        item = hp.homeeeducationtitle;
      } else if (key == 'editorialbannertitle') {
        item = hp.editorialbannertitle;
      }
    }
    if (item?.titleEn != null && item!.titleEn!.isNotEmpty) {
      return item.titleEn!;
    }
    final rawHp = homedashbord.homeDashborData['homepage_title'];
    if (rawHp is Map && rawHp[key] is Map) {
      final t = rawHp[key]['title_en'];
      if (t != null && t.toString().isNotEmpty) {
        return t.toString();
      }
    }
  } catch (_) {}
  return fallback;
}

String getHomepageDescText(String key, String fallback) {
  try {
    final homedashbord = Get.find<Homedashbord>();
    final model = homedashbord.dashboardData.value;
    final hp = model?.homepageTitle;
    TitleDetailItem? item;
    if (hp != null) {
      if (key == 'instagramtitle') {
        item = hp.instagramtitle;
      } else if (key == 'ledjewelrttitle') {
        item = hp.ledjewelrttitle;
      } else if (key == 'homenewstitle') {
        item = hp.homenewstitle;
      } else if (key == 'homeeeducationtitle') {
        item = hp.homeeeducationtitle;
      } else if (key == 'editorialbannertitle') {
        item = hp.editorialbannertitle;
      }
    }
    if (item?.descriptionEn != null && item!.descriptionEn!.isNotEmpty) {
      return item.descriptionEn!;
    }
    final rawHp = homedashbord.homeDashborData['homepage_title'];
    if (rawHp is Map && rawHp[key] is Map) {
      final d = rawHp[key]['description_en'];
      if (d != null && d.toString().isNotEmpty) {
        return d.toString();
      }
    }
  } catch (_) {}
  return fallback;
}

Widget buildHtmlOrText(String content) {
  if (content.contains('<') && content.contains('>')) {
    return Html(
      data: content,
      style: {
        "div": Style(
          textAlign: TextAlign.center,
          color: AppColor.textgray,
          fontSize: FontSize(Get.width * 0.030),
          margin: Margins.zero,
        ),
        "span": Style(
          color: AppColor.textgray,
          fontSize: FontSize(Get.width * 0.030),
        ),
        "font": Style(
          color: AppColor.textgray,
        ),
      },
    );
  } else {
    return Text(
      content,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: Get.width * 0.030,
        color: AppColor.textgray,
      ),
    );
  }
}

Widget newsStorySection() {
  final title = getHomepageTitleText('homenewstitle', '');
  final desc = getHomepageDescText('homenewstitle', '');

  if (title.isEmpty && desc.isEmpty) {
    return SizedBox.shrink();
  }

  return Column(
    children: [
      SizedBox(height: Get.height * 0.02),
      Text(
        title,
        style: TextStyle(
          fontFamily: 'Zapf',
          fontSize: Get.width * 0.06,
        ),
      ),
      SizedBox(height: 4),
      if (desc.isNotEmpty)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: buildHtmlOrText(desc),
        ),
      SizedBox(height: Get.height * 0.02),
    ],
  );
}

Widget educationSection() {
  final homedashbord = Get.find<Homedashbord>();
  return Obx(() {
    final model = homedashbord.dashboardData.value;
    final educationList = model?.mainhomeeducationlistDetail ??
        homedashbord.homeDashborData['mainhomeeducationlistDetail']
            as List<dynamic>?;

    final title = getHomepageTitleText('homeeeducationtitle', '');
    final desc = getHomepageDescText('homeeeducationtitle', '');

    if ((educationList == null || educationList.isEmpty) &&
        title.isEmpty &&
        desc.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Zapf',
              fontSize: Get.width * 0.06,
            ),
          ),
          SizedBox(height: 4),
        ],
        if (desc.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: buildHtmlOrText(desc),
          ),
        SizedBox(height: Get.height * 0.02),
        if (educationList != null && educationList.isNotEmpty)
          SizedBox(
            height: Get.height * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: educationList.length,
              itemBuilder: (context, index) {
                final item = educationList[index];
                final imageUrl = item is Map ? item['image'] ?? '' : '';
                if (imageUrl.isEmpty) return SizedBox.shrink();
                return Container(
                  width: Get.width * 0.35,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.contain,
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

Widget newsListSection() {
  final newsController = Get.find<NewsListCalling>();
  return Obx(() {
    if (newsController.isLoading.value && newsController.newsItems.isEmpty) {
      return Shimmer.fromColors(
        baseColor: AppColor.lodingcolor,
        highlightColor: AppColor.highlightColor,
        child: Container(
          height: Get.height * 0.4,
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    final items = newsController.newsItems;
    if (items.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: Get.height * 0.02),
        Text(
          AppString.newsTitle,
          style: TextStyle(
            fontFamily: 'Zapf',
            fontSize: Get.width * 0.06,
            fontWeight: FontWeight.bold,
            color: AppColor.brown_color,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (context, index, realIndex) {
            final item = items[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppColor.dividercolor.withOpacity(0.6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (item.imageLogo != null && item.imageLogo!.isNotEmpty)
                    Image.network(
                      item.imageLogo!,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(AppIcon.imageNotSupported),
                    )
                  else
                    SizedBox.shrink(),
                  SizedBox(height: 8),
                  Text(
                    item.descriptionEn ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Get.width * 0.038,
                      color: AppColor.textgray,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (item.buttonlink != null && item.buttonlink!.isNotEmpty)
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(item.buttonlink!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.black_color, width: 1.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppString.readMore,
                          style: TextStyle(
                            fontSize: Get.width * 0.035,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColor.black_color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: Get.height * 0.42,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            viewportFraction: 0.85,
            enlargeCenterPage: true,
          ),
        ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  });
}
