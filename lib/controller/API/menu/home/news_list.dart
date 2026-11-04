// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kohira/controller/service/menu/home/news_list.dart';
import '../../../../modal/menu/home/news_list.dart';

class NewsListCalling extends GetxController {
  var isLoading = false.obs;
  var newsItems = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFallbackNews();
    getNewsList();
  }

  void loadFallbackNews() {
    newsItems.value = [
      NewsItem(
        id: 97,
        position: "homenewslist",
        titleEn: "KOHIRA BRINGS LUXURY TO NOIDA",
        descriptionEn: "Kohira, India's leading lab-grown diamond jewellery brand, proudly inaugurated its 10th exclusive showroom in the heart of Noida at Wave One Mall, Sector 18. The grand launch marked a significant milestone",
        buttonlink: "https://www.tribuneindia.com/news/business/kohira-lab-grown-diamond-jewellery-opens-its-10th-showroom-in-noida-with-a-grand-launch/",
        imageLogo: "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/mqDi2KnSMepIDJDIToYAFa7OPyMZHqnATJLpVDGD.png",
        newsImage: "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/ajxQpGjOGKsSKY014j5Ex6eLL6M1xKQTg8QubN0L.png",
      ),
      NewsItem(
        id: 96,
        position: "homenewslist",
        titleEn: "KOHIRA'S MUMBAI DEBUT",
        descriptionEn: "Kohira's debut flagship showroom in Mumbai was inaugurated by beloved actor Shivangi Joshi - a moment where Bollywood glamour met the brilliance of lab-grown diamonds. The future of fine jewellery found its home in the heart of Mumbai.",
        buttonlink: "https://www.aninews.in/news/business/popular-actor-shivangi-joshi-inaugurates-kohiras-first-flagship-showroom-in-mumbai20240524151747/",
        imageLogo: "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/wEbogFQ1Cm87Nbvg7JZUF5IHt8cU2jO9w6wEwgHt.png",
        newsImage: "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/hldVQZo2lUc2JMk2flJIKJAMSm6vmglOJvRpPied.png",
      ),
      NewsItem(
        id: 95,
        position: "homenewslist",
        titleEn: "A GOLDEN MOMENT, A LASTING LEGACY",
        descriptionEn: "A proud moment for Kohira. Our founder was honoured at the prestigious 4th Golden Girls Award 2026 by IBJA in Mumbai - celebrated among India's most inspiring women entrepreneurs in jewellery. A recognition that reflects the vision and dedication Kohira is built upon.",
        buttonlink: "https://kohira.com/",
        imageLogo: "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/hPlzRtGGZmOJkx0adH0MQoS2WryUeijmDnoZlLmh.png",
        newsImage: "https://d2spbytg38ui5z.cloudfront.net/web-banners/mainHomePage/Wi8AeOktTnaKE0gXPXSDT9EMUIhynEOBoL2fpO9p.png",
      ),
    ];
  }

  Future<void> getNewsList() async {
    try {
      isLoading.value = true;
      final result = await NewsListService().fetchNewsList();
      if (result != null && result.data != null && result.data!.isNotEmpty) {
        newsItems.value = result.data!;
        print('News items fetched successfully from POST API: ${newsItems.length}');
      } else {
        print('Using fallback news items as API returned empty or null');
      }
    } catch (e) {
      print('NewsListCalling Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
