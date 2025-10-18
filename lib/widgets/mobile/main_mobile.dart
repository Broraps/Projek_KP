import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    void _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
    final List<String> images = [
      'assets/1.JPG',
      'assets/2.JPG',
      'assets/3.JPG',
      'assets/4.JPG',
    ];

    // --- PERUBAHAN UTAMA: BUNGKUS DENGAN SingleChildScrollView ---
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
        // Hapus constraint tinggi yang kaku agar lebih fleksibel
        // constraints: const BoxConstraints(minHeight: 560),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Carousel Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
                options: CarouselOptions(
                  height: screenWidth * 0.7,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  viewportFraction: 1.0, // Tampilkan 1 gambar penuh di mobile
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Teks Judul
            const Text(
              "Berani Coba\nSensasi Pedas\nPangsit Jontor?",
              textAlign: TextAlign.center,
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
            const SizedBox(height: 15),
            // Teks "Ready On"
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
            const SizedBox(height: 10),
            // Logo Shopee & GoFood
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _launchURL("https://spf.shopee.co.id/3qCPlMgUjv");
                  },
                  customBorder: const CircleBorder(),
                  child: Image.asset(
                    "assets/shopeefood.png",
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(width: 20),
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
          ],
        ),
      ),
    );
  }
}

// WIDGET UNTUK IMAGE CAROUSEL (Tidak berubah)
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