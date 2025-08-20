import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/cart_item_model.dart';
import '../../services/cart_service.dart';

class OrderDekstop extends StatefulWidget {
  const OrderDekstop({super.key});

  @override
  State<OrderDekstop> createState() => _OrderDekstopState();
}

class _OrderDekstopState extends State<OrderDekstop> {
  late final Future<List<Map<String, dynamic>>> _productsFuture;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _productsFuture = Supabase.instance.client
        .from('products')
        .select()
        .order('created_at', ascending: false);
  }

  Future<void> _checkoutToWhatsApp() async {
    const String phoneNumber = '6289664348703'; // Ganti nomormu
    final StringBuffer message =
    StringBuffer('Hallo kak, aku mau pesan nih, yaitu:\n');
    for (var item in _cartService.items.value) {
      message.writeln('- ${item.title} (${item.quantity}x)');
    }
    message
        .writeln('\nTotal: Rp ${_cartService.totalPrice.toStringAsFixed(0)}');
    final String encodedMessage = Uri.encodeComponent(message.toString());
    final Uri whatsappUrl =
    Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Tidak bisa membuka WhatsApp. Pastikan aplikasi sudah terinstall.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAGIAN KIRI: GRID PRODUK
          Expanded(
            flex: 3,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Terjadi Error: ${snapshot.error}'));
                }
                final products = snapshot.data;
                if (products == null || products.isEmpty) {
                  return const Center(child: Text('Belum ada produk.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.7,
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
                            child: Image.network(
                              product['image_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text('Rp ${product['price']}',
                                    style: TextStyle(
                                        color: Colors.green.shade700)),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add_shopping_cart,
                                  size: 16),
                              label: const Text('Tambah'),
                              onPressed: () {
                                _cartService.addToCart(product);
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
            ),
          ),
          const SizedBox(width: 20),
          // BAGIAN KANAN: KERANJANG BELANJA
          SizedBox(
            width: 350,
            child: ValueListenableBuilder<List<CartItem>>(
              valueListenable: _cartService.items,
              builder: (context, cartItems, child) {
                // ... (Sisa kode keranjang tidak perlu diubah, sudah benar)
                return Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Keranjang Belanja', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        const Divider(height: 24),
                        if (cartItems.isEmpty)
                          const Expanded(child: Center(child: Text('Keranjang masih kosong.')))
                        else
                          Expanded(
                            child: ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return ListTile(
                                  leading: Image.network(item.imageUrl, width: 40, fit: BoxFit.cover),
                                  title: Text(item.title),
                                  subtitle: Row(
                                    children: [
                                      IconButton(icon: const Icon(Icons.remove_circle, size: 20), onPressed: () => _cartService.decrementQuantity(item.id)),
                                      Text('${item.quantity}'),
                                      IconButton(icon: const Icon(Icons.add_circle, size: 20), onPressed: () => _cartService.incrementQuantity(item.id)),
                                    ],
                                  ),
                                  trailing: IconButton(icon: const Icon(Icons.close, color: Colors.red, size: 20), onPressed: () => _cartService.removeFromCart(item.id)),
                                );
                              },
                            ),
                          ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Rp ${_cartService.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.chat),
                          label: const Text('Checkout via WhatsApp'),
                          onPressed: cartItems.isEmpty ? null : _checkoutToWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}