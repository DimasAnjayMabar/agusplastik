import 'dart:convert';
import 'package:agusplastik/beans/secure_storage/database_identity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateDistributor extends StatefulWidget {
  const CreateDistributor({super.key});

  @override
  State<CreateDistributor> createState() => _CreateDistributorState();
}

class _CreateDistributorState extends State<CreateDistributor> {
  // Inisialisasi
  final _formKey = GlobalKey<FormState>();

  String? distributorName;
  String? distributorPhoneNumber;
  String? distributorEmail;
  String? distributorEcommerceLink;

  // Fungsi untuk submit data distributor baru
  Future<void> _createDistributor() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final dbIdentity = await StorageService.getDatabaseIdentity(); // Menarik data identitas database
        final dbPassword = await StorageService.getPassword();

        if (dbIdentity.isEmpty) throw Exception('Identitas database tidak ditemukan');

        final response = await http.post(
          Uri.parse('http://${dbIdentity['serverIp']}:3000/new-distributor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'server_ip': dbIdentity['serverIp'],
            'server_username': dbIdentity['serverUsername'],
            'server_password': dbPassword, // Secure password handling
            'server_database': dbIdentity['serverDatabase'],
            'distributor_name': distributorName,
            'distributor_phone_number': distributorPhoneNumber,
            'distributor_email': distributorEmail,
            'distributor_ecommerce_link': distributorEcommerceLink,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penambahan distributor berhasil')),
          );
          Navigator.of(context).pop(true); // Menutup dialog dan kembali ke layar sebelumnya
        } else {
          throw Exception('Penambahan distributor gagal: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // CSS atau UI
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Tambah Distributor Baru',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama distributor';
                  }
                  return null;
                },
                onSaved: (value) => distributorName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan no telp distributor';
                  }
                  return null;
                },
                onSaved: (value) => distributorPhoneNumber = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email distributor';
                  }
                  return null;
                },
                onSaved: (value) => distributorEmail = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Link Ecommerce'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan link ecommerce';
                  }
                  return null;
                },
                onSaved: (value) => distributorEcommerceLink = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Kembali'),
        ),
        ElevatedButton(
          // Submit distributor baru
          onPressed: _createDistributor,
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
