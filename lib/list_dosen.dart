import 'dart:convert';
import 'package:apiuser/edit_dosen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apiuser/tambah_dosen.dart';
import 'model/model_dosen.dart';

class ApiService {
  static const baseUrl = 'http://192.168.232.114:8000/api/dosen';

  static Future<List<ModelDosen>> fetchDosen() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => ModelDosen.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data dosen');
    }
  }

  static Future<bool> hapusDosen(int no) async {
    final response = await http.delete(Uri.parse('$baseUrl/$no'));
    return response.statusCode == 200;
  }
}

class ListDosenPage extends StatefulWidget {
  const ListDosenPage({super.key});

  @override
  State<ListDosenPage> createState() => _ListDosenPageState();
}

class _ListDosenPageState extends State<ListDosenPage> {
  late Future<List<ModelDosen>> futureDosen;

  @override
  void initState() {
    super.initState();
    futureDosen = ApiService.fetchDosen();
  }

  Future<void> _refresh() async {
    setState(() {
      futureDosen = ApiService.fetchDosen();
    });
  }

  void _hapusDosen(int no) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Dosen'),
        content: const Text('Yakin ingin menghapus dosen ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final success = await ApiService.hapusDosen(no);
      if (success) {
        _refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dosen berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus dosen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ModelDosen>>(
        future: futureDosen,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data dosen'));
          }

          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final d = data[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(d.namaLengkap),
                    subtitle: Text('NIP: ${d.nip}\nEmail: ${d.email}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDosenPage(dosen: d),
                              ),
                            );
                            if (result == true) {
                              _refresh();
                            }
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _hapusDosen(d.no),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahDosenPage(),
            ),
          );

          if (result == true) {
            _refresh();
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
        tooltip: 'Tambah Dosen',
      ),
    );
  }
}
