// about_mobile.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/skill_items.dart';

class AboutMobile extends StatelessWidget {
  const AboutMobile({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan SingleChildScrollView agar semua konten bisa di-scroll
    return SingleChildScrollView(
      child: Column(
        children: [
          // Bagian 1: Galeri Foto & Teks Intro
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            color: CustomColor.scaffoldBg,
            child: Column(
              children: [
                // Menggunakan CarouselSlider untuk galeri foto agar hemat tempat di mobile
                CarouselSlider.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          foodItems[index]["img"],
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    viewportFraction: 0.65,
                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 4),
                  ),
                ),
                const SizedBox(height: 30),
                // Teks intro dengan ukuran font yang disesuaikan untuk mobile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Pangsit Jontor Wadidaw hadir dari dapur rumahan dengan semangat UMKM yang mengutamakan rasa, kualitas, dan kepuasan pelanggan. '
                        'Kami percaya bahwa makanan enak tidak harus mahal. Dengan bahan pilihan yang segar, bumbu khas yang menggoda, dan proses pembuatan yang higienis, '
                        'kami menyajikan pangsit pedas dengan cita rasa wadidaw yang bikin nagih!',
                    style: TextStyle(
                      color: Colors.red[900],
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Ukuran font diperkecil
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Bagian 2: Peta Lokasi (Layout diubah menjadi Column)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            color: CustomColor.scaffoldBg,
            // Tata letak diubah dari Row menjadi Column
            child: Column(
              children: [
                // Gambar diletakkan di atas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/stand.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250, // Memberi tinggi agar tidak terlalu besar
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Teks alamat diletakkan di bawah
                Icon(Icons.map_sharp, color: CustomColor.iconHeader, size: 60), // Icon diperkecil
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Jl. Veteran No.66, Nagri Kaler\n"
                        "Kec. Purwakarta, Kab. Purwakarta\n"
                        "Jawa Barat 41115",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Ukuran font diperkecil
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: CustomColor.backgroundPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bagian 3: Jam Buka & Review (Layout diubah menjadi Column)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            color: CustomColor.scaffoldBg,
            // Tata letak diubah dari Row menjadi Column
            child: Column(
              children: [
                // Blok Jam Buka
                SizedBox(
                  height: 450, // Beri tinggi tetap agar layout tidak rusak
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
                              height: 80, // Diperkecil
                              width: 80, // Diperkecil
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/logo.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WE'ARE",
                                  style: TextStyle(
                                    fontSize: 32, // Diperkecil
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.backgroundLogo,
                                    shadows: [
                                      Shadow(blurRadius: 2, color: Colors.black)
                                    ],
                                  ),
                                ),
                                Text(
                                  "OPEN",
                                  style: TextStyle(
                                    fontSize: 32, // Diperkecil
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.backgroundLogo,
                                    shadows: [
                                      Shadow(blurRadius: 2, color: Colors.black)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: const [
                                Text(
                                  "SENIN - SABTU || MINGGU LIBUR",
                                  style: TextStyle(
                                    fontSize: 16, // Diperkecil
                                    color: CustomColor.backgroundLogo,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "11.00-20.00",
                                  style: TextStyle(
                                    fontSize: 16, // Diperkecil
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

                const SizedBox(height: 40), // Jarak antara jam buka dan review

                // Carousel Review
                CarouselSlider.builder(
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
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 400, // Menyesuaikan tinggi untuk mobile
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    viewportFraction: 0.75, // Item terlihat lebih besar
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