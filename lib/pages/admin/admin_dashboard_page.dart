import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube/pages/admin/product_from_page.dart';


class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _productsStream = Supabase.instance.client
      .from('products')
      .stream(primaryKey: ['id']).order('created_at', ascending: false);

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gagal logout, coba lagi.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // --- PERUBAHAN UTAMA DI SINI ---
  Future<void> _deleteProduct(int productId, String imageUrl) async {
    try {
      final imageName = imageUrl.split('/').last;
      await Supabase.instance.client.storage
          .from('food')
          .remove(['uploads/$imageName']);

      await Supabase.instance.client
          .from('products')
          .delete()
          .match({'id': productId}); // Sekarang productId adalah int

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Produk berhasil dihapus'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menghapus produk: $e'),
          backgroundColor: Colors.red,
        ));
      }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Pola ini juga bagus untuk me-refresh data jika diperlukan
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const ProductFormPage(),
          ));
          setState(() {}); // Panggil setState untuk refresh setelah menambah
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
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          // Pola ini juga bagus untuk me-refresh data jika diperlukan
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProductFormPage(product: product),
                          ));
                          setState(() {}); // Panggil setState untuk refresh setelah edit
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        // Panggilan di sini tidak perlu diubah karena product['id']
                        // sudah dalam format angka (integer)
                        onPressed: () => _deleteProduct(
                            product['id'], product['image_url']),
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