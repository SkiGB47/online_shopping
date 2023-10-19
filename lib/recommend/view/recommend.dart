import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/homepage/controller/home_controller.dart';
import 'package:online_shopping/product/model/product_model.dart';
import 'package:online_shopping/product/view/product.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Recommendation'),
        ),
        body: SafeArea(
            child: GridView.count(
                childAspectRatio: (0.8 / 1),
                crossAxisCount: 2,
                children: homeController.productList.map((element) => itemProductCard(element, context)).toList())));
  }

  Widget itemProductCard(ProductModel productModel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductPage(product: productModel));
      },
      child: Container(
        height: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: const Color(0xfff1f5f9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
