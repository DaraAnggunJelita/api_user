import 'package:flutter/material.dart';
import 'package:apiuser/model/model_data_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  late Future<ModelUser> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<ModelUser> fetchUsers() async {
    final response = await http.get(
      Uri.parse('http://192.168.79.113:8000/users'),
    );

    if (response.statusCode == 200) {
      return modelUserFromJson(response.body);
    } else {
      throw Exception('Gagal memuat data user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
        centerTitle: true,
      ),
      body: FutureBuilder<ModelUser>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.users.isEmpty) {
            return const Center(child: Text('Data user kosong'));
          }

          final users = snapshot.data!.users;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${user.id}'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
