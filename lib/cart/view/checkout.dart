import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:get/instance_manager.dart';
import 'package:online_shopping/cart/controller/cart_controller.dart';
import 'package:online_shopping/product/model/product_model.dart';

class CheckoutPage extends StatelessWidget {
  final int totalPrice;
  const CheckoutPage({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    String imgUrl = 'https://payment-api.yimplatform.com/checkout?price=$totalPrice';
    CartController cartController = Get.find();
    cartController.validateImage(imgUrl).then((value) => imgUrl = value
        ? 'https://payment-api.yimplatform.com/checkout?price=$totalPrice'
        : 'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: Get.width * 0.8,
                width: Get.width * 0.8,
                color: Colors.white,
                child: Obx(
                  () => cartController.isCheckingImageUrl.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CachedNetworkImage(
                          useOldImageOnUrlChange: true,
                          imageUrl: imgUrl,
                          fit: BoxFit.fitWidth,
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported_outlined),
                          ),
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                          ),
                        ),
                ),
              ).paddingOnly(right: 16),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: cartController.productList.map((element) => productItem(element)).toList() +
                      [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Text(
                                'Total',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                              Text(
                                totalPrice.toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget productItem(ProductModel productModel) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: Text(
            productModel.name ?? '',
            style: const TextStyle(fontSize: 18),
          )),
          Text(
            (productModel.quentity * (productModel.price ?? 0)).toString(),
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
