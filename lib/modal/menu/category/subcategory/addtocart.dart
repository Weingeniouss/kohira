// ignore_for_file: non_constant_identifier_names

class JewelryItem {
  final int? diamondId;
  final dynamic jewelryId;
  final dynamic ringSize;
  final int? qty;

  JewelryItem({
    this.diamondId,
    this.jewelryId,
    this.ringSize,
    this.qty,
  });

  @override
  String toString() {
    return 'JewelryItem{diamondId: $diamondId, jewelryId: $jewelryId, ringSize: $ringSize, qty: $qty}';
  }

  Map<String, dynamic> toJson() {
    return {
      if (diamondId != null) 'diamondid': diamondId,
      'jewelryid': jewelryId != null ? int.tryParse(jewelryId.toString()) ?? jewelryId : null,
      if (ringSize != null && ringSize.toString().isNotEmpty && ringSize.toString() != 'null')
        'ringsize': int.tryParse(ringSize.toString()) ?? ringSize,
      'qty': qty ?? 1,
    };
  }

  factory JewelryItem.fromJson(Map<String, dynamic> json) {
    return JewelryItem(
      diamondId: json['diamondid'],
      jewelryId: json['jewelryid'],
      ringSize: json['ringsize'] ?? json['ringSize'],
      qty: json['qty'] ?? 1,
    );
  }
}

/// Response model for POST {{BASEURL}}/cart/withoutlogin
class CartWithoutLoginResponse {
  final bool? success;
  final CartWithoutLoginData? data;

  CartWithoutLoginResponse({this.success, this.data});

  factory CartWithoutLoginResponse.fromJson(Map<String, dynamic> json) {
    return CartWithoutLoginResponse(
      success: json['success'],
      data: json['data'] != null ? CartWithoutLoginData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class CartWithoutLoginData {
  final num? myWalletAmount;
  final num? cartGross;
  final num? cartTotal;
  final int? count;
  final num? discount;
  final int? discountType;
  final String? message;
  final num? netAmount;
  final bool? success;
  final List<CartWithoutLoginItem>? carts;
  final num? oldGrossTotal;
  final num? discountPrice;
  final num? gstTotal;
  final int? allowPartial;
  final num? allowPartialPer;
  final num? partialPaymentAmount;
  final String? couponAvailable;
  final String? couponMessage;
  final String? couponid;
  final String? discountrate;
  final String? couponCode;
  final String? coupontype;
  final bool? iswalletallow;
  final GlobalTaxData? globalTax;
  final dynamic goldCoin;

  CartWithoutLoginData({
    this.myWalletAmount,
    this.cartGross,
    this.cartTotal,
    this.count,
    this.discount,
    this.discountType,
    this.message,
    this.netAmount,
    this.success,
    this.carts,
    this.oldGrossTotal,
    this.discountPrice,
    this.gstTotal,
    this.allowPartial,
    this.allowPartialPer,
    this.partialPaymentAmount,
    this.couponAvailable,
    this.couponMessage,
    this.couponid,
    this.discountrate,
    this.couponCode,
    this.coupontype,
    this.iswalletallow,
    this.globalTax,
    this.goldCoin,
  });

  factory CartWithoutLoginData.fromJson(Map<String, dynamic> json) {
    return CartWithoutLoginData(
      myWalletAmount: json['myWalletAmount'],
      cartGross: json['cart_gross'],
      cartTotal: json['cart_total'],
      count: json['count'],
      discount: json['discount'],
      discountType: json['discountType'],
      message: json['message'],
      netAmount: json['net_amount'],
      success: json['success'],
      carts: json['carts'] != null
          ? List<CartWithoutLoginItem>.from(
              json['carts'].map((x) => CartWithoutLoginItem.fromJson(x)))
          : null,
      oldGrossTotal: json['old_gross_total'],
      discountPrice: json['discount_price'],
      gstTotal: json['gstTotal'],
      allowPartial: json['allow_partial'],
      allowPartialPer: json['allow_partial_per'],
      partialPaymentAmount: json['partial_payment_amount'],
      couponAvailable: json['couponAvailable']?.toString(),
      couponMessage: json['couponMessage']?.toString(),
      couponid: json['couponid']?.toString(),
      discountrate: json['discountrate']?.toString(),
      couponCode: json['coupon_code']?.toString(),
      coupontype: json['coupontype']?.toString(),
      iswalletallow: json['iswalletallow'],
      globalTax: json['global_tax'] != null
          ? GlobalTaxData.fromJson(json['global_tax'])
          : null,
      goldCoin: json['goldCoin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myWalletAmount': myWalletAmount,
      'cart_gross': cartGross,
      'cart_total': cartTotal,
      'count': count,
      'discount': discount,
      'discountType': discountType,
      'message': message,
      'net_amount': netAmount,
      'success': success,
      'carts': carts?.map((x) => x.toJson()).toList(),
      'old_gross_total': oldGrossTotal,
      'discount_price': discountPrice,
      'gstTotal': gstTotal,
      'allow_partial': allowPartial,
      'allow_partial_per': allowPartialPer,
      'partial_payment_amount': partialPaymentAmount,
      'couponAvailable': couponAvailable,
      'couponMessage': couponMessage,
      'couponid': couponid,
      'discountrate': discountrate,
      'coupon_code': couponCode,
      'coupontype': coupontype,
      'iswalletallow': iswalletallow,
      'global_tax': globalTax?.toJson(),
      'goldCoin': goldCoin,
    };
  }
}

class CartWithoutLoginItem {
  final int? groupid;
  final int? id;
  final int? qty;
  final dynamic cartDiamondData;
  final dynamic diamondid;
  final CartJewelryData? cartJewelryData;
  final int? jewelryid;
  final RingSizeData? ringsize;
  final int? ringSizeQty;
  final dynamic diaType;
  final dynamic prongType;

  CartWithoutLoginItem({
    this.groupid,
    this.id,
    this.qty,
    this.cartDiamondData,
    this.diamondid,
    this.cartJewelryData,
    this.jewelryid,
    this.ringsize,
    this.ringSizeQty,
    this.diaType,
    this.prongType,
  });

  factory CartWithoutLoginItem.fromJson(Map<String, dynamic> json) {
    return CartWithoutLoginItem(
      groupid: json['groupid'],
      id: json['id'],
      qty: json['qty'],
      cartDiamondData: json['CartDiamondData'],
      diamondid: json['diamondid'],
      cartJewelryData: json['CartJewelryData'] != null
          ? CartJewelryData.fromJson(json['CartJewelryData'])
          : null,
      jewelryid: json['jewelryid'],
      ringsize: json['ringsize'] != null && json['ringsize'] is Map<String, dynamic>
          ? RingSizeData.fromJson(json['ringsize'])
          : null,
      ringSizeQty: json['ringSizeQty'],
      diaType: json['dia_type'],
      prongType: json['prongType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupid': groupid,
      'id': id,
      'qty': qty,
      'CartDiamondData': cartDiamondData,
      'diamondid': diamondid,
      'CartJewelryData': cartJewelryData?.toJson(),
      'jewelryid': jewelryid,
      'ringsize': ringsize?.toJson(),
      'ringSizeQty': ringSizeQty,
      'dia_type': diaType,
      'prongType': prongType,
    };
  }
}

class CartJewelryData {
  final int? id;
  final int? producttype;
  final String? itemcode;
  final String? parentitemcode;
  final String? designcode;
  final String? maindesignnumber;
  final String? width;
  final String? height;
  final String? jewelryLength;
  final int? qty;
  final num? price;
  final num? offerprice;
  final int? offerId;
  final String? offerPercentage;
  final num? offerPercentageOther;
  final CategoryData? category;
  final dynamic subcategory;
  final String? shipmentdays;
  final String? gender;
  final String? slug;
  final String? title;
  final String? sdescription;
  final String? description;
  final int? parentMetal;
  final int? metaltype;
  final String? metalTypeName;
  final int? metalstamp;
  final String? metalStampName;
  final num? metalweight;
  final String? ringsize;
  final num? settingPrice;
  final String? syncMetalPrice;
  final String? syncDiaPrice;
  final String? syncLabourChargePrice;
  final String? syncOtherChargePrice;
  final num? totalCarat;
  final String? totalCenterWeight;
  final String? couponType;
  final String? discount;
  final num? offerPrice;
  final num? finalSettingPrice;
  final num? finalOfferPrice;
  final DefaultImageData? defaultImage;
  final List<DefaultImageData>? allImages;
  final List<VideoData>? video;
  final List<JewelryImageDetail>? images;
  final MetalTypeData? metalType;
  final MetalStampData? metalStamp;
  final List<JewelryDiamondData>? jewelryDiamonds;
  final RingSizeData? jewelryRingSize;
  final JewelryDiamondData? centerStone;
  final List<VideoData>? videoUrl;

  CartJewelryData({
    this.id,
    this.producttype,
    this.itemcode,
    this.parentitemcode,
    this.designcode,
    this.maindesignnumber,
    this.width,
    this.height,
    this.jewelryLength,
    this.qty,
    this.price,
    this.offerprice,
    this.offerId,
    this.offerPercentage,
    this.offerPercentageOther,
    this.category,
    this.subcategory,
    this.shipmentdays,
    this.gender,
    this.slug,
    this.title,
    this.sdescription,
    this.description,
    this.parentMetal,
    this.metaltype,
    this.metalTypeName,
    this.metalstamp,
    this.metalStampName,
    this.metalweight,
    this.ringsize,
    this.settingPrice,
    this.syncMetalPrice,
    this.syncDiaPrice,
    this.syncLabourChargePrice,
    this.syncOtherChargePrice,
    this.totalCarat,
    this.totalCenterWeight,
    this.couponType,
    this.discount,
    this.offerPrice,
    this.finalSettingPrice,
    this.finalOfferPrice,
    this.defaultImage,
    this.allImages,
    this.video,
    this.images,
    this.metalType,
    this.metalStamp,
    this.jewelryDiamonds,
    this.jewelryRingSize,
    this.centerStone,
    this.videoUrl,
  });

  factory CartJewelryData.fromJson(Map<String, dynamic> json) {
    return CartJewelryData(
      id: json['id'],
      producttype: json['producttype'],
      itemcode: json['itemcode'],
      parentitemcode: json['parentitemcode'],
      designcode: json['designcode'],
      maindesignnumber: json['maindesignnumber'],
      width: json['width']?.toString(),
      height: json['height']?.toString(),
      jewelryLength: json['jewelry_length']?.toString(),
      qty: json['qty'],
      price: json['price'],
      offerprice: json['offerprice'],
      offerId: json['offer_id'],
      offerPercentage: json['offer_percentage']?.toString(),
      offerPercentageOther: json['offer_percentage_other'],
      category: json['category'] != null ? CategoryData.fromJson(json['category']) : null,
      subcategory: json['subcategory'],
      shipmentdays: json['shipmentdays']?.toString(),
      gender: json['gender']?.toString(),
      slug: json['slug']?.toString(),
      title: json['title']?.toString(),
      sdescription: json['sdescription']?.toString(),
      description: json['description']?.toString(),
      parentMetal: json['parent_metal'],
      metaltype: json['metaltype'],
      metalTypeName: json['metal_type_name']?.toString(),
      metalstamp: json['metalstamp'],
      metalStampName: json['metal_stamp_name']?.toString(),
      metalweight: json['metalweight'],
      ringsize: json['ringsize']?.toString(),
      settingPrice: json['setting_price'],
      syncMetalPrice: json['sync_metal_price']?.toString(),
      syncDiaPrice: json['sync_dia_price']?.toString(),
      syncLabourChargePrice: json['sync_labour_charge_price']?.toString(),
      syncOtherChargePrice: json['sync_other_charge_price']?.toString(),
      totalCarat: json['total_carat'],
      totalCenterWeight: json['total_center_weight']?.toString(),
      couponType: json['coupon_type']?.toString(),
      discount: json['discount']?.toString(),
      offerPrice: json['offer_price'],
      finalSettingPrice: json['final_setting_price'],
      finalOfferPrice: json['final_offer_price'],
      defaultImage: json['default'] != null ? DefaultImageData.fromJson(json['default']) : null,
      allImages: json['allImages'] != null
          ? List<DefaultImageData>.from(
              json['allImages'].map((x) => DefaultImageData.fromJson(x)))
          : null,
      video: json['video'] != null
          ? List<VideoData>.from(json['video'].map((x) => VideoData.fromJson(x)))
          : null,
      images: json['images'] != null
          ? List<JewelryImageDetail>.from(
              json['images'].map((x) => JewelryImageDetail.fromJson(x)))
          : null,
      metalType: json['metal_type'] != null && json['metal_type'] is Map<String, dynamic>
          ? MetalTypeData.fromJson(json['metal_type'])
          : null,
      metalStamp: json['metal_stamp'] != null && json['metal_stamp'] is Map<String, dynamic>
          ? MetalStampData.fromJson(json['metal_stamp'])
          : null,
      jewelryDiamonds: json['jewelry_diamonds'] != null
          ? List<JewelryDiamondData>.from(
              json['jewelry_diamonds'].map((x) => JewelryDiamondData.fromJson(x)))
          : null,
      jewelryRingSize: json['jewelry_ring_size'] != null && json['jewelry_ring_size'] is Map<String, dynamic>
          ? RingSizeData.fromJson(json['jewelry_ring_size'])
          : null,
      centerStone: json['center_stone'] != null && json['center_stone'] is Map<String, dynamic>
          ? JewelryDiamondData.fromJson(json['center_stone'])
          : null,
      videoUrl: json['video_url'] != null
          ? List<VideoData>.from(json['video_url'].map((x) => VideoData.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producttype': producttype,
      'itemcode': itemcode,
      'parentitemcode': parentitemcode,
      'designcode': designcode,
      'maindesignnumber': maindesignnumber,
      'width': width,
      'height': height,
      'jewelry_length': jewelryLength,
      'qty': qty,
      'price': price,
      'offerprice': offerprice,
      'offer_id': offerId,
      'offer_percentage': offerPercentage,
      'offer_percentage_other': offerPercentageOther,
      'category': category?.toJson(),
      'subcategory': subcategory,
      'shipmentdays': shipmentdays,
      'gender': gender,
      'slug': slug,
      'title': title,
      'sdescription': sdescription,
      'description': description,
      'parent_metal': parentMetal,
      'metaltype': metaltype,
      'metal_type_name': metalTypeName,
      'metalstamp': metalstamp,
      'metal_stamp_name': metalStampName,
      'metalweight': metalweight,
      'ringsize': ringsize,
      'setting_price': settingPrice,
      'sync_metal_price': syncMetalPrice,
      'sync_dia_price': syncDiaPrice,
      'sync_labour_charge_price': syncLabourChargePrice,
      'sync_other_charge_price': syncOtherChargePrice,
      'total_carat': totalCarat,
      'total_center_weight': totalCenterWeight,
      'coupon_type': couponType,
      'discount': discount,
      'offer_price': offerPrice,
      'final_setting_price': finalSettingPrice,
      'final_offer_price': finalOfferPrice,
      'default': defaultImage?.toJson(),
      'allImages': allImages?.map((x) => x.toJson()).toList(),
      'video': video?.map((x) => x.toJson()).toList(),
      'images': images?.map((x) => x.toJson()).toList(),
      'metal_type': metalType?.toJson(),
      'metal_stamp': metalStamp?.toJson(),
      'jewelry_diamonds': jewelryDiamonds?.map((x) => x.toJson()).toList(),
      'jewelry_ring_size': jewelryRingSize?.toJson(),
      'center_stone': centerStone?.toJson(),
      'video_url': videoUrl?.map((x) => x.toJson()).toList(),
    };
  }
}

class CategoryData {
  final int? id;
  final int? parentid;
  final String? name;
  final String? slug;
  final String? image;
  final String? firstImage;
  final String? secondImage;
  final String? thirdImage;
  final String? customOrderImage;
  final String? status;

  CategoryData({
    this.id,
    this.parentid,
    this.name,
    this.slug,
    this.image,
    this.firstImage,
    this.secondImage,
    this.thirdImage,
    this.customOrderImage,
    this.status,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'],
      parentid: json['parentid'],
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      image: json['image']?.toString(),
      firstImage: json['first_image']?.toString(),
      secondImage: json['second_image']?.toString(),
      thirdImage: json['third_image']?.toString(),
      customOrderImage: json['custom_order_image']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentid': parentid,
      'name': name,
      'slug': slug,
      'image': image,
      'first_image': firstImage,
      'second_image': secondImage,
      'third_image': thirdImage,
      'custom_order_image': customOrderImage,
      'status': status,
    };
  }
}

class DefaultImageData {
  final int? id;
  final String? type;
  final String? path;
  final String? thumb;
  final String? feature;
  final String? zoom;

  DefaultImageData({
    this.id,
    this.type,
    this.path,
    this.thumb,
    this.feature,
    this.zoom,
  });

  factory DefaultImageData.fromJson(Map<String, dynamic> json) {
    return DefaultImageData(
      id: json['id'],
      type: json['type']?.toString(),
      path: json['path']?.toString(),
      thumb: json['thumb']?.toString(),
      feature: json['feature']?.toString(),
      zoom: json['zoom']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'path': path,
      'thumb': thumb,
      'feature': feature,
      'zoom': zoom,
    };
  }
}

class VideoData {
  final int? id;
  final String? type;
  final String? path;

  VideoData({this.id, this.type, this.path});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      id: json['id'],
      type: json['type']?.toString(),
      path: json['path']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'path': path,
    };
  }
}

class JewelryImageDetail {
  final int? id;
  final int? jewelryId;
  final String? path;
  final String? type;
  final int? isdefault;
  final String? status;

  JewelryImageDetail({
    this.id,
    this.jewelryId,
    this.path,
    this.type,
    this.isdefault,
    this.status,
  });

  factory JewelryImageDetail.fromJson(Map<String, dynamic> json) {
    return JewelryImageDetail(
      id: json['id'],
      jewelryId: json['jewelry_id'],
      path: json['path']?.toString(),
      type: json['type']?.toString(),
      isdefault: json['isdefault'],
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jewelry_id': jewelryId,
      'path': path,
      'type': type,
      'isdefault': isdefault,
      'status': status,
    };
  }
}

class MetalTypeData {
  final int? id;
  final String? paraname;
  final String? slug;

  MetalTypeData({this.id, this.paraname, this.slug});

  factory MetalTypeData.fromJson(Map<String, dynamic> json) {
    return MetalTypeData(
      id: json['id'],
      paraname: json['paraname']?.toString(),
      slug: json['slug']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paraname': paraname,
      'slug': slug,
    };
  }
}

class MetalStampData {
  final int? id;
  final String? paraname;
  final String? slug;

  MetalStampData({this.id, this.paraname, this.slug});

  factory MetalStampData.fromJson(Map<String, dynamic> json) {
    return MetalStampData(
      id: json['id'],
      paraname: json['paraname']?.toString(),
      slug: json['slug']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paraname': paraname,
      'slug': slug,
    };
  }
}

class JewelryDiamondData {
  final int? id;
  final int? jewelryId;
  final String? diamondtype;
  final String? stonetype;
  final int? totaldiamonds;
  final num? totalweight;
  final DiamondShapeData? shape;
  final String? color;
  final String? clarity;
  final num? price;
  final String? size;

  JewelryDiamondData({
    this.id,
    this.jewelryId,
    this.diamondtype,
    this.stonetype,
    this.totaldiamonds,
    this.totalweight,
    this.shape,
    this.color,
    this.clarity,
    this.price,
    this.size,
  });

  factory JewelryDiamondData.fromJson(Map<String, dynamic> json) {
    return JewelryDiamondData(
      id: json['id'],
      jewelryId: json['jewelry_id'],
      diamondtype: json['diamondtype']?.toString(),
      stonetype: json['stonetype']?.toString(),
      totaldiamonds: json['totaldiamonds'],
      totalweight: json['totalweight'],
      shape: json['shape'] != null && json['shape'] is Map<String, dynamic>
          ? DiamondShapeData.fromJson(json['shape'])
          : null,
      color: json['color']?.toString(),
      clarity: json['clarity']?.toString(),
      price: json['price'],
      size: json['size']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jewelry_id': jewelryId,
      'diamondtype': diamondtype,
      'stonetype': stonetype,
      'totaldiamonds': totaldiamonds,
      'totalweight': totalweight,
      'shape': shape?.toJson(),
      'color': color,
      'clarity': clarity,
      'price': price,
      'size': size,
    };
  }
}

class DiamondShapeData {
  final int? id;
  final String? paraname;
  final String? slug;
  final String? image;

  DiamondShapeData({this.id, this.paraname, this.slug, this.image});

  factory DiamondShapeData.fromJson(Map<String, dynamic> json) {
    return DiamondShapeData(
      id: json['id'],
      paraname: json['paraname']?.toString(),
      slug: json['slug']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paraname': paraname,
      'slug': slug,
      'image': image,
    };
  }
}

class RingSizeData {
  final int? id;
  final String? paraname;
  final String? slug;

  RingSizeData({this.id, this.paraname, this.slug});

  factory RingSizeData.fromJson(Map<String, dynamic> json) {
    return RingSizeData(
      id: json['id'],
      paraname: json['paraname']?.toString(),
      slug: json['slug']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paraname': paraname,
      'slug': slug,
    };
  }
}

class GlobalTaxData {
  final num? globaltaxper;
  final num? globaltaxcharge;

  GlobalTaxData({this.globaltaxper, this.globaltaxcharge});

  factory GlobalTaxData.fromJson(Map<String, dynamic> json) {
    return GlobalTaxData(
      globaltaxper: json['globaltaxper'],
      globaltaxcharge: json['globaltaxcharge'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globaltaxper': globaltaxper,
      'globaltaxcharge': globaltaxcharge,
    };
  }
}
