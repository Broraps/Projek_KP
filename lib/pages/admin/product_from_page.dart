import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
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
      if (kIsWeb) {
        _selectedImageBytes = await pickedFile.readAsBytes();
      } else {
        _selectedImageFile = File(pickedFile.path);
      }
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImageFile == null &&
        _selectedImageBytes == null &&
        !_isEditMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Silakan pilih gambar terlebih dahulu.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (_selectedImageBytes != null) {
        await Supabase.instance.client.storage
            .from('food')
            .uploadBinary('uploads/$fileName', _selectedImageBytes!);
      } else if (_selectedImageFile != null) {
        await Supabase.instance.client.storage
            .from('food')
            .upload('uploads/$fileName', _selectedImageFile!);
      }

      if (_selectedImageBytes != null || _selectedImageFile != null) {
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
          content: Text(
              'Produk berhasil ${_isEditMode ? 'diperbarui' : 'disimpan'}'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menyimpan produk: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Helper untuk gaya input field agar konsisten
  InputDecoration _inputDecoration(String label, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      prefixText: prefix,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background senada dengan Dashboard
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Produk' : 'Tambah Produk Baru',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Area Upload Gambar
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildImagePreview(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Form Input Fields (Dikelompokkan dalam Card putih)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration('Nama Produk'),
                      validator: (value) =>
                      value!.isEmpty ? 'Nama produk wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: _inputDecoration('Deskripsi'),
                      validator: (value) =>
                      value!.isEmpty ? 'Deskripsi wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Harga', prefix: 'Rp '),
                      validator: (value) =>
                      value!.isEmpty ? 'Harga wajib diisi' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. Tombol Simpan
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    _isEditMode ? 'Perbarui Produk' : 'Simpan Produk',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    Widget imageWidget;
    bool hasImage = false;

    if (_selectedImageBytes != null) {
      imageWidget = Image.memory(_selectedImageBytes!, fit: BoxFit.cover, width: double.infinity);
      hasImage = true;
    } else if (_selectedImageFile != null) {
      imageWidget = Image.file(_selectedImageFile!, fit: BoxFit.cover, width: double.infinity);
      hasImage = true;
    } else if (_networkImageUrl != null) {
      imageWidget = Image.network(_networkImageUrl!, fit: BoxFit.cover, width: double.infinity);
      hasImage = true;
    } else {
      imageWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_rounded, size: 50, color: Colors.blueAccent.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            'Ketuk untuk upload gambar',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      );
    }

    // Jika ada gambar, tambahkan overlay icon edit agar user tahu bisa diganti
    if (hasImage) {
      return Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          Container(
            color: Colors.black.withOpacity(0.2), // Dark overlay sedikit
            child: const Center(
              child: Icon(Icons.edit, color: Colors.white, size: 40),
            ),
          ),
        ],
      );
    }

    return imageWidget;
  }
}