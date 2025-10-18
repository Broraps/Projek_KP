// lib/pages/user/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:youtube/services/cart_service.dart';

class ProductDetailPage extends StatelessWidget {
  // Halaman ini menerima data produk yang diklik
  final Map<String, dynamic> product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CartService cartService = CartService();

    return Scaffold(
      appBar: AppBar(
        // Judul AppBar diambil dari nama produk
        title: Text(product['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Tampilkan Gambar Produk yang Besar
            Hero(
              tag: 'product-image-${product['id']}', // Tag unik untuk animasi
              child: Image.network(
                product['image_url'],
                fit: BoxFit.cover,
                height: 300,
              ),
            ),

            // 2. Tampilkan Detail di bawah gambar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${product['price']}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 3. Tampilkan Deskripsi dari Database
                  Text(
                    product['description'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 4. Tombol "Tambah ke Keranjang" di bagian bawah
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Tambah ke Keranjang'),
          onPressed: () {
            cartService.addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product['title']} ditambahkan ke keranjang.'),
                duration: const Duration(seconds: 2),
              ),
            );
            // Kembali ke halaman sebelumnya setelah menambahkan
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}