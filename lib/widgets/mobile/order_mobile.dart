// lib/widgets/order/order_mobile.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cart_service.dart';
import '../product_detail_dialog.dart';

class OrderMobile extends StatefulWidget {
  const OrderMobile({super.key});

  @override
  State<OrderMobile> createState() => _OrderMobileState();
}

class _OrderMobileState extends State<OrderMobile> {
  // Ambil data produk dari Supabase
  final _productsFuture = Supabase.instance.client
      .from('products')
      .select()
      .order('created_at', ascending: false);

  // Inisialisasi service untuk keranjang belanja
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    // FutureBuilder untuk menangani state loading, error, dan data
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final products = snapshot.data;
        if (products == null || products.isEmpty) {
          return const Center(child: Text('Belum ada produk tersedia.'));
        }

        // Tampilkan produk dalam bentuk Grid
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,          // 2 kolom di mobile
            crossAxisSpacing: 16.0,     // Jarak antar item
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.7,      // Rasio aspek item
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            // InkWell agar setiap card bisa di-klik
            return InkWell(
              onTap: () {
                // Tampilkan dialog saat item di-klik
                showDialog(
                  context: context,
                  builder: (context) => ProductDetailDialog(
                    product: product,
                    cartService: _cartService,
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Produk
                    Expanded(
                      child: Hero( // Animasi gambar saat dialog muncul
                        tag: 'product-image-${product['id']}',
                        child: Image.network(
                          product['image_url'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                        ),
                      ),
                    ),
                    // Detail singkat produk
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'] ?? 'Tanpa Nama',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${product['price'] ?? 0}',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}