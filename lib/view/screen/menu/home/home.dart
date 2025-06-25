// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/home/categories.dart';
import 'package:kohira/controller/API/menu/home/slider.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../utils/app_String.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final categories = Get.put(CategoriesCalling());
  final slider = Get.put(SliderCalling());

  final pagecontroller = CarouselSliderController();
  int activeIndex = 0;

  void changeCarouselinadex(index, reason){
    setState(() => activeIndex = index);
  }

  @override
  void initState() {
    super.initState();
    slider.slideruser();
    categories.categoriesuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
            if (slider.isLoading.value) {
              return Center(child: Lottie.asset(AppJson.loading2));
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),

                    //SearchBar Start
                    horizontalpadding(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.textfild_color),
                          borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                        ),
                        child: Center(
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: Get.height / 60),
                              prefixIcon: Icon(Icons.search, color: AppColor.hintColor),
                              hintText: 'Search',
                              hintStyle: TextStyle(color: AppColor.hintColor),
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //SearchBar End

                    SizedBox(height: Get.height / 50),

                    //CarouselSlider Start
                    SizedBox(
                      child: Column(
                        children: [
                          CarouselSlider.builder(
                            carouselController: pagecontroller,
                            options: CarouselOptions(
                              viewportFraction: 1,
                              height: Get.height * 0.45,
                              autoPlay: false,
                              onPageChanged: changeCarouselinadex,
                            ),
                            itemCount: slider.data.length,
                            itemBuilder: (BuildContext context, int index, int realIndex) {
                              final sliderlist = slider.data[index];

                              if (sliderlist.imageType == 'image') {
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      sliderlist.image ?? '',
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, progress) {
                                        if (progress == null) return child;
                                        return Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(child: Text("Image load failed"));
                                      },
                                    ),
                                    Container(
                                      color: Colors.black.withOpacity(0.2),
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
                                                  (sliderlist.subtitle == null)
                                                      ? ''
                                                      : sliderlist.subtitle.toString(),
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
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: AppColor.pink_color,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Embraae Your Royal Glow',
                                                    style: TextStyle(
                                                      color: AppColor.pink_color,
                                                      fontSize: Get.width / 25,
                                                    ),
                                                  ),
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
                                    color: Colors.black.withOpacity(0.2),
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
                                                  (sliderlist.subtitle == null)
                                                      ? ''
                                                      : sliderlist.subtitle.toString(),
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
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: AppColor.pink_color,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Embraae Your Royal Glow',
                                                    style: TextStyle(
                                                      color: AppColor.pink_color,
                                                      fontSize: Get.width / 25,
                                                    ),
                                                  ),
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
                           activeIndex: activeIndex,
                           count: slider.data.length,
                            effect: ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: AppColor.pink_color,
                            dotColor: AppColor.Appbercolor,
                           ),
                           onDotClicked: (index) => pagecontroller.animateToPage(index),
                          ),
                          SizedBox(height: Get.height / 60),
                        ],
                      ),
                    ),
                    //CarouselSlider End

                    SizedBox(height: Get.height / 80),

                    //Categorieslist Start
                    Container(
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
                              itemCount: categories.data.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final categorieslist = categories.data[index];
                                return Column(
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
                                        textAlign: TextAlign.center,
                                        categorieslist.name.toString(),
                                        style: TextStyle(
                                          fontSize: Get.width / 32,
                                          color: AppColor.hintColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
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
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
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

//Video Player Setting
class VideoPlayerMenu extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerMenu({required this.videoUrl});

  @override
  State<VideoPlayerMenu> createState() => _VideoPlayerMenuState();
}

class _VideoPlayerMenuState extends State<VideoPlayerMenu> {
  late VideoPlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setVolume(0.0); // Mute video
        _controller.setLooping(true);
        _controller.play();
        setState(() {
          _isReady = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.2),
        ),
      ],
    );
  }
}
