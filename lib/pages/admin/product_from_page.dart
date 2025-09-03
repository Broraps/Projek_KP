import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List; // 1. Import kIsWeb & Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  // 2. Siapkan variabel untuk file (Mobile/Desktop) dan bytes (Web)
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  String? _networkImageUrl;
  bool _isLoading = false;
  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _titleController.text = widget.product!['title'];
      _descriptionController.text = widget.product!['description'];
      _priceController.text = widget.product!['price'].toString();
      _networkImageUrl = widget.product!['image_url'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // 3. Cek platform, lalu simpan data gambar sesuai formatnya
      if (kIsWeb) {
        _selectedImageBytes = await pickedFile.readAsBytes();
      } else {
        _selectedImageFile = File(pickedFile.path);
      }
      setState(() {}); // Update UI untuk menampilkan preview
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImageFile == null && _selectedImageBytes == null && !_isEditMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Silakan pilih gambar terlebih dahulu.'),
          backgroundColor: Colors.red));
      return;
    }

    setState(() { _isLoading = true; });

    try {
      String? imageUrl;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 4. Cek platform saat upload ke Supabase Storage
      if (_selectedImageBytes != null) { // Upload untuk Web
        await Supabase.instance.client.storage
            .from('food')
            .uploadBinary('uploads/$fileName', _selectedImageBytes!);
      } else if (_selectedImageFile != null) { // Upload untuk Mobile/Desktop
        await Supabase.instance.client.storage
            .from('food')
            .upload('uploads/$fileName', _selectedImageFile!);
      }

      if(_selectedImageBytes != null || _selectedImageFile != null) {
        imageUrl = Supabase.instance.client.storage
            .from('food')
            .getPublicUrl('uploads/$fileName');
      } else {
        imageUrl = _networkImageUrl;
      }

      final data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': num.parse(_priceController.text),
        'image_url': imageUrl,
      };

      if (_isEditMode) {
        await Supabase.instance.client
            .from('products')
            .update(data)
            .match({'id': widget.product!['id']});
      } else {
        await Supabase.instance.client.from('products').insert(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Produk berhasil ${_isEditMode ? 'diperbarui' : 'disimpan'}'),
            backgroundColor: Colors.green));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal menyimpan produk: $e'),
            backgroundColor: Colors.red));
      }
    }

    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Produk' : 'Tambah Produk Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 5. Widget preview gambar yang cerdas
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: _buildImagePreview(), // Panggil fungsi preview
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => value!.isEmpty? 'Nama produk tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) => value!.isEmpty? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                validator: (value) => value!.isEmpty? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: Text(_isLoading ? 'Menyimpan...' : 'Simpan Produk')),
            ],
          ),
        ),
      ),
    );
  }

  // 6. Buat fungsi helper untuk memilih widget gambar yang tepat
  Widget _buildImagePreview() {
    if (_selectedImageBytes != null) {
      // Jika di web, gunakan Image.memory
      return Image.memory(_selectedImageBytes!, fit: BoxFit.cover);
    } else if (_selectedImageFile != null) {
      // Jika di mobile/desktop, gunakan Image.file
      return Image.file(_selectedImageFile!, fit: BoxFit.cover);
    } else if (_networkImageUrl != null) {
      // Jika mode edit dan belum ada gambar baru, tampilkan gambar lama
      return Image.network(_networkImageUrl!, fit: BoxFit.cover);
    } else {
      // Tampilan default
      return const Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.image, size: 40), Text('Ketuk untuk pilih gambar')]));
    }
  }
}