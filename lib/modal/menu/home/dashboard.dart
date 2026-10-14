import 'dart:convert';

HomeDashboardModel homeDashboardModelFromJson(String str) =>
    HomeDashboardModel.fromJson(json.decode(str));

class HomeDashboardModel {
  bool? success;
  String? message;
  List<MainSliderDetail>? mainSliderDetail;
  List<MainOfferSliderDetail>? mainOfferSliderDetail;
  List<MainhomepagesinstareelDetail>? mainhomepagesinstareelDetail;
  List<GoldMineBanner>? goldMineBanner;
  List<CustomOrderBanner>? customOrderBanner;
  List<MaindesignledjewelleryDetail>? maindesignledjewelleryDetail;
  List<HomestoresliderBanner>? homestoresliderBanner;
  List<dynamic>? mainhomeeducationlistDetail;
  List<EditorialbannerDetail>? editorialbannerDetail;
  List<HomeCustomerReviewDetail>? homeCustomerReviewDetail;
  List<HomeCategoryItem>? categories;
  HomeCollections? homeCollections;
  List<WhyChooseUs>? whyChooseUs;
  HomepageTitle? homepageTitle;

  HomeDashboardModel({
    this.success,
    this.message,
    this.mainSliderDetail,
    this.mainOfferSliderDetail,
    this.mainhomepagesinstareelDetail,
    this.goldMineBanner,
    this.customOrderBanner,
    this.maindesignledjewelleryDetail,
    this.homestoresliderBanner,
    this.mainhomeeducationlistDetail,
    this.editorialbannerDetail,
    this.homeCustomerReviewDetail,
    this.categories,
    this.homeCollections,
    this.whyChooseUs,
    this.homepageTitle,
  });

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    return HomeDashboardModel(
      success: json['success'],
      message: json['message'],
      mainSliderDetail: json['mainSliderDetail'] != null
          ? (json['mainSliderDetail'] as List)
              .map((e) => MainSliderDetail.fromJson(e))
              .toList()
          : null,
      mainOfferSliderDetail: json['mainOfferSliderDetail'] != null
          ? (json['mainOfferSliderDetail'] as List)
              .map((e) => MainOfferSliderDetail.fromJson(e))
              .toList()
          : null,
      mainhomepagesinstareelDetail: json['mainhomepagesinstareelDetail'] != null
          ? (json['mainhomepagesinstareelDetail'] as List)
              .map((e) => MainhomepagesinstareelDetail.fromJson(e))
              .toList()
          : null,
      goldMineBanner: json['goldMineBanner'] != null
          ? (json['goldMineBanner'] as List)
              .map((e) => GoldMineBanner.fromJson(e))
              .toList()
          : null,
      customOrderBanner: json['customOrderBanner'] != null
          ? (json['customOrderBanner'] as List)
              .map((e) => CustomOrderBanner.fromJson(e))
              .toList()
          : null,
      maindesignledjewelleryDetail: json['maindesignledjewelleryDetail'] != null
          ? (json['maindesignledjewelleryDetail'] as List)
              .map((e) => MaindesignledjewelleryDetail.fromJson(e))
              .toList()
          : null,
      homestoresliderBanner: json['homestoresliderBanner'] != null
          ? (json['homestoresliderBanner'] as List)
              .map((e) => HomestoresliderBanner.fromJson(e))
              .toList()
          : null,
      mainhomeeducationlistDetail: json['mainhomeeducationlistDetail'],
      editorialbannerDetail: json['editorialbannerDetail'] != null
          ? (json['editorialbannerDetail'] as List)
              .map((e) => EditorialbannerDetail.fromJson(e))
              .toList()
          : null,
      homeCustomerReviewDetail: json['homeCustomerReviewDetail'] != null
          ? (json['homeCustomerReviewDetail'] as List)
              .map((e) => HomeCustomerReviewDetail.fromJson(e))
              .toList()
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((e) => HomeCategoryItem.fromJson(e))
              .toList()
          : null,
      homeCollections: json['homeCollections'] != null
          ? HomeCollections.fromJson(json['homeCollections'])
          : null,
      whyChooseUs: json['whyChooseUs'] != null
          ? (json['whyChooseUs'] as List)
              .map((e) => WhyChooseUs.fromJson(e))
              .toList()
          : null,
      homepageTitle: json['homepage_title'] != null
          ? HomepageTitle.fromJson(json['homepage_title'])
          : null,
    );
  }
}

class MainSliderDetail {
  num? id;
  String? titleEn;
  dynamic titleJp;
  dynamic subtitle;
  String? imageType;
  dynamic descriptionEn;
  dynamic descriptiontitleEn;
  String? image;
  String? mobileImg;
  String? buttontextEn;
  String? buttonlink;
  String? textposition;
  String? buttonposition;
  String? textType;
  String? type;
  String? redirectSlug;

  MainSliderDetail({
    this.id,
    this.titleEn,
    this.titleJp,
    this.subtitle,
    this.imageType,
    this.descriptionEn,
    this.descriptiontitleEn,
    this.image,
    this.mobileImg,
    this.buttontextEn,
    this.buttonlink,
    this.textposition,
    this.buttonposition,
    this.textType,
    this.type,
    this.redirectSlug,
  });

  factory MainSliderDetail.fromJson(Map<String, dynamic> json) {
    return MainSliderDetail(
      id: json['id'],
      titleEn: json['title_en'],
      titleJp: json['title_jp'],
      subtitle: json['subtitle'],
      imageType: json['image_type'],
      descriptionEn: json['description_en'],
      descriptiontitleEn: json['descriptiontitle_en'],
      image: json['image'],
      mobileImg: json['mobile_img'],
      buttontextEn: json['buttontext_en'],
      buttonlink: json['buttonlink'],
      textposition: json['textposition'],
      buttonposition: json['buttonposition'],
      textType: json['text_type'],
      type: json['type'],
      redirectSlug: json['redirectSlug'],
    );
  }
}

class MainOfferSliderDetail {
  num? id;
  String? image;
  String? mobileImg;
  String? type;
  String? imageType;
  String? redirectSlug;

  MainOfferSliderDetail({
    this.id,
    this.image,
    this.mobileImg,
    this.type,
    this.imageType,
    this.redirectSlug,
  });

  factory MainOfferSliderDetail.fromJson(Map<String, dynamic> json) {
    return MainOfferSliderDetail(
      id: json['id'],
      image: json['image'],
      mobileImg: json['mobile_img'],
      type: json['type'],
      imageType: json['image_type'],
      redirectSlug: json['redirectSlug'],
    );
  }
}

class MainhomepagesinstareelDetail {
  num? id;
  String? imageType;
  String? descriptionEn;
  String? buttonlink;
  String? image;

  MainhomepagesinstareelDetail({
    this.id,
    this.imageType,
    this.descriptionEn,
    this.buttonlink,
    this.image,
  });

  factory MainhomepagesinstareelDetail.fromJson(Map<String, dynamic> json) {
    return MainhomepagesinstareelDetail(
      id: json['id'],
      imageType: json['image_type'],
      descriptionEn: json['description_en'],
      buttonlink: json['buttonlink'],
      image: json['image'],
    );
  }
}

class GoldMineBanner {
  num? id;
  String? position;
  String? image;
  String? mobileImg;

  GoldMineBanner({
    this.id,
    this.position,
    this.image,
    this.mobileImg,
  });

  factory GoldMineBanner.fromJson(Map<String, dynamic> json) {
    return GoldMineBanner(
      id: json['id'],
      position: json['position'],
      image: json['image'],
      mobileImg: json['mobile_img'],
    );
  }
}

class CustomOrderBanner {
  num? id;
  String? titleEn;
  String? descriptionEn;
  String? buttonlink;
  String? buttontextEn;
  String? image;
  String? mobileImg;

  CustomOrderBanner({
    this.id,
    this.titleEn,
    this.descriptionEn,
    this.buttonlink,
    this.buttontextEn,
    this.image,
    this.mobileImg,
  });

  factory CustomOrderBanner.fromJson(Map<String, dynamic> json) {
    return CustomOrderBanner(
      id: json['id'],
      titleEn: json['title_en'],
      descriptionEn: json['description_en'],
      buttonlink: json['buttonlink'],
      buttontextEn: json['buttontext_en'],
      image: json['image'],
      mobileImg: json['mobile_img'],
    );
  }
}

class MaindesignledjewelleryDetail {
  num? id;
  String? titleEn;
  String? image;
  String? mobileImg;
  String? desktopMobImage;
  String? type;
  String? redirectSlug;

  MaindesignledjewelleryDetail({
    this.id,
    this.titleEn,
    this.image,
    this.mobileImg,
    this.desktopMobImage,
    this.type,
    this.redirectSlug,
  });

  factory MaindesignledjewelleryDetail.fromJson(Map<String, dynamic> json) {
    return MaindesignledjewelleryDetail(
      id: json['id'],
      titleEn: json['title_en'],
      image: json['image'],
      mobileImg: json['mobile_img'],
      desktopMobImage: json['desktop_mob_image'],
      type: json['type'],
      redirectSlug: json['redirectSlug'],
    );
  }
}

class HomestoresliderBanner {
  num? id;
  String? titleEn;
  String? descriptionEn;
  String? image;
  String? mobileImg;

  HomestoresliderBanner({
    this.id,
    this.titleEn,
    this.descriptionEn,
    this.image,
    this.mobileImg,
  });

  factory HomestoresliderBanner.fromJson(Map<String, dynamic> json) {
    return HomestoresliderBanner(
      id: json['id'],
      titleEn: json['title_en'],
      descriptionEn: json['description_en'],
      image: json['image'],
      mobileImg: json['mobile_img'],
    );
  }
}

class EditorialbannerDetail {
  num? id;
  String? buttonlink;
  String? image;

  EditorialbannerDetail({
    this.id,
    this.buttonlink,
    this.image,
  });

  factory EditorialbannerDetail.fromJson(Map<String, dynamic> json) {
    return EditorialbannerDetail(
      id: json['id'],
      buttonlink: json['buttonlink'],
      image: json['image'],
    );
  }
}

class HomeCustomerReviewDetail {
  num? id;
  String? userName;
  String? rateUs;
  String? body;
  String? reviewLink;
  String? image;

  HomeCustomerReviewDetail({
    this.id,
    this.userName,
    this.rateUs,
    this.body,
    this.reviewLink,
    this.image,
  });

  factory HomeCustomerReviewDetail.fromJson(Map<String, dynamic> json) {
    return HomeCustomerReviewDetail(
      id: json['id'],
      userName: json['user_name'],
      rateUs: json['rate_us'],
      body: json['body'],
      reviewLink: json['review_link'],
      image: json['image'],
    );
  }
}

class HomeCategoryItem {
  num? id;
  String? name;
  String? description;
  String? image;
  String? type;
  num? categoryId;
  String? slug;

  HomeCategoryItem({
    this.id,
    this.name,
    this.description,
    this.image,
    this.type,
    this.categoryId,
    this.slug,
  });

  factory HomeCategoryItem.fromJson(Map<String, dynamic> json) {
    return HomeCategoryItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      type: json['type'],
      categoryId: json['category_id'],
      slug: json['slug'],
    );
  }
}

class CollectionSection {
  num? id;
  String? name;
  String? description;
  num? sectionNo;
  String? buttontext;
  String? buttonlink;
  String? subTitle;
  String? subDescription;
  List<String>? images;
  String? video;
  String? appImage;
  List<dynamic>? detail;

  CollectionSection({
    this.id,
    this.name,
    this.description,
    this.sectionNo,
    this.buttontext,
    this.buttonlink,
    this.subTitle,
    this.subDescription,
    this.images,
    this.video,
    this.appImage,
    this.detail,
  });

  factory CollectionSection.fromJson(Map<String, dynamic> json) {
    return CollectionSection(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sectionNo: json['section_no'],
      buttontext: json['buttontext'],
      buttonlink: json['buttonlink'],
      subTitle: json['sub_title'],
      subDescription: json['sub_description'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
      video: json['video'],
      appImage: json['app_image'],
      detail: json['detail'],
    );
  }
}

class HomeCollections {
  CollectionSection? collectionSection1;
  CollectionSection? collectionSection2;
  CollectionSection? collectionSection3;
  CollectionSection? collectionSection4;

  HomeCollections({
    this.collectionSection1,
    this.collectionSection2,
    this.collectionSection3,
    this.collectionSection4,
  });

  factory HomeCollections.fromJson(Map<String, dynamic> json) {
    return HomeCollections(
      collectionSection1: json['collection_section_1'] != null
          ? CollectionSection.fromJson(json['collection_section_1'])
          : null,
      collectionSection2: json['collection_section_2'] != null
          ? CollectionSection.fromJson(json['collection_section_2'])
          : null,
      collectionSection3: json['collection_section_3'] != null
          ? CollectionSection.fromJson(json['collection_section_3'])
          : null,
      collectionSection4: json['collection_section_4'] != null
          ? CollectionSection.fromJson(json['collection_section_4'])
          : null,
    );
  }
}

class WhyChooseUs {
  num? id;
  String? name;
  String? description;
  String? image1;

  WhyChooseUs({
    this.id,
    this.name,
    this.description,
    this.image1,
  });

  factory WhyChooseUs.fromJson(Map<String, dynamic> json) {
    return WhyChooseUs(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image1: json['image1'],
    );
  }
}

class TitleDetailItem {
  String? position;
  String? titleEn;
  String? descriptionEn;
  String? buttonlink;
  String? buttontextEn;

  TitleDetailItem({
    this.position,
    this.titleEn,
    this.descriptionEn,
    this.buttonlink,
    this.buttontextEn,
  });

  factory TitleDetailItem.fromJson(Map<String, dynamic> json) {
    return TitleDetailItem(
      position: json['position'],
      titleEn: json['title_en'],
      descriptionEn: json['description_en'],
      buttonlink: json['buttonlink'],
      buttontextEn: json['buttontext_en'],
    );
  }
}

class HomepageTitle {
  TitleDetailItem? instagramtitle;
  TitleDetailItem? ledjewelrttitle;
  TitleDetailItem? homenewstitle;
  TitleDetailItem? homeeeducationtitle;
  TitleDetailItem? editorialbannertitle;

  HomepageTitle({
    this.instagramtitle,
    this.ledjewelrttitle,
    this.homenewstitle,
    this.homeeeducationtitle,
    this.editorialbannertitle,
  });

  factory HomepageTitle.fromJson(Map<String, dynamic> json) {
    return HomepageTitle(
      instagramtitle: json['instagramtitle'] != null
          ? TitleDetailItem.fromJson(json['instagramtitle'])
          : null,
      ledjewelrttitle: json['ledjewelrttitle'] != null
          ? TitleDetailItem.fromJson(json['ledjewelrttitle'])
          : null,
      homenewstitle: json['homenewstitle'] != null
          ? TitleDetailItem.fromJson(json['homenewstitle'])
          : null,
      homeeeducationtitle: json['homeeeducationtitle'] != null
          ? TitleDetailItem.fromJson(json['homeeeducationtitle'])
          : null,
      editorialbannertitle: json['editorialbannertitle'] != null
          ? TitleDetailItem.fromJson(json['editorialbannertitle'])
          : null,
    );
  }
}
