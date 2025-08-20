import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/cart_item_model.dart';
import '../../services/cart_service.dart'; // 1. Import package

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();

  // 2. Fungsi untuk membuat dan membuka link WhatsApp
  Future<void> _checkoutToWhatsApp() async {
    // Ganti dengan nomor WhatsApp admin (gunakan kode negara, misal 62 untuk Indonesia)
    const String phoneNumber = '6289664348703';

    // Membuat template pesan
    final StringBuffer message = StringBuffer('Hallo kak, aku mau pesan nih, yaitu:\n');
    for (var item in _cartService.items.value) {
      message.writeln('- ${item.title} (${item.quantity}x)');
    }
    message.writeln('\nTotal: Rp ${_cartService.totalPrice.toStringAsFixed(0)}');

    // Encode pesan agar sesuai format URL
    final String encodedMessage = Uri.encodeComponent(message.toString());

    // Membuat URL WhatsApp
    final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');

    // Mencoba membuka URL
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      // Jika gagal, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka WhatsApp. Pastikan aplikasi sudah terinstall.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: _cartService.items,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) {
            return const Center(
              child: Text('Keranjang Anda masih kosong.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Rp ${item.price}'),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () =>
                                      _cartService.decrementQuantity(item.id),
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () =>
                                      _cartService.incrementQuantity(item.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Rp ${_cartService.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon( // 3. Ganti tombol Checkout
                  icon: const Icon(Icons.chat),
                  label: const Text('Checkout via WhatsApp'),
                  onPressed: _checkoutToWhatsApp, // Panggil fungsi baru
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}