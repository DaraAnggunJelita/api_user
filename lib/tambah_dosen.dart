import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahDosenPage extends StatefulWidget {
  const TambahDosenPage({super.key});

  @override
  State<TambahDosenPage> createState() => _TambahDosenPageState();
}

class _TambahDosenPageState extends State<TambahDosenPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nipController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  Future<void> _simpan() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final url = Uri.parse('http://192.168.232.114:8000/api/dosen');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nama_lengkap': _namaController.text,
            'nip': _nipController.text,
            'alamat': _alamatController.text,
            'no_telepon': _teleponController.text,
            'email': _emailController.text,
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 201 || response.statusCode == 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dosen berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal: ${response.statusCode} - ${response.body}')),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('Tambah Dosen'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.person_add_alt_1, size: 80, color: Colors.pink),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _namaController,
                label: 'Nama Dosen',
                icon: Icons.person,
              ),
              _buildTextField(
                controller: _nipController,
                label: 'Nip',
                icon: Icons.badge,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _alamatController,
                label: 'Alamat',
                icon: Icons.home,
              ),
              _buildTextField(
                controller: _teleponController,
                label: 'Nomor Telepon',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _isLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Data'),
                  onPressed: _isLoading ? null : _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.pink),
          prefixIcon: Icon(icon, color: Colors.pink),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
          ),
        ),
        validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
      ),
    );
  }
}
