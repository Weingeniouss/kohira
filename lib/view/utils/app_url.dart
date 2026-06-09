// ignore_for_file: unused_import, constant_identifier_names

import 'package:kohira/view/screen/menu/home/Search.dart';

class GoogleUrl{
    static const googlebase = 'https://www.google.com';
    static const googlesarch = '$googlebase/maps/search/';
}

class AppUrl {
  //local
  static const baseurl = 'http://192.168.1.178:8888/kohira-next-lara/lmda-ctrl-zeta-layer';
  //   static const baseurl = 'http://192.168.1.178:8888/kohira-next-lara/api';

  //staging
  // static const baseurl = 'https://api.weingenious.in/kohira/lmda-ctrl-zeta-layer';
  //   static const baseurl = 'https://api.weingenious.in/kohira/api';

  //Live
  // static const baseurl = 'https://kdvkpanel.kohira.com/lmda-ctrl-zeta-layer';

  //credentials
  static const login = '$baseurl/login';
  static const sinup = '$baseurl/signup';
  static const logout = '$baseurl/logout';
  static const forgetpassword = '$baseurl/forgot-password';
  static const country = '$baseurl/country';
  static const state = '$baseurl/state';

  //Otp
  static const otp = '$baseurl/send-otp';
  static const verifyotp = '$baseurl/verify-otp';

  //Counting
  static const count = '$baseurl/count-wish-cart';

     //Menu
      //home
      static const categories = '$baseurl/home/categories';
      static const homeDashbord = '$baseurl/home/dashboard';
      static const homepage_JewelryList = '$baseurl/homepage-JewelryList';
      static const slider = '$baseurl/home/slider';
      static const homecollcation = '$baseurl/home/collections';
      static const homecJewelry = '$baseurl/home/Jewelry';

      //drawer
      static const collection = '$baseurl/collections';
      static const jewellery_filter = '$baseurl/Jewellery-filter';

          //Custom Jewellery
          static const customorder = '$baseurl/category-customorder';
          static const clarity = '$baseurl/clarity';
          static const addcustom = '$baseurl/add-custom-jewelry';

      //Categorie
      static const recommendedJewelleryList ='$baseurl/recommendedJewelleryList';
      static const wishlist = '$baseurl/wishlist';
      static const wishlistwithoutlogin = '$baseurl/wishlist/withoutlogin';
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
      // static const payment = '$baseurl/process-payment';
      static const payment = '$baseurl/make-payment';
      static const withoutlogin = '$baseurl/cart/withoutlogin';

      //Over Store
      static const store = '$baseurl/storeassetsList';
      static const storecity = '$baseurl/storecity';
      static const storedetails = '$baseurl/storeassetDetail';

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
