import 'dart:convert';
import 'package:agusplastik/beans/secure_storage/database_identity.dart';
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
  bool _isDialogOpen = false; // Flag untuk mencegah dialog ganda

  @override
  void initState() {
    super.initState();
    _distributorDetails = fetchDistributorDetails(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Menunggu hingga UI siap sebelum memanggil dialog
      _showDistributorDetailsDialog();
    });
  }

  Future<Map<String, dynamic>> fetchDistributorDetails(
      int distributorId) async {
    try {
      final dbIdentity = await StorageService.getDatabaseIdentity();
      final dbPassword = await StorageService.getPassword();

      final response = await http.post(
        Uri.parse('http://${dbIdentity['serverIp']}:3000/distributor-details'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'servername': dbIdentity['serverIp'],
          'username': dbIdentity['serverUsername'],
          'password': dbPassword,
          'database': dbIdentity['serverDatabase'],
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

  Future<void> _showDistributorDetailsDialog() async {
    if (_isDialogOpen) return; // Mencegah dialog ganda
    _isDialogOpen = true;

    try {
      final distributorDetails = await _distributorDetails;

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
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
                    Navigator.of(context).pop(); // Tutup dialog
                  },
                  child: const Text('Kembali'),
                ),
                const SizedBox(height: 8.0,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Aksi Edit
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(height: 8.0,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Aksi Hapus
                  },
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data distributor: $e')),
        );
      }
    } finally {
      _isDialogOpen = false; // Reset flag
      if (mounted) {
        Navigator.of(context).pop(); // Kembali ke menu sebelumnya
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan kosong karena dialog langsung ditampilkan
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
