import 'dart:convert';

OfferBannerModel offerBannerModelFromJson(String str) => OfferBannerModel.fromJson(json.decode(str));
String offerBannerModelToJson(OfferBannerModel data) => json.encode(data.toJson());

class OfferBannerModel {
  OfferBannerModel({
    OfferBannerData? data,
    num? count,
    bool? success,
    String? message,
  }) {
    _data = data;
    _count = count;
    _success = success;
    _message = message;
  }

  OfferBannerModel.fromJson(dynamic json) {
    _data = json['data'] != null ? OfferBannerData.fromJson(json['data']) : null;
    _count = json['count'];
    _success = json['success'];
    _message = json['message'];
  }

  OfferBannerData? _data;
  num? _count;
  bool? _success;
  String? _message;

  OfferBannerData? get data => _data;
  num? get count => _count;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['count'] = _count;
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }
}

class OfferBannerData {
  OfferBannerData({
    List<OfferBannerItem>? offerbanner,
    List<TopBarSliderItem>? topbarslider,
  }) {
    _offerbanner = offerbanner;
    _topbarslider = topbarslider;
  }

  OfferBannerData.fromJson(dynamic json) {
    if (json['offerbanner'] != null) {
      _offerbanner = [];
      json['offerbanner'].forEach((v) {
        _offerbanner?.add(OfferBannerItem.fromJson(v));
      });
    }
    if (json['topbarslider'] != null) {
      _topbarslider = [];
      json['topbarslider'].forEach((v) {
        _topbarslider?.add(TopBarSliderItem.fromJson(v));
      });
    }
  }

  List<OfferBannerItem>? _offerbanner;
  List<TopBarSliderItem>? _topbarslider;

  List<OfferBannerItem>? get offerbanner => _offerbanner;
  List<TopBarSliderItem>? get topbarslider => _topbarslider;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_offerbanner != null) {
      map['offerbanner'] = _offerbanner?.map((v) => v.toJson()).toList();
    }
    if (_topbarslider != null) {
      map['topbarslider'] = _topbarslider?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OfferBannerItem {
  OfferBannerItem({
    num? id,
    String? position,
    String? titleEn,
    dynamic titleJp,
    dynamic subtitle,
    dynamic descriptionEn,
    String? descriptionJp,
    dynamic smalltextEn,
    dynamic smalltextJp,
    dynamic descriptiontitleEn,
    dynamic descriptiontitleJp,
    String? image,
    String? mobileImg,
    String? buttontextEn,
    dynamic buttontextJp,
    String? buttonlink,
    dynamic textposition,
    dynamic buttonposition,
    dynamic textType,
    String? status,
    dynamic sort,
    dynamic type,
  }) {
    _id = id;
    _position = position;
    _titleEn = titleEn;
    _titleJp = titleJp;
    _subtitle = subtitle;
    _descriptionEn = descriptionEn;
    _descriptionJp = descriptionJp;
    _smalltextEn = smalltextEn;
    _smalltextJp = smalltextJp;
    _descriptiontitleEn = descriptiontitleEn;
    _descriptiontitleJp = descriptiontitleJp;
    _image = image;
    _mobileImg = mobileImg;
    _buttontextEn = buttontextEn;
    _buttontextJp = buttontextJp;
    _buttonlink = buttonlink;
    _textposition = textposition;
    _buttonposition = buttonposition;
    _textType = textType;
    _status = status;
    _sort = sort;
    _type = type;
  }

  OfferBannerItem.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _titleEn = json['title_en'];
    _titleJp = json['title_jp'];
    _subtitle = json['subtitle'];
    _descriptionEn = json['description_en'];
    _descriptionJp = json['description_jp'];
    _smalltextEn = json['smalltext_en'];
    _smalltextJp = json['smalltext_jp'];
    _descriptiontitleEn = json['descriptiontitle_en'];
    _descriptiontitleJp = json['descriptiontitle_jp'];
    _image = json['image'];
    _mobileImg = json['mobile_img'];
    _buttontextEn = json['buttontext_en'];
    _buttontextJp = json['buttontext_jp'];
    _buttonlink = json['buttonlink'];
    _textposition = json['textposition'];
    _buttonposition = json['buttonposition'];
    _textType = json['text_type'];
    _status = json['status'];
    _sort = json['sort'];
    _type = json['type'];
  }

  num? _id;
  String? _position;
  String? _titleEn;
  dynamic _titleJp;
  dynamic _subtitle;
  dynamic _descriptionEn;
  String? _descriptionJp;
  dynamic _smalltextEn;
  dynamic _smalltextJp;
  dynamic _descriptiontitleEn;
  dynamic _descriptiontitleJp;
  String? _image;
  String? _mobileImg;
  String? _buttontextEn;
  dynamic _buttontextJp;
  String? _buttonlink;
  dynamic _textposition;
  dynamic _buttonposition;
  dynamic _textType;
  String? _status;
  dynamic _sort;
  dynamic _type;

  num? get id => _id;
  String? get position => _position;
  String? get titleEn => _titleEn;
  dynamic get titleJp => _titleJp;
  dynamic get subtitle => _subtitle;
  dynamic get descriptionEn => _descriptionEn;
  String? get descriptionJp => _descriptionJp;
  dynamic get smalltextEn => _smalltextEn;
  dynamic get smalltextJp => _smalltextJp;
  dynamic get descriptiontitleEn => _descriptiontitleEn;
  dynamic get descriptiontitleJp => _descriptiontitleJp;
  String? get image => _image;
  String? get mobileImg => _mobileImg;
  String? get buttontextEn => _buttontextEn;
  dynamic get buttontextJp => _buttontextJp;
  String? get buttonlink => _buttonlink;
  dynamic get textposition => _textposition;
  dynamic get buttonposition => _buttonposition;
  dynamic get textType => _textType;
  String? get status => _status;
  dynamic get sort => _sort;
  dynamic get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['title_en'] = _titleEn;
    map['title_jp'] = _titleJp;
    map['subtitle'] = _subtitle;
    map['description_en'] = _descriptionEn;
    map['description_jp'] = _descriptionJp;
    map['smalltext_en'] = _smalltextEn;
    map['smalltext_jp'] = _smalltextJp;
    map['descriptiontitle_en'] = _descriptiontitleEn;
    map['descriptiontitle_jp'] = _descriptiontitleJp;
    map['image'] = _image;
    map['mobile_img'] = _mobileImg;
    map['buttontext_en'] = _buttontextEn;
    map['buttontext_jp'] = _buttontextJp;
    map['buttonlink'] = _buttonlink;
    map['textposition'] = _textposition;
    map['buttonposition'] = _buttonposition;
    map['text_type'] = _textType;
    map['status'] = _status;
    map['sort'] = _sort;
    map['type'] = _type;
    return map;
  }
}

class TopBarSliderItem {
  TopBarSliderItem({
    num? id,
    String? position,
    dynamic titleEn,
    String? descriptionEn,
    dynamic buttontextEn,
    String? buttonlink,
    num? sort,
    dynamic type,
  }) {
    _id = id;
    _position = position;
    _titleEn = titleEn;
    _descriptionEn = descriptionEn;
    _buttontextEn = buttontextEn;
    _buttonlink = buttonlink;
    _sort = sort;
    _type = type;
  }

  TopBarSliderItem.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _titleEn = json['title_en'];
    _descriptionEn = json['description_en'];
    _buttontextEn = json['buttontext_en'];
    _buttonlink = json['buttonlink'];
    _sort = json['sort'];
    _type = json['type'];
  }

  num? _id;
  String? _position;
  dynamic _titleEn;
  String? _descriptionEn;
  dynamic _buttontextEn;
  String? _buttonlink;
  num? _sort;
  dynamic _type;

  num? get id => _id;
  String? get position => _position;
  dynamic get titleEn => _titleEn;
  String? get descriptionEn => _descriptionEn;
  dynamic get buttontextEn => _buttontextEn;
  String? get buttonlink => _buttonlink;
  num? get sort => _sort;
  dynamic get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['title_en'] = _titleEn;
    map['description_en'] = _descriptionEn;
    map['buttontext_en'] = _buttontextEn;
    map['buttonlink'] = _buttonlink;
    map['sort'] = _sort;
    map['type'] = _type;
    return map;
  }
}
