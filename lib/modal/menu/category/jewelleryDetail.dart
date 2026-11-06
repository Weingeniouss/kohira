// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

JewelleryDetailModel jewelleryDetailModelFromJson(String str) =>
    JewelleryDetailModel.fromJson(json.decode(str));

String jewelleryDetailModelToJson(JewelleryDetailModel data) =>
    json.encode(data.toJson());

class JewelleryDetailModel {
  final bool success;
  final String message;
  final JewelleryDetailData? data;

  JewelleryDetailModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory JewelleryDetailModel.fromJson(Map<String, dynamic> json) =>
      JewelleryDetailModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? JewelleryDetailData.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class JewelleryDetailData {
  final int id;
  final String title;
  final String slug;
  final String itemcode;
  final String parentitemcode;
  final String maindesignnumber;
  final String? width;
  final String? height;
  final String? description;
  final String? tags;
  final dynamic metalweight;
  final num offerPrice;
  final num settingPrice;
  final num discountPrice;
  final String? discount;
  final String? couponType;
  final dynamic allTotalCarat;
  final dynamic totalCarat;
  final String? syncMetalPrice;
  final String? syncDiaPrice;
  final String? syncLabourChargePrice;
  final String? syncOtherChargePrice;
  final bool isParent;
  final String? itemType;
  final String? ringSizeGuideline;
  final List<dynamic> allRingSize;
  final List<dynamic> allChainSizes;
  final List<ProductImage> allImages;
  final List<ProductVideo> video;
  final CategoryRef? category;
  final ParamRef? metalStamp;
  final ParamRef? metalType;
  final dynamic centerstone;
  final List<JewelryDiamond> jewelryDiamonds;
  final dynamic jewelryRingSize;
  final List<JewelleryDetailData> variants;
  final List<dynamic> wishlist;
  final dynamic chainMetalType;
  final dynamic chainMetalStamp;
  final dynamic chainlength;
  final dynamic chainweight;
  final String? havechain;

  JewelleryDetailData({
    required this.id,
    required this.title,
    required this.slug,
    required this.itemcode,
    required this.parentitemcode,
    required this.maindesignnumber,
    this.width,
    this.height,
    this.description,
    this.tags,
    this.metalweight,
    required this.offerPrice,
    required this.settingPrice,
    required this.discountPrice,
    this.discount,
    this.couponType,
    this.allTotalCarat,
    this.totalCarat,
    this.syncMetalPrice,
    this.syncDiaPrice,
    this.syncLabourChargePrice,
    this.syncOtherChargePrice,
    required this.isParent,
    this.itemType,
    this.ringSizeGuideline,
    required this.allRingSize,
    required this.allChainSizes,
    required this.allImages,
    required this.video,
    this.category,
    this.metalStamp,
    this.metalType,
    this.centerstone,
    required this.jewelryDiamonds,
    this.jewelryRingSize,
    required this.variants,
    required this.wishlist,
    this.chainMetalType,
    this.chainMetalStamp,
    this.chainlength,
    this.chainweight,
    this.havechain,
  });

  factory JewelleryDetailData.fromJson(Map<String, dynamic> json) =>
      JewelleryDetailData(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        slug: json["slug"] ?? "",
        itemcode: json["itemcode"] ?? "",
        parentitemcode: json["parentitemcode"] ?? "",
        maindesignnumber: json["maindesignnumber"] ?? "",
        width: json["width"]?.toString(),
        height: json["height"]?.toString(),
        description: json["description"]?.toString(),
        tags: json["tags"]?.toString(),
        metalweight: json["metalweight"],
        offerPrice: json["offer_price"] ?? 0,
        settingPrice: json["setting_price"] ?? 0,
        discountPrice: json["discount_price"] ?? 0,
        discount: json["discount"]?.toString(),
        couponType: json["coupon_type"]?.toString(),
        allTotalCarat: json["all_total_carat"],
        totalCarat: json["total_carat"],
        syncMetalPrice: json["sync_metal_price"]?.toString(),
        syncDiaPrice: json["sync_dia_price"]?.toString(),
        syncLabourChargePrice: json["sync_labour_charge_price"]?.toString(),
        syncOtherChargePrice: json["sync_other_charge_price"]?.toString(),
        isParent: json["is_parent"] ?? false,
        itemType: json["itemType"]?.toString(),
        ringSizeGuideline: json["RingSizeGuideline"]?.toString(),
        allRingSize: json["allRingSize"] != null
            ? List<dynamic>.from(json["allRingSize"].map((x) => x))
            : [],
        allChainSizes: json["AllChainSizes"] != null
            ? List<dynamic>.from(json["AllChainSizes"].map((x) => x))
            : [],
        allImages: json["allImages"] != null
            ? List<ProductImage>.from(
                json["allImages"].map((x) => ProductImage.fromJson(x)))
            : [],
        video: json["video"] != null
            ? List<ProductVideo>.from(
                json["video"].map((x) => ProductVideo.fromJson(x)))
            : [],
        category: json["category"] != null
            ? CategoryRef.fromJson(json["category"])
            : null,
        metalStamp: json["metal_stamp"] != null
            ? ParamRef.fromJson(json["metal_stamp"])
            : null,
        metalType: json["metal_type"] != null
            ? ParamRef.fromJson(json["metal_type"])
            : null,
        centerstone: json["centerstone"],
        jewelryDiamonds: json["jewelry_diamonds"] != null
            ? List<JewelryDiamond>.from(json["jewelry_diamonds"]
                .map((x) => JewelryDiamond.fromJson(x)))
            : [],
        jewelryRingSize: json["jewelry_ring_size"],
        variants: json["variants"] != null
            ? List<JewelleryDetailData>.from(json["variants"]
                .map((x) => JewelleryDetailData.fromJson(x)))
            : [],
        wishlist: json["wishlist"] != null
            ? List<dynamic>.from(json["wishlist"].map((x) => x))
            : [],
        chainMetalType: json["chain_metal_type"],
        chainMetalStamp: json["chain_metal_stamp"],
        chainlength: json["chainlength"],
        chainweight: json["chainweight"],
        havechain: json["havechain"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "itemcode": itemcode,
        "parentitemcode": parentitemcode,
        "maindesignnumber": maindesignnumber,
        "width": width,
        "height": height,
        "description": description,
        "tags": tags,
        "metalweight": metalweight,
        "offer_price": offerPrice,
        "setting_price": settingPrice,
        "discount_price": discountPrice,
        "discount": discount,
        "coupon_type": couponType,
        "all_total_carat": allTotalCarat,
        "total_carat": totalCarat,
        "sync_metal_price": syncMetalPrice,
        "sync_dia_price": syncDiaPrice,
        "sync_labour_charge_price": syncLabourChargePrice,
        "sync_other_charge_price": syncOtherChargePrice,
        "is_parent": isParent,
        "itemType": itemType,
        "RingSizeGuideline": ringSizeGuideline,
        "allRingSize": List<dynamic>.from(allRingSize.map((x) => x)),
        "AllChainSizes": List<dynamic>.from(allChainSizes.map((x) => x)),
        "allImages": List<dynamic>.from(allImages.map((x) => x.toJson())),
        "video": List<dynamic>.from(video.map((x) => x.toJson())),
        "category": category?.toJson(),
        "metal_stamp": metalStamp?.toJson(),
        "metal_type": metalType?.toJson(),
        "centerstone": centerstone,
        "jewelry_diamonds":
            List<dynamic>.from(jewelryDiamonds.map((x) => x.toJson())),
        "jewelry_ring_size": jewelryRingSize,
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "wishlist": List<dynamic>.from(wishlist.map((x) => x)),
        "chain_metal_type": chainMetalType,
        "chain_metal_stamp": chainMetalStamp,
        "chainlength": chainlength,
        "chainweight": chainweight,
        "havechain": havechain,
      };
}

class ProductImage {
  final int id;
  final String? thumb;
  final String? feature;

  ProductImage({
    required this.id,
    this.thumb,
    this.feature,
  });

  String get imageUrl =>
      (thumb != null && thumb!.isNotEmpty) ? thumb! : (feature ?? "");

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"] ?? 0,
        thumb: json["thumb"]?.toString(),
        feature: json["feature"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "thumb": thumb,
        "feature": feature,
      };
}

class ProductVideo {
  final int id;
  final String? type;
  final String? path;

  ProductVideo({
    required this.id,
    this.type,
    this.path,
  });

  factory ProductVideo.fromJson(Map<String, dynamic> json) => ProductVideo(
        id: json["id"] ?? 0,
        type: json["type"]?.toString(),
        path: json["path"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "path": path,
      };
}

class CategoryRef {
  final int id;
  final String name;
  final String slug;

  CategoryRef({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryRef.fromJson(Map<String, dynamic> json) => CategoryRef(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        slug: json["slug"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}

class ParamRef {
  final int id;
  final String paraname;
  final String slug;

  ParamRef({
    required this.id,
    required this.paraname,
    required this.slug,
  });

  factory ParamRef.fromJson(Map<String, dynamic> json) => ParamRef(
        id: json["id"] ?? 0,
        paraname: json["paraname"] ?? "",
        slug: json["slug"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paraname": paraname,
        "slug": slug,
      };
}

class JewelryDiamond {
  final int id;
  final int? jewelryId;
  final String? diamondtype;
  final String? stonetype;
  final int? colclagroup;
  final int? totaldiamonds;
  final dynamic totalweight;
  final String? stonecolor;
  final String? stoneclarity;
  final String? color;
  final String? clarity;
  final String? size;
  final int? isdeleted;
  final DiamondShape? shape;
  final StoneGroup? stoneGroup;

  JewelryDiamond({
    required this.id,
    this.jewelryId,
    this.diamondtype,
    this.stonetype,
    this.colclagroup,
    this.totaldiamonds,
    this.totalweight,
    this.stonecolor,
    this.stoneclarity,
    this.color,
    this.clarity,
    this.size,
    this.isdeleted,
    this.shape,
    this.stoneGroup,
  });

  factory JewelryDiamond.fromJson(Map<String, dynamic> json) => JewelryDiamond(
        id: json["id"] ?? 0,
        jewelryId: json["jewelry_id"],
        diamondtype: json["diamondtype"]?.toString(),
        stonetype: json["stonetype"]?.toString(),
        colclagroup: json["colclagroup"],
        totaldiamonds: json["totaldiamonds"],
        totalweight: json["totalweight"],
        stonecolor: json["stonecolor"]?.toString() ?? json["color"]?.toString(),
        stoneclarity:
            json["stoneclarity"]?.toString() ?? json["clarity"]?.toString(),
        color: json["color"]?.toString(),
        clarity: json["clarity"]?.toString(),
        size: json["size"]?.toString(),
        isdeleted: json["isdeleted"],
        shape:
            json["shape"] != null ? DiamondShape.fromJson(json["shape"]) : null,
        stoneGroup: json["stone_group"] != null
            ? StoneGroup.fromJson(json["stone_group"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jewelry_id": jewelryId,
        "diamondtype": diamondtype,
        "stonetype": stonetype,
        "colclagroup": colclagroup,
        "totaldiamonds": totaldiamonds,
        "totalweight": totalweight,
        "stonecolor": stonecolor,
        "stoneclarity": stoneclarity,
        "color": color,
        "clarity": clarity,
        "size": size,
        "isdeleted": isdeleted,
        "shape": shape?.toJson(),
        "stone_group": stoneGroup?.toJson(),
      };
}

class DiamondShape {
  final int id;
  final String paraname;
  final String slug;
  final String image;

  DiamondShape({
    required this.id,
    required this.paraname,
    required this.slug,
    required this.image,
  });

  factory DiamondShape.fromJson(Map<String, dynamic> json) => DiamondShape(
        id: json["id"] ?? 0,
        paraname: json["paraname"] ?? "",
        slug: json["slug"] ?? "",
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paraname": paraname,
        "slug": slug,
        "image": image,
      };
}

class StoneGroup {
  final int id;
  final String? color;
  final String? clarity;
  final dynamic minSize;
  final dynamic maxSize;
  final num? amount;

  StoneGroup({
    required this.id,
    this.color,
    this.clarity,
    this.minSize,
    this.maxSize,
    this.amount,
  });

  factory StoneGroup.fromJson(Map<String, dynamic> json) => StoneGroup(
        id: json["id"] ?? 0,
        color: json["color"]?.toString(),
        clarity: json["clarity"]?.toString(),
        minSize: json["min_size"],
        maxSize: json["max_size"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
        "clarity": clarity,
        "min_size": minSize,
        "max_size": maxSize,
        "amount": amount,
      };
}
