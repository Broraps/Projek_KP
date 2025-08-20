// lib/widgets/dekstop/main_dekstop.dart

import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';

class MainDekstop extends StatelessWidget {
  const MainDekstop({super.key});

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

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      // --- PERUBAHAN 1: HAPUS TINGGI YANG KAKU ---
      // height: screenHeight / 1.2,
      constraints: const BoxConstraints(minHeight: 350),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            // --- PERUBAHAN 2: BUNGKUS COLUMN DENGAN SingleChildScrollView ---
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Berani Coba\nSensasi Pedas\nPangsit Jontor?",
                    textAlign: TextAlign.center, // Tambahkan ini agar rapi
                    style: TextStyle(
                      fontSize: 45,
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
                      fontSize: 25,
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
                  const SizedBox(height: 15), // Tambah jarak
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
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("https://gofood.link/a/Jevmo2S");
                        },
                        customBorder: const CircleBorder(),
                        child: Image.asset(
                          "assets/gofood.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Tambah jarak
                  SizedBox(
                    width: 250,
                    height: 50, // Beri tinggi pada tombol
                    child: ElevatedButton(
                      onPressed: () {
                        // Arahkan ke halaman pesan
                        Navigator.pushNamed(context, '/order');
                      },
                      child: const Text("Pesan Sekarang"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20.0),
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
                    height: 500,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                  )
              ),
            ),
          ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
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
      ),
    );
  }
}