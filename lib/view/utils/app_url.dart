// ignore_for_file: unused_import

import 'package:kohira/view/screen/menu/home/Search.dart';

class AppUrl {
  //local
  // static const baseurl = 'http://192.168.1.101:8888/kohira-next-lara/api';

  //staging
  static const baseurl = 'https://api.weingenious.in/kohira/api';

  //credentials
  static const login = '$baseurl/login';
  static const sinup = '$baseurl/signup';
  static const forgetpassword = '$baseurl/forgot-password';
  static const country = '$baseurl/country';

    //Menu
     //home
      static const categories = '$baseurl/home/categories';
      static const slider = '$baseurl/home/slider';
      static const homecollcation = '$baseurl/home/collections';

      //Categorie
      static const recommendedJewelleryList ='$baseurl/recommendedJewelleryList';

     //Seach
      static const search = '$baseurl/search';
      static const category = '$baseurl/category';
      static const product = '$baseurl/products';
      static const jewelleryDetail = '$baseurl/JewelleryDetailApp';
}
