import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/favorite/controller/favorite_controller.dart';
import 'package:online_shopping/product/model/product_model.dart';
import 'package:online_shopping/product/view/product.dart';
import 'package:online_shopping/widget/custom_dialog.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    FavoriteController favoriteController = Get.put(FavoriteController());
    favoriteController.getFavoriteList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Saved",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.dialog(
                    CustomDialog(
                      title: 'Are you sure ?',
                      onPressedConfirm: () {
                        Get.back();
                        favoriteController.removeAllFavorite();
                      },
                      success: false,
                      exclamation: true,
                      textCancel: 'Cancel',
                      buttonCancel: true,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_sweep_outlined,
                        size: 30,
                      ),
                      const Text(
                        'Remove All',
                        style: TextStyle(fontSize: 18),
                      ).paddingAll(8),
                    ],
                  ),
                )
              ],
            ),
            SingleChildScrollView(child: Obx(() => Column(children: favoriteController.productList.map((element) => itemProduct(element)).toList())))
          ],
        ),
      )),
    );
  }

  Widget itemProduct(ProductModel productModel) {
    FavoriteController favoriteController = Get.find();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: Get.width * 0.2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
                label: 'Delete',
                icon: Icons.delete,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onPressed: (context) => Get.dialog(CustomDialog(
                      title: 'Are you sure ?',
                      onPressedConfirm: () {
                        Get.back();
                        favoriteController.removeFavorite(productModel);
                      },
                      success: false,
                      exclamation: true,
                      textCancel: 'Cancel',
                      buttonCancel: true,
                    ))),
          ],
        ),
        child: GestureDetector(
          onTap: () => Get.to(ProductPage(product: productModel))?.then((value) => favoriteController.getFavoriteList()),
          child: Row(
            children: [
              Container(
                height: Get.width * 0.2,
                width: Get.width * 0.2,
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
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                  ),
                ),
              ).paddingOnly(right: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.name ?? '',
                      style: const TextStyle(fontSize: 18),
                    ).paddingSymmetric(vertical: 16),
                    Text('\$ ${NumberFormat("#,##0.00", "en_US").format(productModel.price ?? 0).toString()}'),
                  ],
                ),
              ),
              CircleAvatar(
                child: Text(productModel.quentity.toString()).paddingAll(8),
              ).paddingAll(8),
            ],
          ),
        ),
      ),
    );
  }
}
