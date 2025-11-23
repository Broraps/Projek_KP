import 'package:flutter/material.dart';
import 'package:youtube/constants/size.dart';
import 'package:youtube/widgets/dekstop/main_dekstop.dart';

import '../widgets/mobile/main_mobile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kMinDesktopWidth) {
          return const MainDekstop();
        } else {
          return const MainMobile();
        }
      },
    );
  }
}
