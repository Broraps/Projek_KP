import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SiteLogo extends StatefulWidget {
  const SiteLogo({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  State<SiteLogo> createState() => _SiteLogoState();
}

class _SiteLogoState extends State<SiteLogo> {
  int _tapCount = 0;
  Timer? _tapTimer;

  void _handleSecretTap() {
    _tapCount++;
    // Reset timer setiap kali ada ketukan baru
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(seconds: 2), () {
      // Jika jeda lebih dari 2 detik, reset hitungan
      _tapCount = 0;
    });

    // Jika hitungan mencapai 5, navigasi ke halaman login admin
    if (_tapCount >= 5) {
      _tapCount = 0;
      _tapTimer?.cancel();
      if (mounted) {
        Navigator.pushNamed(context, '/admin_login');
      }
    }
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Jalankan fungsi onTap normal dari parent (yang sudah kita perbaiki)
            widget.onTap?.call();
            // Jalankan juga fungsi untuk menghitung ketukan rahasia
            _handleSecretTap();
          },
          child: Image.asset(
            "assets/logo.PNG",
            height: 40, // Beri ukuran agar konsisten
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          "Pangsit Jontor Wadidaw",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: CustomColor.yellowPrimary,
          ),
        )
      ],
    );
  }
}