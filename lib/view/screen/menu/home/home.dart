// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, deprecated_member_use, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/user_inerface/menu/home/home.dart';
import 'package:kohira/view/screen/menu/home/Search.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_logo.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../utils/app_String.dart';
import '../../../utils/widget/inputField.dart';
import '../../../utils/widget/video.dart';
import '../category/showproduct.dart';
import '../category/subcategory.dart';
import 'menuwidget/drawer.dart';

class Home extends StatelessWidget {
  final home = Get.put(HomeController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Home({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('No')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Yes')),
            ],
          ),
        ) ?? false;
        if (shouldPop) Navigator.of(context).pop();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          prefixicon: AppIcon.menu,
          prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
          logo: AppLogo.logo,
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
              if (home.homecollction.isLoading.value && home.homecollction.data.isEmpty) {
                return SingleChildScrollView(
                  child: horizontalpadding(
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
                              borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height / 50),
                        Shimmer.fromColors(
                          baseColor: AppColor.lodingcolor,
                          highlightColor: AppColor.highlightColor,
                          child: Container(
                            height: Get.height * 0.45,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Get.width / 50), color: AppColor.white_color),
                          ),
                        ),
                        SizedBox(height: Get.height / 50),
                        Shimmer.fromColors(
                          baseColor: AppColor.lodingcolor,
                          highlightColor: AppColor.highlightColor,
                          child: Container(
                            height: Get.height * 0.015,
                            width: Get.width / 5,
                            decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        SizedBox(height: Get.height / 50),
                        Shimmer.fromColors(
                          baseColor: AppColor.lodingcolor,
                          highlightColor: AppColor.highlightColor,
                          child: SizedBox(
                            height: Get.height * 0.23,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 8),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(border: Border.all(color: AppColor.white_color), borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(45),
                                        decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(12)),
                                      ),
                                      SizedBox(height: Get.height / 150),
                                      Container(
                                        width: Get.width / 6,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(12)),
                                      ),
                                      SizedBox(height: Get.height / 150),
                                      Container(
                                        width: Get.width / 9,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(12)),
                                      ),
                                      SizedBox(height: Get.height / 150),
                                      Container(
                                        width: Get.width / 13,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height / 50),
                      ],
                    ),
                  ),
                );
              }
              final rings = home.homejewelry.homejewelrydata['data']?['most_loved_engagement_rings'];
              if (rings == null || (rings is List && rings.isEmpty)) return Center(child: Lottie.asset(AppJson.noData));
              final section = home.homecollction.data['3']?['collection_section_3'];
              if (section == null) return Center(child: Lottie.asset(AppJson.noData));
              final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),

                    //SearchBar Start
                    horizontalpadding(child: searchField(readOnly: true, onTap: () => Get.to(Search()))),
                    //SearchBar End

                    SizedBox(height: Get.height / 50),

                    //CarouselSlider Start
                    (home.slider.data.isEmpty)
                        ? SizedBox()
                        : SizedBox(
                            child: Column(
                              children: [
                                CarouselSlider.builder(
                                  carouselController: home.pagecontroller,
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    height: Get.height * 0.45,
                                    autoPlay: false,
                                    onPageChanged: home.changeCarouselIndex,
                                  ),
                                  itemCount: home.slider.data.length,
                                  itemBuilder: (BuildContext context, int index, int realIndex) {
                                    final sliderlist = home.slider.data[index];
                                    if (sliderlist.imageType == 'image') {
                                      return Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            sliderlist.image ?? '',
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Center(child: Lottie.asset(AppJson.loading2, height: 30, width: 30));
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(child: Text("Image load failed"));
                                            },
                                          ),
                                          Container(
                                            color: Colors.black.withOpacity(0.1),
                                            child: Padding(
                                              padding: EdgeInsets.all(Get.width / 15),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(sliderlist.titleEn.toString(), style: TextStyle(color: AppColor.white_color, fontSize: Get.width / 26)),
                                                      SizedBox(height: Get.width / 80),
                                                      Text(
                                                        (sliderlist.subtitle == null) ? '' : sliderlist.subtitle.toString(),
                                                        style: TextStyle(
                                                          color: AppColor.white_color,
                                                          fontSize: Get.width / 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: getAlignmentFromTextPosition(sliderlist.textposition),
                                                    child: TextButton(
                                                      onPressed: () {},
                                                      child: Container(
                                                        padding: EdgeInsets.only(bottom: Get.size.height / 150),
                                                        decoration: BoxDecoration(
                                                          border: Border(bottom: BorderSide(color: AppColor.pink_color, width: 2.0)),
                                                        ),
                                                        child: Text('Embraae Your Royal Glow', style: TextStyle(color: AppColor.pink_color, fontSize: Get.width / 25)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    } else if (sliderlist.imageType == 'video') {
                                      return Stack(children: [
                                        VideoPlayerMenu(videoUrl: sliderlist.image ?? ''),
                                        Container(
                                          color: Colors.black.withOpacity(0.1),
                                          width: Get.width,
                                          child: Padding(
                                            padding: EdgeInsets.all(Get.width / 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(sliderlist.titleEn.toString(), style: TextStyle(color: AppColor.white_color, fontSize: Get.width / 26)),
                                                    SizedBox(height: Get.width / 80),
                                                    Text(
                                                      (sliderlist.subtitle == null) ? '' : sliderlist.subtitle.toString(),
                                                      style: TextStyle(color: AppColor.white_color, fontSize: Get.width / 15),
                                                    ),
                                                  ],
                                                ),
                                                Align(
                                                  alignment: getAlignmentFromTextPosition(sliderlist.textposition),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    child: Container(
                                                      padding: EdgeInsets.only(bottom: Get.size.height / 150),
                                                      decoration: BoxDecoration(
                                                        border: Border(bottom: BorderSide(color: AppColor.pink_color, width: 2.0)),
                                                      ),
                                                      child: Text('Embraae Your Royal Glow', style: TextStyle(color: AppColor.pink_color, fontSize: Get.width / 25)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]);
                                    } else {
                                      return Center(child: Text("Unsupported content"));
                                    }
                                  },
                                ),
                                SizedBox(height: Get.height / 60),
                                AnimatedSmoothIndicator(
                                  activeIndex: home.activeIndex.value,
                                  count: home.slider.data.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    activeDotColor: AppColor.pink_color,
                                    dotColor: AppColor.Appbercolor,
                                  ),
                                  onDotClicked: (index) => home.pagecontroller.animateToPage(index),
                                ),
                                SizedBox(height: Get.height / 60),
                              ],
                            ),
                          ),
                    //CarouselSlider End

                    SizedBox(height: Get.height / 80),

                    //Categorieslist Start
                    (home.categories.data.isEmpty)
                        ? SizedBox()
                        : Container(
                            decoration: BoxDecoration(color: AppColor.spicalcontainer),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: Get.height / 50),
                              child: Column(
                                children: [
                                  horizontalpadding(
                                    child: Align(
                                      alignment: AlignmentGeometry.topLeft,
                                      child: Text(
                                        AppString.matter_heading,
                                        style: TextStyle(
                                          fontSize: Get.width * 0.060,
                                          fontFamily: 'Zapf',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                                    child: SizedBox(
                                      height: Get.height * 0.25,
                                      child: ListView.builder(
                                        itemCount: home.categories.data.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index) {
                                          final categorieslist = home.categories.data[index];
                                          return GestureDetector(
                                            onTap: () {
                                              categorieslist.slug;
                                              categorieslist.name;
                                              print("categorieslist :- ${categorieslist.slug}");
                                              Get.to(
                                                () => Subcategorys(
                                                  subcategrorys: categorieslist.slug.toString(),
                                                  subcategrorysname: categorieslist.name.toString(),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.45,
                                                  height: Get.height * 0.20,
                                                  margin: EdgeInsets.only(left: Get.width * 0.04),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.transparent),
                                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                                    image: DecorationImage(
                                                      image: NetworkImage(categorieslist.image ?? ''),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: Get.height / 150),
                                                SizedBox(
                                                  width: Get.width * 0.25,
                                                  child: Text(
                                                    categorieslist.name.toString().length > 25 ? '${categorieslist.name.toString().substring(0, 10)}...' : categorieslist.name.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: Get.width / 32, color: AppColor.hintColor, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    //Categorieslist End

                    SizedBox(height: Get.height / 50),

                    //section 1 start
                    Container(
                      decoration: BoxDecoration(color: AppColor.spicalcontainer),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              home.homecollction.data['2']?['collection_section_2']?['name'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.060, fontFamily: 'Zapf'),
                            ),
                            SizedBox(height: Get.height / 50),
                            Text(
                              home.homecollction.data['2']?['collection_section_2']?['description'] ?? '',
                              maxLines: home.kohiraDiamonds.value ? null : 3,
                              overflow: home.kohiraDiamonds.value ? TextOverflow.visible : TextOverflow.ellipsis,
                              style: TextStyle(color: AppColor.hintColor, fontSize: Get.width / 29),
                            ),
                            GestureDetector(
                              onTap: home.toggleKohiraDiamonds,
                              child: Text(
                                home.kohiraDiamonds.value ? 'See Less' : 'See More',
                                style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Image.network(home.homecollction.data['2']?['collection_section_2']['images']?[0] ?? '')
                          ],
                        ),
                      ),
                    ),
                    //section 1 End

                    SizedBox(height: Get.height / 50),

                    //Most Loverd Engagement Rings Start
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(color: AppColor.spicalcontainer),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Get.height / 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Most Loved Engagement Rings', style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.060, fontFamily: 'Zapf')),
                            ),
                            SizedBox(height: Get.height / 80),
                            SizedBox(
                              height: Get.height * 0.30,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  final image = home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'][index]['allImages'][0]['thumb'];
                                  final title = home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'][index]['title'];
                                  final price = home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'][index]['setting_price'];
                                  return GestureDetector(
                                    onTap: (){
                                      Get.to(() => Showproduct(
                                        slug: home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'][index]['slug'],
                                        categoryslug: home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'][index]['title'],
                                      ));
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 4),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.network(image,width: 150,height: 150),
                                              SizedBox(width:Get.width / 3,child: Text(title,style: TextStyle(fontSize: Get.width / 32, color: AppColor.hintColor, fontWeight: FontWeight.w500))),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: Get.width / 60),
                                            Text(indianFormat.format(price) ,style: TextStyle(color: AppColor.pink_color,fontWeight: FontWeight.w500)),
                                          ],
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
                    ),
                    //Most Loverd Engagement Rings End

                    SizedBox(height: Get.height / 50),

                    //section 2 start
                    Container(
                      decoration: BoxDecoration(color: AppColor.spicalcontainer),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section['name'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Get.width * 0.060,
                                    fontFamily: 'Zapf',
                                  ),
                                ),
                                SizedBox(height: Get.height / 50),
                                Text(
                                  section['description'] ?? '',
                                  maxLines: home.dreemJewwlry.value ? null : 3,
                                  overflow: home.dreemJewwlry.value ? TextOverflow.visible : TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColor.hintColor,
                                    fontSize: Get.width / 29,
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: home.toggleDreemJewwlry,
                                  child: Text(
                                    home.dreemJewwlry.value ? 'See Less' : 'See More',
                                    style: TextStyle(
                                      color: AppColor.pink_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height / 40),
                            AspectRatio(
                              aspectRatio: 9 / 10,
                              child: VideoPlayerMenuSecond(videoUrl: section['video']),
                            ),
                            SizedBox(height: Get.height / 40),
                          ],
                        ),
                      ),
                    ),
                    //section 2 End

                    SizedBox(height: Get.height / 50),

                    //Featurd Jewellery Start
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(color: AppColor.spicalcontainer),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Get.height / 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:EdgeInsets.all(10),
                              child: Text('Featured Jewellery', style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.060, fontFamily: 'Zapf')),
                            ),
                            SizedBox(
                              height: Get.height * 0.30,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: home.homejewelry.homejewelrydata['data']['new_arrivals'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  final image = home.homejewelry.homejewelrydata['data']['new_arrivals'][index]['allImages'][0]['thumb'];
                                  final title = home.homejewelry.homejewelrydata['data']['new_arrivals'][index]['title'];
                                  final price = home.homejewelry.homejewelrydata['data']['new_arrivals'][index]['setting_price'];
                                  return GestureDetector(
                                    onTap: (){
                                      Get.to(() => Showproduct(
                                        slug: home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'][index]['slug'],
                                        categoryslug: home.homejewelry.homejewelrydata['data']['most_loved_engagement_rings'][index]['title'],
                                      ));
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 4),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.network(image,width: 150,height: 150),
                                              SizedBox(width:Get.width / 3,child: Text(title,style: TextStyle(fontSize: Get.width / 32, color: AppColor.hintColor, fontWeight: FontWeight.w500))),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: Get.width / 60),
                                            Text(indianFormat.format(price) ,style: TextStyle(color: AppColor.pink_color,fontWeight: FontWeight.w500)),
                                          ],
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
                    ),
                    //Featurd Jewellery End

                    SizedBox(height: Get.height / 50),

                    //Only Kohira Information Start
                    Container(
                      decoration: BoxDecoration(color: AppColor.hintColor2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  home.homecollction.data['4']?['collection_section_4']?['name'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.050, fontFamily: 'Zapf'),
                                ),
                                SizedBox(height: Get.height / 80),
                                Text(
                                  home.homecollction.data['4']?['collection_section_4']?['description'] ?? '',
                                  style: TextStyle(color: AppColor.hintColor, fontSize: Get.width / 29),
                                ),
                                SizedBox(height: Get.height / 80),
                                Text(
                                  textAlign: TextAlign.center,
                                  home.homecollction.data['4']?['collection_section_4']?['sub_title'] ?? '',
                                  style: TextStyle(fontSize: Get.width * 0.050, fontFamily: 'Lora'),
                                ),
                                SizedBox(height: Get.height / 80),
                                Text(
                                  home.homecollction.data['4']?['collection_section_4']?['sub_description'] ?? '',
                                  style: TextStyle(color: AppColor.hintColor, fontSize: Get.width / 29),
                                ),
                              ],
                            ),
                          ),
                          Image.network(home.homecollction.data['4']?['collection_section_4']['images'][0] ?? ''),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 3,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        home.homecollction.data['4']?['collection_section_4']?['detail'][0]['title'] ?? '',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.040),
                                      ),
                                    ),
                                    SizedBox(height: 100, child: VerticalDivider(color: AppColor.dividercolor, thickness: 2, width: 80)),
                                    SizedBox(
                                      width: Get.width / 3,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        home.homecollction.data['4']?['collection_section_4']?['detail'][1]['title'] ?? '',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.040),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Get.height / 50),
                                Divider(color: AppColor.dividercolor),
                                SizedBox(height: Get.height / 50),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 3,
                                      child: Text(
                                         textAlign: TextAlign.center,
                                         home.homecollction.data['4']?['collection_section_4']?['detail'][2]['title'] ?? '',
                                         style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.040,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 100, child: VerticalDivider(color: AppColor.dividercolor, thickness: 2, width: 80)),
                                    SizedBox(
                                      width: Get.width / 3,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        home.homecollction.data['4']?['collection_section_4']?['detail'][3]['title'] ?? '',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.040),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    //Only kohira Information End
                    SizedBox(height: Get.height / 50),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

//Set Alignment
  Alignment getAlignmentFromTextPosition(String? position) {
    switch (position) {
      case 'top-left':
        return Alignment.topLeft;
      case 'top-center':
        return Alignment.topCenter;
      case 'top-right':
        return Alignment.topRight;
      case 'center-left':
        return Alignment.centerLeft;
      case 'center':
        return Alignment.center;
      case 'center-right':
        return Alignment.centerRight;
      case 'bottom-left':
        return Alignment.bottomLeft;
      case 'bottom-center':
        return Alignment.bottomCenter;
      case 'bottom-right':
        return Alignment.bottomRight;
      default:
        return Alignment.center; // fallback
    }
  }
}
