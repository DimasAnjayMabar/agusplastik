import 'dart:convert';
import 'package:agusplastik/beans/secure_storage/admin.dart';
import 'package:agusplastik/beans/secure_storage/database_identity.dart';
import 'package:agusplastik/menus/setting_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class VerifyAdmin extends StatefulWidget {
  final VoidCallback onSuccess; // Tambahkan callback untuk sukses

  const VerifyAdmin({super.key, required this.onSuccess});

  @override
  _VerifyAdminState createState() => _VerifyAdminState();
}


class _VerifyAdminState extends State<VerifyAdmin> {
  // Inisialisasi
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode =
      FocusNode(); // FocusNode untuk menangkap event keyboard

  String? adminUsername;
  String? adminPassword;
  int? adminId;

  Future<void> _loginForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final dbIdentity = await StorageService.getDatabaseIdentity();
        final dbPassword = await StorageService.getPassword();

        // Tampilkan indikator loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        final response = await http.post(
          Uri.parse('http://${dbIdentity['serverIp']}:3000/verify-admin'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'server_ip': dbIdentity['serverIp'],
            'server_username': dbIdentity['serverUsername'],
            'server_password':dbPassword, // Secure password handling
            'server_database': dbIdentity['serverDatabase'],
            'admin_username': adminUsername,
            'admin_password': adminPassword,
          }),
        );

        Navigator.pop(context); // Tutup indikator loading

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['status'] == 'success') {
            final adminData = data['admin'];

            // Validasi id_admin
            if (adminData['admin_id'] is int) {
              adminId = adminData['admin_id'];
            } else {
              throw Exception('admin_id bukan int');
            }

            await Admin.saveAdminCredentials(Admin(
              username_admin: adminUsername!,
              password_admin: adminPassword!,
              id_admin: adminId!,
            ));

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verifikasi sukses')),
            );

            // Panggil callback untuk berpindah ke halaman Setting
            widget.onSuccess();

            // Tutup dialog
            Navigator.of(context).pop();
          }else {
            throw Exception('Verifikasi gagal: ${data['message']}');
          }
        } else {
          throw Exception('Gagal untuk verifikasi admin: ${response.body}');
        }
      } catch (e) {
        Navigator.pop(context); // Tutup indikator loading saat error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.of(context).pop(false); // Menutup dialog saat Esc ditekan
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            _loginForm(); // Memanggil loginForm saat Enter ditekan
          }
        }
      },
      child: AlertDialog(
        title: const Text(
          'Verifikasi Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan username';
                    }
                    return null;
                  },
                  onSaved: (value) => adminUsername = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true, // Input untuk password disembunyikan
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan password yang benar';
                    }
                    return null;
                  },
                  onSaved: (value) => adminPassword = value,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false), // Kembali
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            onPressed: _loginForm, // Verifikasi form
            child: const Text('Verifikasi'),
          ),
        ],
      ),
    );
  }
}
