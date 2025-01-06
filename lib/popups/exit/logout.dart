import 'package:agusplastik/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Logout {
  static Future<void> showExitPopup(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        focusNode.requestFocus(); // Fokuskan focusNode agar bisa menerima event key

        return RawKeyboardListener(
          focusNode: focusNode,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                // Escape hanya untuk menutup dialog tanpa logout
                if (Navigator.canPop(context)) {
                  // Hapus data dari SecureStorage sebelum menutup dialog
                  _clearSecureStorageAndClose(context);
                }
              } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                // Logout hanya jika tombol Enter ditekan
                _handleLogout(context);
              }
            }
          },
          child: AlertDialog(
            title: const Text(
              "Konfirmasi Keluar",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
                "Apakah anda yakin ingin logout? (login ke database diperlukan setelah logout)"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Kembali",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // Hapus data dari SecureStorage dan tutup dialog
                  _clearSecureStorageAndClose(context);
                },
              ),
              TextButton(
                child: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // Menghindari pemanggilan dua kali
                  Navigator.of(context).pop(); // Tutup dialog
                  _handleLogout(context); // Panggil fungsi logout
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _handleLogout(BuildContext context) async {
    if (!context.mounted) return; // Pastikan widget masih terpasang sebelum melanjutkan

    // Hapus data dari SecureStorage
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.deleteAll();

    // Navigasikan ke halaman login setelah logout
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  static Future<void> _clearSecureStorageAndClose(BuildContext context) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.deleteAll(); // Hapus data login dari SecureStorage
    Navigator.pop(context); // Tutup dialog
  }
}
