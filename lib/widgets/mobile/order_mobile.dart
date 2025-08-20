// lib/widgets/mobile/order_mobile.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cart_service.dart';

class OrderMobile extends StatefulWidget {
  const OrderMobile({super.key});

  @override
  State<OrderMobile> createState() => _OrderMobileState();
}

class _OrderMobileState extends State<OrderMobile> {
  final _productsFuture = Supabase.instance.client
      .from('products')
      .select()
      .order('created_at', ascending: false);
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    // Scaffold dan AppBar sudah dihapus. Langsung return FutureBuilder.
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final products = snapshot.data!;
        if (products.isEmpty) {
          return const Center(child: Text('Belum ada produk tersedia.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80), // Padding bawah agar tidak tertutup FAB
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(product['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product['title'],
                            style:
                            const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('Rp ${product['price']}',
                            style:
                            TextStyle(color: Colors.green.shade700)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      icon:
                      const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('Tambah'),
                      onPressed: () {
                        _cartService.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${product['title']} ditambahkan ke keranjang.'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}