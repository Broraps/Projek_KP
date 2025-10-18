import 'package:flutter/material.dart';
import 'dart:developer';
import '../services/cart_service.dart'; // Pastikan path ini benar

class ProductDetailDialog extends StatelessWidget {
  final Map<String, dynamic> product;
  final CartService cartService;

  const ProductDetailDialog({
    super.key,
    required this.product,
    required this.cartService,
  });

  @override
  Widget build(BuildContext context) {
    // --- Ambil data dengan aman (kode ini sudah bagus dari sebelumnya) ---
    final String title = product['title'] as String? ?? 'Tanpa Judul';
    final String imageUrl = product['image_url'] as String? ?? '';
    final String description = product['description'] as String? ?? 'Tidak ada deskripsi.';

    double price = 0.0;
    if (product['price'] != null) {
      if (product['price'] is num) {
        price = (product['price'] as num).toDouble();
      } else if (product['price'] is String) {
        price = double.tryParse(product['price'] as String) ?? 0.0;
      }
    }
    final bool isImageUrlValid = Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;
    // ------------------------------------------------------------------

    return AlertDialog(
      title: Text(title),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),

      // --- PERBAIKAN UTAMA DI SINI ---
      // Bungkus konten dengan SizedBox untuk memberikan batasan lebar.
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // Batasi lebar dialog
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product-image-${product['id']}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (isImageUrlValid)
                      ? Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity, // Ini sekarang aman karena ada parent (SizedBox) yang membatasi
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      log("Error memuat gambar: $error");
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                      );
                    },
                  )
                      : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Rp ${price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              // Gunakan Flexible di dalam Column agar tidak error jika deskripsi terlalu panjang
              Flexible(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
        ElevatedButton(
          onPressed: () {
            cartService.addToCart(product);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title ditambahkan ke keranjang.'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: const Text('Tambah ke Keranjang'),
        ),
      ],
    );
  }
}