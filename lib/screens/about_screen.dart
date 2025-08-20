// screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:youtube/constants/size.dart';

import '../widgets/dekstop/about_dekstop.dart';
import '../widgets/mobile/about_mobile.dart';



class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kMinDesktopWidth) {
          return const AboutDekstop();
        } else {
          return const AboutMobile(); // Tampilkan AboutMobile untuk layar kecil
        }
      },
    );
  }
}