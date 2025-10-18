// lib/widgets/dekstop/order_dekstop.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cart_service.dart';
import '../product_detail_dialog.dart';

class OrderDesktop extends StatefulWidget {
  const OrderDesktop({super.key});

  @override
  State<OrderDesktop> createState() => _OrderDesktopState();
}

class _OrderDesktopState extends State<OrderDesktop> {
  final _productsFuture = Supabase.instance.client
      .from('products')
      .select()
      .order('created_at', ascending: false);
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
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

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Jumlah kolom untuk desktop
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.75, // Sesuaikan rasio jika perlu
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return InkWell(
              onTap: () {
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
                // --- PERBAIKAN UTAMA ADA DI DALAM COLUMN INI ---
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Bungkus Gambar dengan Expanded
                    Expanded(
                      child: Image.network(
                        product['image_url'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                      ),
                    ),

                    // 2. Konten teks tidak perlu diubah
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'] ?? 'Tanpa Nama',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${product['price'] ?? 0}',
                            style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    // 3. Tombol juga tidak perlu diubah
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _cartService.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product['title']} ditambahkan ke keranjang.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Tambah'),
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