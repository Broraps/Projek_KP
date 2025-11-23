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
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(seconds: 2), () {
      _tapCount = 0;
    });
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
            widget.onTap?.call();
            _handleSecretTap();
          },
          child: Image.asset(
            "assets/logo.PNG",
            height: 40,
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