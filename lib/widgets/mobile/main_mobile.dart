import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';



class MainMobile extends StatelessWidget {
  const MainMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    void _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      // Menghapus height: screenHeight agar bisa di-scroll di dalam SingleChildScrollView
      constraints: const BoxConstraints(minHeight: 560),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // MENGGANTI IMAGE STATIS DENGAN CAROUSEL
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(colors: [
                CustomColor.scaffoldBg.withOpacity(0.6),
                CustomColor.scaffoldBg.withOpacity(0.6),
              ]).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            // Membungkus Carousel dengan SizedBox agar ukurannya terkontrol
            child: SizedBox(
              height: screenWidth * 0.6, // Tentukan tinggi carousel
              width: screenWidth * 0.8,  // Tentukan lebar carousel
              child: const _ImageCarousel(), // Panggil widget carousel di sini
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Berani Coba\nSensasi Pedas\nPangsit Jontor?",
            textAlign: TextAlign.center, // Tambahkan ini agar teks rata tengah
            style: TextStyle(
              fontSize: 28,
              height: 1.5,
              fontWeight: FontWeight.bold,
              color: CustomColor.backgroundPrimary,
              fontStyle: FontStyle.italic,
              shadows: [
                Shadow(
                  offset: Offset(3.0, 3.0),
                  blurRadius: 3.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Ready On : ",
            style: TextStyle(
              fontSize: 20,
              height: 1.5,
              fontWeight: FontWeight.bold,
              color: CustomColor.backgroundPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10), // Beri jarak sedikit
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar pertama yang bisa diklik
              InkWell(
                onTap: () {
                  _launchURL("https://spf.shopee.co.id/3qCPlMgUjv");
                },
                customBorder: const CircleBorder(),
                child: Image.asset(
                  "assets/shopeefood.png",
                  width: 80, // Ukuran disesuaikan untuk mobile
                  height: 80,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              // Gambar kedua yang bisa diklik
              InkWell(
                onTap: () {
                  _launchURL("https://gofood.link/a/Jevmo2S");
                },
                customBorder: const CircleBorder(),
                child: Image.asset(
                  "assets/gofood.png",
                  width: 80,
                  height: 80,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Pesan Sekarang"),
              )),
        ],
      ),
    );
  }
}

// WIDGET BARU UNTUK IMAGE CAROUSEL
class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel();
  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}
class _ImageCarouselState extends State<_ImageCarousel> {
  final List<String> _images = [
    'assets/1.JPG',
    'assets/2.JPG',
    'assets/3.JPG',
    'assets/4.JPG',
  ];
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            _images[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}