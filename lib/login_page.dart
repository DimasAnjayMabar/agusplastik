import 'dart:convert';

import 'package:agusplastik/beans/secure_storage/database.dart';
import 'package:agusplastik/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for the text fields
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  String _message = '';
  FocusNode _ipFocusNode = FocusNode();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _databaseFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  Future<void> _verifyConnection() async {
    setState(() {
      _isLoading = true;
    });

    String serverIp = _ipController.text.trim();
    String serverUsername = _usernameController.text.trim();
    String serverPassword = _passwordController.text.trim();
    String serverDatabase = _databaseController.text.trim();

    if (serverIp.isEmpty ||
        serverUsername.isEmpty ||
        serverDatabase.isEmpty ||
        serverPassword.isEmpty) {
      setState(() {
        _isLoading = false;
        _message = 'Isi semua kolom dengan benar';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp:3000/connect'),
        body: {
          'server_ip': serverIp,
          'server_username': serverUsername,
          'server_password': serverPassword,
          'server_database': serverDatabase
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _isLoading = false;
          _message = data['message'];
        });

        if (data['status'] == 'success') {
          await DatabaseIdentity.saveDatabaseIdentity(DatabaseIdentity(
              serverIp: serverIp,
              serverUsername: serverUsername,
              serverPassword: serverPassword,
              serverDatabase: serverDatabase));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        } else {
          setState(() {
            _message = 'Koneksi gagal : ${data['message']}';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _message = 'Koneksi gagal';
        });
      }
    } catch (e) {
      _isLoading = false;
      _message = 'Error : $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF03045e),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'LOGIN DI AGUS PLASTIK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32.0),
              // IP Server Field
              TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'IP SERVER',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Color(0xFF03045e),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_usernameFocusNode),
              ),
              const SizedBox(height: 16.0),
              // Username Field
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'USERNAME',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Color(0xFF03045e),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_databaseFocusNode),
              ),
              const SizedBox(height: 16.0),
              // Database Field
              TextField(
                controller: _databaseController,
                decoration: const InputDecoration(
                  labelText: 'DATABASE',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Color(0xFF03045e),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
              ),
              const SizedBox(height: 16.0),
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PASSWORD',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Color(0xFF03045e),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (_) => _verifyConnection,
              ),
              const SizedBox(height: 32.0),
              // Login Button
              ElevatedButton(
                onPressed: _verifyConnection,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                  backgroundColor: const Color(0xFF0077b6),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  _message,
                  style: const TextStyle(color: Colors.yellow),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _databaseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
