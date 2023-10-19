import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:online_shopping/cart/view/cart.dart';
import 'package:online_shopping/favorite/view/favorite.dart';
import 'package:online_shopping/homepage/view/home.dart';

import 'homepage/controller/home_controller.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    RxInt tabIndex = 0.obs;
    final taps = [
      const HomePage(),
      const FavoritePage(),
      const CartPage(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Stack(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: taps[tabIndex.value],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.orange[200] ?? Colors.grey))),
                child: BottomNavigationBar(
                  currentIndex: tabIndex.value,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedFontSize: 12,
                  selectedItemColor: const Color.fromRGBO(2, 65, 109, 1),
                  iconSize: 28,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(
                          tabIndex.value == 0 ? IconlyBold.home : IconlyLight.home,
                          color: Colors.orange,
                        ),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(tabIndex.value == 1 ? Icons.favorite : Icons.favorite_border, color: Colors.orange), label: 'Saved'),
                    BottomNavigationBarItem(
                        icon: Icon(tabIndex.value == 2 ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined, color: Colors.orange),
                        label: 'Cart'),
                  ],
                  onTap: (index) {
                    tabIndex(index);
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
