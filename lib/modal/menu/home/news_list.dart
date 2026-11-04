import 'dart:convert';

NewsListModel newsListModelFromJson(String str) => NewsListModel.fromJson(json.decode(str));
String newsListModelToJson(NewsListModel data) => json.encode(data.toJson());

class NewsListModel {
  NewsListModel({
    bool? success,
    String? message,
    List<NewsItem>? data,
    Meta? meta,
  }) {
    _success = success;
    _message = message;
    _data = data;
    _meta = meta;
  }

  NewsListModel.fromJson(dynamic json) {
    if (json is Map) {
      _success = json['success'] == true || json['success'] == 1 || json['success'].toString().toLowerCase() == 'true';
      _message = json['message'];
      var rawData = json['data'];
      if (rawData != null) {
        if (rawData is List) {
          _data = rawData.map((v) => NewsItem.fromJson(v)).toList();
        } else if (rawData is Map && rawData['data'] is List) {
          _data = (rawData['data'] as List).map((v) => NewsItem.fromJson(v)).toList();
        }
      }
      _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    }
  }

  bool? _success;
  String? _message;
  List<NewsItem>? _data;
  Meta? _meta;

  bool? get success => _success;
  String? get message => _message;
  List<NewsItem>? get data => _data;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

class NewsItem {
  NewsItem({
    num? id,
    String? position,
    String? titleEn,
    String? descriptionEn,
    String? buttonlink,
    String? imageLogo,
    String? newsImage,
  }) {
    _id = id;
    _position = position;
    _titleEn = titleEn;
    _descriptionEn = descriptionEn;
    _buttonlink = buttonlink;
    _imageLogo = imageLogo;
    _newsImage = newsImage;
  }

  NewsItem.fromJson(dynamic json) {
    if (json is Map) {
      _id = json['id'];
      _position = json['position'];
      _titleEn = json['title_en'];
      _descriptionEn = json['description_en'];
      _buttonlink = json['buttonlink'];
      _imageLogo = json['image_logo'];
      _newsImage = json['news_image'];
    }
  }

  num? _id;
  String? _position;
  String? _titleEn;
  String? _descriptionEn;
  String? _buttonlink;
  String? _imageLogo;
  String? _newsImage;

  num? get id => _id;
  String? get position => _position;
  String? get titleEn => _titleEn;
  String? get descriptionEn => _descriptionEn;
  String? get buttonlink => _buttonlink;
  String? get imageLogo => _imageLogo;
  String? get newsImage => _newsImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['title_en'] = _titleEn;
    map['description_en'] = _descriptionEn;
    map['buttonlink'] = _buttonlink;
    map['image_logo'] = _imageLogo;
    map['news_image'] = _newsImage;
    return map;
  }
}

class Meta {
  Meta({
    num? currentPage,
    num? perPage,
    num? total,
    num? lastPage,
  }) {
    _currentPage = currentPage;
    _perPage = perPage;
    _total = total;
    _lastPage = lastPage;
  }

  Meta.fromJson(dynamic json) {
    if (json is Map) {
      _currentPage = json['current_page'];
      _perPage = json['per_page'];
      _total = json['total'];
      _lastPage = json['last_page'];
    }
  }

  num? _currentPage;
  num? _perPage;
  num? _total;
  num? _lastPage;

  num? get currentPage => _currentPage;
  num? get perPage => _perPage;
  num? get total => _total;
  num? get lastPage => _lastPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    map['per_page'] = _perPage;
    map['total'] = _total;
    map['last_page'] = _lastPage;
    return map;
  }
}
