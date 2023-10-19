import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/homepage/controller/home_controller.dart';
import 'package:online_shopping/homepage/model/product_model.dart';
import 'package:online_shopping/product/view/product.dart';
import 'package:online_shopping/recommend/view/recommend.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();

    homeController.callBannerList();
    homeController.callProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            banner(),
            productRecommendation(),
          ],
        ),
      ),
    );
  }

  banner() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: homeController.bannerList.isEmpty
            ? [const CircularProgressIndicator()]
            : [
                CarouselSlider.builder(
                  itemCount: homeController.bannerList.length,
                  options: CarouselOptions(
                    autoPlay: (homeController.bannerList.length == 1) ? false : true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) => homeController.bannerIndex(index),
                  ),
                  itemBuilder: (context, index, indexPage) => GestureDetector(
                      onTap: () {},
                      child: CachedNetworkImage(
                        useOldImageOnUrlChange: true,
                        imageUrl: 'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg',
                        fit: BoxFit.fitWidth,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported_outlined),
                        ),
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          ),
                        ),
                      )),
                ),
                const SizedBox(height: 10),
                AnimatedSmoothIndicator(
                  activeIndex: homeController.bannerIndex.value,
                  count: homeController.bannerList.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.orange,
                    dotHeight: 8,
                    dotWidth: 12,
                    spacing: 6,
                  ),
                )
              ],
      ),
    );
  }

  showBannerImage(int index) {
    FutureBuilder(
        future: homeController.validateImage(homeController.bannerList.elementAt(index).imgUrl ?? ''),
        builder: (context, snapshot) {
          return Container(
            color: Colors.white,
            child: (snapshot as bool)
                ? Container(
                    height: 50,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined),
                  )
                : CachedNetworkImage(
                    useOldImageOnUrlChange: true,
                    imageUrl: 'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg',
                    fit: BoxFit.fitWidth,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  productRecommendation() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: Text(
              'Recommendation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            GestureDetector(
                onTap: () {
                  Get.to(const RecommendPage());
                },
                child: const Text(
                  'View all',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ))
          ],
        ).paddingSymmetric(vertical: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () => Row(
              children: homeController.productList.isEmpty
                  ? [const CircularProgressIndicator()]
                  : homeController.productList.sublist(0, 4).map((element) => itemProductCard(element)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemProductCard(ProductModel productModel) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductPage(product: productModel));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: const Color(0xfff1f5f9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.white,
                child: CachedNetworkImage(
                  useOldImageOnUrlChange: true,
                  imageUrl: productModel.imgUrl ?? '',
                  fit: BoxFit.fitWidth,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                productModel.name ?? '',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Text('\$ ${NumberFormat("#,##0.00", "en_US").format(productModel.price ?? 0).toString()}'),
          ],
        ),
      ),
    );
  }
}
