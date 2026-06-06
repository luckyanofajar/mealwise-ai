import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart'; // Menyesuaikan alamat import agar valid

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final ratingController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan semua controller dari memori
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    ratingController.dispose();
    super.dispose();
  }

  // Fungsi pembantu untuk membuat TextField dengan gaya tema gelap
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.orange, width: 1.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff161622), // Tema gelap agar serasi dengan HomePage
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Tambah Makanan Baru",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(controller: nameController, label: "Nama Makanan"),
            _buildTextField(controller: priceController, label: "Harga", keyboardType: TextInputType.number),
            _buildTextField(controller: categoryController, label: "Kategori"),
            _buildTextField(controller: descriptionController, label: "Deskripsi"),
            _buildTextField(controller: imageController, label: "URL Gambar"),
            _buildTextField(controller: ratingController, label: "Rating", keyboardType: TextInputType.number),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () async {
                  // Validasi input tidak boleh ada yang kosong
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      categoryController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      imageController.text.isEmpty ||
                      ratingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Semua kolom input wajib diisi! ❌"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Eksekusi pengiriman data ke database melalui ApiService
                    final success = await ApiService().addFood(
                      name: nameController.text,
                      price: int.parse(priceController.text),
                      category: categoryController.text,
                      description: descriptionController.text,
                      image: imageController.text,
                      rating: double.parse(ratingController.text),
                    );

                    if (success) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Makanan berhasil ditambahkan 🔥"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Kembali ke halaman utama setelah sukses menyimpan
                        Navigator.pop(context);
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Gagal menyimpan data makanan ke server ❌"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // Menangkap error jika format angka Harga/Rating salah ketik
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Format Harga atau Rating tidak valid! ❌"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  "SIMPAN MAKANAN",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}