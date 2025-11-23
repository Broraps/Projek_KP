import 'package:flutter/material.dart';
import 'package:youtube/constants/colors.dart';
import 'package:youtube/constants/size.dart';
import 'package:youtube/pages/user/cart_page.dart';
import 'package:youtube/services/cart_service.dart';
import 'package:youtube/widgets/mobile/drawer_mobile.dart';
import 'package:youtube/widgets/mobile/header_mobile.dart';

import '../widgets/dekstop/header_dekstop.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: CustomColor.scaffoldBg,
        endDrawer: constraints.maxWidth >= kMinDesktopWidth
            ? null
            : const DrawerMobile(),
        floatingActionButton: (currentRoute == '/order' &&
                constraints.maxWidth < kMinDesktopWidth)
            ? ValueListenableBuilder<int>(
                valueListenable: _cartService.totalItemsNotifier,
                builder: (context, totalItems, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const CartPage(),
                          ));
                        },
                        child: const Icon(Icons.shopping_cart),
                      ),
                      if (totalItems > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$totalItems',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              )
            : null,
        // Jika bukan halaman order atau di desktop, jangan tampilkan floating action button
        body: Column(
          children: [
            if (constraints.maxWidth >= kMinDesktopWidth)
              const HeaderDekstop()
            else
              HeaderMobile(
                onLogoTap: () {
                  if (ModalRoute.of(context)?.settings.name != '/') {
                    Navigator.pushNamed(context, '/');
                  }
                },
                onMenuTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      );
    });
  }
}
