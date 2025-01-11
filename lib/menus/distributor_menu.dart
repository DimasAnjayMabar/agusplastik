import 'dart:convert';
import 'package:agusplastik/beans/algorithm/btree/btree_class.dart';
import 'package:agusplastik/beans/secure_storage/database_identity.dart';
import 'package:agusplastik/popups/create/create_distributor.dart';
import 'package:agusplastik/popups/read/distributor_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DistributorMenu extends StatefulWidget {
  const DistributorMenu({super.key});

  @override
  State<DistributorMenu> createState() => _DistributorMenuState();
}

class _DistributorMenuState extends State<DistributorMenu> {
  List<dynamic> _filteredDistributors = [];
  final BTree _distributorBTree = BTree(3);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDistributors();
  }

  // Fetch data distributor
  Future<void> fetchDistributors() async {
    try {
      final dbIdentity = await StorageService.getDatabaseIdentity();
      final dbPassword = await StorageService.getPassword();

      final response = await http.post(
        Uri.parse('http://${dbIdentity['serverIp']}:3000/distributors'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'server_ip': dbIdentity['serverIp'],
          'server_username': dbIdentity['serverUsername'],
          'server_password': dbPassword,
          'server_database': dbIdentity['serverDatabase'],
        }),
      );

      if (response.statusCode == 200) {
        final distributors = json.decode(response.body)['distributors'];
        
        if (distributors == null || distributors.isEmpty) {
          setState(() {
            _filteredDistributors = [];  // Tidak ada data, set ke list kosong
          });
        } else {
          setState(() {
            _filteredDistributors = distributors;
            for (var distributor in distributors) {
              final lowerCaseName = distributor['distributor_name'].toLowerCase();
              _distributorBTree.insertIntoBtree(lowerCaseName, distributor);
            }
          });
        }
      } else {
        print('Error fetching distributors: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fungsi untuk memanggil BTree ke dalam fungsi search
  void _searchDistributor(String query) {
    final lowerCaseQuery = query.toLowerCase();
    final matchedProducts = _distributorBTree.searchBySubstring(lowerCaseQuery);
    setState(() {
      _filteredDistributors = matchedProducts.toSet().toList();
    });
  }

  // Fungsi untuk refresh data setelah navigasi
  Future<void> _navigateAndRefresh(Widget page) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    if (result == true) {
      fetchDistributors(); // Refresh data setelah kembali
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchDistributor,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari distributor...',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          // ListView Builder with Scrollbar
          Expanded(
            child: _filteredDistributors.isEmpty
                ? const Center(child: Text("Tidak ada distributor"))
                : Scrollbar(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: _filteredDistributors.length,
                      itemBuilder: (context, index) {
                        final distributor = _filteredDistributors[index];
                        return GestureDetector(
                          onTap: () {
                            // Tampilkan detail distributor
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return DistributorDetails(
                                  id: distributor['distributor_id'],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).canvasColor,
                              boxShadow: const [BoxShadow()],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Nama: ${distributor['distributor_name']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Telepon: ${distributor['distributor_phone_number'] ?? "Tidak ada telepon"}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateDistributor(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
