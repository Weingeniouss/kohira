// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

RecommendedJewelleryListModel recommendedJewelleryListModelFromJson(
        String str) =>
    RecommendedJewelleryListModel.fromJson(json.decode(str));

String recommendedJewelleryListModelToJson(
        RecommendedJewelleryListModel data) =>
    json.encode(data.toJson());

class RecommendedJewelleryListModel {
  final bool success;
  final String message;
  final List<RecommendedItem> freqBoughtItems;
  final List<RecommendedItem> matchingItems;

  RecommendedJewelleryListModel({
    required this.success,
    required this.message,
    required this.freqBoughtItems,
    required this.matchingItems,
  });

  factory RecommendedJewelleryListModel.fromJson(Map<String, dynamic> json) =>
      RecommendedJewelleryListModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        freqBoughtItems: json["freq_bought_items"] != null
            ? List<RecommendedItem>.from(json["freq_bought_items"]
                .map((x) => RecommendedItem.fromJson(x)))
            : [],
        matchingItems: json["matching_items"] != null
            ? List<RecommendedItem>.from(json["matching_items"]
                .map((x) => RecommendedItem.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "freq_bought_items":
            List<dynamic>.from(freqBoughtItems.map((x) => x.toJson())),
        "matching_items":
            List<dynamic>.from(matchingItems.map((x) => x.toJson())),
      };
}

class RecommendedItem {
  final int id;
  final String itemcode;
  final dynamic producttype;
  final String maindesignnumber;
  final num settingPrice;
  final String slug;
  final String title;
  final num offerPrice;
  final String discount;
  final String defaultImage;
  final String secondImage;

  RecommendedItem({
    required this.id,
    required this.itemcode,
    this.producttype,
    required this.maindesignnumber,
    required this.settingPrice,
    required this.slug,
    required this.title,
    required this.offerPrice,
    required this.discount,
    required this.defaultImage,
    required this.secondImage,
  });

  String get displayImage =>
      secondImage.isNotEmpty ? secondImage : defaultImage;

  factory RecommendedItem.fromJson(Map<String, dynamic> json) =>
      RecommendedItem(
        id: json["id"] ?? 0,
        itemcode: json["itemcode"] ?? "",
        producttype: json["producttype"],
        maindesignnumber: json["maindesignnumber"] ?? "",
        settingPrice: json["setting_price"] ?? 0,
        slug: json["slug"] ?? "",
        title: json["title"] ?? "",
        offerPrice: json["offer_price"] ?? 0,
        discount: json["discount"]?.toString() ?? "0.00",
        defaultImage: json["default_image"] ?? "",
        secondImage: json["second_image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemcode": itemcode,
        "producttype": producttype,
        "maindesignnumber": maindesignnumber,
        "setting_price": settingPrice,
        "slug": slug,
        "title": title,
        "offer_price": offerPrice,
        "discount": discount,
        "default_image": defaultImage,
        "second_image": secondImage,
      };
}
