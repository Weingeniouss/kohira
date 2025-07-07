import 'dart:convert';
/// data : [{"id":7,"name":"Rings","slug":"rings","image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/category/tx8vwQ2vjoLlKSDkm8ZVQFGOJsyE5HX9bEynZ8Bc.jpg","sort":1,"subcategory":[{"id":75,"name":"3 Stone","slug":"rings-3-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":76,"name":"Engagement Rings","slug":"engagement-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":77,"name":"Contemporary Rings","slug":"contemporary-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":78,"name":"Side Stones","slug":"rings-side-stones","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":79,"name":"Solitaire","slug":"rings-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":80,"name":"Diamond Accents","slug":"rings-diamond-accents","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":81,"name":"Plain Shank","slug":"rings-plain-shank","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":82,"name":"Promise Rings","slug":"promise-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":83,"name":"Men's Rings","slug":"mens-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":84,"name":"Halo","slug":"rings-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":85,"name":"Wrap Rings","slug":"wrap-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":87,"name":"Cocktail Rings","slug":"cocktail-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":88,"name":"Solitaire Luxe Rings","slug":"solitaire-luxe-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":89,"name":"Crossover Rings","slug":"crossover-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":90,"name":"Wedding Bands","slug":"wedding-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":91,"name":"Eternity Bands","slug":"rings-eternity-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":92,"name":"Anniversary Bands","slug":"anniversary-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":93,"name":"Hidden Halo","slug":"rings-hidden-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":94,"name":"Bridal Ring Sets","slug":"bridal-ring-sets","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":95,"name":"Chevron Bands","slug":"chevron-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":96,"name":"Couple Bands","slug":"couple-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":97,"name":"Stackable Bands","slug":"stackable-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":100,"name":"7 Stone Cluster","slug":"rings7-stone-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":101,"name":"9 Stone","slug":"rings-9-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":105,"name":"Three Stone","slug":"rings-three-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":106,"name":"2 Stone","slug":"rings-2-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":108,"name":"5 Stone","slug":"ring-5-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":111,"name":"Cluster","slug":"rings-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":112,"name":"Artisanal Halo","slug":"rings-artisanal-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":114,"name":"Heart","slug":"rings-heart","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":116,"name":"Sunburst Halo","slug":"rings-sunburst-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":123,"name":"Detachable Halo","slug":"rings-detachable-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":124,"name":"7 Stone","slug":"rings-7-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":126,"name":"Tiger Claw Prong","slug":"tiger-claw-prong","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":127,"name":"Half Eternity","slug":"half-eternity","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":128,"name":"Floral Halo","slug":"floral-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":129,"name":"Band","slug":"band","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":130,"name":"Statement Ring","slug":"statement-ring","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]},{"id":2,"name":"Earrings","slug":"earrings","image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/category/olcFtyH2wAq0hugskX8ekmIOIGa5IvKmFgNJomCY.jpg","sort":2,"subcategory":[{"id":16,"name":"Cluster","slug":"cluster-earrings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":43,"name":"Danglers","slug":"earrings-danglers","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":44,"name":"Heart","slug":"earrings-heart","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":45,"name":"Studs","slug":"earrings-studs","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":46,"name":"Solitaire","slug":"earrings-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":47,"name":"Sunburst Halo","slug":"earrings-sunburst-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":48,"name":"J Hoops","slug":"earrings-j-hoops","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":49,"name":"Solitaire Luxe Earrings","slug":"earrings-solitaire-luxe-earrings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":50,"name":"Front Back","slug":"earrings-front-back","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":51,"name":"Hoops & Huggies","slug":"earrings-hoops-huggies","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":52,"name":"7 Stone Cluster","slug":"earrings-7-stone-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":53,"name":"2 Stone","slug":"earrings-2-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":54,"name":"Detachable Halo","slug":"earrings-detachable-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":55,"name":"Drops","slug":"earrings-drops","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":56,"name":"Artisanal Halo","slug":"earrings-artisanal-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":104,"name":"Starburst Halo","slug":"earrings-starburst-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":113,"name":"Halo","slug":"earrings-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":120,"name":"Statement Earrings","slug":"statement-earrings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":122,"name":"Chandeliers","slug":"chandeliers","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]},{"id":21,"name":"Mangalsutras","slug":"mangalsutras","image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/category/OMDIZgmYasl5MjtOSGPFoZoSSZkbS2TMjb7euVE0.jpg","sort":3,"subcategory":[{"id":22,"name":"Tanmaniya","slug":"mangalsutras-tanmaniya","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":23,"name":"5 Stone","slug":"mangalsutras-5-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":24,"name":"Artisanal Halo","slug":"mangalsutras-artisanal-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":25,"name":"Solitaire Luxe Mangalsutras","slug":"mangalsutras-solitaire-luxe-mangalsutras","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":26,"name":"Halo","slug":"mangalsutras-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":27,"name":"Cluster","slug":"mangalsutras-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":107,"name":"3 Stone","slug":"managalsutras-3-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":115,"name":"Solitaire","slug":"mangalsutras-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]},{"id":4,"name":"Necklaces","slug":"necklaces","image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/category/Jotb5BOjGDCEK8M4ho0qsFoiL6OF41HL1ZnPyplB.jpg","sort":4,"subcategory":[{"id":57,"name":"Chain Necklaces","slug":"chain-necklaces","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":59,"name":"Solitaire","slug":"necklaces-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":60,"name":"Heart","slug":"necklaces-heart","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":61,"name":"3 Stone","slug":"necklaces-3-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":62,"name":"Tennis Necklaces","slug":"tennis-necklaces","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":63,"name":"Solitaire Luxe Necklaces","slug":"solitaire-luxe-necklaces","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":64,"name":"Lariats","slug":"necklaces-lariats","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":65,"name":"Halo","slug":"necklaces-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":66,"name":"Light Weight Necklaces","slug":"light-weight-necklaces","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":86,"name":"Artisanal Halo","slug":"necklaces-artisanal-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":121,"name":"Statement Necklaces","slug":"statement-necklaces","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":125,"name":"7 Stone Cluster","slug":"7-stone-cluster-necklace","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]},{"id":5,"name":"Pendants","slug":"pendants","image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/category/FMD4RuZf0Gt8JEqr54uSuEPSJjVUT8n6OtxFra04.jpg","sort":5,"subcategory":[{"id":18,"name":"Cluster","slug":"pendant-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":19,"name":"Heart","slug":"pendant-heart","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":68,"name":"Solitaire","slug":"pendants-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":69,"name":"Halo","slug":"pendants-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":70,"name":"Solitaire Luxe Pendants","slug":"solitaire-luxe-pendants","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":71,"name":"Sunburst Halo","slug":"pendants-sunburst-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":72,"name":"Statement Pendants","slug":"statement-pendants","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":73,"name":"2 Stone","slug":"pendants-2-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":74,"name":"3 Stone","slug":"pendants-3-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":103,"name":"Star","slug":"pendants-star","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":109,"name":"7 Stone Cluster","slug":"pendants-7-stone-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":110,"name":"Artisanal Halo","slug":"pendants-artisanal-Halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":135,"name":"Chain Necklaces","slug":"chain-necklaces-pendants","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":136,"name":"Solitaire Luxe Necklaces","slug":"solitaire-luxe-necklaces-pendants","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]},{"id":1,"name":"Bangles & Bracelets","slug":"bangles-bracelets","image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/category/8PGu4aqLuZkpCPTXcPSNEW2jgePr0BLRI8pn7c8Z.jpg","sort":6,"subcategory":[{"id":36,"name":"Oval Bangles","slug":"bangles-bracelets-oval-bangles","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":37,"name":"Artisanal Halo","slug":"bangles-bracelets-artisanal-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":38,"name":"Solitaire","slug":"bangles-bracelets-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":39,"name":"Solitaire Luxe Bangles & Bracelets","slug":"bangles-bracelets-solitaire-luxe-bangles-bracelets","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":40,"name":"Tennis Bracelets","slug":"bangles-bracelets-tennis-bracelets","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":41,"name":"Halo","slug":"bangles-bracelets-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":42,"name":"5 Stone","slug":"bangles-bracelets-5-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":102,"name":"Round Bangles","slug":"round-bangles","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":117,"name":"Infinity","slug":"bangels-infinity","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":118,"name":"Chain Bracelets","slug":"chain-bracelets","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":119,"name":"Heart","slug":"bangles-heart","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]},{"id":28,"name":"Other Jewellery","slug":"other-jewellery","image":"https://d2spbytg38ui5z.cloudfront.net/web-banners/category/EvYmxEdW4A15k7HXlsjXU2jOq0UMuh3PRRluoR0L.jpg","sort":7,"subcategory":[{"id":29,"name":"Nose Pins","slug":"other-jewellery-nose-pins","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":30,"name":"Cluster","slug":"other-jewellery-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":31,"name":"Solitaire","slug":"other-jewellery-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":32,"name":"Heart","slug":"other-jewellery-heart","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":33,"name":"J Nose Pins","slug":"other-jewellery-j-nose-pins","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":34,"name":"3 Stone","slug":"other-jewellery-3-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":35,"name":"7 Stone Cluster","slug":"other-jewellery-7-stone-Cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":67,"name":"2 Stone","slug":"otherjewellery-2-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]}]
/// count : 7
/// success : true
/// message : "Category fetch Successfully."

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));
String categoryToJson(Category data) => json.encode(data.toJson());
class Category {
  Category({
      List<Data>? data, 
      num? count, 
      bool? success, 
      String? message,}){
    _data = data;
    _count = count;
    _success = success;
    _message = message;
}

  Category.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _count = json['count'];
    _success = json['success'];
    _message = json['message'];
  }
  List<Data>? _data;
  num? _count;
  bool? _success;
  String? _message;
Category copyWith({  List<Data>? data,
  num? count,
  bool? success,
  String? message,
}) => Category(  data: data ?? _data,
  count: count ?? _count,
  success: success ?? _success,
  message: message ?? _message,
);
  List<Data>? get data => _data;
  num? get count => _count;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['count'] = _count;
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// id : 7
/// name : "Rings"
/// slug : "rings"
/// image : "https://d2spbytg38ui5z.cloudfront.net/web-banners/category/tx8vwQ2vjoLlKSDkm8ZVQFGOJsyE5HX9bEynZ8Bc.jpg"
/// sort : 1
/// subcategory : [{"id":75,"name":"3 Stone","slug":"rings-3-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":76,"name":"Engagement Rings","slug":"engagement-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":77,"name":"Contemporary Rings","slug":"contemporary-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":78,"name":"Side Stones","slug":"rings-side-stones","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":79,"name":"Solitaire","slug":"rings-solitaire","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":80,"name":"Diamond Accents","slug":"rings-diamond-accents","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":81,"name":"Plain Shank","slug":"rings-plain-shank","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":82,"name":"Promise Rings","slug":"promise-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":83,"name":"Men's Rings","slug":"mens-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":84,"name":"Halo","slug":"rings-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":85,"name":"Wrap Rings","slug":"wrap-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":87,"name":"Cocktail Rings","slug":"cocktail-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":88,"name":"Solitaire Luxe Rings","slug":"solitaire-luxe-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":89,"name":"Crossover Rings","slug":"crossover-rings","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":90,"name":"Wedding Bands","slug":"wedding-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":91,"name":"Eternity Bands","slug":"rings-eternity-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":92,"name":"Anniversary Bands","slug":"anniversary-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":93,"name":"Hidden Halo","slug":"rings-hidden-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":94,"name":"Bridal Ring Sets","slug":"bridal-ring-sets","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":95,"name":"Chevron Bands","slug":"chevron-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":96,"name":"Couple Bands","slug":"couple-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":97,"name":"Stackable Bands","slug":"stackable-bands","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":100,"name":"7 Stone Cluster","slug":"rings7-stone-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":101,"name":"9 Stone","slug":"rings-9-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":105,"name":"Three Stone","slug":"rings-three-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":106,"name":"2 Stone","slug":"rings-2-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":108,"name":"5 Stone","slug":"ring-5-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":111,"name":"Cluster","slug":"rings-cluster","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":112,"name":"Artisanal Halo","slug":"rings-artisanal-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":114,"name":"Heart","slug":"rings-heart","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":116,"name":"Sunburst Halo","slug":"rings-sunburst-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":123,"name":"Detachable Halo","slug":"rings-detachable-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":124,"name":"7 Stone","slug":"rings-7-stone","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":126,"name":"Tiger Claw Prong","slug":"tiger-claw-prong","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":127,"name":"Half Eternity","slug":"half-eternity","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":128,"name":"Floral Halo","slug":"floral-halo","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":129,"name":"Band","slug":"band","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"},{"id":130,"name":"Statement Ring","slug":"statement-ring","sort":null,"image":"https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? id, 
      String? name, 
      String? slug, 
      String? image, 
      num? sort, 
      List<Subcategory>? subcategory,}){
    _id = id;
    _name = name;
    _slug = slug;
    _image = image;
    _sort = sort;
    _subcategory = subcategory;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _image = json['image'];
    _sort = json['sort'];
    if (json['subcategory'] != null) {
      _subcategory = [];
      json['subcategory'].forEach((v) {
        _subcategory?.add(Subcategory.fromJson(v));
      });
    }
  }
  num? _id;
  String? _name;
  String? _slug;
  String? _image;
  num? _sort;
  List<Subcategory>? _subcategory;
Data copyWith({  num? id,
  String? name,
  String? slug,
  String? image,
  num? sort,
  List<Subcategory>? subcategory,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  slug: slug ?? _slug,
  image: image ?? _image,
  sort: sort ?? _sort,
  subcategory: subcategory ?? _subcategory,
);
  num? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get image => _image;
  num? get sort => _sort;
  List<Subcategory>? get subcategory => _subcategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['slug'] = _slug;
    map['image'] = _image;
    map['sort'] = _sort;
    if (_subcategory != null) {
      map['subcategory'] = _subcategory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 75
/// name : "3 Stone"
/// slug : "rings-3-stone"
/// sort : null
/// image : "https://api.weingenious.in/kohira/public/assets_backend/images/no-images.jpg"

Subcategory subcategoryFromJson(String str) => Subcategory.fromJson(json.decode(str));
String subcategoryToJson(Subcategory data) => json.encode(data.toJson());
class Subcategory {
  Subcategory({
      num? id, 
      String? name, 
      String? slug, 
      dynamic sort, 
      String? image,}){
    _id = id;
    _name = name;
    _slug = slug;
    _sort = sort;
    _image = image;
}

  Subcategory.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _sort = json['sort'];
    _image = json['image'];
  }
  num? _id;
  String? _name;
  String? _slug;
  dynamic _sort;
  String? _image;
Subcategory copyWith({  num? id,
  String? name,
  String? slug,
  dynamic sort,
  String? image,
}) => Subcategory(  id: id ?? _id,
  name: name ?? _name,
  slug: slug ?? _slug,
  sort: sort ?? _sort,
  image: image ?? _image,
);
  num? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  dynamic get sort => _sort;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['slug'] = _slug;
    map['sort'] = _sort;
    map['image'] = _image;
    return map;
  }

}