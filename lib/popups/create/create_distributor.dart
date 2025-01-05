import 'dart:convert';
import 'package:agusplastik/beans/secure_storage/database.dart';
import 'package:agusplastik/menus/distributor_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateDistributor extends StatefulWidget {
  const CreateDistributor({super.key});

  @override
  State<CreateDistributor> createState() => _CreateDistributorState();
}

class _CreateDistributorState extends State<CreateDistributor> {
  //inisialisasi
  final _formKey = GlobalKey<FormState>();

  String? distributorName;
  String? distributorPhoneNumber;
  String? distributorEmail;
  String? distributorEcommerceLink;

  //fungsi untuk submit data produk baru
  Future<void> _createDsitributor() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final dbIdentity = await DatabaseIdentity.getDatabaseIdentity();
        if (dbIdentity == null) throw Exception('User not found');

        final response = await http.post(
          Uri.parse('http://${dbIdentity.serverIp}:3000/new-distributor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'server_ip': dbIdentity.serverIp,
            'server_username': dbIdentity.serverUsername,
            'server_password': dbIdentity.serverPassword,
            'server_database': dbIdentity.serverDatabase,
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
          Navigator.of(context)
              .pop(true); 
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

//css atau ui
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
          //submit produk baru
          onPressed: _createDsitributor,
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
