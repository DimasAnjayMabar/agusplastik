import 'dart:convert';
import 'package:agusplastik/beans/secure_storage/database_identity.dart';
import 'package:agusplastik/menus/distributor_menu.dart';
import 'package:agusplastik/popups/verify/verify_pin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DistributorDetails extends StatefulWidget {
  final int id;

  const DistributorDetails({
    super.key,
    required this.id,
  });

  @override
  State<DistributorDetails> createState() => _DistributorDetailsState();
}

class _DistributorDetailsState extends State<DistributorDetails> {
  late Future<Map<String, dynamic>> _distributorDetails;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _distributorDetails = fetchDistributorDetails(widget.id);
  }

  @override
  void dispose() {
    _isDisposed = true; // Tandai bahwa widget telah dihapus
    super.dispose();
  }

  Future<void> _deleteDistributor(int distributorId) async {
    try {
      final dbIdentity = await StorageService.getDatabaseIdentity();
      final dbPassword = await StorageService.getPassword();

      // Request HTTP untuk menghapus distributor
      final response = await http.post(
        Uri.parse('http://${dbIdentity['serverIp']}:3000/delete-distributor'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'server_ip': dbIdentity['serverIp'],
          'server_username': dbIdentity['serverUsername'],
          'server_password': dbPassword,
          'server_database': dbIdentity['serverDatabase'],
          'distributor_id': distributorId,
        }),
      );

      if (_isDisposed) return; // Jangan lanjutkan jika widget sudah dihapus

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Distributor berhasil dihapus')),
            );
            Navigator.of(context).pop(); // Tutup dialog distributor
          }
        } else {
          throw Exception('Gagal menghapus distributor: ${data['message']}');
        }
      } else {
        throw Exception('Gagal menghapus distributor: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> fetchDistributorDetails(int distributorId) async {
    try {
      final dbIdentity = await StorageService.getDatabaseIdentity();
      final dbPassword = await StorageService.getPassword();

      final response = await http.post(
        Uri.parse('http://${dbIdentity['serverIp']}:3000/distributor-details'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'server_ip': dbIdentity['serverIp'],
          'server_username': dbIdentity['serverUsername'],
          'server_password': dbPassword,
          'server_database': dbIdentity['serverDatabase'],
          'distributor_id': distributorId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || data['status'] != 'success') {
          throw Exception('Gagal memuat distributor: ${data['message']}');
        }

        if (data['distributor'] is Map<String, dynamic>) {
          return data['distributor'];
        } else {
          throw Exception('Data distributor tidak valid');
        }
      } else {
        throw Exception('Gagal memuat distributor: ${response.statusCode}');
      }
    } catch (e) {
      print('Gagal memuat distributor: $e');
      throw Exception('Gagal memuat distributor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _distributorDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Gagal memuat data distributor: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final distributorDetails = snapshot.data!;
          return AlertDialog(
            title: Text(
              distributorDetails['distributor_name'] ?? 'Nama tidak tersedia',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      'No Telp: ${distributorDetails['distributor_phone_number'] ?? "-"}'),
                  Text(
                      'Email: ${distributorDetails['distributor_email'] ?? "-"}'),
                  Text(
                      'Ecommerce: ${distributorDetails['distributor_ecommerce_link'] ?? "-"}'),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Tidak ada perubahan
                },
                child: const Text('Kembali'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Logika untuk mengedit data
                  Navigator.of(context).pop(true); // Menandakan data diubah
                },
                child: const Text('Edit'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VerifyPin(
                        onPinVerified: () async {
                          // Panggil fungsi untuk menghapus distributor
                          await _deleteDistributor(widget.id);

                          // Pastikan Navigator.pop mengembalikan true
                          if (mounted) {
                            Navigator.of(context).pop(true); // Tutup dialog
                          }

                          // Pindahkan ke DistributorMenu dan refresh halaman
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const DistributorMenu()),
                          );
                        },
                      );
                    },
                  );
                },
                child: const Text('Hapus'),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Data distributor tidak tersedia'));
        }
      },
    );
  }
}