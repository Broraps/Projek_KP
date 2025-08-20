import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/skill_items.dart';

class AboutDekstop extends StatelessWidget {
  const AboutDekstop({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Bagian Foto-foto
          Container(
            padding: EdgeInsets.all(16),
            height: screenHeight / 1.2,
            color: CustomColor.scaffoldBg,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: foodItems.map((item) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        item["img"],
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 50),
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
            height: screenHeight / 1.2,
            constraints: const BoxConstraints(minHeight: 350),
            color: CustomColor.scaffoldBg,
            child: Row(
              children: [
                // Teks
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.map_sharp, color: CustomColor.iconHeader, size: 100),
                      SizedBox(height: 20),
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
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bagian Review
          Container(
            height: screenHeight / 1.2,
            constraints: const BoxConstraints(minHeight: 350),
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
                              child: Container(
                                color: CustomColor.backgroundLogo),
                          ),
                          Expanded(
                              flex: 70,
                              child: Container(
                                color: CustomColor.backgroundPrimary)
                          ),
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
                                // shape:,
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
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "WE'ARE",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.backgroundLogo,
                                      shadows: [Shadow(blurRadius: 2, color: Colors.black)]
                                    ),
                                  ),
                                  Text(
                                    "OPEN",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.backgroundLogo,
                                      shadows: [Shadow(blurRadius: 2, color: Colors.black)]
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom :20),
                            child: Column(
                              children: const [
                                Text(
                                  "SENIN - SABTU || MINGGU LIBUR",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: CustomColor.backgroundLogo,
                                    letterSpacing: 1.2
                                  ),
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
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
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
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                    // 4. Atur opsi untuk slideshow
                    options: CarouselOptions(
                      autoPlay: true, // Membuat slideshow berjalan otomatis
                      autoPlayInterval: const Duration(seconds: 3), // Durasi antar slide
                      enlargeCenterPage: true, // Membuat slide di tengah tampak lebih besar
                      aspectRatio: 9 / 16,
                      viewportFraction: 0.7, // Seberapa besar satu item terlihat di layar
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
