// ignore_for_file: unused_import

import 'package:kohira/view/screen/menu/home/Search.dart';

class AppUrl {
  //local
  // static const baseurl = 'http://192.168.1.101:8888/kohira-next-lara/lmda-ctrl-zeta-layer';

  //staging
  // static const baseurl = 'https://api.weingenious.in/kohira/lmda-ctrl-zeta-layer';

  //Live
  static const baseurl = 'https://kdvkpanel.kohira.com/lmda-ctrl-zeta-layer';

  //credentials
  static const login = '$baseurl/login';
  static const sinup = '$baseurl/signup';
  static const forgetpassword = '$baseurl/forgot-password';
  static const country = '$baseurl/country';

  //Counting
  static const count = '$baseurl/count-wish-cart';

     //Menu
      //home
      static const categories = '$baseurl/home/categories';
      static const slider = '$baseurl/home/slider';
      static const homecollcation = '$baseurl/home/collections';

      //Categorie
      static const recommendedJewelleryList ='$baseurl/recommendedJewelleryList';
      static const wishlist = '$baseurl/wishlist';
      static const wishlistdelete = '$baseurl/wishlist-delete';
      static const addtocart = '$baseurl/cart';
      static const jewelleryDetail = '$baseurl/JewelleryDetailApp';

      //subCategorie
      static const jewelleryfilter = '$baseurl/Jewellery-filter';
      static const filtercategory = '$baseurl/category';

      //Seach
      static const search = '$baseurl/search';
      static const category = '$baseurl/category';
      static const product = '$baseurl/products';

      //Cart
      static const cart = '$baseurl/cart';
      static const countcart = '$baseurl/cart';
      static const deletcart = '$baseurl/cart-delete-particular';

      //Over Store
      static const store = '$baseurl/storeassetsList';
      static const storecity = '$baseurl/storecity';

      //Acount
      static const profileDetail = '$baseurl/profileDetail';
      static const profile = '$baseurl/profile';
      static const order = '$baseurl/order-list';
      static const orderdetail = '$baseurl/order-detail/';
      static const wallet = '$baseurl/my-wallet-history';
      static const addressesfeach = '$baseurl/my-address';
      static const setdefault = '$baseurl/my-address-default';
      static const deleteaddress = '$baseurl/my-address/delete';
}
