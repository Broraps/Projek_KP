import 'dart:async'; // <-- Diperlukan untuk Timer
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';

class MainDekstop extends StatelessWidget {
  const MainDekstop({super.key});

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
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: screenHeight / 1.2,
      constraints: const BoxConstraints(minHeight: 350),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Berani Coba\nSensasi Pedas\nPangsit Jontor?",
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
                SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Pesan Sekarang"),
                    ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: screenWidth / 2.5,
              child: const _ImageCarousel(),
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
  // Daftar gambar untuk slideshow
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

    // Timer untuk auto-scroll
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
      margin: EdgeInsets.only(bottom: 16.0),
      child: ClipRRect( // Memberi sudut melengkung pada carousel
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