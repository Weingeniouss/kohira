import 'dart:convert';

HomeJewelrySectionsModel homeJewelrySectionsModelFromJson(String str) =>
    HomeJewelrySectionsModel.fromJson(json.decode(str));

class HomeJewelrySectionsModel {
  bool? success;
  String? message;
  HomeJewelryData? data;

  HomeJewelrySectionsModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeJewelrySectionsModel.fromJson(Map<String, dynamic> json) {
    return HomeJewelrySectionsModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? HomeJewelryData.fromJson(json['data']) : null,
    );
  }
}

class HomeJewelryData {
  HomeJewelrySection? section1;
  HomeJewelrySection? section2;

  HomeJewelryData({
    this.section1,
    this.section2,
  });

  factory HomeJewelryData.fromJson(Map<String, dynamic> json) {
    return HomeJewelryData(
      section1: json['section1'] != null
          ? HomeJewelrySection.fromJson(json['section1'])
          : null,
      section2: json['section2'] != null
          ? HomeJewelrySection.fromJson(json['section2'])
          : null,
    );
  }
}

class HomeJewelrySection {
  num? id;
  String? titleEn;
  String? descriptionEn;
  String? buttonlink;
  String? buttontextEn;
  String? image;
  String? mobileImg;
  String? key;
  String? title;
  List<JewelryItem>? items;

  HomeJewelrySection({
    this.id,
    this.titleEn,
    this.descriptionEn,
    this.buttonlink,
    this.buttontextEn,
    this.image,
    this.mobileImg,
    this.key,
    this.title,
    this.items,
  });

  factory HomeJewelrySection.fromJson(Map<String, dynamic> json) {
    return HomeJewelrySection(
      id: json['id'],
      titleEn: json['title_en'],
      descriptionEn: json['description_en'],
      buttonlink: json['buttonlink'],
      buttontextEn: json['buttontext_en'],
      image: json['image'],
      mobileImg: json['mobile_img'],
      key: json['key'],
      title: json['title'],
      items: json['items'] != null
          ? (json['items'] as List).map((e) => JewelryItem.fromJson(e)).toList()
          : null,
    );
  }
}

class JewelryItem {
  num? id;
  String? title;
  num? settingPrice;
  String? slug;
  num? offerPrice;
  String? discount;
  List<JewelryImage>? allImages;

  JewelryItem({
    this.id,
    this.title,
    this.settingPrice,
    this.slug,
    this.offerPrice,
    this.discount,
    this.allImages,
  });

  factory JewelryItem.fromJson(Map<String, dynamic> json) {
    return JewelryItem(
      id: json['id'],
      title: json['title'],
      settingPrice: json['setting_price'],
      slug: json['slug'],
      offerPrice: json['offer_price'],
      discount: json['discount'],
      allImages: json['allImages'] != null
          ? (json['allImages'] as List)
              .map((e) => JewelryImage.fromJson(e))
              .toList()
          : null,
    );
  }
}

class JewelryImage {
  num? id;
  String? type;
  String? thumb;
  String? feature;
  String? zoom;

  JewelryImage({
    this.id,
    this.type,
    this.thumb,
    this.feature,
    this.zoom,
  });

  factory JewelryImage.fromJson(Map<String, dynamic> json) {
    return JewelryImage(
      id: json['id'],
      type: json['type'],
      thumb: json['thumb'],
      feature: json['feature'],
      zoom: json['zoom'],
    );
  }
}
