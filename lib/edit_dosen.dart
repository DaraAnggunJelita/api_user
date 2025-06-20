import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/model_dosen.dart';

class EditDosenPage extends StatefulWidget {
  final ModelDosen dosen;

  const EditDosenPage({super.key, required this.dosen});

  @override
  State<EditDosenPage> createState() => _EditDosenPageState();
}

class _EditDosenPageState extends State<EditDosenPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _nipController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.dosen.namaLengkap);
    _nipController = TextEditingController(text: widget.dosen.nip);
    _emailController = TextEditingController(text: widget.dosen.email);
  }

  Future<void> _updateDosen() async {
    final url = 'http://192.168.232.114:8000/api/dosen/${widget.dosen.no}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_lengkap': _namaController.text,
          'nip': _nipController.text,
          'email': _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Dosen'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
                validator: (value) =>
                value!.isEmpty ? 'NIP tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateDosen();
                  }
                },
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
