import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube/widgets/social_media_icon.dart';

import '../../constants/colors.dart';
import '../../constants/skill_items.dart';

void _launchMaps() async {
  const String query =
      "Jl. Veteran No.66, Nagri Kaler, Kec. Purwakarta, Kab. Purwakarta, Jawa Barat 41115";
  final Uri uri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'api': '1', 'query': query});
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

class AboutDekstop extends StatelessWidget {
  const AboutDekstop({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Bagian Foto-foto
          Container(
            padding: const EdgeInsets.all(40),
            color: CustomColor.scaffoldBg,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 0.3,
                    enlargeCenterPage: true,
                  ),
                  items: foodItems.map((item) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        item["img"],
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
                Text(
                  'Pangsit Jontor Wadidaw hadir dari dapur rumahan dengan semangat UMKM yang mengutamakan rasa, kualitas, dan kepuasan pelanggan. '
                  'Kami percaya bahwa makanan enak tidak harus mahal. Dengan bahan pilihan yang segar, bumbu khas yang menggoda, dan proses pembuatan yang higienis, '
                  'kami menyajikan pangsit pedas dengan cita rasa wadidaw yang bikin nagih!',
                  style: TextStyle(
                    color: Colors.red[900],
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Bagian Maps
          Container(
            constraints: const BoxConstraints(minHeight: 350),
            color: CustomColor.scaffoldBg,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_sharp,
                          color: CustomColor.iconHeader, size: 100),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: _launchMaps,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Column(
                              children: [
                                Text(
                                  "Jl. Veteran No.66, Nagri Kaler\n"
                                  "Kec. Purwakarta, Kab. Purwakarta\n"
                                  "Jawa Barat 41115",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 35,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.backgroundPrimary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "(Klik untuk membuka di Google Maps)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Gambar
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      "assets/stand.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bagian Review
          Container(
            constraints: const BoxConstraints(minHeight: 350, maxHeight: 700),
            color: CustomColor.scaffoldBg,
            child: Row(
              children: [
                // Gambar 1
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                              flex: 30,
                              child:
                                  Container(color: CustomColor.backgroundLogo)),
                          Expanded(
                              flex: 70,
                              child: Container(
                                  color: CustomColor.backgroundPrimary)),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/logo.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WE'ARE",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.backgroundLogo,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 2, color: Colors.black)
                                      ]),
                                ),
                                Text(
                                  "OPEN",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.backgroundLogo,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 2, color: Colors.black)
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Text(
                                  "SENIN - SABTU || MINGGU LIBUR",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: CustomColor.backgroundLogo,
                                      letterSpacing: 1.2),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "11.00-20.00",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: CustomColor.backgroundLogo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Gambar 2
                Expanded(
                  flex: 1,
                  child: CarouselSlider.builder(
                    itemCount: testiPhotos.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      final photo = testiPhotos[itemIndex];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  photo['img']!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              photo['title']!,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      aspectRatio: 9 / 16,
                      viewportFraction: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // sesi footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            color: const Color.fromARGB(255, 31, 31, 31),
            child: Column(
              children: [
                const Text(
                  "Hubungi Kami",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Punya pertanyaan atau mau order? Jangan ragu hubungi kami!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialMediaIcon(
                      icon: FontAwesomeIcons.instagram,
                      url: 'https://www.instagram.com/pangsitjontor.wadidar/',
                    ),
                    const SizedBox(width: 30),
                    SocialMediaIcon(
                      icon: FontAwesomeIcons.tiktok,
                      url: 'https://www.tiktok.com/@pangsitjontor.wadidar',
                    ),
                    const SizedBox(width: 30),
                    SocialMediaIcon(
                      icon: FontAwesomeIcons.whatsapp,
                      url: 'https://wa.me/6285603128223',
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const Divider(
                    color: Colors.white24, indent: 100, endIndent: 100),
                const SizedBox(height: 20),
                const Text(
                  "© 2024 Pangsit Jontor Wadidaw. All Rights Reserved.",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
