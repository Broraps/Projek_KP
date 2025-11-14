// lib/widgets/desktop/order_dekstop.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/cart_service.dart'; // Menggunakan service Anda
import '../../models/cart_item_model.dart'; // Menggunakan model Anda
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

  // Menggunakan service Anda dengan benar
  final CartService _cartService = CartService();

  // --- FUNGSI CHECKOUT WHATSAPP (SUDAH DISESUAIKAN) ---
  void _checkoutToWhatsApp(List<CartItem> cartItems, double total) async {
    if (cartItems.isEmpty) return;

    String phoneNumber = "6289664348703"; // Ganti dengan nomor WA Anda
    String message = "Halo, saya ingin memesan:\n\n";

    for (var item in cartItems) {
      // Mengakses properti langsung dari 'item', bukan 'item.product'
      message +=
      "- ${item.title} (Rp ${item.price}) x ${item.quantity}\n";
    }

    message += "\nTotal: Rp ${total.toStringAsFixed(0)}";

    final Uri whatsappUrl = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka WhatsApp.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- BAGIAN KIRI: DAFTAR PRODUK (Tidak ada perubahan) ---
          Expanded(
            flex: 3,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                // ... (Kode GridView, Card, dll. tetap sama) ...
                // ... (Di dalam GridView.builder) ...
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final products = snapshot.data;
                if (products == null || products.isEmpty) {
                  return const Center(
                      child: Text('Belum ada produk tersedia.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              ProductDetailDialog(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                product['image_url'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                    child: Icon(Icons.broken_image,
                                        color: Colors.grey)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['title'] ?? 'Tanpa Nama',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${product['price'] ?? 0}',
                                    style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Panggilan ini sudah benar
                                  _cartService.addToCart(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${product['title']} ditambahkan ke keranjang.'),
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
            ),
          ),

          const SizedBox(width: 20),

          // --- BAGIAN KANAN: KERANJANG BELANJA (SUDAH DISESUAIKAN) ---
          SizedBox(
            width: 350,
            child: ValueListenableBuilder<List<CartItem>>(
              // Mendengarkan 'items', bukan 'cart'
              valueListenable: _cartService.items,
              builder: (context, cartItems, child) {
                // Menggunakan getter 'totalPrice' dari service
                double total = _cartService.totalPrice;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Keranjang Belanja',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(thickness: 1.5, height: 20),
                    Expanded(
                      child: cartItems.isEmpty
                          ? const Center(
                        child: Text('Keranjang masih kosong.'),
                      )
                          : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ListTile(
                            leading: Image.network(
                              // Mengakses 'imageUrl' langsung
                              item.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            // Mengakses 'title' langsung
                            title: Text(item.title),
                            subtitle: Text(
                              // Mengakses 'quantity' dan 'price' langsung
                                'Rp ${item.price}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Colors.red),
                                  onPressed: () {
                                    // Mengirim 'item.id' (String)
                                    _cartService.decrementQuantity(item.id);
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.green),
                                  onPressed: () {
                                    // Panggil addToCart dengan data produk dari item
                                    _cartService.addToCart({
                                      'id': item.id,
                                      'title': item.title,
                                      'price': item.price,
                                      'image_url': item.imageUrl,
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(thickness: 1.5, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp ${total.toStringAsFixed(0)}',
                          // 'total' dari service
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send_to_mobile),
                      label: const Text('Checkout via WhatsApp'),
                      onPressed: cartItems.isEmpty
                          ? null
                          : () => _checkoutToWhatsApp(cartItems, total),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}