import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

BoxDecoration kHeaderDecoration = BoxDecoration(
  // gradient: const LinearGradient(
  //   colors: [
  //     Colors.transparent,
  //     CustomColor.backgroundPrimary],
  // ),
  color: CustomColor.backgroundPrimary,
  borderRadius: BorderRadius.circular(100),
);

// Gaya untuk judul utama di setiap bagian halaman
const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: CustomColor.backgroundPrimary, // Atau warna lain yang Anda inginkan
  fontFamily: 'Roboto', // Ganti dengan font yang Anda gunakan jika ada
);

// Gaya untuk sub-judul atau teks yang sedikit menonjol
const TextStyle kSubtitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Colors.black87,
  fontFamily: 'Roboto',
);

// Gaya untuk teks isi/paragraf
const TextStyle kBodyTextStyle = TextStyle(
  fontSize: 16,
  height: 1.5, // Jarak antar baris agar mudah dibaca
  color: Colors.black54,
  fontFamily: 'Roboto',
);