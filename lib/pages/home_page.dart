// home_page.dart

import 'package:flutter/material.dart';
import 'package:youtube/constants/colors.dart';
import 'package:youtube/constants/size.dart';
import 'package:youtube/widgets/mobile/drawer_mobile.dart';
import '../widgets/dekstop/header_dekstop.dart';
import '../widgets/mobile/header_mobile.dart';

class HomePage extends StatefulWidget {
  final Widget child; // +++ Tambahkan parameter child
  const HomePage({super.key, required this.child}); // +++ Tambahkan parameter child

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: CustomColor.scaffoldBg,
        endDrawer: constraints.maxWidth >= kMinDesktopWidth
            ? null
            : const DrawerMobile(),
        // --- Ganti body dari ListView menjadi SingleChildScrollView yang berisi header dan child ---
        body: SingleChildScrollView( // Memastikan halaman bisa di-scroll jika kontennya panjang
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // HEADER
              if (constraints.maxWidth >= kMinDesktopWidth)
                const HeaderDekstop()
              else
                HeaderMobile(
                  onLogoTap: () {
                    // Navigasi ke home
                    if (ModalRoute.of(context)?.settings.name != '/') {
                      Navigator.pushNamed(context, '/');
                    }
                  },
                  onMenuTap: () {
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                ),

              // KONTEN HALAMAN UTAMA (CHILD)
              widget.child, // +++ Tampilkan widget child di sini

              // FOOTER (jika ada dan bersifat global)
              Container(
                height: 500,
                width: double.maxFinite,
                // Anda bisa meletakkan footer di sini jika ingin tampil di setiap halaman
              ),
            ],
          ),
        ),
      );
    });
  }
}