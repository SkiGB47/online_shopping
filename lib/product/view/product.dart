import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/homepage/model/product_model.dart';
import 'package:online_shopping/product/controller/product_controller.dart';

class ProductPage extends StatefulWidget {
  final ProductModel product;

  const ProductPage({super.key, required this.product});

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    productController.checkFavorite(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        child: CachedNetworkImage(
                          useOldImageOnUrlChange: true,
                          imageUrl: widget.product.imgUrl ?? '',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                productController.toggleFavorite(widget.product);
                              },
                              child: Icon(
                                productController.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                                color: Colors.orange,
                              ).paddingAll(8),
                            ),
                          )
                        ],
                      ),
                      Text(
                        widget.product.name ?? '',
                        style: const TextStyle(fontSize: 20),
                      ).paddingSymmetric(vertical: 16),
                      Text('\$ ${NumberFormat("#,##0.00", "en_US").format(widget.product.price ?? 0).toString()}'),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange,
                        border: Border.all(
                          color: Colors.orange,
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
