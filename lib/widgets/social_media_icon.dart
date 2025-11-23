// lib/widgets/social_media_icon.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  const SocialMediaIcon({
    super.key,
    required this.icon,
    required this.url,
    this.tooltip = 'Kunjungi halaman media sosial kami',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        try {
          final Uri uri = Uri.parse(url);
          if (!context.mounted) return;
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tidak dapat membuka tautan.')),
            );
          }
        } catch (e) {
          // jika format URL tidak valid
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Format URL tidak valid: $url')),
          );
        }
      },
      icon: FaIcon(icon),
      color: Colors.white,
      iconSize: 40,
      tooltip: tooltip,
      splashRadius: 30,
    );
  }
}
