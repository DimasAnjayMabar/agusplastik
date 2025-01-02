import 'package:flutter/material.dart';

class AddTransaksiPopup extends StatefulWidget {
  final String? initialTransactionType;

  const AddTransaksiPopup({Key? key, this.initialTransactionType}) : super(key: key);

  @override
  _AddTransaksiPopupState createState() => _AddTransaksiPopupState();
}

class _AddTransaksiPopupState extends State<AddTransaksiPopup> {
  String _transactionType = 'buy'; // Default to 'buy'

  @override
  void initState() {
    super.initState();
    if (widget.initialTransactionType != null) {
      _transactionType = widget.initialTransactionType!;
    }
  }

  // Handle the continue button click
  void _onContinuePressed() {
    Navigator.of(context).pop();
    // You can pass _transactionType to the next step here if needed
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transaksi Baru'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Pembelian'),
            leading: Radio<String>(
              value: 'buy',
              groupValue: _transactionType,
              onChanged: (value) {
                setState(() {
                  _transactionType = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Penjualan'),
            leading: Radio<String>(
              value: 'sell',
              groupValue: _transactionType,
              onChanged: (value) {
                setState(() {
                  _transactionType = value!;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: _onContinuePressed,
          child: const Text('Lanjut'),
        ),
      ],
    );
  }
}
