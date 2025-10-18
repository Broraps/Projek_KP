// lib/screens/order_screen.dart

import 'package:flutter/material.dart';
import 'package:youtube/constants/size.dart';
import 'package:youtube/widgets/mobile/order_mobile.dart';

import '../widgets/dekstop/order_dekstop.dart';

class OrderScreen extends StatelessWidget { // Pastikan nama kelasnya OrderScreen
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kMinDesktopWidth) {
          return const OrderDesktop();
        } else {
          return const OrderMobile();
        }
      },
    );
  }
}