import 'dart:convert'; // Hapus jika tidak diperlukan
import 'package:agusplastik/popups/choose_buy_or_sell.dart';
import 'package:flutter/material.dart';

// Ganti dengan data mock untuk testing UI
class Buildtransaksi extends StatefulWidget {
  const Buildtransaksi({super.key});

  @override
  _BuildTransaksiState createState() => _BuildTransaksiState();
}

class _BuildTransaksiState extends State<Buildtransaksi> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredTransactions = []; // Data transaksi mock
  String _transactionType = 'buy'; // Default transaction type: buy (Pembelian)

  // Ganti dengan data dummy untuk sementara
  void _generateMockTransactions() {
    _filteredTransactions = [
      {'id_transaksi': 1, 'nama_customer': 'Customer 1', 'total_harga': 100},
      {'id_transaksi': 2, 'nama_customer': 'Customer 2', 'total_harga': 200},
      {'id_transaksi': 3, 'nama_customer': 'Customer 3', 'total_harga': 300},
    ];
  }

  // Simulasi pencarian transaksi
  void _searchTransactions(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredTransactions = _filteredTransactions
          .where((transaction) =>
              transaction['nama_customer']
                  .toLowerCase()
                  .contains(lowerCaseQuery))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateMockTransactions(); // Gantilah dengan data mock
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          // Navbar for filtering transaction type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _transactionType = 'buy';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _transactionType == 'buy' ? Colors.orange : Colors.grey,
                ),
                child: const Text('Pembelian'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _transactionType = 'sell';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _transactionType == 'sell' ? Colors.orange : Colors.grey,
                ),
                child: const Text('Penjualan'),
              ),
            ],
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchTransactions,
              decoration: InputDecoration(
                labelText: 'Cari Transaksi',
                filled: true,
                fillColor: Colors.grey[700],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Transaction List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada transaksi',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return ListTile(
                        title: Text(transaction['nama_customer']),
                        subtitle: Text('Rp ${transaction['total_harga']}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tampilkan AddTransaksiPopup ketika tombol ditekan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTransaksiPopup(
                initialTransactionType: _transactionType, // Menyampaikan transactionType yang dipilih
              );
            },
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
