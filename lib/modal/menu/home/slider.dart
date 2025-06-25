import 'dart:convert';
/// mainSliderDetail : [{"id":68,"position":"mainhomepage","title_en":"India's Solitaire Signature","title_jp":null,"subtitle":null,"image_type":"video","description_en":null,"description_jp":null,"smalltext_en":null,"smalltext_jp":null,"descriptiontitle_en":null,"descriptiontitle_jp":null,"image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/mNfSqg09Kx9RcUHn75rf4RS4yiyXACEaZmzVS52Z.mp4","mobile_img":"","buttontext_en":"Shop Kohira","buttontext_jp":null,"buttonlink":"https://www.kohira.com/claw-kiss-engagement-rings-collection","textposition":"center-left","buttonposition":null,"text_type":"black","sort":1,"type":"collection","redirectSlug":"claw-kiss-engagement-rings-collection"},{"id":64,"position":"mainhomepage","title_en":"Light of the Modern Maharani","title_jp":null,"subtitle":null,"image_type":"image","description_en":"Grace of tradition, glow of today, crafted for India's queen within.","description_jp":null,"smalltext_en":null,"smalltext_jp":null,"descriptiontitle_en":null,"descriptiontitle_jp":null,"image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/NJbJOTsYE5ub62n8SJR0uPuVM0a73f3ntA6S5YNv.jpg","mobile_img":"https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/o8m8ue9KJzdzigFkleaGF0Big7kAd87WAAX5FcRk.jpg","buttontext_en":"Embrace Your Royal Glow","buttontext_jp":null,"buttonlink":"https://www.kohira.com/velvet-arc-chevrons-collection","textposition":"center-right","buttonposition":null,"text_type":"black","sort":2,"type":"collection","redirectSlug":"velvet-arc-chevrons-collection"},{"id":53,"position":"mainhomepage","title_en":"Find Your Kohinoor","title_jp":null,"subtitle":null,"image_type":"image","description_en":"From the soul of tradition to the pulse of today , Our jewels celebrate the You the world can’t ignore.","description_jp":null,"smalltext_en":null,"smalltext_jp":null,"descriptiontitle_en":null,"descriptiontitle_jp":null,"image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/91BJFCATYvVd64Jk8ZBtHlJRyXkCMY8oRmlOVVQH.jpg","mobile_img":"https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/vNptkB4wyu3IQjkdMeUzRvJsekk1d8DTbkeqHCBQ.jpg","buttontext_en":"Crown Me Now","buttontext_jp":null,"buttonlink":"https://www.kohira.com/velvet-arc-chevrons-collection","textposition":"center-left","buttonposition":null,"text_type":"white","sort":5,"type":"collection","redirectSlug":"velvet-arc-chevrons-collection"}]
/// count : 3
/// success : true
/// message : "Home Page Slider fetch Successfully."

Slider sliderFromJson(String str) => Slider.fromJson(json.decode(str));
String sliderToJson(Slider data) => json.encode(data.toJson());
class Slider {
  Slider({
      List<MainSliderDetail>? mainSliderDetail, 
      num? count, 
      bool? success, 
      String? message,}){
    _mainSliderDetail = mainSliderDetail;
    _count = count;
    _success = success;
    _message = message;
}

  Slider.fromJson(dynamic json) {
    if (json['mainSliderDetail'] != null) {
      _mainSliderDetail = [];
      json['mainSliderDetail'].forEach((v) {
        _mainSliderDetail?.add(MainSliderDetail.fromJson(v));
      });
    }
    _count = json['count'];
    _success = json['success'];
    _message = json['message'];
  }
  List<MainSliderDetail>? _mainSliderDetail;
  num? _count;
  bool? _success;
  String? _message;
Slider copyWith({  List<MainSliderDetail>? mainSliderDetail,
  num? count,
  bool? success,
  String? message,
}) => Slider(  mainSliderDetail: mainSliderDetail ?? _mainSliderDetail,
  count: count ?? _count,
  success: success ?? _success,
  message: message ?? _message,
);
  List<MainSliderDetail>? get mainSliderDetail => _mainSliderDetail;
  num? get count => _count;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_mainSliderDetail != null) {
      map['mainSliderDetail'] = _mainSliderDetail?.map((v) => v.toJson()).toList();
    }
    map['count'] = _count;
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// id : 68
/// position : "mainhomepage"
/// title_en : "India's Solitaire Signature"
/// title_jp : null
/// subtitle : null
/// image_type : "video"
/// description_en : null
/// description_jp : null
/// smalltext_en : null
/// smalltext_jp : null
/// descriptiontitle_en : null
/// descriptiontitle_jp : null
/// image : "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/mNfSqg09Kx9RcUHn75rf4RS4yiyXACEaZmzVS52Z.mp4"
/// mobile_img : ""
/// buttontext_en : "Shop Kohira"
/// buttontext_jp : null
/// buttonlink : "https://www.kohira.com/claw-kiss-engagement-rings-collection"
/// textposition : "center-left"
/// buttonposition : null
/// text_type : "black"
/// sort : 1
/// type : "collection"
/// redirectSlug : "claw-kiss-engagement-rings-collection"

MainSliderDetail mainSliderDetailFromJson(String str) => MainSliderDetail.fromJson(json.decode(str));
String mainSliderDetailToJson(MainSliderDetail data) => json.encode(data.toJson());
class MainSliderDetail {
  MainSliderDetail({
      num? id, 
      String? position, 
      String? titleEn, 
      dynamic titleJp, 
      dynamic subtitle, 
      String? imageType, 
      dynamic descriptionEn, 
      dynamic descriptionJp, 
      dynamic smalltextEn, 
      dynamic smalltextJp, 
      dynamic descriptiontitleEn, 
      dynamic descriptiontitleJp, 
      String? image, 
      String? mobileImg, 
      String? buttontextEn, 
      dynamic buttontextJp, 
      String? buttonlink, 
      String? textposition, 
      dynamic buttonposition, 
      String? textType, 
      num? sort, 
      String? type, 
      String? redirectSlug,}){
    _id = id;
    _position = position;
    _titleEn = titleEn;
    _titleJp = titleJp;
    _subtitle = subtitle;
    _imageType = imageType;
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
    _sort = sort;
    _type = type;
    _redirectSlug = redirectSlug;
}

  MainSliderDetail.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _titleEn = json['title_en'];
    _titleJp = json['title_jp'];
    _subtitle = json['subtitle'];
    _imageType = json['image_type'];
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
    _sort = json['sort'];
    _type = json['type'];
    _redirectSlug = json['redirectSlug'];
  }
  num? _id;
  String? _position;
  String? _titleEn;
  dynamic _titleJp;
  dynamic _subtitle;
  String? _imageType;
  dynamic _descriptionEn;
  dynamic _descriptionJp;
  dynamic _smalltextEn;
  dynamic _smalltextJp;
  dynamic _descriptiontitleEn;
  dynamic _descriptiontitleJp;
  String? _image;
  String? _mobileImg;
  String? _buttontextEn;
  dynamic _buttontextJp;
  String? _buttonlink;
  String? _textposition;
  dynamic _buttonposition;
  String? _textType;
  num? _sort;
  String? _type;
  String? _redirectSlug;
MainSliderDetail copyWith({  num? id,
  String? position,
  String? titleEn,
  dynamic titleJp,
  dynamic subtitle,
  String? imageType,
  dynamic descriptionEn,
  dynamic descriptionJp,
  dynamic smalltextEn,
  dynamic smalltextJp,
  dynamic descriptiontitleEn,
  dynamic descriptiontitleJp,
  String? image,
  String? mobileImg,
  String? buttontextEn,
  dynamic buttontextJp,
  String? buttonlink,
  String? textposition,
  dynamic buttonposition,
  String? textType,
  num? sort,
  String? type,
  String? redirectSlug,
}) => MainSliderDetail(  id: id ?? _id,
  position: position ?? _position,
  titleEn: titleEn ?? _titleEn,
  titleJp: titleJp ?? _titleJp,
  subtitle: subtitle ?? _subtitle,
  imageType: imageType ?? _imageType,
  descriptionEn: descriptionEn ?? _descriptionEn,
  descriptionJp: descriptionJp ?? _descriptionJp,
  smalltextEn: smalltextEn ?? _smalltextEn,
  smalltextJp: smalltextJp ?? _smalltextJp,
  descriptiontitleEn: descriptiontitleEn ?? _descriptiontitleEn,
  descriptiontitleJp: descriptiontitleJp ?? _descriptiontitleJp,
  image: image ?? _image,
  mobileImg: mobileImg ?? _mobileImg,
  buttontextEn: buttontextEn ?? _buttontextEn,
  buttontextJp: buttontextJp ?? _buttontextJp,
  buttonlink: buttonlink ?? _buttonlink,
  textposition: textposition ?? _textposition,
  buttonposition: buttonposition ?? _buttonposition,
  textType: textType ?? _textType,
  sort: sort ?? _sort,
  type: type ?? _type,
  redirectSlug: redirectSlug ?? _redirectSlug,
);
  num? get id => _id;
  String? get position => _position;
  String? get titleEn => _titleEn;
  dynamic get titleJp => _titleJp;
  dynamic get subtitle => _subtitle;
  String? get imageType => _imageType;
  dynamic get descriptionEn => _descriptionEn;
  dynamic get descriptionJp => _descriptionJp;
  dynamic get smalltextEn => _smalltextEn;
  dynamic get smalltextJp => _smalltextJp;
  dynamic get descriptiontitleEn => _descriptiontitleEn;
  dynamic get descriptiontitleJp => _descriptiontitleJp;
  String? get image => _image;
  String? get mobileImg => _mobileImg;
  String? get buttontextEn => _buttontextEn;
  dynamic get buttontextJp => _buttontextJp;
  String? get buttonlink => _buttonlink;
  String? get textposition => _textposition;
  dynamic get buttonposition => _buttonposition;
  String? get textType => _textType;
  num? get sort => _sort;
  String? get type => _type;
  String? get redirectSlug => _redirectSlug;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['title_en'] = _titleEn;
    map['title_jp'] = _titleJp;
    map['subtitle'] = _subtitle;
    map['image_type'] = _imageType;
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
    map['sort'] = _sort;
    map['type'] = _type;
    map['redirectSlug'] = _redirectSlug;
    return map;
  }

}