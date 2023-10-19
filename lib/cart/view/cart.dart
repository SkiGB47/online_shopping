import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/cart/controller/cart_controller.dart';
import 'package:online_shopping/product/model/product_model.dart';
import 'package:online_shopping/product/view/product.dart';
import 'package:online_shopping/widget/custom_dialog.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());
    cartController.getCartList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cart",
            style: TextStyle(fontSize: 20),
          ).paddingOnly(bottom: 40, left: 16),
          Expanded(
              child: SingleChildScrollView(
                  child: Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(children: cartController.productList.map((element) => itemProduct(element)).toList()),
                      )))),
          totalPrice(),
        ],
      )),
    );
  }

  Widget itemProduct(ProductModel productModel) {
    CartController cartController = Get.find();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
                        cartController.removeCartItem(productModel);
                      },
                      success: false,
                      exclamation: true,
                      textCancel: 'Cancel',
                      buttonCancel: true,
                    ))),
          ],
        ),
        child: GestureDetector(
          onTap: () => Get.to(ProductPage(product: productModel))?.then((value) => cartController.getCartList()),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.name ?? '',
                      style: const TextStyle(fontSize: 18),
                    ).paddingOnly(bottom: 8),
                    Row(
                      children: [
                        Expanded(child: Text('\$ ${NumberFormat("#,##0.00", "en_US").format(productModel.price ?? 0).toString()}')),
                        Expanded(
                            child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                cartController.manageCartQuentity(productModel, false);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Text(
                                  '-',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
                              decoration: const BoxDecoration(
                                border: Border.symmetric(horizontal: BorderSide(color: Colors.black)),
                              ),
                              child: Text(
                                productModel.quentity.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                cartController.manageCartQuentity(productModel, true);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    border: Border.all(color: Colors.black)),
                                child: const Text(
                                  '+',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  totalPrice() {
    CartController cartController = Get.find();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              const Text(
                'Total : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Obx(() {
                int totalPrice = 0;
                for (var cartItem in cartController.productList) {
                  totalPrice += cartItem.quentity * (cartItem.price ?? 0);
                }
                return Text(
                  totalPrice.toString(),
                  style: const TextStyle(fontSize: 18),
                );
              }),
            ],
          )),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black)),
            child: const Text(
              'Checkout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
