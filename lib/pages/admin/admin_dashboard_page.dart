import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube/pages/admin/product_from_page.dart';


class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Gunakan Stream untuk mendapatkan data produk secara real-time
  final _productsStream = Supabase.instance.client
      .from('products')
      .stream(primaryKey: ['id']).order('created_at', ascending: false);

  Future<void> _signOut() async {
    try {
      // Tetap coba untuk logout dari server Supabase
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      // Jika terjadi error (misal: tidak ada internet), kita bisa mencatatnya
      // di console untuk debugging, tapi kita tidak menampilkan pesan error
      // yang mengganggu ke pengguna.
      debugPrint("Error during sign out: $e");
    } finally {
      // BLOK INI AKAN SELALU DIJALANKAN, BAIK LOGOUT BERHASIL MAUPUN GAGAL.
      // Ini memastikan pengguna selalu keluar dari halaman admin.
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  Future<void> _deleteProduct(String productId, String imageUrl) async {
    try {
      // 1. Hapus gambar dari Storage
      final imageName = imageUrl.split('/').last;
      await Supabase.instance.client.storage
          .from('food')
          .remove(['uploads/$imageName']);

      // 2. Hapus data dari tabel database
      await Supabase.instance.client
          .from('products')
          .delete()
          .match({'id': productId});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Produk berhasil dihapus'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menghapus produk: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Logout',
          ),
        ],
      ),
      // Tombol plus untuk menambah produk baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const ProductFormPage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _productsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(
              child: Text('Belum ada produk. Tekan tombol + untuk menambah.'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    product['image_url'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
                  ),
                  title: Text(product['title']),
                  subtitle: Text('Rp ${product['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Update
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProductFormPage(product: product),
                          ));
                        },
                      ),
                      // Tombol Delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteProduct(product['id'], product['image_url']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}