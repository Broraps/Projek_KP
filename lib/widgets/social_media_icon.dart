// lib/widgets/social_media_icon.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  // Gunakan constructor const untuk performa yang lebih baik
  const SocialMediaIcon({
    super.key,
    required this.icon,
    required this.url,
    this.tooltip = 'Kunjungi halaman media sosial kami', // Tooltip default
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        try {
          final Uri uri = Uri.parse(url);

          // Selalu periksa apakah widget masih terpasang ('mounted') sebelum menggunakan BuildContext dalam operasi async.
          if (!context.mounted) return;

          // Coba buka URL di aplikasi eksternal (browser, TikTok, dll.)
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tidak dapat membuka tautan.')),
            );
          }
        } catch (e) {
          // Tangani jika format URL tidak valid
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Format URL tidak valid: $url')),
          );
        }
      },
      icon: FaIcon(icon),
      color: Colors.white,
      iconSize: 40,
      tooltip: tooltip, // Gunakan tooltip dari parameter
      splashRadius: 30, // Atur radius efek ripple agar pas
    );
  }
}
