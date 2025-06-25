import 'dart:convert';
/// category : [{"id":1,"name":"RINGS","description":"One Circle. Infinite Feels.","image":"https://d2spbytg38ui5z.cloudfront.net/images/banners/mainHomeCategory/lcjk2DYTqQ5rzDbpOAupL6677laQYgU3dMeRjX39.png","category_id":7,"category":"Rings","slug":"rings"},{"id":2,"name":"BANGLES & BRACELETS","description":"Jewels That Move With You.","image":"https://d2spbytg38ui5z.cloudfront.net/images/banners/mainHomeCategory/N3S7WxaC4moBEaqMSmD3f9bg1VF3SqXknM4zHOCz.png","category_id":1,"category":"Bangles & Bracelets","slug":"bangles-bracelets"},{"id":3,"name":"PENDANTS","description":"Wear Your Heart, Literally.","image":"https://d2spbytg38ui5z.cloudfront.net/images/banners/mainHomeCategory/1ieAqrIuUQm1uv9CIMcZR9Oy3r1D9HzvxEpjfULC.png","category_id":5,"category":"Pendants","slug":"pendants"},{"id":6,"name":"EARRINGS","description":"Sparkle That Listens.","image":"https://d2spbytg38ui5z.cloudfront.net/images/banners/mainHomeCategory/DYvqmH5dQohYsNi2aLqwsCsWSWSUhSJDsB6ycr7T.png","category_id":2,"category":"Earrings","slug":"earrings"},{"id":8,"name":"MANGALSUTRAS","description":"Old Soul, New Shine.","image":"https://d2spbytg38ui5z.cloudfront.net/images/banners/mainHomeCategory/0UCdTE61rG4y23F8aVh7BydZWxHBFjAPvZZmQWxf.png","category_id":21,"category":"Mangalsutras","slug":"mangalsutras"}]
/// count : 5
/// success : true
/// message : "Category fetch Successfully."

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));
String categoriesToJson(Categories data) => json.encode(data.toJson());
class Categories {
  Categories({
      List<Category>? category, 
      num? count, 
      bool? success, 
      String? message,}){
    _category = category;
    _count = count;
    _success = success;
    _message = message;
}

  Categories.fromJson(dynamic json) {
    if (json['category'] != null) {
      _category = [];
      json['category'].forEach((v) {
        _category?.add(Category.fromJson(v));
      });
    }
    _count = json['count'];
    _success = json['success'];
    _message = json['message'];
  }
  List<Category>? _category;
  num? _count;
  bool? _success;
  String? _message;
Categories copyWith({  List<Category>? category,
  num? count,
  bool? success,
  String? message,
}) => Categories(  category: category ?? _category,
  count: count ?? _count,
  success: success ?? _success,
  message: message ?? _message,
);
  List<Category>? get category => _category;
  num? get count => _count;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_category != null) {
      map['category'] = _category?.map((v) => v.toJson()).toList();
    }
    map['count'] = _count;
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// id : 1
/// name : "RINGS"
/// description : "One Circle. Infinite Feels."
/// image : "https://d2spbytg38ui5z.cloudfront.net/images/banners/mainHomeCategory/lcjk2DYTqQ5rzDbpOAupL6677laQYgU3dMeRjX39.png"
/// category_id : 7
/// category : "Rings"
/// slug : "rings"

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));
String categoryToJson(Category data) => json.encode(data.toJson());
class Category {
  Category({
      num? id, 
      String? name, 
      String? description, 
      String? image, 
      num? categoryId, 
      String? category, 
      String? slug,}){
    _id = id;
    _name = name;
    _description = description;
    _image = image;
    _categoryId = categoryId;
    _category = category;
    _slug = slug;
}

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'];
    _categoryId = json['category_id'];
    _category = json['category'];
    _slug = json['slug'];
  }
  num? _id;
  String? _name;
  String? _description;
  String? _image;
  num? _categoryId;
  String? _category;
  String? _slug;
Category copyWith({  num? id,
  String? name,
  String? description,
  String? image,
  num? categoryId,
  String? category,
  String? slug,
}) => Category(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  image: image ?? _image,
  categoryId: categoryId ?? _categoryId,
  category: category ?? _category,
  slug: slug ?? _slug,
);
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get image => _image;
  num? get categoryId => _categoryId;
  String? get category => _category;
  String? get slug => _slug;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['image'] = _image;
    map['category_id'] = _categoryId;
    map['category'] = _category;
    map['slug'] = _slug;
    return map;
  }

}